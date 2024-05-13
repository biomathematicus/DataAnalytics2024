import os
import psycopg2
import pandas as pd
import matplotlib.pyplot as plt

def run_sql_script(connection, script_path):
    """
    Executes an SQL script file using a given PostgreSQL connection.
    Args:
        connection (psycopg2.connection): Active PostgreSQL connection.
        script_path (str): Path to the SQL script file.
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
    Executes a SQL query to retrieve data and generates a graph.
    Args:
        connection (psycopg2.connection): Active PostgreSQL connection.
        sql_query (str): SQL query to retrieve data.
        output_path (str): Path to save the generated graph.
    """
    df = pd.read_sql(sql_query, connection)
    plt.figure(figsize=(10, 5))
    df.set_index('leaid').plot(kind='bar')
    plt.title('HMDA Data by LEAID')
    plt.ylabel('Some Metric')
    plt.xlabel('LEAID')
    plt.tight_layout()
    plt.savefig(output_path)
    plt.close()
    print(f"Graph saved to {output_path}")

# Initialize database connection
conn = psycopg2.connect(
    dbname='CRDB',
    user='postgres',
    password='yourpassword',  # Modify as necessary
    host='127.0.0.1'
)

# Define paths
sql_script_path = 'leaid_tract_conversion.sql'
data_query = """
SELECT leaid, SUM(denial_reason_count) AS total_denials
FROM some_table  -- Replace with your actual table and column names
GROUP BY leaid;
"""
graph_output_path = 'output/hmda_data_by_leaid.png'

# Run the SQL script
run_sql_script(conn, sql_script_path)

# Generate a graph from the data
create_graph_from_data(conn, data_query, graph_output_path)

# Close the database connection
conn.close()