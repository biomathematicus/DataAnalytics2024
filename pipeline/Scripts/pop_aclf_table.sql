SET search_path TO data_schema;

CREATE TABLE aclf_housing (
    state SMALLINT,
    county SMALLINT,
    tract CHAR(7),
    block SMALLINT,
    block_geoid BIGINT,
    total_housing_units SMALLINT,
    total_group_quarters SMALLINT,
    total_correctional_facilities_for_adults SMALLINT,
    total_juvenile_facilities SMALLINT,
    total_nursing_facilities_skilled_nursing_facilities SMALLINT,
    total_other_institutional_facilities SMALLINT,
    total_college_university_student_housing SMALLINT,
    total_military_quarters SMALLINT,
    total_other_noninstitutional_facilities SMALLINT
);


CREATE OR REPLACE FUNCTION copy_files_to_table(table_name text, file_paths text[], delimiter_char text, encoding_name text) 
RETURNS void AS $$
DECLARE
    file_path text;
BEGIN
    FOREACH file_path IN ARRAY file_paths
    LOOP
        EXECUTE format('COPY %I FROM %L DELIMITER %L CSV HEADER ENCODING %L', 
                       table_name, file_path, delimiter_char, encoding_name);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT copy_files_to_table(
	'aclf_housing', 
ARRAY[
'/home/Data/ACLF_States/01_Alabama.csv', 
'/home/Data/ACLF_States/02_Alaska.csv', 
'/home/Data/ACLF_States/04_Arizona.csv', 
'/home/Data/ACLF_States/05_Arkansas.csv', 
'/home/Data/ACLF_States/06_California.csv', 
'/home/Data/ACLF_States/08_Colorado.csv', 
'/home/Data/ACLF_States/09_Connecticut.csv', 
'/home/Data/ACLF_States/10_Delaware.csv', 
'/home/Data/ACLF_States/11_DistrictofColumbia.csv', 
'/home/Data/ACLF_States/12_Florida.csv', 
'/home/Data/ACLF_States/13_Georgia.csv', 
'/home/Data/ACLF_States/15_Hawaii.csv', 
'/home/Data/ACLF_States/16_Idaho.csv', 
'/home/Data/ACLF_States/17_Illinois.csv', 
'/home/Data/ACLF_States/18_Indiana.csv', 
'/home/Data/ACLF_States/19_Iowa.csv', 
'/home/Data/ACLF_States/20_Kansas.csv', 
'/home/Data/ACLF_States/21_Kentucky.csv', 
'/home/Data/ACLF_States/22_Louisiana.csv', 
'/home/Data/ACLF_States/23_Maine.csv', 
'/home/Data/ACLF_States/24_Maryland.csv', 
'/home/Data/ACLF_States/25_Massachusetts.csv', 
'/home/Data/ACLF_States/26_Michigan.csv', 
'/home/Data/ACLF_States/27_Minnesota.csv', 
'/home/Data/ACLF_States/28_Mississippi.csv', 
'/home/Data/ACLF_States/29_Missouri.csv', 
'/home/Data/ACLF_States/30_Montana.csv', 
'/home/Data/ACLF_States/31_Nebraska.csv', 
'/home/Data/ACLF_States/32_Nevada.csv', 
'/home/Data/ACLF_States/33_NewHampshire.csv', 
'/home/Data/ACLF_States/34_NewJersey.csv', 
'/home/Data/ACLF_States/35_NewMexico.csv', 
'/home/Data/ACLF_States/36_NewYork.csv', 
'/home/Data/ACLF_States/37_NorthCarolina.csv', 
'/home/Data/ACLF_States/38_NorthDakota.csv', 
'/home/Data/ACLF_States/39_Ohio.csv', 
'/home/Data/ACLF_States/40_Oklahoma.csv', 
'/home/Data/ACLF_States/41_Oregon.csv', 
'/home/Data/ACLF_States/42_Pennsylvania.csv', 
'/home/Data/ACLF_States/72_PuertoRico.csv', 
'/home/Data/ACLF_States/44_RhodeIsland.csv', 
'/home/Data/ACLF_States/45_SouthCarolina.csv', 
'/home/Data/ACLF_States/46_SouthDakota.csv', 
'/home/Data/ACLF_States/47_Tennessee.csv', 
'/home/Data/ACLF_States/48_Texas.csv', 
'/home/Data/ACLF_States/49_Utah.csv', 
'/home/Data/ACLF_States/50_Vermont.csv', 
'/home/Data/ACLF_States/51_Virginia.csv', 
'/home/Data/ACLF_States/53_Washington.csv', 
'/home/Data/ACLF_States/54_WestVirginia.csv', 
'/home/Data/ACLF_States/55_Wisconsin.csv', 
'/home/Data/ACLF_States/56_Wyoming.csv'
],
'|', 'windows-1251');