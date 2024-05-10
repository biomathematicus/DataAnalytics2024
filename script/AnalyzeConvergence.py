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

def hist2moments_convergence(histogram_data, num_terms, generate_figs, algebra_estimates, COLOR1, COLOR2, sz, OutputResolution, state):
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

    degrees = range(1, num_terms+1)
    f_approx = np.zeros((x.shape[0], len(degrees)))
    fit_degree = []
    error_metric = []
    column = 0
    for i in degrees:
        f_approx[:,column] = representation_theory(i, x, y, h)
        error_metric.append(np.sqrt(np.mean((y - f_approx[:,column])**2)))
        column += 1

    # Graphic output if needed
    if generate_figs:
        # Create the first plot
        fig, ax1 = plt.subplots(1, figsize=(7, 4))
        plt.xlabel('Polynomial Degree to Fit Histogram', size=sz)
        ax1.set_ylabel('RMSE of Polynomial Fit', size=sz)
        ax1.plot(degrees, error_metric, 'ko-', linewidth=lw)
        fig.tight_layout()
        plt.savefig('../Figures/Convergence/ErrorPlot.png', dpi=OutputResolution)
        plt.close()
        
        # Create the first plot
        threshold = 0.05
        fig, ax1 = plt.subplots(1, figsize=(7, 4))
        plt.xlabel('Polynomial Degree to Fit Histogram', size=sz)
        ax1.set_ylabel('Rel. Change in RMSE of Polynomial Fit', size=sz)
        ax1.plot(degrees[:-1], np.abs(np.diff(error_metric)/error_metric[0]), 'ko-', linewidth=lw, label='Error')
        ax1.plot([degrees[0], degrees[-1]], [threshold, threshold], 'b--', linewidth=lw, label='Threshold')
        ax1.plot(degrees[3], np.abs(np.diff(error_metric)[3]/error_metric[0]), 'ro', linewidth=lw, label='Necessary Degree')
        ax1.legend(frameon=False)
        fig.tight_layout()
        plt.savefig('../Figures/Convergence/ChangeErrorPlot.png', dpi=OutputResolution)
        plt.close()

    return

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
num_terms        =  10        # Number of terms in polynomial approximation to PDF function   
generate_figs    = True      # Flag to generate figures  
skip_state_maps  = True      # Flag to skip state map generation  
state_string = [
    'TX'
]
FIP_state = [
    '48'
]

# Check if the folder exists - Figures
if not os.path.exists("../Figures"):
    # Create the folder
    os.makedirs("../Figures", exist_ok=True)
    print("Folder created: ../Figures")
else:
    print("Folder already exists: ../Figures")

# Check if the folder exists- Convergence
if not os.path.exists("../Figures/Convergence"):
    # Create the folder
    os.makedirs("../Figures/Convergence", exist_ok=True)
    print("Folder created: ../Figures/Convergence")
else:
    print("Folder already exists: ../Figures/Convergence")

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
    hist2moments_convergence(sorted_normalized_estimated_childrenPoverty, 
                                                num_terms, generate_figs, sorted_algebraII_estimated, COLOR1,COLOR2, sz, 
                                                OutputResolution, state)
    
    # Move on top next state
    time_end_state[state_iteration] = tk.time()
    state_iteration += 1

# Close the cursor and connection
cursor.close()
conn.close()

time_end_abs = tk.time()
print('\n\nCode has finished to last line in '+str(time_end_abs-time_str_abs)+' secs.')