import os
import pandas as pd
import psycopg2
from psycopg2 import sql
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

def find_max_char_lengths(csv_file_path, string_columns):
    df = pd.read_csv(csv_file_path, dtype=str, encoding="cp1252")
    max_lengths = {}
    for column in string_columns:
        max_character = df[column].fillna('').map(len).max()
        max_lengths[column] = max(max_character, 2)  # Set a minimum length of 2
    return max_lengths

def copy_data_from_csv_to_db(conn, table_name, csv_file_path):
    copy_query = sql.SQL("COPY {} FROM STDIN WITH CSV HEADER DELIMITER ',' ENCODING 'windows-1251'").format(sql.Identifier(table_name))
    with open(csv_file_path, 'r', encoding='windows-1251') as f, conn.cursor() as cur:
        cur.copy_expert(copy_query, f)
    conn.commit()
    

# Define your data types for CSV columns
data_types = {
        'X': float,
        'Y': float,
        'OBJECTID': int,
        'NCESSCH': str,  # National Center for Education Statistics School ID as string to preserve leading zeros
        'SURVYEAR': str,  # Survey Year as string if it has a specific format
        'STABR': str,     # State abbreviation as string
        'LEAID': str,     # Local Education Agency ID as string to preserve leading zeros
        'ST_LEAID': str,  # State-level LEA ID as string to preserve formatting
        'LEA_NAME': str,  # Local Education Agency Name
        'SCH_NAME': str,  # School Name
        'LSTREET1': str,  # Location Street 1
        'LSTREET2': str,  # Location Street 2
        'LSTREET3': str,  # Location Street 3
        'LCITY': str,     # Location City
        'LSTATE': str,    # Location State
        'LZIP': str,      # Location Zip Code
        'LZIP4': str,     # Location Zip+4
        'PHONE': str,     # Phone Number
        'CHARTER_TEXT': str,  # Charter School Text
        'MAGNET_TEXT': str,   # Magnet School Text
        'VIRTUAL': str,       # Virtual School Status
        'GSLO': str,          # Grade Span Low
        'GSHI': str,          # Grade Span High
        'SCHOOL_LEVEL': str,  # School Level
        'STITLEI': str,       # Title I School Status
        'STATUS': str,        # School Status
        'SCHOOL_TYPE_TEXT': str,   # School Type Text
        'SY_STATUS_TEXT': str,     # School Year Status Text
        'NMCNTY': str,             # County Name
        'ULOCALE': str,            # Locale
        'TOTFRL': float,             # Total Free Lunch Eligible
        'FRELCH': float,             # Free Lunch Eligible
        'REDLCH': float,             # Reduced Price Lunch Eligible
        'PK': float,
        'KG': float,
        'G01': float,
        'G02': float,
        'G03': float,
        'G04': float,
        'G05': float,
        'G06': float,
        'G07': float,
        'G08': float,
        'G09': float,
        'G10': float,
        'G11': float,
        'G12': float,
        'G13': float,
        'UG': float,
        'AE': float,
        'TOTFENROL': float,
        'TOTMENROL': float,
        'TOTAL': float,
        'FTE': float,
        'MEMBER': float,
        'STUTERATIO': float,
        'AMALM': float,
        'AMALF': float,
        'AM': float,
        'ASALM': float,
        'ASALF': float,
        'AS': float,
        'BLALM': float,
        'BLALF': float,
        'BL': float,
        'HPALM': float,
        'HPALF': float,
        'HP': float,
        'HIALM': float,
        'HIALF': float,
        'HI': float,
        'TRALM': float,
        'TRALF': float,
        'TR': float,
        'WHALM': float,
        'WHALF': float,
        'WH': float,
        'LATCOD': float,
        'LONCOD': float
    }

# Modified to escape column names if they are reserved keywords or contain lowercase characters.
def get_sql_column_definition(data_types, max_lengths):
    reserved_keywords = {'AS', 'GROUP', 'SELECT', 'WHERE', 'JOIN'}  # Add more if needed.
    column_defs = []
    for column, data_type in data_types.items():
        # Escape column name if it's a reserved keyword or contains lowercase characters.
        safe_column = f'"{column}"' if column.upper() in reserved_keywords or any(c.islower() for c in column) else column
        
        if data_type == str:
            # For string types, use VARCHAR with the maximum length found in the CSV
            column_defs.append(f'"{column}" VARCHAR({max_lengths.get(column, 255)})')  # Default to 255 if not in max_lengths
        else:
            sql_type = 'FLOAT'
            column_defs.append(f"{safe_column} {sql_type}")
            
    return ", ".join(column_defs)

def load_data(csv_file_path, conn, table_name):
    # Find the maximum lengths for string columns
    string_columns = [col for col, dtype in data_types.items() if dtype == str]
    max_char_lengths = find_max_char_lengths(csv_file_path, string_columns)
    
    # Update string column data types to use VARCHAR with max lengths
    for column in max_char_lengths:
        if column in data_types and isinstance(data_types[column], str):
            data_types[column] = f"VARCHAR({max_char_lengths[column]})"
    
    # Read the CSV file into a DataFrame with the specified data types
    df = pd.read_csv(csv_file_path, dtype=data_types, encoding="cp1252")
    
    # Generate the SQL DDL command
    column_defs = get_sql_column_definition(data_types, max_char_lengths)
    create_table_query = f'CREATE TABLE IF NOT EXISTS "CRDB".{table_name} ({column_defs});'
    print(create_table_query)
    
    # Execute the CREATE TABLE command
    with conn.cursor() as cur:
        cur.execute(create_table_query)
        conn.commit()
    
    # Prepare and execute the COPY command
    copy_sql = f"COPY \"CRDB\".{table_name} FROM STDIN WITH CSV HEADER DELIMITER ','"

    with open(csv_file_path, 'r', encoding="cp1252") as f, conn.cursor() as cur:
        cur.copy_expert(copy_sql, f)
        conn.commit()


    
# Connect to your PostgreSQL database
# Set up connection parameters
conn_params = {
    "dbname": 'CRDB',
    "user": 'postgres',
    "password": os.getenv('PostgreSQL_PWD'),
    "host": '127.0.0.1',
    "port": '5432'
}

# Specify the directory where the CSV file is stored
data_directory = '../data/EDGE_PublicSchoolCharacteristics'
csv_filename = 'Public_School_Characteristics_2017-18.csv'  # Change to the name of your CSV file
table_name = 'public_school_characteristics_2017_18'
csv_file_path = os.path.join(data_directory, csv_filename)

## ... (setup the connection)
conn = psycopg2.connect(**conn_params)
conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    
# Load data into the database
load_data(csv_file_path, conn, table_name)
    
# Close the connection
conn.close()

