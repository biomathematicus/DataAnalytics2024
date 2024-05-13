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


#### 7. `leaid_tract_conversions.sql`
- **Location:** `sql/leaid_tract_conversions.sql` within the `script/` directory.
- **Purpose:** Facilitates critical preprocessing steps for handling LEAID and tract data, ensuring the database is optimized for efficient queries. The script includes preliminary data cleaning, indexing for optimization, and setting up the database schema for detailed educational data analysis. This script should be run AFTER  `scripts/CreateTablesPostgresSQL.py` to configure the database correctly for subsequent data loading and querying operations. 
- **Weight Assignment**: Weights are calculated based on the land area associated with each block group, ensuring more accurate data representation in analyses. The weights help in adjusting student counts and other metrics to reflect the proportionate size of each geographical unit. A few notes:
    - **Zero Land Area**: Block groups with zero land area receive a weight of zero to exclude them from contributing to averages. It is noteworthy that no leaids were made entirely of block groups with zero land area.
    - **Single LEAID**: Block groups with positive land area contributing to a single LEAID and are assigned a weight of one, to reflect that fact that 100% of the block group contributes to given LEAID.
    - **Multiple LEAIDs**: For block groups spanning multiple LEAIDs, weights are dynamically calculated based on the ratio of the land area area associated with each LEAID-block-group pair to the total land area associated with each LEAID. The weights for an LEAID sum to
1.
The functions `get_leaid_students_and_landarea()` and `assign_blkgrp_weights()` encapsulate the logic for computing these weights and are used to update the database accordingly.
- **Cleaning and Prepration**: To prepare the data, columns were added to existing tables, adjustmented were made to data types, and functions were created. Extensive use of indexing on pivotal columns like LEAID, tract, and block group identifiers to expedite data retrieval operations.
- *** RESULTS ***
  The following functions are notable and are used in `leaid_mortgage_results.py` within the `script/` directory.
  ##### 1. `calculate_totals_for_all_leaids`
  - **Location:** public schema of "CRDB"
  - **Purpose:** This function iterates over all LEAIDs, calculating various metrics related to enrollment, population, and their estimated counterparts, along with errors in estimation. It operates by invoking the `calculate_leaid_totals()` function for each LEAID and combines the results with additional information about the number of block groups in each LEAID.
  - **Input:** None
  - **Output:** A table containing the following columns:
      - `leaid_`: LEAID identifier
      - `total_enrollment_leaid`: Total enrollment count for the LEAID
      - `estimated_leaid_enrollment`: Estimated enrollment count for the LEAID
      - `student_error`: Error in student count estimation (the difference between total enrollment and estimated enrollment)
      - `total_population_leaid`: Total population count for the LEAID
      - `estimated_leaid_population`: Estimated population count for the LEAID
      - `pop_error`: Error in population count estimation (the difference between total population and estimated population)
      - `num_blks_in_leaid`: Number of block groups within the LEAID
  - **Implementation Details:**
      - Temporarily creates a table to store distinct LEAIDs.
      - Iterates over each LEAID, invoking `calculate_leaid_totals()` and joining the results with additional block group information.
      - Calculates errors in enrollment and population estimation.
      - Cleans up temporary table after processing.
  - **Usage:** This function provides insights into the accuracy of enrollment and population estimations for each LEAID, facilitating further analysis and decision-making based on the data's reliability.
    ##### 2. `get_algebraii_enrollment_summary_leaid`
  - **Location:** public schema of "CRDB"
  - **Purpose:** This function computes a summary of Algebra II enrollment statistics for each LEAID. It calculates the total number of males enrolled in Algebra II (`total_algii_males`), the total number of females enrolled in Algebra II (`total_algii_females`), the overall Algebra II enrollment count (`total_algii_enrollment`), and the percentage of students enrolled in Algebra II relative to the general total enrollment (`percentage_algii_enrollment`). It operates by querying the "CRDB" database's `algebraii` table and utilizes the `get_total_students_by_leaid()` function to obtain the general total enrollment for each LEAID. We are only interested in schools that offer Algebra II.
  - **Input:** None
  - **Output:** A table with the following columns:
      - `leaid`: LEAID identifier
      - `total_algii_males`: Total males enrolled in Algebra II
      - `total_algii_females`: Total females enrolled in Algebra II
      - `total_algii_enrollment`: Total enrollment in Algebra II
      - `general_total_enrollment`: General total enrollment for the LEAID
      - `percentage_algii_enrollment`: Percentage of students enrolled in Algebra II relative to the general total enrollment
  - **Implementation Details:**
      - Aggregates male and female enrollment counts separately, considering only non-negative values.
      - Calculates the total Algebra II enrollment by summing up male and female enrollment counts.
      - Computes the percentage of Algebra II enrollment relative to the general total enrollment, handling potential division by zero errors.
  - **Usage:** This function facilitates the assessment of Algebra II enrollment patterns across LEAIDs, aiding in educational policy planning and resource allocation.
##### 3. `get_leaid_algii_mortgage`
  - **Location:** public schema of "CRDB"
  - **Purpose:** This function retrieves mortgage data associated with Algebra II enrollment statistics for each LEAID. It fetches information such as the denial count, weighted average rate spread, weighted average minority population, weighted average HUD median family income, and weighted average tract-to-MSAMD income. The function joins the results from `get_algebraii_enrollment_summary_leaid()` with data obtained from `get_hmda_data_per_tract_leaid()` to provide insights into mortgage-related metrics correlated with Algebra II enrollment.
  - **Input:** None
  - **Output:** A table with the following columns:
      - `leaid`: LEAID identifier
      - `algii_enrollment`: Total Algebra II enrollment for the LEAID
      - `percentage_algii_enrollment`: Percentage of students enrolled in Algebra II relative to the general total enrollment
      - `denial_count`: Total count of mortgage denials
      - `weighted_avg_rate_spread`: Weighted average rate spread of mortgages
      - `weighted_avg_minority_population`: Weighted average minority population
      - `weighted_avg_hud_median_family_income`: Weighted average HUD median family income
      - `weighted_avg_tract_to_msamd_income`: Weighted average tract-to-MSAMD income
  - **Implementation Details:**
      - Joins the results from `get_algebraii_enrollment_summary_leaid()` with data obtained from `get_hmda_data_per_tract_leaid()` based on the LEAID.
      - Aggregates mortgage-related metrics such as denial count and weighted averages.
  - **Usage:** This function enables the examination of potential correlations between Algebra II enrollment rates and mortgage-related factors, aiding in understanding socioeconomic dynamics within educational contexts.
  - **Note:** The function creates or replaces a table `leaid_algii_mortgage_data` to store the results for further analysis.


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
