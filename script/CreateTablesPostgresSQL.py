import subprocess
import time
import sys
import re
import os 

start = time.time()

def install_packages_from_requirements(file_name):
    """
    Install or reinstall packages from a requirements.txt file using pip.
    This forces a reinstall to the specific versions listed in the file.
    
    Args:
        file_name (str): The name of the requirements.txt file.
    """
    try:
        # Construct the full path to the requirements file based on the script's directory
        file_path = os.path.join(os.path.dirname(__file__), file_name)
        
        # Execute pip install with the --force-reinstall option
        subprocess.run([sys.executable, '-m', 'pip', 'install', '-r', file_path], check=True)
        print("All packages have been installed or reinstalled to match the versions specified.")
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while installing packages: {e}")
    except FileNotFoundError:
        print(f"Could not find the requirements file at {file_path}. Please ensure the file exists.")


# Function to execute an SQL file
def execute_sql_file(filename, connection):
    # Open and read the SQL file
    with open(filename, 'r') as file:
        sql_content = file.read()
    
    # Print the SQL content for debugging
    print("SQL File Contents:\n", sql_content)

    # Execute the SQL commands
    try:
        cursor = connection.cursor()
        cursor.execute(sql_content)
        connection.commit()  # Commit the transaction
        print(f"Successfully executed {filename}")
    except Exception as e:
        print(f"Error executing {filename}: {e}")
    finally:
        cursor.close()

def generate_ddl(table_name, column_names, max_lengths):
    """Generate a DDL statement for creating a SQL table with all columns as VARCHAR."""
    ddl = f"CREATE TABLE IF NOT EXISTS {table_name} (\n"
    column_definitions = []
    for column_name in column_names:
        # Directly use the maximum length for VARCHAR
        length = max_lengths[column_name]
        column_def = f"    {column_name} VARCHAR({length})"
        column_definitions.append(column_def)
    ddl += ",\n".join(column_definitions)
    ddl += "\n);"
    
    # Print DDL to debug
    print("Generated DDL:", ddl)
    return ddl

def clean_file_and_save_copy(file_path):
    """
    Reads a file line by line, removes lines that are empty or contain only spaces,
    and saves a cleaned copy. Then, loads this cleaned copy to clean column names and save again.
    """
    file_path = os.path.abspath(file_path)
    cleaned_lines = []  # List to hold cleaned lines
    with open(file_path, 'r', encoding='cp1252') as file:
        for line in file:
            # Check if line is not empty or doesn't contain only spaces
            if line.strip():
                cleaned_lines.append(line)
    
    # Define a new file path for the cleaned file
    directory, filename = os.path.split(file_path)
    cleaned_file_path = os.path.join(directory, f"cleaned_{filename}")
    
    # Write the cleaned lines to the intermediate new file
    with open(cleaned_file_path, 'w', encoding='utf-8') as cleaned_file:
        cleaned_file.writelines(cleaned_lines)

    return cleaned_file_path

def find_files(path_directory, flag_xlsx):
    # Search for CSV files in current directory and all subdirectories
    if flag_xlsx:
        list_files = glob.glob(os.path.join(path_directory, '', '*.xlsx'), recursive=True)
        if len(list_files) == 0:
            list_files = glob.glob(os.path.join(path_directory, '', '*.xls'), recursive=True)
    else:
        list_files = glob.glob(os.path.join(path_directory, '', '*.csv'), recursive=True)
    # Filter out temporary Excel files created by MS Office
    # list_files = [file for file in list_files if not os.path.basename(file).startswith('~$')]
    # print("FIND FILES",flag_xlsx, list_files)
    return list_files

def find_max_char_lengths(csv_file_path):
    """Finds the maximum number of characters for each column in a CSV file."""
    file_toCheckMax = pd.read_csv(csv_file_path, dtype = "str", encoding="cp1252")

    max_lengths = {}
    for column in file_toCheckMax.columns:
        # Ensure the column is of string type
        #max_lengths[column] = int(file_toCheckMax[column].str.len().max())
        max_character = int(file_toCheckMax[column].fillna('').astype(str).str.len().max())
        if max_character == 0: 
            max_character = 2
        max_lengths[column] = max_character  
    return max_lengths

def clean_column_name(column_name):
    """
    Clean column names to ensure they are valid SQL identifiers.
    """
    cleaned_name = re.sub(r'\W+', '_', column_name).strip('_').lower()
    return cleaned_name if cleaned_name else 'invalid_column_name'

def convert_excel_to_csv_same_path(excel_file_path):
    # Extract directory and base filename without extension
    directory, base_filename = os.path.split(excel_file_path)
    base_filename_without_ext, extension = os.path.splitext(base_filename)
    print("BASE file", base_filename)
    
    # Construct the CSV file path
    csv_file_path = os.path.join(directory, f"{base_filename_without_ext}.csv")
    
    # Read the Excel file
    if(base_filename_without_ext == 'ussd17'):
            header_row_index = 2
            df = pd.read_excel(excel_file_path, header=header_row_index, dtype=str)
            df.columns = ["state", "state_FIPS","DistrictID", "NameSchoolDistrict","TotalPopulation", "Population5_17","Population5_17InPoverty"]
            df = df.drop([df.index[0], df.index[1]])
            csv_file_path = os.path.join(directory, f"{base_filename_without_ext}_edited.csv")
            
    else:
        df = pd.read_excel(excel_file_path)
        
    df.columns = [clean_column_name(col) for col in df.columns]  # Clean column names
        
    # Save the DataFrame to a CSV file
    
    df.to_csv(csv_file_path, index=False, quoting=csv.QUOTE_ALL)
    print(f"CSV file saved at: {csv_file_path}")

def convert_txt_to_csv(txt_file_path):
    csv_file_path = txt_file_path.replace('.txt', '.csv')
    with open(txt_file_path, 'r', encoding='utf-8') as txt_file, \
         open(csv_file_path, 'w', newline='', encoding='utf-8') as csv_file:
        reader = csv.reader(txt_file, delimiter='|')
        writer = csv.writer(csv_file)
        for row in reader:
            writer.writerow(row)
    return csv_file_path

# install and verify the packages
install_packages_from_requirements('../requirements_dataAnalytics.txt')

import os
import glob
import csv
import pandas as pd
import psycopg2

ENCODING = 'utf-8'

# Retrieve the PostgreSQL_PWD environment variable
postgresql_pwd = os.getenv('PostgreSQL_PWD')

# All directories that will be imported to SQL
all_path_directories = [os.path.join(os.path.dirname(__file__), '../data/GRF17')
    ,os.path.join(os.path.dirname(__file__), '../data/2017-18 Public-Use Files/Data/SCH/CRDC/CSV')
    ,os.path.join(os.path.dirname(__file__), '../data/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV')
    ,os.path.join(os.path.dirname(__file__), '../data/2017-18 Public-Use Files/Data/LEA/CRDC/CSV')
    ,os.path.join(os.path.dirname(__file__), '../data/EDGE_GEOCODE_PUBLICLEA_1718')
    ,os.path.join(os.path.dirname(__file__), '../data')
    ,os.path.join(os.path.dirname(__file__),'../data/hmda_2017_nationwide_all-records_labels')
]

# All directories that will be imported to SQL
output_sql_name = ['GRF17'
                  ,'CRDC_SCH'
                  ,'CRDC_SCH_EDFacts'
                  ,'CRDC_LEA'
                  ,'GEOCODE'
                  ,'ussd17'
                  ,'HMDA'
]

#Change it according with the files that you have in each directory 
excel_files_exist = [False  # If first time, put True (GRF17)
                    ,True
                    ,True 
                    ,True
                    ,False 
                    ,True # If first time, put TRUE (ussd17)
                    ,False
]

file_number = 0
for path_directory in all_path_directories:

    # Eliminate previously cleaned data to avoid replicas
    pattern = path_directory + '/cleaned_*'

    # List all files matching the pattern in the current directory
    for file in glob.glob(pattern):
        try:
            os.remove(file)
            print(f"Deleted file: {file}")
        except OSError as e:
            print(f"Error deleting file {file}: {e.strerror}")

    # Convert Excel Files to CSV if needed
    excel_files = excel_files_exist[file_number]
    if excel_files: 
        xlsx_files = find_files(path_directory, excel_files)
        print(xlsx_files)
        for file_xlsx in xlsx_files:
        # Example usage
            convert_excel_to_csv_same_path(file_xlsx)
        
        excel_files = False
    
    # Find all CSV files at path_directory
    csv_files = find_files(path_directory, excel_files)
    print("\n\n\ncsv_files")
    print( csv_files )
    print("path_directory")
    print( path_directory )
    print("\n\n\n")
    print("Current File >> ")
    print(os.path.join(os.path.dirname(__file__), "../SQL/"+output_sql_name[file_number]+".sql"))

    # Check if the copy_commands.sql file exists and erase it
    if os.path.exists(os.path.join(os.path.dirname(__file__), "../SQL/"+output_sql_name[file_number]+".sql")):
        os.remove(os.path.join(os.path.dirname(__file__), "../SQL/"+output_sql_name[file_number]+".sql"))

    # Create the file with initial SCHEMA command
    with open(os.path.join(os.path.dirname(__file__), "../SQL/"+output_sql_name[file_number]+".sql"), 'x', encoding=ENCODING) as copy_commands_file:
        copy_commands_file.write('CREATE SCHEMA IF NOT EXISTS "CRDB"; \n')

    #Create the tables and copy commands 
    with open(os.path.join(os.path.dirname(__file__), "../SQL/"+output_sql_name[file_number]+".sql"), 'a', encoding=ENCODING) as copy_commands_file:
        for file_csv in csv_files:

            # Generate the table name based on the file name
            table_name = os.path.splitext(os.path.basename(file_csv))[0].replace('-', '')
            table_name = table_name.replace('(', '')
            table_name = table_name.replace(')', '')
            table_name = table_name.replace(' ', '')
            table_name = '"CRDB"' + "." + table_name

            print(table_name)
            max_lengths = find_max_char_lengths(file_csv)

            # Generate the DDL statement for the table
            ddl = generate_ddl(table_name, list(max_lengths.keys()), max_lengths)

            # Assuming table_postgreSQL is your opened file for writing DDL statements
            copy_commands_file.write(ddl + "\n")

            # Pre-process the file path to escape backslashes

            #To use the files without the last empty line
            file_csv_cleaned = clean_file_and_save_copy(file_csv)
            file_csv_escaped = file_csv_cleaned.replace('\\', '/')

            # Format the COPY command for the current file using the pre-processed path
            copy_command = f"COPY {table_name} FROM '{file_csv_escaped}' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';\n"

            # Write the COPY command to the file
            copy_commands_file.write(copy_command)
    file_number=file_number+1



# Connect to the PostgreSQL database
connection = psycopg2.connect(
    dbname='CRDB',
    user='postgres',
    password=postgresql_pwd,
    host='127.0.0.1'
)

# List all files in the specified folder
sqls_to_run = ['ussd17.sql'
              ,'CRDC_LEA.sql'
              ,'GEOCODE.sql'
              ,'CRDC_SCH_EDFacts.sql'
              ,'CRDC_SCH.sql'
              ,'GRF17.sql'
              ,'HMDA.sql'
]

for filename in sqls_to_run:
    # Construct the full path to the file
    full_path = os.path.join(os.path.join(os.path.dirname(__file__),'../SQL'), filename)
    # Execute the SQL file
    execute_sql_file(full_path, connection)

finish = time.time()
print(' ')
print(' ')
print('Finished CreateTablesPostgreSQL.py: ' + str(finish-start) + ' secs.')