CREATE SCHEMA IF NOT EXISTS "CRDB"; 
CREATE TABLE IF NOT EXISTS "CRDB".hmda_2017_nationwide_allrecords_labels (
    as_of_year VARCHAR(4),
    respondent_id VARCHAR(10),
    agency_name VARCHAR(43),
    agency_abbr VARCHAR(4),
    agency_code VARCHAR(1),
    loan_type_name VARCHAR(18),
    loan_type VARCHAR(1),
    property_type_name VARCHAR(61),
    property_type VARCHAR(1),
    loan_purpose_name VARCHAR(16),
    loan_purpose VARCHAR(1),
    owner_occupancy_name VARCHAR(42),
    owner_occupancy VARCHAR(1),
    loan_amount_000s VARCHAR(7),
    preapproval_name VARCHAR(29),
    preapproval VARCHAR(1),
    action_taken_name VARCHAR(51),
    action_taken VARCHAR(1),
    msamd_name VARCHAR(53),
    msamd VARCHAR(5),
    state_name VARCHAR(20),
    state_abbr VARCHAR(2),
    state_code VARCHAR(2),
    county_name VARCHAR(33),
    county_code VARCHAR(3),
    census_tract_number VARCHAR(7),
    applicant_ethnicity_name VARCHAR(81),
    applicant_ethnicity VARCHAR(1),
    co_applicant_ethnicity_name VARCHAR(81),
    co_applicant_ethnicity VARCHAR(1),
    applicant_race_name_1 VARCHAR(81),
    applicant_race_1 VARCHAR(1),
    applicant_race_name_2 VARCHAR(41),
    applicant_race_2 VARCHAR(1),
    applicant_race_name_3 VARCHAR(41),
    applicant_race_3 VARCHAR(1),
    applicant_race_name_4 VARCHAR(41),
    applicant_race_4 VARCHAR(1),
    applicant_race_name_5 VARCHAR(41),
    applicant_race_5 VARCHAR(1),
    co_applicant_race_name_1 VARCHAR(81),
    co_applicant_race_1 VARCHAR(1),
    co_applicant_race_name_2 VARCHAR(41),
    co_applicant_race_2 VARCHAR(1),
    co_applicant_race_name_3 VARCHAR(41),
    co_applicant_race_3 VARCHAR(1),
    co_applicant_race_name_4 VARCHAR(41),
    co_applicant_race_4 VARCHAR(1),
    co_applicant_race_name_5 VARCHAR(41),
    co_applicant_race_5 VARCHAR(1),
    applicant_sex_name VARCHAR(81),
    applicant_sex VARCHAR(1),
    co_applicant_sex_name VARCHAR(81),
    co_applicant_sex VARCHAR(1),
    applicant_income_000s VARCHAR(7),
    purchaser_type_name VARCHAR(76),
    purchaser_type VARCHAR(1),
    denial_reason_name_1 VARCHAR(46),
    denial_reason_1 VARCHAR(1),
    denial_reason_name_2 VARCHAR(46),
    denial_reason_2 VARCHAR(1),
    denial_reason_name_3 VARCHAR(46),
    denial_reason_3 VARCHAR(1),
    rate_spread VARCHAR(5),
    hoepa_status_name VARCHAR(16),
    hoepa_status VARCHAR(1),
    lien_status_name VARCHAR(29),
    lien_status VARCHAR(1),
    edit_status_name VARCHAR(2),
    edit_status VARCHAR(2),
    sequence_number VARCHAR(2),
    population VARCHAR(5),
    minority_population VARCHAR(20),
    hud_median_family_income VARCHAR(6),
    tract_to_msamd_income VARCHAR(18),
    number_of_owner_occupied_units VARCHAR(5),
    number_of_1_to_4_family_units VARCHAR(5),
    application_date_indicator VARCHAR(2)
);
COPY "CRDB".hmda_2017_nationwide_allrecords_labels FROM 'c:/Users/Public/Version111324_dataAnalytics/DataAnalytics2024/data/hmda_2017_nationwide_all-records_labels/cleaned_hmda_2017_nationwide_all-records_labels.csv' DELIMITER ',' CSV HEADER ENCODING 'windows-1251';
