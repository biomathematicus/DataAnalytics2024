"""
Script Name: main.py
Description: This script sequentially runs a collection of Python scripts 
             and captures their output and errors. Each script is executed 
             as a subprocess, and the output or error from each script is 
             printed to the console.

Usage:
    1. Ensure that the target scripts are in the same directory as this script,
       or adjust the `scripts` list with relative paths as needed.
    2. Run this script using the following command:
        
        python main.py

Notes:
    - This script uses the subprocess module to execute other scripts.
    - The subprocess.run method is used to run each script, capture its output, 
      and handle any errors that occur during execution.
    - If any script fails, an error message will be printed to the console.

Author: GPT-4
Date: 5/14/2024
"""

import subprocess
import time
import sys
import os

def run_script(script_name):
    try:
        # Get the absolute path of the script based on its relative path
        script_path = os.path.join(os.path.dirname(__file__), script_name)
        
        # Run the script using the current Python interpreter
        result = subprocess.run(
            [sys.executable, script_path],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        print(f"Output of {script_name}:\n{result.stdout.decode('utf-8', errors='replace')}")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while running {script_name}:")

if __name__ == "__main__":
    # Import Tables to SQL
    overwrite_SQL_tables = True # False # 

    # List of script files with paths relative to the directory of main.py
    if overwrite_SQL_tables:
        scripts = [
            'CreateTablesPostgresSQL.py',
            'AnalyzeConvergence.py',
            'VisualizeSpatialPovertyData.py',
            'CreateLaTeXAppendix.py'
        ]
        print("Estimated runtime: ~ 35 minutes")
    else:
        scripts = [
            'AnalyzeConvergence.py',
            'VisualizeSpatialPovertyData.py',
            'CreateLaTeXAppendix.py'
        ]
        print("Estimated runtime: ~ 20 minutes")
    
    # Run each script
    start = time.time()
    print(' ')
    for script in scripts:
        run_script(script)
    finish = time.time()
    print(' ')
    print(' ')
    print('Total runtime : ' + str(finish-start) + ' secs.')
    print('All done.')