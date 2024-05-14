import os
import psycopg2
import time as tk
import numpy as np 
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
from   matplotlib.ticker import PercentFormatter
import matplotlib.colors as mcol
import matplotlib.cm as cm
from   shapely.geometry import box

def hist2moments(histogram_data, num_terms, generate_figs, algebra_estimates, COLOR1, COLOR2, sz, OutputResolution, state):
    lw = 2.5
    
    # nan_exists = np.isnan(histogram_data).any()
    # inf_exists = np.isinf(histogram_data).any()
    histogram_data = np.nan_to_num(histogram_data, nan=0.0) # NaNs come from 0/0 proportions
    
    # Normalize histogram data to create PDF
    # counts, edges = np.histogram(histogram_data, bins='auto', density=True)
    counts, edges = np.histogram(histogram_data, density=True)
    x = edges[:-1] + np.diff(edges) / 2
    y = counts
    h = (max(x) - min(x)) / (len(x) - 1)
    f_approx = representation_theory(num_terms, x, y, h)

    # Graphic output if needed
    if generate_figs:
        # Create the first plot
        fig, ax1 = plt.subplots(1, figsize=(7, 4))

        plt.xlabel('Proportion of Children 5-17 in Poverty in ' + state, size=sz)
        ax1.set_ylabel('PDF', size=sz)
        ax1.hist(histogram_data, bins='auto', density=True, color='k', alpha=0.25, label='Histogram')
        ax1.plot(x, f_approx, 'b-', label='Fitted Curve', linewidth=lw)
        ax1.tick_params(axis='y')

        ax2 = ax1.twinx()

        clr = 'tab:red'
        colors = np.where(np.array(algebra_estimates) >= np.array(histogram_data), COLOR1, COLOR2) 
        enroll_greater_than_poverty = np.sum(np.array(algebra_estimates) >= np.array(histogram_data))/len(algebra_estimates)

        ax2.set_ylabel('Proportion Children in ' + state + '\n Enrolled in Algebra II', color=clr, size=sz)  # we already handled the x-label with ax1
        plt.scatter(histogram_data, algebra_estimates, color=colors, s=5)
        plt.plot([0, 0.3], [0, 0.3], 'k--', linewidth=lw)
        ax2.tick_params(axis='y', labelcolor=clr)

        # Show the plot
        fig.tight_layout()  # To ensure the right y-label is not slightly clipped
        
        plt.gca().xaxis.set_major_formatter(PercentFormatter(1))
        plt.savefig('../Figures/Histograms/Poverty_vs_Alg2_' + state + '.png', dpi=OutputResolution)
        plt.close()

    # Calculate the first four statistical moments
    e_x = inner_product(x * f_approx, np.ones_like(f_approx), h)
    std = np.sqrt(inner_product((x - e_x) ** 2 * f_approx, np.ones_like(f_approx), h))
    skw = inner_product((x - e_x) ** 3 * f_approx, np.ones_like(f_approx), h) / (std**2) ** (3/2)
    krt = inner_product((x - e_x) ** 4 * f_approx, np.ones_like(f_approx), h) / (std**2) ** 2 - 3

    # Return statistical moments
    return e_x, std, skw, krt, colors, enroll_greater_than_poverty

def representation_theory(num_terms, t, f, h):
    # Basis array
    u = np.vstack([t ** m for m in range(num_terms)])
    # Coeff. Matrix and forcing vector A and b
    A = np.zeros((num_terms, num_terms))
    b = np.zeros(num_terms)
    for row in range(num_terms):
        b[row] = inner_product(u[row, :], f, h)
        for col in range(num_terms):
            A[row, col] = inner_product(u[row, :], u[col, :], h)
    # Solve for c
    c = np.linalg.solve(A, b)
    f_approx = np.dot(c, u)
    return f_approx

def inner_product(f, g, h):
    product = f * g
    integral = h * (0.5 * product[0] + np.sum(product[1:-1]) + 0.5 * product[-1])
    return integral

time_str_abs = tk.time()

# These are the setup variables (Passowrds, graphic settings, states to analyze)
postgresql_pwd   =  os.getenv('PostgreSQL_PWD')
sz               =  12       # Fontsize
COLOR1           = '#FF0000' # Color for scatter points - Lower prop. of enrollment than poverty
COLOR2           = '#0000FF' # Color for scatter points - Higher prop. of enrollment than poverty
OutputResolution =  500      # Figure resolution in DPI
window_width     =  12       # Figure width
window_height    =  8        # Figure length
num_terms        =  4        # Number of terms in polynomial approximation to PDF function   
generate_figs    = True      # Flag to generate figures  
skip_state_maps  = True      # Flag to skip state map generation  
state_string = [
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL',
    'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME',
    'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH',
    'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'PR',
    'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV',
    'WI', 'WY'
]
FIP_state = [
    '01', '02', '04', '05', '06', '08', '09', '10', '11', '12',
    '13', '15', '16', '17', '18', '19', '20', '21', '22', '23',
    '24', '25', '26', '27', '28', '29', '30', '31', '32', '33',
    '34', '35', '36', '37', '38', '39', '40', '41', '42', '72',
    '44', '45', '46', '47', '48', '49', '50', '51', '53', '54',
    '55', '56'
]


# Main connection to PostgreSQL server
conn = psycopg2.connect(
    dbname='CRDB', 
    user='postgres', 
    password=postgresql_pwd, 
    host='localhost', 
    port='5432'
)

# Create a cursor object
cursor = conn.cursor()

# Initial SQL query to create LEAID column in the Poverty Table (ussd17)
sql_initial_LEAID = """
    ALTER TABLE "CRDB".ussd17_edited
    ADD COLUMN leaid VARCHAR(7);

    UPDATE "CRDB".ussd17_edited
    SET leaid = CONCAT(state_fips, '', districtid);
"""

cursor.execute(sql_initial_LEAID)

# CPU time evaluation
state_iteration   = 0
time_str_state    = np.zeros((len(state_string)))
time_end_state    = np.zeros((len(state_string)))
time_str_graphics = np.zeros((len(state_string)))
time_end_graphics = np.zeros((len(state_string)))

state_performance = np.zeros((len(state_string)))

# Loop to analyze each state in "state_string"
for state,FIPS_state in zip(state_string,FIP_state):
    
    time_str_state[state_iteration] = tk.time()
    
    print(state, FIPS_state)
    sql_query = 'SELECT leaid from "CRDB".ussd17_edited where state like %s;'
    cursor.execute(sql_query, (state,))
    # Fetch the Poverty data
    data = cursor.fetchall()
    # Save LEAID from each state to another list
    TX_LEAID = []
    for row in data:
        TX_LEAID.append(row[0])

    # Extract proportion of children in poverty for each LEAID
    query = """
    SELECT 
        SUM(CAST(population5_17inpoverty AS INTEGER)) AS total_estimated_children_in_poverty,
        SUM(CAST(population5_17 AS INTEGER)) AS total_estimated_population_5_17, 
        leaid
    FROM 
        "CRDB".ussd17_edited
    WHERE 
        leaid = ANY(%s)
    GROUP BY 
        leaid;
    """

    # Extract total students enrolled per LEAID
    query_enrollment = """
    SELECT 
        SUM(CASE WHEN CAST(TOT_ENR_M AS INTEGER) < 0 THEN 0 ELSE CAST(TOT_ENR_M AS INTEGER) END) AS sum_enrollment_m,
        SUM(CASE WHEN CAST(TOT_ENR_F AS INTEGER) < 0 THEN 0 ELSE CAST(TOT_ENR_F AS INTEGER) END) AS sum_enrollment_f, 
        LEAID
    FROM 
        "CRDB".Enrollment
    WHERE 
        LEAID = ANY(%s)
    GROUP BY 
        LEAID
    ORDER BY 
        LEAID;
    """

    # Extract total students enrolled in ALGII per LEAID
    query_algebra = """
    SELECT 
        SUM(CASE WHEN CAST(TOT_MATHENR_ALG2_M AS INTEGER) < 0 THEN 0 ELSE CAST(TOT_MATHENR_ALG2_M AS INTEGER) END) AS sum_tot_alge2_enroll_m,
        SUM(CASE WHEN CAST(TOT_MATHENR_ALG2_F AS INTEGER) < 0 THEN 0 ELSE CAST(TOT_MATHENR_ALG2_F AS INTEGER) END) AS sum_tot_alge2_enroll_f, 
        LEAID
    FROM 
        "CRDB".algebraII
    WHERE 
        LEAID = ANY(%s)
    GROUP BY 
        LEAID
    ORDER BY 
        LEAID;
    """
    
    # SQL query to fetch average loan amount and family income grouped by county code for Texas
    sql_query_hmda = """
    SELECT 
        county_code,
        AVG(CASE WHEN loan_amount_000s = '' THEN NULL ELSE CAST(loan_amount_000s AS NUMERIC) END) AS average_loan_amount,
        AVG(CASE WHEN applicant_income_000s = '' THEN NULL ELSE CAST(applicant_income_000s AS NUMERIC) END) AS average_family_income
    FROM 
        "CRDB".hmda_2017_nationwide_allrecords_labels
    WHERE 
        state_abbr = %s
    GROUP BY 
        county_code;
    """

    #To extract districts coordinates
    sql_query_geocode = """
    SELECT 
        lat,
        lon,
        LEAID
    FROM 
        "CRDB".edge_geocode_publiclea_1718
    WHERE 
        state = %s;
    """

    # Execute each SQL query
    # Poverty table query
    with conn.cursor() as cur:
        cur.execute(query, (TX_LEAID,))
        rows = cur.fetchall()
    estimated_childrenPoverty = []
    estimated_population_5_17 = []
    leaid_poverty = []
    for row in rows:
        estimated_childrenPoverty.append(row[0])
        estimated_population_5_17.append(row[1])
        leaid_poverty.append(row[2])
    normalized_estimated_childrenPoverty = (np.array(estimated_childrenPoverty)/np.array(estimated_population_5_17))

    # Algebra II table query
    with conn.cursor() as cur_2:
        cur_2.execute(query_algebra, (TX_LEAID,))
        rows_algebra = cur_2.fetchall()
    algebraII_estimated_Male = []
    algebraII_estimated_Female = []
    leaid_algebra = []
    for row in rows_algebra:
        algebraII_estimated_Male.append(int(row[0]))
        algebraII_estimated_Female.append(int(row[1]))
        leaid_algebra.append(row[2])

    # Total enrollment table query
    with conn.cursor() as cur_3:
        cur_3.execute(query_enrollment, (TX_LEAID,))
        rows_enrollment = cur_3.fetchall()
    total_enrollment_Male = []
    total_enrollment_Female = []
    leaid_enrollment = []
    for row in rows_enrollment:
        total_enrollment_Male.append(int(row[0]))
        total_enrollment_Female.append(int(row[1]))
        leaid_enrollment.append(row[2])
    algebraII_estimated = (np.array(algebraII_estimated_Male) + 
                           np.array(algebraII_estimated_Female))/(np.array(total_enrollment_Male) 
                                                                  + np.array(total_enrollment_Female))

    # Eliminate the LEAIDs that are not shared between lists 
    not_in_algebra = [item for item in leaid_poverty if item not in leaid_algebra]
    not_in_poverty = [item for item in leaid_algebra if item not in leaid_poverty]
    if len(not_in_algebra) != 0:
        for leaid_not in not_in_algebra:
            index = leaid_poverty.index(leaid_not)
            del leaid_poverty[index]
            normalized_estimated_childrenPoverty = np.delete(normalized_estimated_childrenPoverty, index)
    if len(not_in_poverty) != 0:
        for leaid_not in not_in_poverty:
            index = leaid_algebra.index(leaid_not)
            del leaid_algebra[index]
            algebraII_estimated = np.delete(algebraII_estimated, index)

    #Create dictionaries for easy lookup
    poverty_dict = dict(zip(leaid_poverty, normalized_estimated_childrenPoverty))
    algebra_dict = dict(zip(leaid_algebra, algebraII_estimated))
    standard_order_leaid = sorted(set(leaid_poverty + leaid_algebra))
    sorted_normalized_estimated_childrenPoverty = [poverty_dict.get(leaid, 0) for leaid in standard_order_leaid]
    sorted_algebraII_estimated = [algebra_dict.get(leaid, 0) for leaid in standard_order_leaid]

    # Use representation theory to approximate statistical moments of data (unused for now)
    e_x, std, skw, krt, colors, enroll_greater_than_poverty = hist2moments(sorted_normalized_estimated_childrenPoverty, 
                                                num_terms, generate_figs, sorted_algebraII_estimated, COLOR1,COLOR2, sz, 
                                                OutputResolution, state)
    
    # Proportion of districts with higher alg II enrollment than poverty enrollment
    state_performance[state_iteration] = enroll_greater_than_poverty

    if skip_state_maps:
        state_iteration += 1
        continue

    # Representative colors per each LEAID
    colors_leaid = {'Color': colors,
            'LEAID': standard_order_leaid}
    colors_leaid_df = pd.DataFrame(colors_leaid)
    print(f"Statistical Moments: {e_x, std, skw, krt}")
    
    # Load mortgage data
    cursor.execute(sql_query_hmda, (state,))
    results = cursor.fetchall()

    # Process results into DataFrame
    income_data = pd.DataFrame(results, columns=['county_code', 'average_loan_amount', 'average_family_income'])
    income_data['county_code'] = income_data['county_code'].astype(str).str.zfill(3)

    # Loading coordinates
    cursor.execute(sql_query_geocode, (state,))
    results_geocode = cursor.fetchall()
    geocode_data = pd.DataFrame(results_geocode, columns=['lat','lon','LEAID'])
    geocode_data['LEAID'] = geocode_data['LEAID'].astype(str).str.zfill(7)

    # Merge database to share scatter color per LEAID 
    geocode_data = geocode_data.merge(colors_leaid_df, on='LEAID', how='left')
    geocode_data_gdf = gpd.GeoDataFrame(geocode_data, geometry=gpd.points_from_xy(geocode_data['lon'], geocode_data['lat']))
    geocode_data_gdf['Color'] = geocode_data_gdf['Color'].fillna("#FF000000")

    # Use coordintae system for lattitude/longitude - EPSG 4326 is WGS84 Latitude/Longitude
    geocode_data_gdf.set_crs(epsg=4326, inplace=True)  # EPSG 4326 is WGS84 Latitude/Longitude

    # Load the shapefile county data
    shapefile_path = '../shape_files/tl_2018_us_county/tl_2018_us_county.shp'
    counties = gpd.read_file(shapefile_path)

    # Filter out non-Texas counties and cast COUNTYFP to string
    tx_counties = counties[counties['STATEFP'] == FIPS_state]
    tx_counties.loc[:, 'COUNTYFP'] = tx_counties['COUNTYFP'].astype(str)

    # Merge the geodataframe with the income data
    merged = tx_counties.merge(income_data, left_on='COUNTYFP', right_on='county_code', how='left')
    vmin = merged['average_family_income'].min()
    vmax = merged['average_family_income'].max()
    
    time_end_state[state_iteration] = tk.time()

    # Graphic Generation
    if generate_figs:

        time_str_graphics[state_iteration] = tk.time()

        # Create figure and axes for Matplotlib - average_family_income
        cmap = 'Greens'
        fig, ax = plt.subplots(1, figsize=(window_width, window_height))
        fig.subplots_adjust(left=0.1, right=0.9, top=0.75, bottom=0.1)
        ax.axis('off')
        merged.plot(column='average_family_income', ax=ax, edgecolor='0.8', linewidth=1, cmap=cmap)
        sm = plt.cm.ScalarMappable(norm=plt.Normalize(vmin=vmin, vmax=vmax), cmap=cmap)
        sm._A = []
        cbaxes = fig.add_axes([0.85, 0.15, 0.015, 0.7])
        cbar = fig.colorbar(sm, cax=cbaxes)
        cbar.set_label('Average family income per county\n in ' + state + ' in thousands of dollars', size=sz)
        colors = geocode_data_gdf['Color'].dropna().unique()

        for color in colors:
            if (color != "#FF000000"):
                subset = geocode_data_gdf[geocode_data_gdf['Color'] == color]
                if (color == COLOR1):
                    subset.plot(ax=ax, color=color, markersize=5, label='Higher Proportion of Poverty\nthan AP Enrollment')
                else:
                    subset.plot(ax=ax, color=color, markersize=5, label='Lower Proportion of Poverty\nthan AP Enrollment')

        ax.legend(loc='upper left', bbox_to_anchor=(0.1, 0.9, 0, 0), bbox_transform=fig.transFigure, framealpha=0.0, fontsize=sz)
        plt.savefig('../Figures/Income_StateMaps/IncomeMap_' + state + '.png', dpi=OutputResolution)
        plt.close()

        # Create figure and axes for Matplotlib - average_loan_amount
        vmin = merged['average_loan_amount'].min()
        vmax = merged['average_loan_amount'].max()
        fig, ax = plt.subplots(1, figsize=(window_width, window_height))
        fig.subplots_adjust(left=0.1, right=0.9, top=0.75, bottom=0.1)
        ax.axis('off')
        merged.plot(column='average_loan_amount', ax=ax, edgecolor='0.8', linewidth=1, cmap=cmap)
        sm = plt.cm.ScalarMappable(norm=plt.Normalize(vmin=vmin, vmax=vmax), cmap=cmap)
        sm._A = []
        cbaxes = fig.add_axes([0.85, 0.15, 0.015, 0.7])
        cbar = fig.colorbar(sm, cax=cbaxes)
        cbar.set_label('Average loan amount per county\n in ' + state + ' in thousands of dollars', size=sz)
        colors = geocode_data_gdf['Color'].dropna().unique()

        for color in colors:
            if (color != "#FF000000"):
                subset = geocode_data_gdf[geocode_data_gdf['Color'] == color]
                if (color == COLOR1):
                    subset.plot(ax=ax, color=color, markersize=5, label='Lower Proportion of Poverty\nthan AP Enrollment')
                else:
                    subset.plot(ax=ax, color=color, markersize=5, label='Higher Proportion of Poverty\nthan AP Enrollment')
            
        ax.legend(loc='upper left', bbox_to_anchor=(0.1, 0.9, 0, 0), bbox_transform=fig.transFigure, framealpha=0.0, fontsize=sz)
        plt.savefig('../Figures/Loan_StateMaps/LoanMap_' + state + '.png', dpi=OutputResolution)
        plt.close()
        
        time_str_graphics[state_iteration] = tk.time()

    # Move on top next state
    time_end_state[state_iteration] = tk.time()
    state_iteration += 1

# Close the cursor and connection
cursor.close()
conn.close()

# Analyze runtime evolution
runtime = time_end_state-time_str_state
plt.figure(figsize=(10, 6))  # You can adjust the size as needed
plt.bar(state_string, runtime, color='blue')  # You can change the color as well
plt.xlabel('State')
plt.ylabel('Runtime [s]')
plt.savefig('../Figures/runtime.png', dpi=OutputResolution)
plt.close()

# Analyze State Perfomance
upperlimit = np.percentile(state_performance, 96) # The upper limit of the heatmap will be the 96th percentile
midpoint = np.mean(state_performance)
# midpoint   = np.percentile(state_performance, 50) # The midpoint of the heatmap will be the 50th percentile
print('upperlimit >> ', upperlimit)
fig, ax1 = plt.subplots(1, figsize=(7, 4))
plt.xlabel('State Performance', size=sz)
ax1.set_ylabel('PDF', size=sz)
ax1.hist(state_performance, bins='auto', density=True, color='k', alpha=0.25, label='Histogram')
ax1.plot([upperlimit, upperlimit], [0, 7], 'r--', label='95th Percentile')
fig.tight_layout()  # To ensure the right y-label is not slightly clipped
plt.savefig('../Figures/StatePerformanceHistogram.png', dpi=OutputResolution)
plt.close()


# Cap extreme of state_performance at 96th percentile
state_performance_copy = state_performance
state_performance_copy[state_performance>upperlimit] = upperlimit
state_group = {'STATEFP': FIP_state,
                'state_performance': state_performance_copy}
print('\nMinimum  ', min(state_performance_copy))
print('Midpoint ', midpoint)
print('Maximum  ', upperlimit)

# Analyze Country-wide performance indices
shapefile_states_path = '../shape_files/tl_2023_us_state/tl_2023_us_state.shp'
states_shp = gpd.read_file(shapefile_states_path)
enroll_greater_than_poverty_df = pd.DataFrame(state_group)
states_shp = states_shp.merge(enroll_greater_than_poverty_df, left_on='STATEFP', right_on='STATEFP', how='left')
window_width, window_height = 15, 10
fig, ax = plt.subplots(1, figsize=(window_width, window_height))
fig.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.1)
ax.axis('off')


# User-defined colormap from red to blue
color_list = ['red', 'blue']  # Colors from blue to white to red
# color_list = ['red', 'white', 'blue']  # Colors from blue to white to red
cmap_name = 'MyCmapName'
positions = ([min(state_performance), upperlimit]-min(state_performance))/(upperlimit-min(state_performance))
# positions = ([min(state_performance), midpoint, upperlimit]-min(state_performance))/(upperlimit-min(state_performance))
cm1 = mcol.LinearSegmentedColormap.from_list(cmap_name, list(zip(positions, color_list)))
cnorm = mcol.Normalize(vmin=min(state_performance), vmax=upperlimit)
sm = cm.ScalarMappable(norm=cnorm, cmap=cm1)
sm.set_array([])  
states_shp.plot(column='state_performance', ax=ax, edgecolor='0', linewidth=1, cmap=cm1)
cbaxes = fig.add_axes([0.85, 0.15, 0.015, 0.7])  # Adjust these values for your layout needs
cbar = fig.colorbar(sm, cax=cbaxes)
cbar.set_label('State Performance', size=12)  # Adjust the label
ax.set_ylim((  19,  71))
ax.set_xlim((-170, -50))
plt.savefig('../Figures/CountryWidePerformance.png', dpi=OutputResolution)
plt.close()


time_end_abs = tk.time()
print('\n\nCode has finished to last line in '+str(time_end_abs-time_str_abs)+' secs.')