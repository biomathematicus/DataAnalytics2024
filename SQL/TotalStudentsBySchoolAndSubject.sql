SELECT LEA_STATE, LEAID, LEA_NAME, SCHID, SCH_NAME, TOTAL, 
       CASE WHEN APMath < 0 THEN NULL ELSE APMath END AS APMath,
	   CASE WHEN AdvMath < 0 THEN NULL ELSE AdvMath END AS AdvMath,
	   CASE WHEN APScience < 0 THEN NULL ELSE APScience END AS APScience,
	   CASE WHEN APOthers < 0 THEN NULL ELSE APOthers END AS APOthers,
       CASE WHEN AlgII < 0 THEN NULL ELSE AlgII END AS AlgII,
	   CASE WHEN Bio < 0 THEN NULL ELSE Bio END AS Bio,
	   CASE WHEN Cal < 0 THEN NULL ELSE Cal END AS Cal,
	   CASE WHEN Chem < 0 THEN NULL ELSE Chem END AS Chem,
	   CASE WHEN Geo < 0 THEN NULL ELSE Geo END AS Geo,
	   CASE WHEN Phy < 0 THEN NULL ELSE Phy END AS Phy
FROM HSTOTALS();