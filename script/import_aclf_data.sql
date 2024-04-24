CREATE TABLE IF NOT EXISTS "CRDB".address_data_national ("state" VARCHAR(2), "county" VARCHAR(3), "tract" VARCHAR(7), "block" VARCHAR(4), "block_geoid" VARCHAR(15), "total_housing_units" DECIMAL, "total_group_quarters" DECIMAL, "total_correctional_facilities_for_adults" DECIMAL, "total_juvenile_facilities" DECIMAL, "total_nursing_facilities_skilled_nursing_facilities" DECIMAL, "total_other_institutional_facilities" DECIMAL, "total_college_university_student_housing" DECIMAL, "total_military_quarters" DECIMAL, "total_other_noninstitutional_facilities" DECIMAL);
-- Data from state code 28 appended to address_data_national