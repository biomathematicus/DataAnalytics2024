copy (
select e."lea_state", e."leaid", e."lea_name", lc."lea_city", lc."lea_zip", e."schid", e."sch_name",  
		cast(tot_enr_m as integer) + cast(tot_enr_f as integer) as total,
		cast(tot_mathenr_advm_m as integer) + cast(tot_mathenr_advm_f as integer) as advmath,
		cast(tot_apmathenr_m as integer) + cast(tot_apmathenr_f as integer) as apmath,
		cast(tot_apscienr_m as integer) + cast(tot_apscienr_f as integer) as apscience,
		cast(tot_apothenr_m as integer) + cast(tot_apothenr_f as integer) as apothers,
		cast(tot_mathenr_alg2_m as integer) + cast(tot_mathenr_alg2_f as integer) as algii,
		cast(tot_scienr_biol_m as integer) + cast(tot_scienr_biol_f as integer) as bio,
		cast(tot_mathenr_calc_m as integer) + cast(tot_mathenr_calc_f as integer) as cal,
		cast(tot_scienr_chem_m as integer) + cast(tot_scienr_chem_f as integer) as chem,
		cast(tot_mathenr_geom_m as integer) + cast(tot_mathenr_geom_f as integer) as geo,
		cast(tot_scienr_phys_m as integer) + cast(tot_scienr_phys_f as integer) as phy,
		pov.pov/pop_schl as PerctPov, 
		distinct((cast(tot_mathenr_alg2_m as float) + cast(tot_mathenr_alg2_f as float))/
		(cast(tot_enr_m as float) + cast(tot_enr_f as float))) as PerctAlgII
from 	"CRDB".schoolcharacteristics sc
		join "CRDB".enrollment e 
		on sc.schid = e.schid and sc.leaid = e.leaid
		join "CRDB".leacharacteristics as lc
		on sc.leaid = lc.leaid
		join "CRDB".advancedmathematics av
		on av.schid = e.schid and av.leaid = e.leaid
		join "CRDB".advancedplacement ap
		on ap.schid = e.schid and ap.leaid = e.leaid
		join "CRDB".algebraii alg2
		on alg2.schid = e.schid and alg2.leaid = e.leaid
		join "CRDB".biology bio
		on bio.schid = e.schid and bio.leaid = e.leaid
		join "CRDB".calculus cal
		on cal.schid = e.schid and cal.leaid = e.leaid
		join "CRDB".chemistry che
		on che.schid = e.schid and che.leaid = e.leaid
		join "CRDB".geometry geo
		on geo.schid = e.schid and geo.leaid = e.leaid
		join "CRDB".physics phy
		on phy.schid = e.schid and phy.leaid = e.leaid
		join "CRDB".POV pov 
		on pov.schoolid = e.schid
where	sch_grade_g09 = 'Yes'
		and sch_grade_g10  = 'Yes'
		and sch_grade_g11 = 'Yes'
		and sch_grade_g12 = 'Yes'
		and cast(tot_enr_m as integer) >= 0
		and cast(tot_enr_f as integer) >= 0
		and cast(tot_enr_m as integer) + cast(tot_enr_f as integer) > 0
		and e.lea_state = 'CA'
order by e.lea_state, e.lea_name, e.sch_name
) TO 'C:\Dropbox\!JBGPresentations\!2024\2024 CSU\AlgVsPov.csv' DELIMITER ',' CSV HEADER;


-- select distinct lea_state from "CRDB".enrollment order by lea_state

/*
************************************************************
************************************************************
************************************************************
*/

COPY (
    SELECT DISTINCT ON (e."lea_state", e."lea_name", e."sch_name") 
        e."lea_state", 
        e."leaid", 
        e."lea_name", 
        lc."lea_city", 
        lc."lea_zip", 
        e."schid", 
        e."sch_name",  
        CAST(tot_enr_m AS INTEGER) + CAST(tot_enr_f AS INTEGER) AS total,
        CAST(tot_mathenr_advm_m AS INTEGER) + CAST(tot_mathenr_advm_f AS INTEGER) AS advmath,
        CAST(tot_apmathenr_m AS INTEGER) + CAST(tot_apmathenr_f AS INTEGER) AS apmath,
        CAST(tot_apscienr_m AS INTEGER) + CAST(tot_apscienr_f AS INTEGER) AS apscience,
        CAST(tot_apothenr_m AS INTEGER) + CAST(tot_apothenr_f AS INTEGER) AS apothers,
        CAST(tot_mathenr_alg2_m AS INTEGER) + CAST(tot_mathenr_alg2_f AS INTEGER) AS algii,
        CAST(tot_scienr_biol_m AS INTEGER) + CAST(tot_scienr_biol_f AS INTEGER) AS bio,
        CAST(tot_mathenr_calc_m AS INTEGER) + CAST(tot_mathenr_calc_f AS INTEGER) AS cal,
        CAST(tot_scienr_chem_m AS INTEGER) + CAST(tot_scienr_chem_f AS INTEGER) AS chem,
        CAST(tot_mathenr_geom_m AS INTEGER) + CAST(tot_mathenr_geom_f AS INTEGER) AS geo,
        CAST(tot_scienr_phys_m AS INTEGER) + CAST(tot_scienr_phys_f AS INTEGER) AS phy,
        pov.pov / pop_schl AS PerctPov, 
        (CAST(tot_mathenr_alg2_m AS FLOAT) + CAST(tot_mathenr_alg2_f AS FLOAT)) / 
        (CAST(tot_enr_m AS FLOAT) + CAST(tot_enr_f AS FLOAT)) AS PerctAlgII
    FROM "CRDB".schoolcharacteristics sc
    JOIN "CRDB".enrollment e ON sc.schid = e.schid AND sc.leaid = e.leaid
    JOIN "CRDB".leacharacteristics lc ON sc.leaid = lc.leaid
    JOIN "CRDB".advancedmathematics av ON av.schid = e.schid AND av.leaid = e.leaid
    JOIN "CRDB".advancedplacement ap ON ap.schid = e.schid AND ap.leaid = e.leaid
    JOIN "CRDB".algebraii alg2 ON alg2.schid = e.schid AND alg2.leaid = e.leaid
    JOIN "CRDB".biology bio ON bio.schid = e.schid AND bio.leaid = e.leaid
    JOIN "CRDB".calculus cal ON cal.schid = e.schid AND cal.leaid = e.leaid
    JOIN "CRDB".chemistry che ON che.schid = e.schid AND che.leaid = e.leaid
    JOIN "CRDB".geometry geo ON geo.schid = e.schid AND geo.leaid = e.leaid
    JOIN "CRDB".physics phy ON phy.schid = e.schid AND phy.leaid = e.leaid
    JOIN "CRDB".POV pov ON pov.schoolid = e.schid
    WHERE sch_grade_g09 = 'Yes'
        AND sch_grade_g10 = 'Yes'
        AND sch_grade_g11 = 'Yes'
        AND sch_grade_g12 = 'Yes'
        AND CAST(tot_enr_m AS INTEGER) >= 0
        AND CAST(tot_enr_f AS INTEGER) >= 0
        AND CAST(tot_enr_m AS INTEGER) + CAST(tot_enr_f AS INTEGER) > 0
        AND e.lea_state = 'CA'
    ORDER BY e.lea_state, e.lea_name, e.sch_name
) TO 'C:\\Dropbox\\!JBGPresentations\\!2024\\2024 CSU\\AlgVsPov.csv' DELIMITER ',' CSV HEADER;



/*
********************************************
********************************************
********************************************
*/

COPY (
    SELECT PerctPov, AVG(PerctAlgII) AS AvgPerctAlgII
    FROM (
        SELECT DISTINCT ON (e."lea_state", e."lea_name", e."sch_name") 
            e."lea_state", 
            e."leaid", 
            e."lea_name", 
            lc."lea_city", 
            lc."lea_zip", 
            e."schid", 
            e."sch_name",  
            CAST(tot_enr_m AS INTEGER) + CAST(tot_enr_f AS INTEGER) AS total,
            CAST(tot_mathenr_advm_m AS INTEGER) + CAST(tot_mathenr_advm_f AS INTEGER) AS advmath,
            CAST(tot_apmathenr_m AS INTEGER) + CAST(tot_apmathenr_f AS INTEGER) AS apmath,
            CAST(tot_apscienr_m AS INTEGER) + CAST(tot_apscienr_f AS INTEGER) AS apscience,
            CAST(tot_apothenr_m AS INTEGER) + CAST(tot_apothenr_f AS INTEGER) AS apothers,
            CAST(tot_mathenr_alg2_m AS INTEGER) + CAST(tot_mathenr_alg2_f AS INTEGER) AS algii,
            CAST(tot_scienr_biol_m AS INTEGER) + CAST(tot_scienr_biol_f AS INTEGER) AS bio,
            CAST(tot_mathenr_calc_m AS INTEGER) + CAST(tot_mathenr_calc_f AS INTEGER) AS cal,
            CAST(tot_scienr_chem_m AS INTEGER) + CAST(tot_scienr_chem_f AS INTEGER) AS chem,
            CAST(tot_mathenr_geom_m AS INTEGER) + CAST(tot_mathenr_geom_f AS INTEGER) AS geo,
            CAST(tot_scienr_phys_m AS INTEGER) + CAST(tot_scienr_phys_f AS INTEGER) AS phy,
            pov.pov / pop_schl AS PerctPov, 
            (CAST(tot_mathenr_alg2_m AS FLOAT) + CAST(tot_mathenr_alg2_f AS FLOAT)) / 
            (CAST(tot_enr_m AS FLOAT) + CAST(tot_enr_f AS FLOAT)) AS PerctAlgII
        FROM "CRDB".schoolcharacteristics sc
        JOIN "CRDB".enrollment e ON sc.schid = e.schid AND sc.leaid = e.leaid
        JOIN "CRDB".leacharacteristics lc ON sc.leaid = lc.leaid
        JOIN "CRDB".advancedmathematics av ON av.schid = e.schid AND av.leaid = e.leaid
        JOIN "CRDB".advancedplacement ap ON ap.schid = e.schid AND ap.leaid = e.leaid
        JOIN "CRDB".algebraii alg2 ON alg2.schid = e.schid AND alg2.leaid = e.leaid
        JOIN "CRDB".biology bio ON bio.schid = e.schid AND bio.leaid = e.leaid
        JOIN "CRDB".calculus cal ON cal.schid = e.schid AND cal.leaid = e.leaid
        JOIN "CRDB".chemistry che ON che.schid = e.schid AND che.leaid = e.leaid
        JOIN "CRDB".geometry geo ON geo.schid = e.schid AND geo.leaid = e.leaid
        JOIN "CRDB".physics phy ON phy.schid = e.schid AND phy.leaid = e.leaid
        JOIN "CRDB".POV pov ON pov.schoolid = e.schid
        WHERE sch_grade_g09 = 'Yes'
            AND sch_grade_g10 = 'Yes'
            AND sch_grade_g11 = 'Yes'
            AND sch_grade_g12 = 'Yes'
            AND CAST(tot_enr_m AS INTEGER) >= 0
            AND CAST(tot_enr_f AS INTEGER) >= 0
            AND CAST(tot_enr_m AS INTEGER) + CAST(tot_enr_f AS INTEGER) > 0
            AND e.lea_state = 'CA'
        ORDER BY e.lea_state, e.lea_name, e.sch_name
    ) AS subquery
	where PerctPov > 0 and PerctAlgII > 0
    GROUP BY PerctPov
    ORDER BY PerctPov
) TO 'C:\\Dropbox\\!JBGPresentations\\!2024\\2024 CSU\\AlgVsPov_Avg_TwoCol.csv' DELIMITER ',' CSV HEADER;


