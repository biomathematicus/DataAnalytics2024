-- Standardize LEA table
UPDATE data_schema.lea_leacharacteristics
SET leaid = CASE 
WHEN leaid ~ '^[0-9]+$' THEN CAST(CAST(leaid AS INT) AS VARCHAR)
ELSE leaid
END; 

ALTER TABLE data_schema.lea_leacharacteristics
RENAME COLUMN lea_state_name to state_code;

ALTER TABLE data_schema.lea_leacharacteristics 
ALTER COLUMN state_code 
TYPE SMALLINT 
USING NULL::SMALLINT;

UPDATE data_schema.lea_leacharacteristics l
SET state_code = s.state_code
FROM ref_schema.ref_state s
WHERE l.lea_state = s.state_abbr;

ALTER TABLE data_schema.lea_leacharacteristics
ADD CONSTRAINT fk_state_code
FOREIGN KEY (state_code) REFERENCES ref_schema.ref_state(state_code);

ALTER TABLE data_schema.lea_leacharacteristics
DROP COLUMN lea_state;

-- state (i.e. TX) and state_fips have a 1-to-1 relationship
-- So, state_fips is moved to the reference table 

ALTER TABLE ref_schema.ref_state
ADD COLUMN state_fips SMALLINT;

UPDATE ref_schema.ref_state AS r
SET state_fips = cast(s.state_fips as smallint)
FROM data_schema.saipe_ussd17 AS s
WHERE r.state_abbr = s.state;

UPDATE ref_schema.ref_state
SET state_fips = 52
WHERE state_name = 'U.S. Virgin Islands';

ALTER TABLE data_schema.saipe_ussd17
RENAME COLUMN state_fips to state_code;

ALTER TABLE data_schema.saipe_ussd17
ALTER COLUMN state_code 
TYPE SMALLINT 
USING NULL::SMALLINT;

UPDATE data_schema.saipe_ussd17 AS s
SET state_code = r.state_code
FROM ref_schema.ref_state AS r
WHERE r.state_abbr = s.state;

ALTER TABLE data_schema.saipe_ussd17
DROP COLUMN state;

ALTER TABLE data_schema.saipe_ussd17
ADD CONSTRAINT fk_state_code
FOREIGN KEY (state_code) REFERENCES ref_schema.ref_state(state_code);

-- standardize with the LEA Characteristics table
UPDATE ref_schema.ref_lea_sch
SET leaid = CASE 
WHEN leaid ~ '^[0-9]+$' THEN CAST(CAST(leaid AS INT) AS VARCHAR)
ELSE leaid
END;

ALTER TABLE ref_schema.ref_lea_sch
ADD state_code SMALLINT;

UPDATE ref_schema.ref_lea_sch ls
SET state_code = s.state_code
FROM ref_schema.ref_state s
WHERE s.state_abbr = ls.lea_state;


UPDATE data_schema.saipe_ussd17
SET districtid = LPAD(districtid, 5, '0')
WHERE LENGTH(districtid) < 5;

UPDATE data_schema.lea_leacharacteristics
SET leaid = LPAD(leaid, 7, '0')
WHERE LENGTH(leaid) < 7;

UPDATE ref_schema.ref_lea_sch
SET leaid = LPAD(leaid, 7, '0')
WHERE LENGTH(leaid) < 7;

UPDATE data_schema.sdgr_grf17_lea_place
SET leaid = LPAD(leaid, 7, '0')
WHERE LENGTH(leaid) < 7;

--ALTER TABLE data_schema.saipe_ussd17
--ADD CONSTRAINT pk_district PRIMARY KEY (state_code, districtid);


-- Moving lea_id to a reference table

CREATE TABLE ref_schema.ref_lea (
  id SERIAL PRIMARY KEY,
  lea_id VARCHAR(7),
  state_code smallint,
  lea_name_sdgr VARCHAR(81),
  lea_name_lea_char VARCHAR(89),
  lea_name_saipe VARCHAR(81)
);

INSERT INTO ref_schema.ref_lea (lea_id, state_code, lea_name_lea_char)
select distinct leaid, state_code, lea_name
from data_schema.lea_leacharacteristics
order by leaid;

UPDATE ref_schema.ref_lea AS rl
SET lea_name_saipe = saipe.nameschooldistrict
FROM data_schema.saipe_ussd17 AS saipe
WHERE rl.state_code=saipe.state_code and right(rl.lea_id,5)=saipe.districtid;

-- Adding leaid to SAIPE
ALTER TABLE data_schema.saipe_ussd17 drop constraint fk_state_code;
alter table data_schema.saipe_ussd17 add column state_id smallint;
update data_schema.saipe_ussd17 set state_id = state_code;
alter table data_schema.saipe_ussd17 RENAME COLUMN  state_code to leaid;
alter table data_schema.saipe_ussd17 RENAME COLUMN  state_id to state_code;
ALTER TABLE data_schema.saipe_ussd17 ALTER COLUMN leaid TYPE VARCHAR(7) USING ''::VARCHAR;

ALTER TABLE data_schema.saipe_ussd17
ADD CONSTRAINT fk_state_code
FOREIGN KEY (state_code) REFERENCES ref_schema.ref_state(state_code);

update data_schema.saipe_ussd17 as saipe
set leaid = rl.lea_id
from ref_schema.ref_lea as rl
where right(rl.lea_id, 5) = saipe.districtid and rl.state_code=saipe.state_code;

WITH mapped_lea AS ( SELECT nameschooldistrict,
CASE 
WHEN nameschooldistrict = 
'Detroit City School District' THEN 'Detroit Public Schools Community District' 

WHEN nameschooldistrict = 
'Montebello Unified School District' THEN 'Los Angeles Unified' 

WHEN nameschooldistrict = 
'James City County Public Schools' THEN 'WILLIAMSBURG-JAMES CITY PBLC SCHS'
WHEN nameschooldistrict = 
'North Colonie Central School District' THEN 'NORTH COLONIE CSD'
WHEN nameschooldistrict = 
'Camp Lejeune Schools' THEN 'Onslow County Schools'

WHEN nameschooldistrict = 
'Oregon Trail School District 46' THEN 'Oregon Trail SD 46'
ELSE NULL
END AS lea_name FROM data_schema.saipe_ussd17
)
UPDATE data_schema.saipe_ussd17
SET leaid = (
    SELECT DISTINCT leaid 
    FROM ref_schema.ref_lea_sch rls
    WHERE rls.lea_name = mapped_lea.lea_name
)
FROM mapped_lea
WHERE data_schema.saipe_ussd17.nameschooldistrict = mapped_lea.nameschooldistrict AND mapped_lea.lea_name IS NOT NULL;


-- Fill in missing LEA IDs
DROP table if exists temp_school_district_mapping;
CREATE TEMPORARY TABLE temp_school_district_mapping (
    nameschooldistrict VARCHAR(81),
    lea_name VARCHAR(89),
    state_code SMALLINT,
    state_abbr VARCHAR
);

INSERT INTO temp_school_district_mapping (nameschooldistrict, lea_name, state_abbr)
VALUES
('Detroit City School District', 'Detroit Public Schools Community District', 'MI') -- Closely matching enrollment and total population
,('Montebello Unified School District', 'Los Angeles Unified', 'CA') -- Montebello is a suburb in the heart of LA
,('James City County Public Schools', 'WILLIAMSBURG-JAMES CITY PBLC SCHS', 'VA')
,('North Colonie Central School District', 'NORTH COLONIE CSD', 'NY')
,('Camp Lejeune Schools', 'Onslow County Schools','NC') -- Matched by county and schools like Bell Fork Elementary
,('Oregon Trail School District 46','Oregon Trail SD 46','OR')
,('Chittenden South Supervisory Union','Champlain Valley Unified School District', 'VT')
,('Fairfax City Public Schools','FAIRFAX CO PBLC SCHS','VA')
--,('Romulus Community Schools','TODO: Missing LEA','MI')

--,('Washington Township School District','Washington Township School District','NJ') -- Multiple LEA ID matches
;

UPDATE temp_school_district_mapping t
SET state_code = r.state_code
FROM ref_schema.ref_state r
WHERE t.state_abbr = r.state_abbr;

UPDATE data_schema.saipe_ussd17
SET leaid = (
    SELECT DISTINCT leaid 
    FROM ref_schema.ref_lea_sch rls
    WHERE rls.lea_name = temp.lea_name
)
FROM temp_school_district_mapping temp
WHERE data_schema.saipe_ussd17.nameschooldistrict = temp.nameschooldistrict
AND data_schema.saipe_ussd17.state_code = temp.state_code;
-- SAIPE now linked to LEA IDs

-- Fix merged district records by taking sum of populations
WITH summed_values AS (
    SELECT leaid, 
           SUM(totalpopulation) AS totalpopulation_sum,
           SUM(population5_17) AS population5_17_sum,
           SUM(population5_17inpoverty) AS population5_17inpoverty_sum
    FROM data_schema.saipe_ussd17
    WHERE leaid <> ''
    GROUP BY leaid
    HAVING 
        MIN(totalpopulation) <> MAX(totalpopulation) OR
        MIN(population5_17) <> MAX(population5_17) OR
        MIN(population5_17inpoverty) <> MAX(population5_17inpoverty)
)
UPDATE data_schema.saipe_ussd17
SET totalpopulation = summed_values.totalpopulation_sum,
    population5_17 = summed_values.population5_17_sum,
    population5_17inpoverty = summed_values.population5_17inpoverty_sum
FROM summed_values
WHERE data_schema.saipe_ussd17.leaid = summed_values.leaid;

-- Following query will now return no records
/*
SELECT leaid FROM data_schema.saipe_ussd17
where leaid <> '' GROUP BY leaid
HAVING 
MIN(totalpopulation) <> MAX(totalpopulation)
or MIN(population5_17) <> MAX(population5_17)
or MIN(population5_17inpoverty) <> MAX(population5_17inpoverty);
*/
