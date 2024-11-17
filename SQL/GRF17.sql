CREATE SCHEMA IF NOT EXISTS "CRDB"; 
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_aiannh (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    aiannh VARCHAR(5),
    name_aiannh17 VARCHAR(74),
    count VARCHAR(2),
    landarea VARCHAR(22),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_aiannh FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_aiannh.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_blkgrp (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    blkgrp VARCHAR(12),
    count VARCHAR(4),
    landarea VARCHAR(22),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_blkgrp FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_blkgrp.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_cbsa (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    cbsa VARCHAR(5),
    name_cbsa17 VARCHAR(57),
    count VARCHAR(2),
    landarea VARCHAR(21),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_cbsa FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_cbsa.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_cd (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    stcd115 VARCHAR(4),
    count VARCHAR(2),
    landarea VARCHAR(22),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_cd FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_cd.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_county (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    stcounty VARCHAR(5),
    name_county17 VARCHAR(33),
    count VARCHAR(2),
    landarea VARCHAR(21),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_county FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_county.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_cousub (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    cousub VARCHAR(10),
    name_cousub17 VARCHAR(42),
    count VARCHAR(3),
    landarea VARCHAR(22),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_cousub FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_cousub.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_csa (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    csa VARCHAR(3),
    name_csa17 VARCHAR(62),
    count VARCHAR(1),
    landarea VARCHAR(20),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_csa FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_csa.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_necta (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    necta VARCHAR(5),
    name_necta17 VARCHAR(59),
    count VARCHAR(1),
    landarea VARCHAR(19),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_necta FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_necta.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_place (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    place VARCHAR(7),
    name_place17 VARCHAR(57),
    count VARCHAR(3),
    landarea VARCHAR(22),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_place FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_place.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_tract (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    tract VARCHAR(11),
    count VARCHAR(4),
    landarea VARCHAR(22),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_tract FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_tract.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_uace10 (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    uace10 VARCHAR(5),
    name_uace10 VARCHAR(71),
    count VARCHAR(2),
    landarea VARCHAR(22),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_uace10 FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_uace10.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE IF NOT EXISTS "CRDB".grf17_lea_zcta5ce10 (
    leaid VARCHAR(7),
    name_lea17 VARCHAR(81),
    zcta5ce10 VARCHAR(5),
    count VARCHAR(3),
    landarea VARCHAR(22),
    waterarea VARCHAR(22)
);
COPY "CRDB".grf17_lea_zcta5ce10 FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/GRF17/cleaned_grf17_lea_zcta5ce10.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
