# Education Data Pipeline

This project is a [Reproducible Analytical Pipeline](https://analysisfunction.civilservice.gov.uk/support/reproducible-analytical-pipelines/) that performs automated [ETL (Extract, Transform, Load)](https://aws.amazon.com/what-is/etl/) and generates HTML reports from Jupyter Notebooks.

## View Interactive Reports 
- https://jsparks9.github.io/edu-data-pipeline/Jupyter%20Output/by_lea_sums.html
- https://jsparks9.github.io/edu-data-pipeline/Jupyter%20Output/by_school.html
- https://jsparks9.github.io/edu-data-pipeline/Jupyter%20Output/by_lea.html

## Setup Instructions
### Step 1
Ensure Docker and Bash are installed
Start Docker Desktop
### Step 2
Run Run_Py_Setup.sh
This creates the Docker image and takes 2-3 minutes
### Step 3
Open the Py VSC Project folder in VS Code, reopen in container when prompted. This is using the Dev Container plugin for VSCode. 
### Step 4
Run Run_SQL_Setup.sh
This takes about 20-25 minutes

## Data Overview

- **CRDC** (2017-18 Civil Rights Data Collection): Provides achievement metrics for U.S. middle and high schools, foundational for analyzing educational performance and demographic impacts.
  - **ED** tables provide information on race and disability for each school. ED tables are not currently incorporated into the report analysis.
  - **LEA** (Local Educational Agency) tables are used in this analysis to link schools with LEA IDs.
  - **SCH** tables provide enrollment data per school. In this analysis, enrollment in various high school courses and total enrollment are taken from these tables.

- **SAIPE** (Small Area Income and Poverty Estimates): Offers annual income and poverty statistics by school district, allowing analysis of economic conditions alongside educational achievements.
  - From the SAIPE table, the analysis fetches the population of people ages 5-17 and the poverty rate for this group. These records are per district, which is matched with the LEA ID.

- **SLGA** (2017 School Locations & Geoassignments): Contains geocoded addresses and geographic indicators for educational institutions, useful for spatial analysis.

- **HMDA** (2017 Home Mortgage Disclosure Act): Provides mortgage data by census tract, to be correlated with educational and socioeconomic data.

- **SDGR** (2017 School District Geographic Relationship): Highlights the spatial relationships between school districts and other geographic areas, crucial for understanding resource allocation.

- **ACLF** (2020 Address Count Listing Files of the Bureau of the Census): Contains detailed housing unit counts by census block, with the Texas file available in your data folder.

