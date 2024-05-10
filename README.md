# ANALYSYS PIPELINE FOR EDUCATIONAL ATTAINTMENT IN THE US

# Project Scripts Documentation

This README file provides a detailed overview of the scripts included in this repository, their purpose, and how to use them. The scripts are designed to work with PostgreSQL and perform various tasks related to database management and data processing.

## Files Description

### Data Overview
1. **2017-18 Civil Rights Data Collection (CRDC):** Provides achievement metrics for U.S. middle and high schools, foundational for analyzing educational performance and demographic impacts.
URL: [CRDC](https://ocrdata.ed.gov/)
2. **Small Area Income and Poverty Estimates (SAIPE):** Offers annual income and poverty statistics by school district, allowing analysis of economic conditions alongside educational achievements.
URL: [SAIPE](https://www.census.gov/data/datasets/2017/demo/saipe/2017-school-districts.html)
3. **2017 School Locations & Geoassignments (SLGA):** Contains geocoded addresses and geographic indicators for educational institutions, useful for spatial analysis.
URL: [SLGA](https://nces.ed.gov/programs/edge/geographic/schoollocations)
4. **2017 Home Mortgage Disclosure Act (HMDA) Database:** Provides mortgage data by census tract, to be correlated with educational and socioeconomic data.
URL: [HMDA](https://www.consumerfinance.gov/data-research/hmda/historic-data/)
5. **2017 School District Geographic Relationship Files (SDGR):** Highlights the spatial relationships between school districts and other geographic areas, crucial for understanding resource allocation.
URL: [SDGR](https://nces.ed.gov/programs/edge/Geographic/RelationshipFiles)
6. **2020 Address Count Listing Files of the Bureau of the Census (ACLF):** Contains detailed housing unit counts by census block, with the Texas file available in your data folder.
URL: [ACLF](https://www.census.gov/geographies/reference-files/2020/geo/2020addcountlisting.html)

**Data Organization**
All raw data must be stored in a directory named "data" at the work directory. This directory includes several subfolders:
- `../data/GRF17`
- `../data/2017-18-crdc-data/2017-18 Public-Use Files/Data/SCH/CRDC/CSV`
- `../data/2017-18-crdc-data/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV`
- `../data/2017-18-crdc-data/2017-18 Public-Use Files/Data/LEA/CRDC/CSV`
- `../data/hmda_2017_nationwide_all-records_labels`
- `../data/EDGE_GEOCODE_PUBLICLEA_1718`
- `../data`

These subfolders contain various CSV or Excel files which will be converted to CSV if necessary, and then saved as tables in PostgreSQL under the following names:

- `GRF17`
- `CRDC_SCH`
- `CRDC_SCH_EDFacts`
- `CRDC_LEA`
- `HMDA`
- `GEOCODE`
- `ussd17_edited`

**Shapefiles Overview**
  - **Source:** The shapefiles are downloaded from the U.S. Census Bureau, specifically from their TIGER/Line files. These files are a comprehensive source of geographic data that provides detailed information about various geographical and administrative boundaries in the United States.
  - **Usage:**
    - *County Level Shapefiles:* Used to create detailed maps that display data at the county level. This granularity allows for the visualization of data variations within states, which is crucial for analyses that require understanding local differences in demographic and economic conditions. These maps are instrumental in visualizing the distribution of poverty among children and the enrollment rates in Algebra II across different counties. The shapefiles for the counties can be accessed directly via [Census Bureau - County Shapefiles 2018](https://www2.census.gov/geo/tiger/TIGER2018/COUNTY/)
    - *State Level Shapefiles:* These are used to create broader state-level visualizations. Such maps are useful for assessing and comparing overall state performance and trends, particularly useful in your project for creating heatmaps of state performance in educational metrics. These shapefiles can be accessed through [Census Bureau - State Shapefiles 2018](https://www2.census.gov/geo/tiger/TIGER2018/STATE/)
  - **Technical Details**
    - **Format:** The shapefiles are provided in a standard format that includes essential geographic data attributes, such as boundaries and identifiers, which can be easily integrated into geographic information systems (GIS) to create maps.
    - **Access:** Files are accessed via the FTP archive, which allows for direct download of the latest available data for each year, ensuring the maps reflect current administrative boundaries and geographical data.
    - **Organization:** The shape files must be saved in a folder called "shape_files" in order to be called as follow: `../shape_files/tl_2018_us_county/tl_2018_us_county.shp` for the county shape file, and `../shape_files/tl_2018_us_state/tl_2018_us_state.shp` for the state shape file. 


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

#### 2. `CreateTablesPostgresSQL.py`
- **Location:** 'script' directory.
- **Purpose:** Automate the setup and preparation of a PostgreSQL database for analyzing educational data. It handles the entire workflow of importing, cleaning, and setting up database tables directly from raw data files.
- **Detailed Processing Workflow:** 
  - **Package Management:**
    - Installs or reinstalls packages from a `requirements.txt` file to ensure the environment matches the specified versions. This is crucial for maintaining consistency across different deployment environments.
  - **SQL File Execution:**
    - Opens and executes SQL files to run commands on a PostgreSQL database. This includes creating tables, inserting data, and other database operations, committing transactions, and handling errors.
- **Table Definition Generation (DDL):**
    - Generates Data Definition Language (DDL) statements for creating SQL tables. All columns are defined as `VARCHAR` with lengths based on the maximum lengths found in the data. This ensures that the database can accommodate the data without truncation errors.
- **Data Cleaning:**
    - Reads and cleans CSV files by removing lines that are empty or contain only spaces. This helps in preventing errors during data import and ensures data quality.
- **Database Connection:**
    - Establishes a connection to a PostgreSQL database using credentials and connection parameters. This is essential for executing SQL queries and managing the database.
- **Data Import Workflow:**
    - Iterates through each subfolder inside the "data" directory, processing CSV files for each dataset.
    - For each CSV file:
      - Converts Excel files to CSV if necessary.
      - Cleans the CSV files for unnecessary spaces or column names.
      - Generates and writes SQL statements to create tables based on the CSV structure.
      - Prepares SQL commands to import cleaned data into the PostgreSQL database using the COPY command.
      - SQL Command Management:
        - Generates SQL commands for each table and writes them to SQL files, which are later executed against the database to create tables and import data.
- **Requirenments:**   
  - Requires `pandas`, `psycopg2`, `openpyxl`, `xlrd`
  - You have to create an environmental variables with your PostgreSQL password, called `PostgreSQL_PWD`. 
  - The script requires to create a folder called "SQL" in the work directory.  
  - You must create a database in PostgreSQL called "CRDB". 
- **Output:** The script creates a SQL script in the "SQL" folder and generates the tables in PostgreSQL under the name of "CRDB". 
- **Data Files:** This script uses the data explained on Data Overview. 


#### 3. `AnalyzeConvergence.py`
- **Location:** 'script' directory.
- **Purpose:** Finds the best polynomial fit for an histogram representing the proportion of children aged 5 to 17 in poverty for each state. The script iterates through different degrees of polynomials to access where the root mean square error (RMSE) converges. Convergency is considered when the relative change of RMSE is below a threshold (5%).
- **Detailed Processing Workflow:** 
  - **Polynomial Degree Iteration:**
    - Iterates over a range of polynomial degrees to fit the histogram data.
    - Computes the polynomial coefficients for each degree.
  - **Error Calculation:**
    - Calculates the RMSE for each polynomial fit to assess the accuracy.
    - Identifies the polynomial degree that results in the minimum RMSE.
- **Histogram Approximation:**
    - Uses the optimal polynomial fit to approximate the histogram of the proportion of children in poverty across states.
- **Dependencies:** Requires `psycopg2`, `geopandas`, `matplotlib`. 
- **Output:** Generates and saves visualizations in a structured folder system within the "Figures" directory, which includes the RMSE evolution versus polynomial degree and the relative change of the RMSE normalized by the intial RMSE.
- **Data Files:** The script calls executes several SQL queries to obtain the source data for the histograms. 

#### 4. `VisualizeSpatialPovertyData.py`
- **Location:**  'script' directory.
- **Purpose:** Automates the visual representation of poverty data and algebra II enrollment across various geographical divisions, and identifies patterns and disparities in educational and economic metrics. It visually represents these metrics in several forms including histograms, maps, and heatmaps.
- **Detailed Processing Workflow:**
  - **Data Extraction:**
    - Executes several SQL queries to retrieve the necessary data from a PostgreSQL database, including children in poverty, algebra II enrollment, family income, and loan data.
  - **Histogram Generation:**
    - Creates polynomial approximations of histograms for the proportion of children in poverty.
    - Saves these visualizations in the "Histograms" subfolder.
  - **Spatial Analysis:**
    - Identifies school districts with a higher proportion of children enrolled in Algebra II compared to those in poverty, and vice versa.
    - Uses a color code system to differentiate these districts on visualizations.
  - **Map Visualization:**
    - Generates maps by county, plotting family income and loan amounts for each state.
    Color codes the districts according to the criteria specified for Algebra II and poverty proportions.
    Saves these maps in the "Income_StateMaps" and "Loan_StateMaps" subfolders.
  - **Heatmap Generation:** 
    - Creates heatmaps to visualize state performance regarding the proportions of children in poverty and their enrollment in Algebra II.
    Saves these heatmaps in the "Figures" folder.
- **Dependencies:** 
  - Requires Python libraries such as `matplotlib`, `pandas`, `psycopg2`. 
  - A folder named "shape_fies", located in the work directory is also necessary, where the shape files downloaded from Census Bureau are going to be. 
- **Output:** Generates and saves visualizations in a structured folder system within the "Figures" directory, which includes subfolders for different types of visual data.
- **Data Files:** Utilizes data extracted from SQL databases and processed for visualization purposes. Shape files from all the counties and states were also used to create the map figures. Refer to Data Overview to check it. 

#### 5. `CreateLaTeXAppendix.py`
- **Purpose:** The script automates the generation of a LaTeX document which integrates visual outputs from other analytical processes. Specifically, it compiles heatmaps of average family income and average loan amounts by county, along with histograms into a cohesive LaTeX document, and subsequently generates a PDF.
- **Functionality:**
  - **Data Collection:** The script retrieves heatmap and histogram files previously generated by other scripts in the project.
  - **LaTeX Script Generation:** It dynamically generates LaTeX code to embed these visualizations in an organized manner. The LaTeX code includes formatting and layout configurations to ensure the visualizations are displayed effectively.
- **Output:** he final output is a LaTeX file that systematically presents all the visual data concerning family income, loans, and other relevant metrics, making it a valuable reference document for stakeholders or researchers who require detailed visual insights into the data. This LaTeX file can be compiled using any LaTeX interpreter such as MikTek, with the geometry.sty being the only requirement.

#### 6. `CreatingAddressTableFromACLFTxt.py`
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

#### 7. `blocks.sql`
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