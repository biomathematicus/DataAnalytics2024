"""
Script Name: main.py
Description: This script sequentially runs a collection of Python scripts 
             (File1.py, File2.py, File3.py) and captures their output and errors. 
             Each script is executed as a subprocess, and the output or error 
             from each script is printed to the console.

Usage:
    1. Ensure that File1.py, File2.py, and File3.py are in the same directory 
       as this script or provide the correct paths to these files in the `scripts` list.
    2. Run this script using the following command:
        
        python main.py

Notes:
    - This script uses the subprocess module to execute other scripts.
    - The subprocess.run method is used to run each script, capture its output, 
      and handle any errors that occur during execution.
    - If any script fails, an error message will be printed to the console.

Author: GPT-4o. The query used was: 
    - User: "I have a collection of files in python, File1.py, File2.py, FIle3.py. 
    I want you to create a single script that calls all these other scripts. User
    All of the files are scripts with no parameters. Generate the commets at the 
    beginning of the file to serve as documentation"
Date: 5/14/2024
"""

import subprocess

def run_script(script_name):
    try:
        result = subprocess.run(['python', script_name], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print(f"Output of {script_name}:\n{result.stdout.decode()}")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while running {script_name}:\n{e.stderr.decode()}")

if __name__ == "__main__":
    scripts = ['script\\CreateTablesPostgresSQL.py', 
               'script\\AnalyzeConvergence.py', 
               'script\\VisualizeSpatialPovertyData.py',
               'script\\CreateLaTeXAppendix.py']
    
    for script in scripts:
        run_script(script)
