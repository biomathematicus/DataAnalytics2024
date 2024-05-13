--prelimanary cleaning
--adjusting table values
SELECT leaid FROM "CRDB".grf17_lea_blkgrp
WHERE LENGTH(leaid) != 7;

UPDATE "CRDB".grf17_lea_blkgrp
SET leaid = LPAD(leaid, 7, '0')
WHERE LENGTH(leaid) < 7;


-- creating indices for optimization
-- Index on 'leaid' 
CREATE INDEX IF NOT EXISTS idx_leaid_grf17_lea_tract ON "CRDB".grf17_lea_tract (leaid);

-- Index on 'tract' 
CREATE INDEX IF NOT EXISTS idx_tract_grf17_lea_tract ON "CRDB".grf17_lea_tract (tract);

-- Index on 'leaid' for 'lea_block_groups'
CREATE INDEX IF NOT EXISTS idx_leaid_grf17_lea_blkgr ON "CRDB".grf17_lea_blkgrp (leaid);

-- Index on 'block' for 'lea_block_groups'
CREATE INDEX IF NOT EXISTS idx_block_grf17_lea_blkgr ON "CRDB".grf17_lea_blkgrp (blkgrp);

CREATE INDEX IF NOT EXISTS idx_address_data_national_tract ON "CRDB".address_data_national (LEFT(block_geoid, 11));

CREATE INDEX IF NOT EXISTS idx_leaid_public_school_characteristics_2017_18 ON "CRDB".public_school_characteristics_2017_18 ("LEAID");


-- Before indexing a tract on the block groupd, we 
-- Add a 'tract' column to 'lea_block_groups' table based on 'block_group'
ALTER TABLE "CRDB".grf17_lea_blkgrp
ADD COLUMN IF NOT EXISTS tract VARCHAR(11);


-- ADDING COL in address table for block group
-- Add the new column without a default value
ALTER TABLE "CRDB".address_data_national
ADD COLUMN IF NOT EXISTS blkgrp VARCHAR(12);
-- Populate the new column based on another column
UPDATE "CRDB".address_data_national
SET blkgrp = CAST(LEFT(block_geoid, 12) AS VARCHAR);
-- Create an index on the new 'blkgrp' column
CREATE INDEX IF NOT EXISTS  idx_blkgrp_address_data_national ON "CRDB".address_data_national (blkgrp);


-- Update the 'tract' column with the first 11 characters of the 'block_group'
UPDATE "CRDB".grf17_lea_blkgrp
SET tract = LEFT(blkgrp, 11)
WHERE tract IS NULL OR tract = '';
-- Create an index on the 'tract' column
CREATE INDEX IF NOT EXISTS  idx_tract_grf17_lea_blkgrp ON "CRDB".grf17_lea_blkgrp (tract);


-- getting indices
SELECT
    indexname AS index_name,
    indexdef AS index_definition
FROM
    pg_indexes
WHERE
    tablename = 'address_data_national'
    AND schemaname = 'CRDB';

-- adjusting types
ALTER TABLE "CRDB".grf17_lea_county
ALTER COLUMN landarea TYPE NUMERIC USING landarea::NUMERIC;

ALTER TABLE "CRDB".grf17_lea_tract
ALTER COLUMN landarea TYPE NUMERIC USING landarea::NUMERIC;

ALTER TABLE "CRDB".grf17_lea_place
ALTER COLUMN landarea TYPE NUMERIC USING landarea::NUMERIC;

ALTER TABLE "CRDB".grf17_lea_blkgrp
ALTER COLUMN landarea TYPE NUMERIC USING landarea::NUMERIC;

ALTER TABLE "CRDB".grf17_lea_blkgrp
ALTER COLUMN count TYPE NUMERIC USING count::NUMERIC;

ALTER TABLE "CRDB".ussd17_edited 
ALTER COLUMN estimated_total_population TYPE INTEGER USING estimated_total_population::INTEGER,
ALTER COLUMN estimated_population_5_17 TYPE INTEGER USING estimated_population_5_17::INTEGER,
ALTER COLUMN estimated_number_of_relevant_children_5_to_17_years_old_in_pove TYPE INTEGER USING estimated_number_of_relevant_children_5_to_17_years_old_in_pove::INTEGER;


CREATE INDEX IF NOT EXISTS idx_landarea_on_grf17_lea_blkgrp
ON "CRDB".grf17_lea_blkgrp (landarea);

-- Investigating block overlap
CREATE OR REPLACE FUNCTION check_blkgrp_in_multiple_tracts_or_leaids()
RETURNS TABLE(blkgrp VARCHAR, num_tracts INTEGER, num_leaids INTEGER) AS $$
BEGIN
    RETURN QUERY
    WITH tract_counts AS (
        SELECT
            a.blkgrp AS blkgrp,
            CAST(COUNT(DISTINCT a.tract) AS INTEGER) AS num_tracts
        FROM
            "CRDB".address_data_national AS a  -- Using alias 'a' for address_data_national
        GROUP BY
            a.blkgrp
    ),
    leaid_counts AS (
        SELECT
            b.blkgrp AS blkgrp,
            CAST(COUNT(DISTINCT b.leaid) AS INTEGER) AS num_leaids
        FROM
            "CRDB".grf17_lea_blkgrp AS b  -- Using alias 'b' for grf17_lea_blkgrp
        GROUP BY
            b.blkgrp
    )
    SELECT
        COALESCE(t.blkgrp, l.blkgrp) AS blkgrp,  -- Using COALESCE to handle possible NULLs from FULL JOIN
        COALESCE(t.num_tracts, 0) AS num_tracts,  -- Return 0 if no tracts are associated
        COALESCE(l.num_leaids, 0) AS num_leaids   -- Return 0 if no LEAIDs are associated
    FROM
        tract_counts t
    FULL JOIN
        leaid_counts l ON t.blkgrp = l.blkgrp
    ORDER BY
        COALESCE(t.blkgrp, l.blkgrp);  -- Ensure 'blkgrp' joins are qualified by aliases
    --WHERE
        --t.num_tracts > 1  OR l.num_leaids > 1; --uncomment for meaningful result 
END;
$$ LANGUAGE plpgsql;
DROP TABLE IF exists blkgrp_num_tracts_num_leaids; --for reproducibility purposes
CREATE TABLE blkgrp_num_tracts_num_leaids AS SELECT * FROM check_blkgrp_in_multiple_tracts_or_leaids();

--SELECT * FROM blkgrp_num_tracts_num_leaids WHERE blkgrp = '100010411001';
--SELECT * FROM "CRDB".grf17_lea_blkgrp WHERE blkgrp = '100010411001';
--SELECT * FROM  "CRDB".address_data_national WHERE   state = '10' and county ='001' and tract LIKE '0411%';
--SELECT * FROM  "CRDB".hmda_2017_nationwide_allrecords_labels WHERE  state_code = '10' and county_code ='1' and census_tract_number LIKE '0411%';
--SELECT * FROM "CRDB".public_school_characteristics_2017_18 WHERE "LEAID" = '1000180'; --shows that tract "10001041100" does exist

--- IMPORTANT FINDING:
-- A block group is only one tract, but can be in multiple in leaids


CREATE OR REPLACE FUNCTION blkgrp_in_multiple_leaids()
RETURNS TABLE(blkgrp VARCHAR, num_tracts INTEGER, num_leaids INTEGER) AS $$
BEGIN
    RETURN QUERY
    WITH tract_counts AS (
        SELECT
            a.blkgrp AS blkgrp,
            CAST(COUNT(DISTINCT a.tract) AS INTEGER) AS num_tracts
        FROM
            "CRDB".address_data_national AS a  -- Using alias 'a' for address_data_national
        GROUP BY
            a.blkgrp
    ),
    leaid_counts AS (
        SELECT
            b.blkgrp AS blkgrp,
            CAST(COUNT(DISTINCT b.leaid) AS INTEGER) AS num_leaids
        FROM
            "CRDB".grf17_lea_blkgrp AS b  -- Using alias 'b' for grf17_lea_blkgrp
        GROUP BY
            b.blkgrp
    )
    SELECT
        COALESCE(t.blkgrp, l.blkgrp) AS blkgrp,  -- Using COALESCE to handle possible NULLs from FULL JOIN
        COALESCE(t.num_tracts, 0) AS num_tracts,  -- Return 0 if no tracts are associated
        COALESCE(l.num_leaids, 0) AS num_leaids   -- Return 0 if no LEAIDs are associated
    FROM
        tract_counts t
    FULL JOIN
        leaid_counts l ON t.blkgrp = l.blkgrp
	WHERE
        t.num_tracts >= 1  AND l.num_leaids >= 1
    ORDER BY
        COALESCE(t.blkgrp, l.blkgrp);  
END;
$$ LANGUAGE plpgsql;
DROP TABLE IF EXISTS blkgrp_in_multiple_leaids;
CREATE TABLE blkgrp_in_multiple_leaids AS SELECT * FROM blkgrp_in_multiple_leaids();

SELECT * FROM blkgrp_in_multiple_leaids WHERE num_leaids > 1; --24286 blkgroups --12345 tracs

-- to find percentages
SELECT COUNT(*) FROM blkgrp_in_multiple_leaids WHERE num_leaids = 2;--16408/141859
SELECT COUNT(*) FROM blkgrp_in_multiple_leaids WHERE num_leaids > 2; --7878/141859
SELECT COUNT(*) FROM blkgrp_in_multiple_leaids;



-- adding columns
ALTER TABLE blkgrp_in_multiple_leaids
ADD COLUMN IF NOT EXISTS tract VARCHAR(11);
UPDATE blkgrp_in_multiple_leaids
SET tract = LEFT(blkgrp, 11);
ALTER TABLE blkgrp_in_multiple_leaids
ADD COLUMN IF NOT EXISTS  state VARCHAR(2);
UPDATE blkgrp_in_multiple_leaids
SET state = LEFT(blkgrp, 2);

-- it is easy to see where the overlap is
SELECT * FROM blkgrp_in_multiple_leaids WHERE num_leaids > 1 ORDER BY  num_leaids DESC;
SELECT tract FROM blkgrp_in_multiple_leaids WHERE num_leaids > 1 GROUP BY tract;


DROP FUNCTION IF EXISTS get_blocks_by_leaid(VARCHAR);
CREATE OR REPLACE FUNCTION get_blocks_by_leaid(target_leaid VARCHAR)
RETURNS TABLE(
    leaid VARCHAR, 
    tract VARCHAR, 
    blkgrp VARCHAR, 
    num_blocks_in_leaid INTEGER, 
    num_blocks_in_tract_leaid_pair INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.leaid AS leaid, 
        CAST(LEFT(b.blkgrp, 11) AS VARCHAR) AS tract, 
        b.blkgrp AS blkgrp, 
        CAST(b.count AS INTEGER) AS num_blocks_in_leaid,
        CAST(t.num_blocks_in_tract AS INTEGER) -- Cast to INTEGER
    FROM 
        "CRDB".grf17_lea_blkgrp AS b
    INNER JOIN (
        SELECT 
            CAST(LEFT(inner_blkgrp.blkgrp, 11) AS VARCHAR) AS inner_tract, 
            COUNT(DISTINCT inner_blkgrp.blkgrp) AS num_blocks_in_tract -- Returns bigint
        FROM 
            "CRDB".grf17_lea_blkgrp AS inner_blkgrp
        WHERE 
            inner_blkgrp.leaid = target_leaid
        GROUP BY 
            inner_tract
    ) AS t ON CAST(LEFT(b.blkgrp, 11) AS VARCHAR) = t.inner_tract
    WHERE 
        b.leaid = target_leaid;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_blocks_by_leaid('4808130');



DROP FUNCTION if exists get_blocks_by_tract(target_tract VARCHAR);
CREATE OR REPLACE FUNCTION get_blocks_by_tract(target_tract VARCHAR)
RETURNS TABLE(tract VARCHAR, blkgrp VARCHAR, num_distinct_blkgrps_in_tract INTEGER) AS $$
DECLARE
    distinct_count INTEGER;
BEGIN
    -- Calculate the number of distinct block groups in the tract
    SELECT COUNT(DISTINCT LEFT(a.blkgrp, 12))
    INTO distinct_count
    FROM "CRDB".address_data_national a
    WHERE LEFT(a.blkgrp, 11) = target_tract;

    -- Return each block group in the specified tract with the total count of distinct block groups
    RETURN QUERY
    SELECT
        target_tract AS tract,
        a.blkgrp AS blkgrp,
        distinct_count AS num_distinct_blkgrps_in_tract  -- Constant count of distinct block groups
    FROM
        "CRDB".address_data_national a
    WHERE
        LEFT(a.blkgrp, 11) = target_tract
	GROUP BY
		a.blkgrp;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_blocks_by_tract('48375010100');

SELECT * FROM "CRDB".address_data_national WHERE LEFT(block_geoid, 11) ='48375010100';



DROP FUNCTION if exists get_tracts_by_leaid(VARCHAR);
CREATE OR REPLACE FUNCTION get_tracts_by_leaid(target_leaid VARCHAR)
RETURNS TABLE(leaid VARCHAR, tract VARCHAR, num_tracts_in_leaid INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT t.leaid, t.tract, CAST(t.count AS INTEGER)
	FROM "CRDB".grf17_lea_tract AS t
	WHERE t.leaid =target_leaid;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_tracts_by_leaid('4808130');


CREATE OR REPLACE FUNCTION get_total_students_by_leaid(leaid VARCHAR)
RETURNS INTEGER AS $$
DECLARE
    total_students INTEGER;
BEGIN
    SELECT SUM(total) INTO total_students
    FROM "CRDB".public_school_characteristics_2017_18
    WHERE "LEAID" = leaid;

    RETURN total_students;
END;
$$ LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS get_blocks_and_tracts_by_leaid(VARCHAR);
CREATE OR REPLACE FUNCTION get_blocks_and_tracts_by_leaid(target_leaid VARCHAR)
RETURNS TABLE(
    leaid_output VARCHAR, 
    tract_output VARCHAR, 
    blkgrp_output VARCHAR, 
    num_blocks_in_leaid_output INTEGER, 
    num_blocks_in_tract_leaid_pair_output INTEGER,
    num_tracts_in_leaid_output INTEGER,
	num_overlapping_leaids_in_blkgrp_output INTEGER,
    leaid_overlapping_blkgrp_output VARCHAR,
    total_students INTEGER
) AS $$
BEGIN
    RETURN QUERY
    WITH tracts AS (
        SELECT 
            t.leaid AS leaid, 
            t.tract AS tract, 
            CAST(t.count AS INTEGER) AS num_tracts_in_leaid
        FROM 
            "CRDB".grf17_lea_tract AS t
        WHERE 
            t.leaid = target_leaid
    ),
    blocks AS (
        SELECT 
            CAST(LEFT(b.blkgrp, 11) AS VARCHAR) AS tract,
            b.blkgrp AS blkgrp,
            CAST(b.count AS INTEGER) AS num_blocks_in_leaid,
            b.leaid AS leaid
        FROM 
            "CRDB".grf17_lea_blkgrp AS b
        WHERE 
            b.leaid = target_leaid
    ),
    tract_blocks AS (
        SELECT 
            tb.tract AS inner_tract, 
            CAST(COUNT(DISTINCT tb.blkgrp)AS INTEGER) AS num_blocks_in_tract
        FROM 
            "CRDB".grf17_lea_blkgrp AS tb
        WHERE 
            tb.leaid = target_leaid
        GROUP BY 
            tb.tract
    )
    SELECT 
        b.leaid AS leaid_output, 
        b.tract AS tract_output, 
        b.blkgrp AS blkgrp_output, 
        b.num_blocks_in_leaid AS num_blocks_in_leaid_output,
        tb.num_blocks_in_tract AS num_blocks_in_tract_leaid_pair_output,
        tr.num_tracts_in_leaid AS num_tracts_in_leaid_output,
		bn.num_leaids AS num_overlapping_leaids_in_blkgrp_output,
        ld.overlapping_leaid AS leaid_overlapping_blkgrp_output,
        get_total_students_by_leaid(ld.overlapping_leaid) AS total_students
    FROM 
        blocks AS b
    LEFT JOIN tract_blocks AS tb ON b.tract = tb.inner_tract
    LEFT JOIN tracts AS tr ON b.leaid = tr.leaid AND b.tract = tr.tract
    CROSS JOIN LATERAL (
        SELECT 
			bg.leaid AS overlapping_leaid
        FROM "CRDB".grf17_lea_blkgrp AS bg
        WHERE bg.blkgrp = b.blkgrp 
    ) AS ld
	LEFT JOIN blkgrp_num_tracts_num_leaids bn ON bn.blkgrp = b.blkgrp
	ORDER BY blkgrp_output ASC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_blocks_and_tracts_by_leaid('4808130');

SELECT * FROM get_blocks_and_tracts_by_leaid('1000180');

SELECT COUNT(DISTINCT blkgrp_output) FROM get_blocks_and_tracts_by_leaid('1000180');

SELECT * FROM "CRDB".public_school_characteristics_2017_18
LIMIT 100;


-- tract is in 4 leaids, lets test it
SELECT * FROM "CRDB".grf17_lea_blkgrp WHERE tract = '36103990100'; 

SELECT * FROM get_blocks_and_tracts_by_leaid('1000180');
SELECT CAST(COUNT(DISTINCT leaid) AS INTEGER) FROM "CRDB".grf17_lea_blkgrp WHERE blkgrp = '100010411001';
SELECT DISTINCT leaid FROM "CRDB".grf17_lea_blkgrp WHERE blkgrp = '100010411001';


-- double check
SELECT DISTINCT blkgrp_output FROM get_blocks_and_tracts_by_leaid('1000180');




-- Function to retrieve all LEAIDs associated with a given block group
CREATE OR REPLACE FUNCTION get_leaids_for_blkgrp(blkgrp_id VARCHAR)
RETURNS TABLE(leaid VARCHAR, total_students INTEGER ) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        b.leaid,
		get_total_students_by_leaid(b.leaid) AS total_students
    FROM
        "CRDB".grf17_lea_blkgrp AS b
    WHERE
        b.blkgrp = blkgrp_id;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_leaids_for_blkgrp('361039901000'); --contains 32  leaids


-- Function to calculate total students and their percentage for each LEAID in a block group
-- for a given blk group, it gives the total students in each leaid that block belongs to
-- then the percent of that blocks students that are in that leaid
CREATE OR REPLACE FUNCTION calculate_leaid_students_and_percentages(blkgrp_id VARCHAR)
RETURNS TABLE(leaid VARCHAR, total_students INTEGER, percent_students FLOAT) AS $$
BEGIN
    RETURN QUERY
    WITH leaid_data AS (
        SELECT
            b.leaid,  -- Specify that leaid is coming from the subquery result of get_leaids_for_blkgrp
            get_total_students_by_leaid(b.leaid) AS total_students
        FROM
            get_leaids_for_blkgrp(blkgrp_id) AS b  -- Alias the table function to ensure clarity
    ),
    total AS (
        SELECT SUM(ld.total_students) AS total_students_sum FROM leaid_data ld
    )
    SELECT
        ld.leaid,  -- Specify leaid comes from leaid_data
        ld.total_students,
        (ld.total_students::FLOAT / t.total_students_sum) * 100 AS percent_students
    FROM
        leaid_data ld,  -- Clearly reference leaid_data alias
        total t;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM calculate_leaid_students_and_percentages('361039901000');

-- Shows that land area is per leaid, but specific to country or block
SELECT SUM(landarea) AS total_land_area
FROM "CRDB".grf17_lea_county
WHERE leaid = '4808130';
SELECT SUM(landarea) AS total_land_area
FROM "CRDB".grf17_lea_county
WHERE leaid = '4808130';




-- 590 blocks with multiple leaids have 0 land area and therefore shouldn't count
SELECT 
    m.blkgrp,
    m.num_leaids,
	z.count as num_blkgrps_in_leaid,
    z.landarea,
    z.waterarea
FROM 
    blkgrp_in_multiple_leaids m
JOIN 
    "CRDB".grf17_lea_blkgrp z ON m.blkgrp = z.blkgrp
WHERE 
    m.num_leaids  > 0  AND z.landarea = 0;


-- Important finding: all block groups with land area zero,
-- have more than one blkgroup in the leaid
SELECT 
    m.blkgrp,
    m.num_leaids,
	z.count as num_blkgrps_in_leaid,
    z.landarea,
    z.waterarea
FROM 
    blkgrp_in_multiple_leaids m
JOIN 
    "CRDB".grf17_lea_blkgrp z ON m.blkgrp = z.blkgrp
WHERE 
     z.count = 1 and z.landarea = 0;
-- this means that if a blkgroup has 0 land area, 
-- it does not contribute to the district


SELECT 
    m.blkgrp,
    m.num_leaids,
	z.count as num_blkgrps_in_leaid,
    z.landarea,
    z.waterarea
FROM 
    blkgrp_in_multiple_leaids m
JOIN 
    "CRDB".grf17_lea_blkgrp z ON m.blkgrp = z.blkgrp
WHERE 
    z.landarea = 0;



-- so now we disconsider these
CREATE OR REPLACE FUNCTION blkgrp_positive_landarea_in_multiple_leaids()
RETURNS TABLE(blkgrp VARCHAR, num_tracts INTEGER, num_leaids INTEGER) AS $$
BEGIN
    RETURN QUERY
    WITH tract_counts AS (
        SELECT
            a.blkgrp AS blkgrp,
            CAST(COUNT(DISTINCT a.tract) AS INTEGER) AS num_tracts
        FROM
            "CRDB".address_data_national AS a  -- Using alias 'a' for address_data_national
        GROUP BY
            a.blkgrp
    ),
    leaid_counts AS (
        SELECT
            b.blkgrp AS blkgrp,
            CAST(COUNT(DISTINCT b.leaid) AS INTEGER) AS num_leaids
        FROM
            "CRDB".grf17_lea_blkgrp AS b  -- Using alias 'b' for grf17_lea_blkgrp
		WHERE
			b.landarea > 0
        GROUP BY
            b.blkgrp
    )
    SELECT
        COALESCE(t.blkgrp, l.blkgrp) AS blkgrp,  -- Using COALESCE to handle possible NULLs from FULL JOIN
        COALESCE(t.num_tracts, 0) AS num_tracts,  -- Return 0 if no tracts are associated
        COALESCE(l.num_leaids, 0) AS num_leaids   -- Return 0 if no LEAIDs are associated
    FROM
        tract_counts t
    FULL JOIN
        leaid_counts l ON t.blkgrp = l.blkgrp
	WHERE
        t.num_tracts >= 1  AND l.num_leaids >= 1
    ORDER BY
        COALESCE(t.blkgrp, l.blkgrp);
END;
$$ LANGUAGE plpgsql;
DROP TABLE IF EXISTS blkgrp_positive_landarea_in_multiple_leaids;
CREATE TABLE blkgrp_positive_landarea_in_multiple_leaids AS SELECT * FROM blkgrp_positive_landarea_in_multiple_leaids();
SELECT * FROM blkgrp_positive_landarea_in_multiple_leaids WHERE num_leaids > 1 ORDER By 
		num_leaids DESC;


-- example of leaid with multipe block groups is 100005
-- the following shows the the land area in grf17_lea_blkgrp 
-- is specific to the leaid and blkgrp pairing
SELECT leaid, landarea, waterarea
FROM "CRDB".grf17_lea_blkgrp
WHERE blkgrp = '10950307024';

SELECT leaid, landarea, waterarea
FROM "CRDB".grf17_lea_blkgrp
WHERE leaid = '100005';


-- helper function
CREATE OR REPLACE FUNCTION get_total_land_area_by_leaid(target_leaid VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
    total_land_area NUMERIC;
BEGIN
    SELECT SUM(landarea) INTO total_land_area
    FROM "CRDB".grf17_lea_blkgrp
    WHERE leaid = target_leaid;
    RETURN total_land_area;
END;
$$ LANGUAGE plpgsql;


-- getting weights
--DROP FUNCTION get_leaid_students_and_landarea(blkgrp_id VARCHAR);
CREATE OR REPLACE FUNCTION get_leaid_students_and_landarea(blkgrp_id VARCHAR)
RETURNS TABLE(
    leaid VARCHAR, 
    total_students_in_leaid INTEGER, 
    landarea_in_leaid_blk_pair NUMERIC,
    total_land_area_in_leaid NUMERIC, 
    total_land_area_in_blkgrp NUMERIC,
    weight_land FLOAT,
    estimated_students_in_leaid_blk_pair FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        z.leaid,
        get_total_students_by_leaid(z.leaid) AS total_students_in_leaid,
        z.landarea AS landarea_in_leaid_blk_pair,
        get_total_land_area_by_leaid(z.leaid) AS total_land_area_in_leaid,
        SUM(z.landarea) OVER () AS total_land_area_in_blkgrp,  -- Calculate total land area over all rows
        (z.landarea::FLOAT / get_total_land_area_by_leaid(z.leaid)) AS weight_land, -- Calculate weight based on land area
        get_total_students_by_leaid(z.leaid) * (z.landarea::FLOAT / get_total_land_area_by_leaid(z.leaid)) AS estimated_students_in_leaid_blk_pair
    FROM  
        "CRDB".grf17_lea_blkgrp z
    WHERE 
        z.blkgrp = blkgrp_id;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_leaid_students_and_landarea('301110014023');
SELECT * FROM get_leaid_students_and_landarea('100050517021');


-- now collecting the weights in a table
CREATE OR REPLACE FUNCTION assign_blkgrp_weights()
RETURNS TABLE(
    blkgrp VARCHAR,
    leaid VARCHAR,
    weight FLOAT
) AS $$
BEGIN
    -- Drop the temporary table if it exists to ensure fresh data each time the function is called
    DROP TABLE IF EXISTS temp_blkgrp_weights;
    CREATE TEMP TABLE temp_blkgrp_weights (
        temp_blkgrp VARCHAR,
        temp_leaid VARCHAR,
        temp_weight FLOAT
    );

    -- Assign weight 0 to block groups with land area 0
    INSERT INTO temp_blkgrp_weights (temp_blkgrp, temp_leaid, temp_weight)
    SELECT
        bg.blkgrp,
        bg.leaid,
        0::FLOAT AS weight -- Initialize with zero weight
    FROM
        "CRDB".grf17_lea_blkgrp bg
    WHERE
        bg.landarea = 0;

    -- Assign weight 1 to block groups with num_leaids = 1
    INSERT INTO temp_blkgrp_weights (temp_blkgrp, temp_leaid, temp_weight)
    SELECT
        b.blkgrp,
        bg.leaid,
        1::FLOAT AS weight
    FROM
        blkgrp_positive_landarea_in_multiple_leaids b
    JOIN
        "CRDB".grf17_lea_blkgrp bg ON bg.blkgrp = b.blkgrp
    WHERE
        b.num_leaids = 1 AND bg.landarea > 0;

    -- Insert complex weight calculations for other cases
    INSERT INTO temp_blkgrp_weights (temp_blkgrp, temp_leaid, temp_weight)
	SELECT
	    z.blkgrp,
	    z.leaid,
	    la.weight_land AS weight
	FROM
	    "CRDB".grf17_lea_blkgrp z
	JOIN 
	    get_leaid_students_and_landarea(z.blkgrp) la ON la.leaid = z.leaid
	WHERE
	    z.landarea > 0 AND z.blkgrp NOT IN (SELECT temp_blkgrp FROM temp_blkgrp_weights);

    -- Return the weights from the temporary table
    RETURN QUERY SELECT temp_blkgrp AS blkgrp, temp_leaid AS leaid, temp_weight AS weight FROM temp_blkgrp_weights;

    -- Optionally, drop the temporary table if no longer needed
    --DROP TABLE IF EXISTS temp_blkgrp_weights;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM assign_blkgrp_weights() ORDER BY weight DESC;

SELECT * FROM  blkgrp_in_multiple_leaids where num_leaids > 1 ORDER BY num_leaids DESC;

SELECT * FROM get_leaid_students_and_landarea('300210001002');

SELECT * FROM assign_blkgrp_weights() WHERE blkgrp = '300210001002';

-- checking the estimates to see the error
drop function if exists  estimate_leaid_block_group_data();
CREATE OR REPLACE FUNCTION estimate_leaid_block_group_data()
RETURNS TABLE(
    leaid VARCHAR,
    blkgrp VARCHAR,
	weight FLOAT,
	total_enrollment_leaid INTEGER,
    estimated_students_in_blk_leaid FLOAT,
	total_population_leaid INTEGER,
    estimated_population_in_blk_leaid FLOAT
) AS $$
DECLARE
    total_enrollment INTEGER;
    total_population INTEGER;
BEGIN
    -- Temporary table to store intermediate results
    CREATE TEMP TABLE leaid_data AS
    SELECT
        psc."LEAID" as leaid,
        get_total_students_by_leaid(psc."LEAID") AS total_enrollment_leaid,
        ue.total_population AS total_population_leaid
    FROM
        "CRDB".public_school_characteristics_2017_18 psc
    JOIN
       (SELECT LPAD(ue.state_fips_code, 2, '0') || LPAD(ue.district_id, 5, '0') AS leaid,
		ue.estimated_total_population AS total_population
		FROM
		"CRDB".ussd17_edited ue
		GROUP BY
            LPAD(ue.state_fips_code, 2, '0') || LPAD(ue.district_id, 5, '0'), ue.estimated_total_population
       ) ue ON ue.leaid = psc."LEAID";
    -- Calculate estimated students and population for each block group
    RETURN QUERY
    SELECT
        ld.leaid,
        aw.blkgrp,
		aw.weight,
		ld.total_enrollment_leaid,
        ROUND(ld.total_enrollment_leaid * aw.weight / grf.count) AS estimated_students_in_blk_leaid,
		ld.total_population_leaid,
        ROUND(ld.total_population_leaid * aw.weight / grf.count) AS estimated_population_in_blk_leaid
    FROM
        leaid_data ld
    JOIN
        assign_blkgrp_weights() aw ON aw.leaid = ld.leaid
	JOIN
		"CRDB".grf17_lea_blkgrp grf ON grf.blkgrp =  aw.blkgrp AND grf.leaid = aw.leaid;
    -- Drop the temporary table after use
    DROP TABLE IF EXISTS leaid_data;
END;
$$ LANGUAGE plpgsql;
drop table if exists leaid_blkgrp_estimates;
CREATE TABLE leaid_blkgrp_estimates AS SELECT DISTINCT
    leaid,
    blkgrp,
	weight,
    total_enrollment_leaid,
    estimated_students_in_blk_leaid,
    total_population_leaid,
    estimated_population_in_blk_leaid
FROM
    estimate_leaid_block_group_data();

-- experimenting and messigng around
SELECT * FROM leaid_blkgrp_estimates;
select * from leaid_blkgrp_estimates where leaid = ('3416890');
select * from leaid_blkgrp_estimates where leaid = ('3178540'); --total enrollment is 314
select count from "CRDB".grf17_lea_blkgrp where leaid = ('0805010');

--checking that weights are unique
SELECT 
    leaid,
    blkgrp,
    ARRAY_AGG(weight) AS weights -- This aggregates all weights into an array for each leaid-blkgrp pair
FROM 
    leaid_blkgrp_estimates
GROUP BY 
    leaid,
    blkgrp
HAVING 
    COUNT(weight) > 1;
select distinct(leaid) from "CRDB".grf17_lea_blkgrp where blkgrp = '530350925001';
select leaid, blkgrp, landarea from "CRDB".grf17_lea_blkgrp where blkgrp = '530350925001'; 
select num_leaids from blkgrp_positive_landarea_in_multiple_leaids where blkgrp = '530350925001'; 
select * from assign_blkgrp_weights() where leaid = '3416890';


-- can use this code to check blkgrps 
SELECT 
    leaid,
    blkgrp,
    ARRAY_AGG(weight) AS weights -- This aggregates all weights into an array for each leaid-blkgrp pair
FROM 
    leaid_blkgrp_estimates
where 
    blkgrp ='530350925001' 
GROUP BY 
    leaid,
    blkgrp;

-- checking accurary
drop function if exists calculate_leaid_totals(target_leaid VARCHAR);
CREATE OR REPLACE FUNCTION calculate_leaid_totals(target_leaid VARCHAR)
RETURNS TABLE(
	leaid VARCHAR,
	total_enrollment_leaid INTEGER,
    estimated_leaid_enrollment FLOAT,
	total_population_leaid INTEGER,
    estimated_leaid_population FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
		target_leaid as leaid,
		e.total_enrollment_leaid,
        SUM(e.estimated_students_in_blk_leaid) AS estimated_leaid_enrollment,
		e.total_population_leaid,
        SUM(e.estimated_population_in_blk_leaid) AS estimated_leaid_population
    FROM 
        leaid_blkgrp_estimates e
    WHERE 
        e.leaid = target_leaid
	group by
		e.total_enrollment_leaid,e.total_population_leaid;
END;
$$ LANGUAGE plpgsql;

--running the above for all leaids:
drop FUNCTION if exists calculate_totals_for_all_leaids();
CREATE OR REPLACE FUNCTION calculate_totals_for_all_leaids()
RETURNS TABLE(
    leaid_ VARCHAR,
    total_enrollment_leaid INTEGER,
    estimated_leaid_enrollment FLOAT,
	student_error FLOAT,
    total_population_leaid INTEGER,
    estimated_leaid_population FLOAT,
	pop_error FLOAT,
	num_blks_in_leaid INTEGER
) AS $$
DECLARE
    rec RECORD;  -- Declaring the loop variable as a RECORD type to store row results.
BEGIN
    -- Dropping and recreating the result table to ensure freshness and avoid conflicts
    DROP TABLE IF EXISTS temp_leaid_totals;
    CREATE TEMP TABLE temp_leaid_totals AS
        SELECT DISTINCT leaid FROM leaid_blkgrp_estimates;

    -- Looping over the distinct leaids stored in the temporary table
    FOR rec IN SELECT leaid FROM temp_leaid_totals
    LOOP
        RETURN QUERY
        SELECT 
            sub.leaid AS leaid_,  -- Clear disambiguation by using an alias
            sub.total_enrollment_leaid,
            sub.estimated_leaid_enrollment,
			sub.total_enrollment_leaid - sub.estimated_leaid_enrollment as student_error,
            sub.total_population_leaid,
            sub.estimated_leaid_population,
			sub.total_population_leaid - sub.estimated_leaid_population as pop_error,
			grf.count::INTEGER AS num_blks_in_leaid
        FROM 
            calculate_leaid_totals(rec.leaid) AS sub
        LEFT JOIN
            "CRDB".grf17_lea_blkgrp AS grf ON sub.leaid = grf.leaid;
    END LOOP;

    -- Cleanup temporary table
    DROP TABLE IF EXISTS temp_leaid_totals;
END;
$$ LANGUAGE plpgsql;
-- shows accuracy
SELECT * FROM calculate_totals_for_all_leaids() ORDER by student_error DESC;




-- GETTING READY TO CONVERT TO TRACT
-- helper function
drop  FUNCTION if exists count_block_groups_per_tract();
CREATE OR REPLACE FUNCTION count_block_groups_per_tract_leaid()
RETURNS TABLE(
	leaid VARCHAR,
    tract VARCHAR,
    num_block_groups INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
		b.leaid,
        CAST(LEFT(LPAD(b.blkgrp , 12, '0'), 11) AS VARCHAR) AS tract,  -- Extract the first 11 characters to identify the tract
        COUNT(DISTINCT b.blkgrp)::INTEGER AS num_block_groups  -- Count distinct block groups in each tract
    FROM
        "CRDB".grf17_lea_blkgrp b
    GROUP BY
        CAST(LEFT(LPAD(b.blkgrp , 12, '0'), 11) AS VARCHAR), b.leaid;  -- Group by the tract identifier
END;
$$ LANGUAGE plpgsql;
SELECT * FROM count_block_groups_per_tract_leaid() limit 50;

-- experimenting
Select count(distinct(tract)) from "CRDB".grf17_lea_blkgrp; --99963
Select count(distinct( CAST(LEFT(blkgrp, 11) AS VARCHAR))) from  assign_blkgrp_weights(); --99963

-- get the tract weight (contribution of a tract to an leaid)
drop function if exists calculate_all_tract_weights();
CREATE OR REPLACE FUNCTION calculate_all_tract_weights()
RETURNS TABLE(
    leaid VARCHAR,
	--blk_grp VARCHAR,
    tract VARCHAR,
    --blkgrp_weight FLOAT,
	tract_weight FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.leaid,
		--CAST(LPAD(b.blkgrp , 12, '0') AS VARCHAR) as blkgroup,
        CAST(LEFT(LPAD(b.blkgrp , 12, '0'), 11) AS VARCHAR) AS tract,  -- Extracting the tract ID from the blkgrp
        --b.weight AS blkgrp_weight,
		SUM(b.weight) AS tract_weight
    FROM
        assign_blkgrp_weights() b  -- Assuming this table contains blkgrp, weight, and LEAID
	GROUP BY 
		b.leaid,
		--b.blkgrp,
		CAST(LEFT(LPAD(b.blkgrp , 12, '0'), 11) AS VARCHAR);
END;
$$ LANGUAGE plpgsql;
SELECT * FROM calculate_all_tract_weights() ORDER BY leaid, tract;

-- check 
SELECT t.leaid, SUM(tract_weight)
	FROM 
	calculate_all_tract_weights() b
	JOIN 
		count_block_groups_per_tract_leaid() t ON t.tract = b.tract AND t.leaid = b.leaid
	GROUP BY t.leaid;


--COMBINING WITH HMDA DATA
-- first cleaning hmda
ALTER TABLE "CRDB".hmda_2017_nationwide_allrecords_labels
ADD COLUMN IF NOT EXISTS tract VARCHAR(11);
UPDATE "CRDB".hmda_2017_nationwide_allrecords_labels
SET tract = LPAD(state_code::VARCHAR, 2, '0') || 
            LPAD(county_code::VARCHAR, 3, '0') || 
            LPAD(SPLIT_PART(census_tract_number::VARCHAR, '.', 1), 4, '0') || 
            RPAD(COALESCE(SPLIT_PART(census_tract_number::VARCHAR, '.', 2), ''), 2, '0')
WHERE state_code IS NOT NULL AND state_code != '' AND
      county_code IS NOT NULL AND county_code != '' AND
      census_tract_number IS NOT NULL AND census_tract_number != '';

CREATE INDEX IF NOT EXISTS idx_non_null_rate_spread 
ON "CRDB".hmda_2017_nationwide_allrecords_labels(rate_spread) WHERE rate_spread IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_minority_population
ON "CRDB".hmda_2017_nationwide_allrecords_labels(minority_population);

CREATE INDEX IF NOT EXISTS idx_hud_median_family_income
ON "CRDB".hmda_2017_nationwide_allrecords_labels(hud_median_family_income);

CREATE INDEX IF NOT EXISTS idx_tract_to_msamd_income
ON "CRDB".hmda_2017_nationwide_allrecords_labels(tract_to_msamd_income);

CREATE INDEX IF NOT EXISTS idx_tract_on_hmda
ON "CRDB".hmda_2017_nationwide_allrecords_labels (tract);


DROP FUNCTION IF EXISTS get_hmda_data_per_tract_leaid();
CREATE OR REPLACE FUNCTION get_hmda_data_per_tract_leaid()
RETURNS TABLE(
	leaid VARCHAR,
    tract VARCHAR,
    denial_count FLOAT,
	avg_rate_spread FLOAT,
    minority_population FLOAT,
    hud_median_family_income FLOAT,
    tract_to_msamd_income FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
		li.leaid,
        h.tract,
        SUM(CASE WHEN h.denial_reason_1 IS NOT NULL AND h.denial_reason_1 != '' THEN 1 ELSE 0 END) * li.tract_weight AS denial_count,
		AVG(NULLIF(h.rate_spread, '')::NUMERIC) * li.tract_weight AS avg_rate_spread,
		AVG(NULLIF(h.minority_population, '')::NUMERIC)  * li.tract_weight AS minority_population,
        AVG(NULLIF(h.hud_median_family_income, '')::NUMERIC) * li.tract_weight AS hud_median_family_income,
        AVG(NULLIF(h.tract_to_msamd_income, '')::NUMERIC) * li.tract_weight AS tract_to_msamd_income
    FROM 
        "CRDB".hmda_2017_nationwide_allrecords_labels h
    JOIN 
        calculate_all_tract_weights() li ON h.tract = li.tract
    WHERE 
        h.tract IS NOT NULL AND
        h.rate_spread IS NOT NULL
    GROUP BY 
        li.leaid, h.tract, li.tract_weight;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM get_hmda_data_per_tract_leaid();


-- get hmda data weighted to the leaid
DROP FUNCTION IF EXISTS get_hmda_data_per_leaid();
CREATE OR REPLACE FUNCTION get_hmda_data_per_leaid()
RETURNS TABLE(
	leaid VARCHAR,
    denial_count FLOAT,
	avg_rate_spread FLOAT,
    minority_population FLOAT,
    hud_median_family_income FLOAT,
    tract_to_msamd_income FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        h.leaid,
        SUM(h.denial_count) AS denial_count,
        SUM(h.avg_rate_spread) AS avg_rate_spread,
        SUM(h.minority_population) AS minority_population,
        SUM(h.hud_median_family_income) AS hud_median_family_income,
        SUM(h.tract_to_msamd_income) AS tract_to_msamd_income
    FROM  
        get_hmda_data_per_tract_leaid() h 
    GROUP BY
        h.leaid;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM get_hmda_data_per_tract_leaid() ORDER BY denial_count DESC;


-- algebra ii
DROP FUNCTION if exists  get_algebraii_enrollment_summary_leaid();
CREATE OR REPLACE FUNCTION get_algebraii_enrollment_summary_leaid()
RETURNS TABLE(
    leaid VARCHAR,
    total_males BIGINT,
    total_females BIGINT,
    total_enrollment BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        a.leaid,
        SUM(CASE WHEN CAST(a.tot_mathenr_alg2_m AS INTEGER) >= 0 THEN CAST(a.tot_mathenr_alg2_m AS INTEGER) ELSE 0 END) AS total_males,
        SUM(CASE WHEN CAST(a.tot_mathenr_alg2_f AS INTEGER) >= 0 THEN CAST(a.tot_mathenr_alg2_f AS INTEGER) ELSE 0 END) AS total_females,
        SUM(CASE WHEN CAST(a.tot_mathenr_alg2_m AS INTEGER) >= 0 THEN CAST(a.tot_mathenr_alg2_m AS INTEGER) ELSE 0 END) +
        SUM(CASE WHEN CAST(a.tot_mathenr_alg2_f AS INTEGER) >= 0 THEN CAST(a.tot_mathenr_alg2_f AS INTEGER) ELSE 0 END) AS total_enrollment
    FROM
        "CRDB".algebraii a
    GROUP BY
        a.leaid;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION if exists get_leaid_algii_mortgage();
CREATE OR REPLACE FUNCTION get_leaid_algii_mortgage()
RETURNS TABLE(
    leaid VARCHAR,
    total_enrollment BIGINT,
    denial_count FLOAT,
    weighted_avg_rate_spread FLOAT,
    weighted_avg_minority_population FLOAT,
    weighted_avg_hud_median_family_income FLOAT,
    weighted_avg_tract_to_msamd_income FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        a.leaid,
        a.total_enrollment,
        SUM(h.denial_count) AS denial_count,
        SUM(h.avg_rate_spread) AS  weighted_avg_rate_spread,
        SUM(h.minority_population) AS weighted_avg_minority_population,
        SUM(h.hud_median_family_income)AS weighted_avg_hud_median_family_income,
        SUM(h.tract_to_msamd_income) AS weighted_avg_tract_to_msamd_income
    FROM
        get_algebraii_enrollment_summary_leaid() a
    JOIN
        get_hmda_data_per_tract_leaid() h ON a.leaid = h.leaid
	GROUP BY
		a.leaid,a.total_enrollment;
END;
$$ LANGUAGE plpgsql;
CREATE TABLE leaid_algii_mortgage_data AS SELECT * from get_leaid_algii_mortgage();
