# ANALYSYS PIPELINE FOR EDUCATIONAL ATTAINTMENT IN THE US

# Project Scripts Documentation

This README file provides a detailed overview of the scripts included in this repository, their purpose, and how to use them. The scripts are designed to work with PostgreSQL and perform various tasks related to database management and data processing.

## Files Description

### Python Scripts

#### 1. `CreateTablesPostgresSQL_MacVersion.py`
- **Location:** 'script' directory.
- **Purpose:** Manages PostgreSQL database operations on macOS, installs required packages from `requirements.txt`, and executes SQL commands to set up the database schema.
- **Detailed Processing Workflow:**
  - **Clean Up:** Initial cleanup of  anypreviously generated `cleaned_` prefix files in the data directories.
  - **Excel to CSV Conversion:**
    - Checks for Excel files in the specified directories.
    - Converts them to CSV, adjusting headers and formatting based on the file specifics (e.g., `ussd17` has specific columns to be extracted and renamed).
  - **CSV Processing:**
    - For each CSV file found, calculates the maximum character length of each column to determine VARCHAR sizes for SQL table creation.
    - Generates Data Definition Language (DDL) SQL commands for table creation with columns appropriately sized.
    - Cleans CSV files to remove empty lines and spaces, preparing them for database insertion.
    - Creates SQL copy commands to load data from CSV files into the PostgreSQL tables.
  - **SQL File Generation and Execution:**
    - Generates SQL files that include schema creation statements and copy commands for each data directory.
    - Executes these SQL files against a PostgreSQL database to populate tables.
- **Dependencies:** Requires `psycopg2` library for database operations and `subprocess` for executing pip commands.
- **Data Files:** The data should be stored in the following subdirectories:
  - `../data/GRF17`
  - `../data/2017-18 Public-Use Files/Data/SCH/CRDC/CSV`
  - `../data/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV`
  - `../data/2017-18 Public-Use Files/Data/LEA/CRDC/CSV`
  - `../data/hmda_2017_nationwide_all-records_labels`
  - `../data/EDGE_GEOCODE_PUBLICLEA_1718`
  - `../data/ussd17`

#### 2. `CreatingAddressTableFromACLFTxt.py`
- **Location:** 'scripts' directory
- **Purpose:** This Python script reads 52 txt files in `data/ACLF_AddressCountListingFiles2020_AllStates` and creates an address table in a PostgreSQL database by doing the following:
- Setting the schema search path in PostgreSQL.
- Cleaning and preparing column names for SQL usage.
- Establishing data types for SQL table creation.
- Bulk data insertion into PostgreSQL using batch operations.
- Creation of indices on the specific state (txt file)
- **Features:** Utilizes `pandas` for data manipulation and `psycopg2.extras` for efficient batch database operations.
- **Data Files:** All txt files in the folder `ACLF_AddressCountListingFiles2020_AllStates` located in the `data` directory.


### SQL Script

#### 3. `blocks.sql`
- **Location:** `sql/blocks.sql` within the `sql/` directory.
- **Purpose:** Contains SQL statements for creating indices to optimize query performance in the "CRDB" schema.
- **Details:** Creates indices on fields like `LEAID`, `TRACT`, `STATE`, `COUNTY`, and `BLOCK_GEOID` to improve the efficiency of database operations.


## Assumptions

- **Database Setup:** The PostgreSQL database is pre-configured with the necessary schemas and tables.
- **File Hierarchy:**
  - SQL scripts are located under the `sql/` directory. For example, the indexing script is found at `sql/blocks.sql`.
  - Data files intended for processing, such as `data/aclf_data.txt`, are stored in the `data/` directory.
  - Python scripts are executed from the root directory, where they can access SQL scripts and data files using relative paths.
- **Permissions:** Users must have the appropriate permissions to execute SQL queries and run Python scripts that interact with the database.
- **Network Access:** Required for fetching data or installing packages, assuming a stable internet connection is available.



## Introduction

## Methods

$$ x^2 $$

## Results



## Conclusions