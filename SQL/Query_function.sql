CREATE OR REPLACE FUNCTION HSTOTALS()
RETURNS TABLE(LEA_STATE VARCHAR(300), LEAID VARCHAR(300), LEA_NAME VARCHAR(300), SCHID VARCHAR(300), 
			 SCH_NAME VARCHAR(300), TOTAL INT, AdvMath INT, APMath INT, 
			 APScience INT, APOthers INT, AlgII INT, Bio INT, 
			 Cal INT, Chem INT, Geo INT, Phy INT) AS
$$
BEGIN RETURN QUERY
SELECT E."LEA_STATE", E."LEAID", E."LEA_NAME", E."SCHID", E."SCH_NAME",  
		CAST("TOT_ENR_M" AS INTEGER) + CAST("TOT_ENR_F" AS INTEGER) AS TOTAL,
		CAST("TOT_MATHENR_ADVM_M" AS INTEGER) + CAST("TOT_MATHENR_ADVM_F" AS INTEGER) AS AdvMath,
		CAST("TOT_APMATHENR_M" AS INTEGER) + CAST("TOT_APMATHENR_F" AS INTEGER) AS APMath,
		CAST("TOT_APSCIENR_M" AS INTEGER) + CAST("TOT_APSCIENR_F" AS INTEGER) AS APScience,
		CAST("TOT_APOTHENR_M" AS INTEGER) + CAST("TOT_APOTHENR_F" AS INTEGER) AS APOthers,
		CAST("TOT_MATHENR_ALG2_M" AS INTEGER) + CAST("TOT_MATHENR_ALG2_F" AS INTEGER) AS AlgII,
		CAST("TOT_SCIENR_BIOL_M" AS INTEGER) + CAST("TOT_SCIENR_BIOL_F" AS INTEGER) AS Bio,
		CAST("TOT_MATHENR_CALC_M" AS INTEGER) + CAST("TOT_MATHENR_CALC_F" AS INTEGER) AS Cal,
		CAST("TOT_SCIENR_CHEM_M" AS INTEGER) + CAST("TOT_SCIENR_CHEM_F" AS INTEGER) AS Chem,
		CAST("TOT_MATHENR_GEOM_M" AS INTEGER) + CAST("TOT_MATHENR_GEOM_F" AS INTEGER) AS Geo,
		CAST("TOT_SCIENR_PHYS_M" AS INTEGER) + CAST("TOT_SCIENR_PHYS_F" AS INTEGER) AS Phy
FROM 	"CRDB".schoolcharacteristics SC
		JOIN "CRDB".enrollment E 
		ON SC."SCHID" = E."SCHID" AND SC."LEAID" = E."LEAID"
		JOIN "CRDB".advancedmathematics AV
		ON AV."SCHID" = E."SCHID" AND AV."LEAID" = E."LEAID"
		JOIN "CRDB".advancedplacement AP
		ON AP."SCHID" = E."SCHID" AND AP."LEAID" = E."LEAID"
		JOIN "CRDB".algebraii Alg2
		ON Alg2."SCHID" = E."SCHID" AND Alg2."LEAID" = E."LEAID"
		JOIN "CRDB".biology Bio
		ON Bio."SCHID" = E."SCHID" AND Bio."LEAID" = E."LEAID"
		JOIN "CRDB".calculus Cal
		ON Cal."SCHID" = E."SCHID" AND Cal."LEAID" = E."LEAID"
		JOIN "CRDB".chemistry Che
		ON Che."SCHID" = E."SCHID" AND Che."LEAID" = E."LEAID"
		JOIN "CRDB".geometry Geo
		ON Geo."SCHID" = E."SCHID" AND Geo."LEAID" = E."LEAID"
		JOIN "CRDB".physics Phy
		ON Phy."SCHID" = E."SCHID" AND Phy."LEAID" = E."LEAID"
WHERE	"SCH_GRADE_G09" = 'Yes'
		AND "SCH_GRADE_G10"  = 'Yes'
		AND "SCH_GRADE_G11" = 'Yes'
		AND "SCH_GRADE_G12" = 'Yes'
		AND CAST("TOT_ENR_M" AS INTEGER) >= 0
		AND CAST("TOT_ENR_F" AS INTEGER) >= 0
		AND CAST("TOT_ENR_M" AS INTEGER) + CAST("TOT_ENR_F" AS INTEGER) > 0
ORDER BY E."LEA_STATE", E."LEA_NAME", E."SCH_NAME";
END;
$$ LANGUAGE plpgsql

/* 
After the query is created, you can see the table by using this following command:

SELECT * FROM HSTOTALS();
*/