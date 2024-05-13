import os
import psycopg2
import pandas as pd
import matplotlib.pyplot as plt

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
    Retrieves data using SQL query, generates a bar graph, and saves it to the specified path.
    """
    df = pd.read_sql(sql_query, connection)
    plt.figure(figsize=(10, 5))
    df.set_index('leaid').plot(kind='bar')
    plt.title('Total Enrollment and HMDA Data by LEAID')
    plt.ylabel('Metrics')
    plt.xlabel('LEAID')
    plt.tight_layout()
    plt.savefig(output_path)
    plt.close()
    print(f"Graph saved to {output_path}")

# Database connection initialization
conn = psycopg2.connect(
    dbname='CRDB',
    user='postgres',
    password='yourpassword',  # Modify as necessary
    host='127.0.0.1'
)

# Paths for SQL script and output
sql_script_path = 'leaid_tract_conversion.sql'
data_query = """
SELECT * FROM public.leaid_algii_mortgage_data;
"""
graph_output_path = 'image/hmda_data_by_leaid.png'

# Execute SQL script and generate graph
run_sql_script(conn, sql_script_path)
create_graph_from_data(conn, data_query, graph_output_path)

# Close the database connection
conn.close()