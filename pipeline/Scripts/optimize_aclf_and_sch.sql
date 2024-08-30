-- aclf optimization

-- This requires optimize_hmda.sql to run
ALTER TABLE data_schema.aclf_housing
ADD CONSTRAINT fk_state
FOREIGN KEY (state)
REFERENCES ref_schema.ref_state(state_code);

-- sch optimization

-- drop table ref_schema.ref_lea_sch;
CREATE TABLE ref_schema.ref_lea_sch (
    combokey VARCHAR(12) PRIMARY KEY,
    leaid VARCHAR(7),
    schid VARCHAR(5),
    lea_name VARCHAR(89),
    sch_name VARCHAR(80),
    lea_state VARCHAR(2),
    jj VARCHAR(3)
);

INSERT INTO ref_schema.ref_lea_sch (combokey, leaid, schid, lea_name, sch_name, lea_state, jj)
select distinct combokey, leaid, schid, lea_name, sch_name, lea_state, jj
FROM data_schema.sch_algebraii;

ALTER TABLE ref_schema.ref_lea_sch
ALTER COLUMN jj
TYPE BOOLEAN
USING (jj = 'Yes');

CREATE OR REPLACE FUNCTION update_sch_tables() RETURNS void AS $$
DECLARE
    table_rec RECORD;
BEGIN
    -- Loop through each table starting with 'sch_' in 'data_schema'
    FOR table_rec IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'data_schema'
          AND table_name LIKE 'sch_%'
    LOOP
        -- Drop existing primary key constraint if it exists
        /*
        EXECUTE format(
            'ALTER TABLE data_schema.%I DROP CONSTRAINT IF EXISTS %I;',
            table_rec.table_name,
            format('%s_pkey', table_rec.table_name)
        );
        */

        EXECUTE format(
            'ALTER TABLE data_schema.%I ADD PRIMARY KEY (combokey);',
            table_rec.table_name
        );

        -- Drop the specified columns
        EXECUTE format(
            'ALTER TABLE data_schema.%I DROP COLUMN IF EXISTS schid, DROP COLUMN IF EXISTS leaid,  DROP COLUMN IF EXISTS lea_name, DROP COLUMN IF EXISTS sch_name, DROP COLUMN IF EXISTS lea_state, DROP COLUMN IF EXISTS lea_state_name,  DROP COLUMN IF EXISTS jj;',
            table_rec.table_name
        );
		
		EXECUTE format(
            'ALTER TABLE data_schema.%I ADD CONSTRAINT %I FOREIGN KEY (combokey) REFERENCES ref_schema.ref_lea_sch (combokey);',
            table_rec.table_name,
            format('%s_fkey', table_rec.table_name)
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT update_sch_tables();

-- set Yes/No Columns to Boolean
CREATE OR REPLACE FUNCTION convert_yes_no_to_boolean(table_name TEXT, columns TEXT[])
RETURNS VOID AS $$
DECLARE column_name TEXT;
BEGIN
    FOREACH column_name IN ARRAY columns
    LOOP
        EXECUTE '
            ALTER TABLE ' || table_name || '
            ALTER COLUMN ' || quote_ident(column_name) || '
            TYPE BOOLEAN 
            USING (CASE WHEN ' || quote_ident(column_name) || ' = ''Yes'' THEN TRUE ELSE FALSE END)';
    END LOOP;
END;
$$ LANGUAGE plpgsql;


SELECT convert_yes_no_to_boolean('data_schema.sch_schoolcharacteristics', 
 ARRAY[
'sch_grade_kg'
,'sch_grade_ps'
,'sch_grade_ug'
,'sch_status_sped'
,'sch_status_magnet'
,'sch_status_charter'
,'sch_status_alt'
,'sch_grade_g01'
,'sch_grade_g02'
,'sch_grade_g03'
,'sch_grade_g04'
,'sch_grade_g05'
,'sch_grade_g06'
,'sch_grade_g07'
,'sch_grade_g08'
,'sch_grade_g09'
,'sch_grade_g10'
,'sch_grade_g11'
,'sch_grade_g12'
]);

ALTER TABLE data_schema.sch_schoolcharacteristics
ADD COLUMN hs_only BOOLEAN;

update data_schema.sch_schoolcharacteristics
set hs_only = (sch_grade_g09 = TRUE and sch_grade_g10 = TRUE 
and sch_grade_g11 = TRUE and sch_grade_g12 = TRUE
and sch_grade_g01 = FALSE and sch_grade_g02 = FALSE
and sch_grade_g03 = FALSE and sch_grade_g04 = FALSE
and sch_grade_g05 = FALSE and sch_grade_g06 = FALSE
and sch_grade_g07 = FALSE and sch_grade_g08 = FALSE
and sch_grade_ps = FALSE and sch_grade_kg = FALSE 
and (sch_grade_ug = FALSE OR (sch_ugdetail_es <> 'Yes' AND sch_ugdetail_ms <> 'Yes')));
