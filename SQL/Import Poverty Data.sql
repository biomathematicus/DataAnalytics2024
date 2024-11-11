-- Step 1: Create the POV table
CREATE TABLE "CRDB".POV (
    ST VARCHAR(2),
    FIPS VARCHAR(5),
    SCHOOLID VARCHAR(5),
    SCHOOLNAME VARCHAR(250),
    POP_TOT float,
    POP_SCHL float,
    POV float
);

-- Step 2: Copy data from CSV into the POV table
-- Replace 'path/to/ussd17.csv' with the actual file path.
COPY  "CRDB".POV (ST, FIPS, SCHOOLID, SCHOOLNAME, POP_TOT, POP_SCHL, POV)
FROM 'C:\Dropbox\!JBGPresentations\!2024\2024 CSU\ussd17.csv'
DELIMITER ','
CSV HEADER;

--select * from "CRDB".POV

