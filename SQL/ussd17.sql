CREATE SCHEMA IF NOT EXISTS "CRDB"; 
CREATE TABLE IF NOT EXISTS "CRDB".ussd17_edited (
    state VARCHAR(2),
    state_fips VARCHAR(2),
    districtid VARCHAR(5),
    nameschooldistrict VARCHAR(81),
    totalpopulation VARCHAR(7),
    population5_17 VARCHAR(7),
    population5_17inpoverty VARCHAR(6)
);
COPY "CRDB".ussd17_edited FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/cleaned_ussd17_edited.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
