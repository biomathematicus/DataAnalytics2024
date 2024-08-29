SET search_path TO data_schema;

CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_SLI (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(3),
    AM_M_7 VARCHAR(2),
    AS_M_7 VARCHAR(2),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(3),
    MU_M_7 VARCHAR(2),
    PI_M_7 VARCHAR(1),
    WH_M_7 VARCHAR(3),
    AM_F_7 VARCHAR(2),
    AS_F_7 VARCHAR(2),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(3),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(3),
    CF_M VARCHAR(1),
    HH_M VARCHAR(1),
    PPPS_M VARCHAR(3),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(3),
    RF_M VARCHAR(1),
    SS_M VARCHAR(2),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(3),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(1),
    SS_F VARCHAR(2)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_SLI FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_SLI.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_VI (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(2),
    AM_M_7 VARCHAR(1),
    AS_M_7 VARCHAR(1),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(2),
    PI_M_7 VARCHAR(1),
    WH_M_7 VARCHAR(2),
    AM_F_7 VARCHAR(1),
    AS_F_7 VARCHAR(1),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(1),
    NLEP_M VARCHAR(2),
    LEP_F VARCHAR(1),
    NLEP_F VARCHAR(2),
    CF_M VARCHAR(1),
    HH_M VARCHAR(1),
    PPPS_M VARCHAR(1),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(1),
    RC80_M VARCHAR(2),
    RF_M VARCHAR(2),
    SS_M VARCHAR(2),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(1),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(1),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(2),
    SS_F VARCHAR(2)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_VI FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_VI.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_OI (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(2),
    AM_M_7 VARCHAR(1),
    AS_M_7 VARCHAR(1),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(1),
    PI_M_7 VARCHAR(1),
    WH_M_7 VARCHAR(2),
    AM_F_7 VARCHAR(1),
    AS_F_7 VARCHAR(1),
    BL_F_7 VARCHAR(1),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(2),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(2),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(2),
    CF_M VARCHAR(1),
    HH_M VARCHAR(1),
    PPPS_M VARCHAR(1),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(1),
    RC80_M VARCHAR(2),
    RF_M VARCHAR(1),
    SS_M VARCHAR(2),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(1),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(1),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(1),
    SS_F VARCHAR(2)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_OI FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_OI.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_MD (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(2),
    AM_M_7 VARCHAR(2),
    AS_M_7 VARCHAR(1),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(1),
    PI_M_7 VARCHAR(1),
    WH_M_7 VARCHAR(2),
    AM_F_7 VARCHAR(2),
    AS_F_7 VARCHAR(2),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(2),
    CF_M VARCHAR(2),
    HH_M VARCHAR(2),
    PPPS_M VARCHAR(1),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(2),
    RF_M VARCHAR(2),
    SS_M VARCHAR(3),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(1),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(2),
    SS_F VARCHAR(2)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_MD FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_MD.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_MR (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(2),
    AM_M_7 VARCHAR(2),
    AS_M_7 VARCHAR(2),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(2),
    PI_M_7 VARCHAR(2),
    WH_M_7 VARCHAR(2),
    AM_F_7 VARCHAR(2),
    AS_F_7 VARCHAR(2),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(2),
    PI_F_7 VARCHAR(2),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(3),
    CF_M VARCHAR(2),
    HH_M VARCHAR(1),
    PPPS_M VARCHAR(1),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(2),
    RF_M VARCHAR(2),
    SS_M VARCHAR(2),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(1),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(2),
    SS_F VARCHAR(2)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_MR FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_MR.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_AUT (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(3),
    AM_M_7 VARCHAR(2),
    AS_M_7 VARCHAR(2),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(3),
    MU_M_7 VARCHAR(2),
    PI_M_7 VARCHAR(1),
    WH_M_7 VARCHAR(3),
    AM_F_7 VARCHAR(1),
    AS_F_7 VARCHAR(1),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(2),
    CF_M VARCHAR(1),
    HH_M VARCHAR(2),
    PPPS_M VARCHAR(3),
    RC39_M VARCHAR(3),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(3),
    RF_M VARCHAR(2),
    SS_M VARCHAR(3),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(2),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(1),
    SS_F VARCHAR(2)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_AUT FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_AUT.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHEducationalEnvironmentbyGenderbyDisability (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(7),
    CF_M VARCHAR(3),
    HH_M VARCHAR(2),
    RC39_M VARCHAR(3),
    RC79TO40_M VARCHAR(3),
    RC80_M VARCHAR(3),
    RF_M VARCHAR(2),
    SS_M VARCHAR(3),
    CF_F VARCHAR(2),
    HH_F VARCHAR(2),
    PPPS_F VARCHAR(3),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(3),
    RC80_F VARCHAR(3),
    SS_F VARCHAR(3),
    PPPS_M VARCHAR(3),
    RF_F VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(4)
);
COPY ed_ID74SCHEducationalEnvironmentbyGenderbyDisability FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Educational Environment by Gender by Disability.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_HI (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(2),
    AM_M_7 VARCHAR(1),
    AS_M_7 VARCHAR(2),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(1),
    PI_M_7 VARCHAR(2),
    WH_M_7 VARCHAR(2),
    AM_F_7 VARCHAR(2),
    AS_F_7 VARCHAR(2),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(3),
    CF_M VARCHAR(1),
    HH_M VARCHAR(1),
    PPPS_M VARCHAR(1),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(3),
    RF_M VARCHAR(2),
    SS_M VARCHAR(3),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(1),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(2),
    SS_F VARCHAR(3)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_HI FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_HI.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_DD (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(2),
    DISABILITY_CATEGORY VARCHAR(2),
    AM_M_7 VARCHAR(2),
    AS_M_7 VARCHAR(2),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(2),
    PI_M_7 VARCHAR(1),
    WH_M_7 VARCHAR(2),
    AM_F_7 VARCHAR(2),
    AS_F_7 VARCHAR(1),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(2),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(2),
    CF_M VARCHAR(1),
    HH_M VARCHAR(1),
    PPPS_M VARCHAR(2),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(2),
    RF_M VARCHAR(1),
    SS_M VARCHAR(2),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(1),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(1),
    SS_F VARCHAR(1)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_DD FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_DD.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_TBI (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(3),
    AM_M_7 VARCHAR(1),
    AS_M_7 VARCHAR(1),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(1),
    PI_M_7 VARCHAR(1),
    WH_M_7 VARCHAR(2),
    AM_F_7 VARCHAR(1),
    AS_F_7 VARCHAR(1),
    BL_F_7 VARCHAR(1),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(2),
    LEP_F VARCHAR(1),
    NLEP_F VARCHAR(2),
    CF_M VARCHAR(1),
    HH_M VARCHAR(1),
    PPPS_M VARCHAR(1),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(2),
    RF_M VARCHAR(1),
    SS_M VARCHAR(1),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(1),
    RC39_F VARCHAR(1),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(1),
    SS_F VARCHAR(1)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_TBI FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_TBI.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_DB (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(2),
    AM_M_7 VARCHAR(1),
    AS_M_7 VARCHAR(1),
    BL_M_7 VARCHAR(1),
    HI_M_7 VARCHAR(1),
    MU_M_7 VARCHAR(1),
    PI_M_7 VARCHAR(1),
    WH_M_7 VARCHAR(1),
    AM_F_7 VARCHAR(1),
    AS_F_7 VARCHAR(1),
    BL_F_7 VARCHAR(1),
    HI_F_7 VARCHAR(1),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(1),
    TOTAL_STUDENTS_REPORTED VARCHAR(2),
    LEP_M VARCHAR(1),
    NLEP_M VARCHAR(1),
    LEP_F VARCHAR(1),
    NLEP_F VARCHAR(1),
    CF_M VARCHAR(1),
    HH_M VARCHAR(1),
    PPPS_M VARCHAR(1),
    RC39_M VARCHAR(1),
    RC79TO40_M VARCHAR(1),
    RC80_M VARCHAR(1),
    RF_M VARCHAR(1),
    SS_M VARCHAR(1),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(1),
    RC39_F VARCHAR(1),
    RC79TO40_F VARCHAR(1),
    RC80_F VARCHAR(1),
    RF_F VARCHAR(1),
    SS_F VARCHAR(1)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_DB FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_DB.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_EMN (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(3),
    AM_M_7 VARCHAR(2),
    AS_M_7 VARCHAR(1),
    BL_M_7 VARCHAR(3),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(2),
    PI_M_7 VARCHAR(2),
    WH_M_7 VARCHAR(3),
    AM_F_7 VARCHAR(1),
    AS_F_7 VARCHAR(1),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(3),
    CF_M VARCHAR(2),
    HH_M VARCHAR(2),
    PPPS_M VARCHAR(2),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(3),
    RF_M VARCHAR(2),
    SS_M VARCHAR(3),
    CF_F VARCHAR(2),
    HH_F VARCHAR(2),
    PPPS_F VARCHAR(2),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(3),
    RF_F VARCHAR(2),
    SS_F VARCHAR(2)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_EMN FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_EMN.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID814SCHChronicAbsenteeism (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    AM_M_7 VARCHAR(3),
    AS_M_7 VARCHAR(3),
    BL_M_7 VARCHAR(3),
    HI_M_7 VARCHAR(4),
    MU_M_7 VARCHAR(3),
    PI_M_7 VARCHAR(3),
    WH_M_7 VARCHAR(4),
    AM_F_7 VARCHAR(3),
    AS_F_7 VARCHAR(3),
    BL_F_7 VARCHAR(3),
    HI_F_7 VARCHAR(4),
    MU_F_7 VARCHAR(3),
    PI_F_7 VARCHAR(3),
    WH_F_7 VARCHAR(4),
    TOTAL_STUDENTS_REPORTED_M VARCHAR(4),
    TOTAL_STUDENTS_REPORTED_F VARCHAR(4),
    WDIS_M VARCHAR(3),
    WDIS_F VARCHAR(3),
    DISAB504_M VARCHAR(3),
    DISAB504_F VARCHAR(2),
    LEP_M VARCHAR(3),
    LEP_F VARCHAR(3),
    H_M VARCHAR(3),
    H_F VARCHAR(3)
);
COPY ed_ID814SCHChronicAbsenteeism FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 814 SCH - Chronic Absenteeism.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_OHI (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(3),
    AM_M_7 VARCHAR(2),
    AS_M_7 VARCHAR(2),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(2),
    PI_M_7 VARCHAR(2),
    WH_M_7 VARCHAR(3),
    AM_F_7 VARCHAR(2),
    AS_F_7 VARCHAR(1),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(2),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(3),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(3),
    CF_M VARCHAR(2),
    HH_M VARCHAR(2),
    PPPS_M VARCHAR(3),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(3),
    RF_M VARCHAR(2),
    SS_M VARCHAR(2),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(2),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(3),
    RF_F VARCHAR(1),
    SS_F VARCHAR(2)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_OHI FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_OHI.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_MISSING (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(4),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(45),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(49),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(7),
    AM_M_7 VARCHAR(1),
    AS_M_7 VARCHAR(2),
    BL_M_7 VARCHAR(2),
    HI_M_7 VARCHAR(2),
    MU_M_7 VARCHAR(2),
    PI_M_7 VARCHAR(1),
    WH_M_7 VARCHAR(3),
    AM_F_7 VARCHAR(1),
    AS_F_7 VARCHAR(1),
    BL_F_7 VARCHAR(2),
    HI_F_7 VARCHAR(2),
    MU_F_7 VARCHAR(1),
    PI_F_7 VARCHAR(1),
    WH_F_7 VARCHAR(2),
    TOTAL_STUDENTS_REPORTED VARCHAR(3),
    LEP_M VARCHAR(2),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(3),
    CF_M VARCHAR(2),
    HH_M VARCHAR(1),
    PPPS_M VARCHAR(2),
    RC39_M VARCHAR(2),
    RC79TO40_M VARCHAR(2),
    RC80_M VARCHAR(3),
    RF_M VARCHAR(2),
    SS_M VARCHAR(2),
    CF_F VARCHAR(1),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(1),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(2),
    RC80_F VARCHAR(2),
    RF_F VARCHAR(1),
    SS_F VARCHAR(2)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_MISSING FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_MISSING.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebySexbyDisabilityplusLEP_SLD (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    DISABILITY_CATEGORY VARCHAR(3),
    AM_M_7 VARCHAR(2),
    AS_M_7 VARCHAR(2),
    BL_M_7 VARCHAR(3),
    HI_M_7 VARCHAR(3),
    MU_M_7 VARCHAR(2),
    PI_M_7 VARCHAR(2),
    WH_M_7 VARCHAR(3),
    AM_F_7 VARCHAR(2),
    AS_F_7 VARCHAR(2),
    BL_F_7 VARCHAR(3),
    HI_F_7 VARCHAR(3),
    MU_F_7 VARCHAR(2),
    PI_F_7 VARCHAR(2),
    WH_F_7 VARCHAR(3),
    TOTAL_STUDENTS_REPORTED VARCHAR(4),
    LEP_M VARCHAR(3),
    NLEP_M VARCHAR(3),
    LEP_F VARCHAR(2),
    NLEP_F VARCHAR(3),
    CF_M VARCHAR(3),
    HH_M VARCHAR(2),
    PPPS_M VARCHAR(3),
    RC39_M VARCHAR(3),
    RC79TO40_M VARCHAR(3),
    RC80_M VARCHAR(3),
    RF_M VARCHAR(2),
    SS_M VARCHAR(3),
    CF_F VARCHAR(2),
    HH_F VARCHAR(1),
    PPPS_F VARCHAR(3),
    RC39_F VARCHAR(2),
    RC79TO40_F VARCHAR(3),
    RC80_F VARCHAR(3),
    RF_F VARCHAR(1),
    SS_F VARCHAR(3)
);
COPY ed_ID74SCHRacebySexbyDisabilityplusLEP_SLD FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Sex by Disability plus LEP_SLD.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID74SCHRacebyPlacement (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    EDUCATIONAL_ENVIRONMENT VARCHAR(8),
    BL_RACE_7 VARCHAR(3),
    MU_RACE_7 VARCHAR(3),
    PI_RACE_7 VARCHAR(2),
    HI_RACE_7 VARCHAR(3),
    WH_RACE_7 VARCHAR(4),
    AS_RACE_7 VARCHAR(3),
    AM_RACE_7 VARCHAR(3),
    TOTAL_STUDENTS_REPORTED VARCHAR(4)
);
COPY ed_ID74SCHRacebyPlacement FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 74 SCH - Race by Placement.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
CREATE TABLE ed_ID22SCHTitleIStatus (
    LEA_STATE VARCHAR(2),
    LEA_STATE_NAME VARCHAR(20),
    NCESLEAID VARCHAR(7),
    LEA_NAME VARCHAR(60),
    SCHID VARCHAR(5),
    SCHOOL_NAME VARCHAR(60),
    NCESSCH VARCHAR(12),
    JJ VARCHAR(3),
    TITLE_I_STATUS VARCHAR(3)
);
COPY ed_ID22SCHTitleIStatus FROM '/home/Data/CRDC/2017-18-crdc-data-corrected-publication 2/2017-18 Public-Use Files/Data/SCH/EDFacts/CSV/ID 22 SCH - Title I Status.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';