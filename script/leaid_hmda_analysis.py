import os
import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
from scipy.stats import pearsonr
import seaborn as sns

def check_table_exists(connection, table_name):
    """
    Check if a specific table exists in the database.
    """
    cursor = connection.cursor()
    try:
        cursor.execute(f"SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '{table_name}');")
        return cursor.fetchone()[0]
    except Exception as e:
        print(f"Error checking if table exists: {e}\n")
    finally:
        cursor.close()

def run_sql_script(connection, script_path):
    """
    Executes an SQL script file using a given PostgreSQL connection.
    """
    with open(script_path, 'r') as file:
        sql_content = file.read()
    try:
        cursor = connection.cursor()
        cursor.execute(sql_content)
        connection.commit()
        print(f"Successfully executed {script_path}\n")
    except Exception as e:
        connection.rollback()
        print(f"Error executing {script_path}: {e}\n")
    finally:
        cursor.close()

def create_graph_from_data(connection, sql_query, data_query_error, output_dir):
    """
    Retrieves data using SQL query, normalizes selected metrics, generates a bar graph, and saves it to the specified path.
    """
    df = pd.read_sql(sql_query, connection)
    print("Column names",list(df),"\n")
    
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Normalize the selected metrics
    scaler = MinMaxScaler()
    
    df[['normalized_percentage_algii_enrollment', 'normalized_rate_spread']] = scaler.fit_transform(df[['percentage_algii_enrollment', 'weighted_avg_rate_spread']])
    # Drop rows with NaN values
    df.dropna(inplace=True)
    
    # Sort DataFrame by 'normalized_rate_spread' in descending order for better visual representation
    df.sort_values('normalized_rate_spread', ascending=False, inplace=True)

    # Bar Graph
    plt.figure(figsize=(11, 8.5))  # Set the figure size to typical page size
    ax = df.plot(kind='bar', x='leaid', y=['normalized_percentage_algii_enrollment', 'normalized_rate_spread'], stacked=False)
    plt.title('Normalized Algebra II Enrollment and Average Rate Spread by LEAID')
    plt.ylabel('Normalized Metrics')
    plt.xlabel('LEAID')
    # Set y-axis limit to the 75th percentile (third quartile) of both normalized metrics combined
    third_quartile = df[['normalized_percentage_algii_enrollment', 'normalized_rate_spread']].quantile(0.75).max()
    plt.ylim([0, 1])
    # Customize x-ticks to show only 10 labels
    total_leaids = len(df['leaid'])
    plt.xticks(ticks=[i for i in range(0, total_leaids, total_leaids // 10)], labels=df['leaid'][::total_leaids // 10], rotation=45)
    plt.tight_layout()
    bar_graph_path = os.path.join(output_dir, 'normalized_metrics_by_leaid.pdf')
    plt.savefig(bar_graph_path)
    plt.close()
    print(f"Bar graph saved to {bar_graph_path}\n")
    
    
    # Scatter Plot (can use to check linearity)
    plt.figure(figsize=(10, 6))
    sns.scatterplot(x='normalized_percentage_algii_enrollment', y='normalized_rate_spread', data=df)
    plt.title('Scatter Plot of Algebra II Enrollment vs. Weighted Average Rate Spread')
    scatter_plot_path = os.path.join(output_dir, 'scatter_plot_enrollment_rate_spread.pdf')
    plt.savefig(scatter_plot_path)
    plt.close()
    print(f"Scatter plot saved to {scatter_plot_path}\n")
    
    # Another Scatter Plot  
    plt.figure(figsize=(10, 6))
    sns.scatterplot(x='percentage_algii_enrollment', y='weighted_avg_tract_to_msamd_income', data=df)
    plt.title('Scatter Plot of Algebra II Enrollment vs. Weighted Average Rate Spread')
    scatter_plot_path = os.path.join(output_dir, 'scatter_plot_enrollment_tract_income.pdf')
    plt.savefig(scatter_plot_path)
    plt.close()
    print(f"Scatter plot saved to {scatter_plot_path}\n")
    
    # Histogram for checking normality
    plt.figure(figsize=(12, 6))
    sns.histplot(df['percentage_algii_enrollment'], kde=True)
    plt.title('Algebra II Enrollment (Percentage of Total Enrollment) Distribution')
    plt.show()
    
    # Error Analysis
    df_error = pd.read_sql(data_query_error, connection) 
     # Create a boxplot for student_error
    fig, ax = plt.subplots()
    ax.boxplot(df_error['student_error'], positions=[1], widths=0.5, patch_artist=True, boxprops=dict(facecolor='skyblue'))
    # Create a boxplot for pop_error
    ax.boxplot(df_error['pop_error'], positions=[2], widths=0.5, patch_artist=True, boxprops=dict(facecolor='lightgreen'))
    ax.set_xticklabels(['Student Error', 'Population Error'])
    ax.set_ylabel('Error')
    ax.set_title('Boxplot of Student Error and Population Error')
    box_plot_path = os.path.join(output_dir, 'error_boxplot.pdf')
    plt.savefig(box_plot_path)
    plt.close()
    print(f"Box plot saved to {box_plot_path}\n")
    
    
    
    ## interesting facts
    # Sort the DataFrame by tract_to_msamd_income
    df_sorted = df.sort_values(by='weighted_avg_tract_to_msamd_income', ascending=False)

    # Extract the top 10 and bottom 10 districts
    top_districts = df_sorted.head(10)
    bottom_districts = df_sorted.tail(10)

    # Create the 'output' directory if it doesn't exist
    output_dir = '../output'
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Define the file path
    file_path = os.path.join(output_dir, 'algii_enrollment_by_income.txt')

    # Open a text file for writing
    with open(file_path, 'w') as file:
        # Write header for top income districts
        file.write("Top 10 districts with highest tract_to_msamd_income:\n")
        file.write("LEAID\tPercentage_AlgebraII_Enrollment\n")
        file.write("----------------------------------------\n")
        
        # Write data for top income districts
        for index, row in top_districts.iterrows():
            file.write(f"{row['leaid']}\t{row['percentage_algii_enrollment']}\n")

        # Add a separator between top and bottom districts
        file.write("\n")
        
        # Write header for bottom income districts
        file.write("Bottom 10 districts with lowest tract_to_msamd_income:\n")
        file.write("LEAID\tPercentage_AlgebraII_Enrollment\n")
        file.write("----------------------------------------\n")
        
        # Write data for bottom income districts
        for index, row in bottom_districts.iterrows():
            file.write(f"{row['leaid']}\t{row['percentage_algii_enrollment']}\n")

    # Notify user about the file creation
    print(f"File '{file_path}' has been created successfully.")

        
# Retrieve the PostgreSQL_PWD environment variable
postgresql_pwd = os.getenv('PostgreSQL_PWD')

# Database connection initialization
conn = psycopg2.connect(
    dbname='CRDB',
    user='postgres',
    password=postgresql_pwd,  # Modify as necessary
    host='127.0.0.1'
)
# Check the current directory
current_directory = os.getcwd()
print(f"Current working directory: {current_directory}")

# Paths for SQL script and output
sql_script_path = 'leaid_tract_conversion.sql'
data_query = "SELECT * FROM public.leaid_algii_mortgage_data;"
data_query_error = "SELECT * FROM public.estimated_totals_for_leaids_with_error;"
#graph_output_path = '../image'
output_dir = '../image'  # Ensure this directory exists or is created
print(f"Graph will be saved to: {output_dir}")


def save_table_to_csv(connection, sql_query, output_dir, file_name):
    """
    Fetches data from the database and saves it to a CSV file.
    """
    df = pd.read_sql(sql_query, connection)

    # Ensure the output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Define the full path for the output file
    file_path = os.path.join(output_dir, file_name)

    # Save the DataFrame to CSV
    df.to_csv(file_path, index=False)
    print(f"Data saved to {file_path}")



# Check if the table exists and run script if it doesn't
if not check_table_exists(conn, 'leaid_algii_mortgage_data'):
    run_sql_script(conn, sql_script_path)

# Generate a graph from the data
print("Generating graph\n")
create_graph_from_data(conn, data_query, data_query_error, output_dir)

# Saving Data in CSV
save_table_to_csv(conn, data_query_error, '../output', 'leaid_algii_mortgage_data.csv')
save_table_to_csv(conn, data_query_error, '../output', 'estimated_totals_for_leaids_with_error.csv')

# Close the database connection
conn.close()

print("Done executing.")