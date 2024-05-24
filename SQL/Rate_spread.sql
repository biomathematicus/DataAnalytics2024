SELECT 
    a.census_tract_number,
	b."NAME_LEA17",
    AVG(CAST(a.rate_spread AS FLOAT)) AS avg_rate_spread
FROM 
    "CRDB".hmda_2017_nationwide_allrecords_labels a
JOIN 
    "CRDB".grf17_lea_tract b 
ON 
    RIGHT(TRIM(b."TRACT"), 6) = REPLACE(TRIM(a.census_tract_number), '.', '')
WHERE 
    a.census_tract_number IS NOT NULL 
    AND TRIM(a.census_tract_number) <> ''
    AND LENGTH(REPLACE(TRIM(a.census_tract_number), '.', '')) = 6
    AND LENGTH(TRIM(b."TRACT")) >= 10
    AND a.rate_spread <> ''  -- This condition filters out empty strings
GROUP BY 
	a.census_tract_number,
	b."NAME_LEA17"
ORDER BY 
    b."NAME_LEA17";
	

SELECT 
    a.census_tract_number,
	b."TRACT",
	b."NAME_LEA17",
    AVG(CAST(a.rate_spread AS FLOAT)) AS avg_rate_spread
FROM 
    "CRDB".hmda_2017_nationwide_allrecords_labels a
JOIN 
    "CRDB".grf17_lea_tract b 
ON 
    RIGHT(TRIM(b."TRACT"), 6) = REPLACE(TRIM(a.census_tract_number), '.', '')
WHERE 
    a.census_tract_number IS NOT NULL 
    AND TRIM(a.census_tract_number) <> ''
    AND LENGTH(REPLACE(TRIM(a.census_tract_number), '.', '')) = 6
    AND LENGTH(TRIM(b."TRACT")) >= 10
    AND a.rate_spread <> ''  -- This condition filters out empty strings
GROUP BY 
    a.census_tract_number,
	b."TRACT",
	b."NAME_LEA17"
ORDER BY 
    b."NAME_LEA17";