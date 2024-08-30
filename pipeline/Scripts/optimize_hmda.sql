-- PostgreSQL script for reducing size of HMDA table

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN as_of_year,
DROP COLUMN property_type,
DROP COLUMN property_type_name,
DROP COLUMN owner_occupancy,
DROP COLUMN owner_occupancy_name,
DROP COLUMN action_taken,
DROP COLUMN action_taken_name,
DROP COLUMN denial_reason_name_1,
DROP COLUMN denial_reason_1,
DROP COLUMN denial_reason_name_2,
DROP COLUMN denial_reason_2,
DROP COLUMN denial_reason_name_3,
DROP COLUMN denial_reason_3,
DROP COLUMN lien_status,
DROP COLUMN lien_status_name,
DROP COLUMN edit_status,
DROP COLUMN edit_status_name,
DROP COLUMN sequence_number,
DROP COLUMN application_date_indicator
;
-- as_of_year is always 2017
-- property_type_name is always "One-to-four family dwelling (other than manufactured housing)"
-- owner_occupancy_name is always "Owner-occupied as a principal dwelling"
-- action_taken_name is always "Loan originated"
-- denial_reason columns irrelevant and empty
-- lien_status_name is always "Secured by a first lien"
-- edit_status_name, sequence_number, and application_date_indicator are always blank


-- Steps have 4 parts
-- 1. Add a table
-- 2. Add data to table
-- 3. Create a FK on the hmda table
-- 4. Remove unnecessary columns

-- Step 1: agency_code

CREATE TABLE ref_schema.ref_agency (
    agency_code SMALLINT CHECK (agency_code BETWEEN 1 AND 9) PRIMARY KEY,
    agency_abbr VARCHAR(4),
    agency_name VARCHAR(43)
);

INSERT INTO ref_schema.ref_agency (agency_code, agency_abbr, agency_name)
SELECT DISTINCT agency_code, agency_abbr, agency_name
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_agency_code
FOREIGN KEY (agency_code)
REFERENCES ref_schema.ref_agency(agency_code);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN agency_abbr,
DROP COLUMN agency_name;

-- Step 2: loan_type

CREATE TABLE ref_schema.ref_loan_type (
    loan_type SMALLINT CHECK (loan_type BETWEEN 1 AND 4) PRIMARY KEY,
    loan_type_name VARCHAR(18)
);

INSERT INTO ref_schema.ref_loan_type (loan_type, loan_type_name)
SELECT DISTINCT loan_type, loan_type_name
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_loan_type
FOREIGN KEY (loan_type)
REFERENCES ref_schema.ref_loan_type(loan_type);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN loan_type_name;

-- Step 3: loan_purpose

CREATE TABLE ref_schema.ref_loan_purpose (
    loan_purpose SMALLINT CHECK (loan_purpose BETWEEN 1 AND 3) PRIMARY KEY,
    loan_purpose_name VARCHAR(16)
);

INSERT INTO ref_schema.ref_loan_purpose (loan_purpose, loan_purpose_name)
SELECT DISTINCT loan_purpose, loan_purpose_name
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_loan_purpose
FOREIGN KEY (loan_purpose)
REFERENCES ref_schema.ref_loan_purpose(loan_purpose);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN loan_purpose_name;

-- Step 4: preapproval

CREATE TABLE ref_schema.ref_preapproval (
    preapproval SMALLINT CHECK (preapproval BETWEEN 1 AND 3) PRIMARY KEY,
    preapproval_name VARCHAR(29)
);

INSERT INTO ref_schema.ref_preapproval (preapproval, preapproval_name)
SELECT DISTINCT preapproval, preapproval_name
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_preapproval
FOREIGN KEY (preapproval)
REFERENCES ref_schema.ref_preapproval(preapproval);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN preapproval_name;

-- Step 5: msamd

-- Set null msamd values to 0
UPDATE data_schema.hmda_2017_nationwide
SET msamd = COALESCE(msamd, 0);

CREATE TABLE ref_schema.ref_msamd (
    msamd INTEGER PRIMARY KEY,
    msamd_name VARCHAR(53)
);

INSERT INTO ref_schema.ref_msamd (msamd, msamd_name)
SELECT DISTINCT msamd, msamd_name
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_msamd
FOREIGN KEY (msamd)
REFERENCES ref_schema.ref_msamd(msamd);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN msamd_name;

-- Step 6: state

-- Set null state_code values to 0
UPDATE data_schema.hmda_2017_nationwide
SET state_code = COALESCE(state_code, 0);

CREATE TABLE ref_schema.ref_state (
    state_code SMALLINT PRIMARY KEY,
    state_name VARCHAR(20),
    state_abbr VARCHAR(2)
);

INSERT INTO ref_schema.ref_state (state_code, state_name, state_abbr)
SELECT DISTINCT state_code, state_name, state_abbr
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_state_code
FOREIGN KEY (state_code)
REFERENCES ref_schema.ref_state(state_code);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN state_name,
DROP COLUMN state_abbr
;

-- Step 6: ethnicity

-- applicant and coapplicant use same codes
CREATE TABLE ref_schema.ref_ethnicity (
    ethnicity SMALLINT PRIMARY KEY,
    ethnicity_name VARCHAR(81)
);

INSERT INTO ref_schema.ref_ethnicity (ethnicity, ethnicity_name)
SELECT DISTINCT co_applicant_ethnicity, co_applicant_ethnicity_name
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_app_ethnicity
FOREIGN KEY (applicant_ethnicity)
REFERENCES ref_schema.ref_ethnicity(ethnicity);

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_co_app_ethnicity
FOREIGN KEY (co_applicant_ethnicity)
REFERENCES ref_schema.ref_ethnicity(ethnicity);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN applicant_ethnicity_name,
DROP COLUMN co_applicant_ethnicity_name
;

-- Step 7: race

-- applicant and coapplicant use same codes
CREATE TABLE ref_schema.ref_race (
    race SMALLINT PRIMARY KEY,
    race_name VARCHAR(81)
);

INSERT INTO ref_schema.ref_race (race, race_name)
select distinct co_applicant_race_1, co_applicant_race_name_1
FROM data_schema.hmda_2017_nationwide
union
select distinct applicant_race_1, applicant_race_name_1
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_app_race
FOREIGN KEY (applicant_race_1)
REFERENCES ref_schema.ref_race(race);

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_co_app_race
FOREIGN KEY (co_applicant_race_1)
REFERENCES ref_schema.ref_race(race);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN applicant_race_name_1,
DROP COLUMN applicant_race_name_2,
DROP COLUMN applicant_race_name_3,
DROP COLUMN applicant_race_name_4,
DROP COLUMN applicant_race_name_5,
DROP COLUMN co_applicant_race_name_1,
DROP COLUMN co_applicant_race_name_2,
DROP COLUMN co_applicant_race_name_3,
DROP COLUMN co_applicant_race_name_4,
DROP COLUMN co_applicant_race_name_5
;

-- Step 8: sex

CREATE TABLE ref_schema.ref_sex (
    sex SMALLINT PRIMARY KEY,
    sex_name VARCHAR(81)
);

INSERT INTO ref_schema.ref_sex (sex, sex_name)
select distinct co_applicant_sex, co_applicant_sex_name
FROM data_schema.hmda_2017_nationwide
union
select distinct applicant_sex, applicant_sex_name
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_app_sex
FOREIGN KEY (applicant_sex)
REFERENCES ref_schema.ref_sex(sex);

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_co_app_sex
FOREIGN KEY (co_applicant_sex)
REFERENCES ref_schema.ref_sex(sex);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN applicant_sex_name,
DROP COLUMN co_applicant_sex_name
;


-- Step 9: purchaser_type

CREATE TABLE ref_schema.ref_purchaser (
    purchaser_type SMALLINT PRIMARY KEY,
    purchaser_type_name VARCHAR(76)
);

INSERT INTO ref_schema.ref_purchaser (purchaser_type, purchaser_type_name)
select distinct purchaser_type, purchaser_type_name
FROM data_schema.hmda_2017_nationwide;

ALTER TABLE data_schema.hmda_2017_nationwide
ADD CONSTRAINT fk_purchaser
FOREIGN KEY (purchaser_type)
REFERENCES ref_schema.ref_purchaser(purchaser_type);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN purchaser_type_name
;


-- Step 10: hoepa_status

ALTER TABLE data_schema.hmda_2017_nationwide
RENAME COLUMN hoepa_status TO is_loan_hoepa;

ALTER TABLE data_schema.hmda_2017_nationwide
ALTER COLUMN is_loan_hoepa
TYPE BOOLEAN
USING (is_loan_hoepa = 1);

ALTER TABLE data_schema.hmda_2017_nationwide
DROP COLUMN hoepa_status_name;

