import os
import psycopg2
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler

def check_table_exists(connection, table_name):
    """
    Check if a specific table exists in the database.
    """
    cursor = connection.cursor()
    try:
        cursor.execute(f"SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '{table_name}');")
        return cursor.fetchone()[0]
    except Exception as e:
        print(f"Error checking if table exists: {e}")
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
        print(f"Successfully executed {script_path}")
    except Exception as e:
        connection.rollback()
        print(f"Error executing {script_path}: {e}")
    finally:
        cursor.close()

def create_graph_from_data(connection, sql_query, output_path):
    """
    Retrieves data using SQL query, normalizes selected metrics, generates a bar graph, and saves it to the specified path.
    """
    df = pd.read_sql(sql_query, connection)

    # Normalize the selected metrics
    scaler = MinMaxScaler()
    df[['normalized_enrollment', 'normalized_rate_spread']] = scaler.fit_transform(df[['total_enrollment', 'weighted_avg_rate_spread']])

    # Sort DataFrame by 'normalized_rate_spread' in descending order for better visual representation
    df.sort_values('normalized_rate_spread', ascending=False, inplace=True)

    # Plotting
    plt.figure(figsize=(11, 8.5))  # Set the figure size to typical page size
    ax = df.plot(kind='bar', x='leaid', y=['normalized_enrollment', 'normalized_rate_spread'], stacked=False)
    plt.title('Normalized Total Enrollment and Average Rate Spread by LEAID')
    plt.ylabel('Normalized Metrics')
    plt.xlabel('LEAID')

    # Set y-axis limit to the 75th percentile (third quartile) of both normalized metrics combined
    third_quartile = df[['normalized_enrollment', 'normalized_rate_spread']].quantile(0.75).max()
    plt.ylim([0, third_quartile])

    # Customize x-ticks to show only 10 labels
    total_leaids = len(df['leaid'])
    plt.xticks(ticks=[i for i in range(0, total_leaids, total_leaids // 10)], labels=df['leaid'][::total_leaids // 10], rotation=45)

    plt.tight_layout()

    # Ensure the directory exists
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    plt.savefig(output_path, format='pdf')  # Save as PDF
    plt.close()
    print(f"Graph saved to {output_path}")
    
# Retrieve the PostgreSQL_PWD environment variable
postgresql_pwd = os.getenv('PostgreSQL_PWD')

# Database connection initialization
conn = psycopg2.connect(
    dbname='CRDB',
    user='postgres',
    password=postgresql_pwd,  # Modify as necessary
    host='127.0.0.1'
)

# Paths for SQL script and output
# Paths for SQL script and output
sql_script_path = 'leaid_tract_conversion.sql'
data_query = "SELECT * FROM public.leaid_algii_mortgage_data;"
#graph_output_path = '../image'
graph_output_path = 'image/hmda_data_by_leaid.pdf'


# Check if the table exists and run script if it doesn't
if not check_table_exists(conn, 'leaid_algii_mortgage_data'):
    run_sql_script(conn, sql_script_path)

# Generate a graph from the data
print("Generating graph")
create_graph_from_data(conn, data_query, graph_output_path)

# Close the database connection
conn.close()