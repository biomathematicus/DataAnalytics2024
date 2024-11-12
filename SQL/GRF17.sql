CREATE SCHEMA IF NOT EXISTS "CRDB"; 
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_aiannh (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    AIANNH VARCHAR(5),
    NAME_AIANNH17 VARCHAR(74),
    COUNT VARCHAR(2),
    LANDAREA VARCHAR(22),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_aiannh FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_aiannh.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_blkgrp (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    BLKGRP VARCHAR(12),
    COUNT VARCHAR(4),
    LANDAREA VARCHAR(22),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_blkgrp FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_blkgrp.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_cbsa (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    CBSA VARCHAR(5),
    NAME_CBSA17 VARCHAR(57),
    COUNT VARCHAR(2),
    LANDAREA VARCHAR(21),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_cbsa FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_cbsa.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_cd (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    STCD115 VARCHAR(4),
    COUNT VARCHAR(2),
    LANDAREA VARCHAR(22),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_cd FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_cd.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_county (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    STCOUNTY VARCHAR(5),
    NAME_COUNTY17 VARCHAR(33),
    COUNT VARCHAR(2),
    LANDAREA VARCHAR(21),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_county FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_county.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_cousub (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    COUSUB VARCHAR(10),
    NAME_COUSUB17 VARCHAR(42),
    COUNT VARCHAR(3),
    LANDAREA VARCHAR(22),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_cousub FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_cousub.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_csa (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    CSA VARCHAR(3),
    NAME_CSA17 VARCHAR(62),
    COUNT VARCHAR(1),
    LANDAREA VARCHAR(20),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_csa FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_csa.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_necta (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    NECTA VARCHAR(5),
    NAME_NECTA17 VARCHAR(59),
    COUNT VARCHAR(1),
    LANDAREA VARCHAR(19),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_necta FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_necta.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_place (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    PLACE VARCHAR(7),
    NAME_PLACE17 VARCHAR(57),
    COUNT VARCHAR(3),
    LANDAREA VARCHAR(22),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_place FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_place.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_tract (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    TRACT VARCHAR(11),
    COUNT VARCHAR(4),
    LANDAREA VARCHAR(22),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_tract FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_tract.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_uace10 (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    UACE10 VARCHAR(5),
    NAME_UACE10 VARCHAR(71),
    COUNT VARCHAR(2),
    LANDAREA VARCHAR(22),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_uace10 FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_uace10.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_zcta5ce10 (
    LEAID VARCHAR(7),
    NAME_LEA17 VARCHAR(81),
    ZCTA5CE10 VARCHAR(5),
    COUNT VARCHAR(3),
    LANDAREA VARCHAR(22),
    WATERAREA VARCHAR(22)
);
COPY "CRDB".grf17_lea_zcta5ce10 FROM 'C:/Dropbox/!JBGCourses/!2024/2024 Data Analytics/github/data/GRF17/cleaned_grf17_lea_zcta5ce10.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
