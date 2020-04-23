-- The following statements simple arithmetic operations performed on the us_counties_census_2010 data
-- Listing 4-2: A CREATE TABLE statement for Census county data
-- Full data dictionary available at: http://www.census.gov/prod/cen2010/doc/pl94-171.pdf
-- Note: Some columns have been given more descriptive names

CREATE TABLE us_counties_census_2010 (
    county_name varchar(90),                    -- Name of the county
    state_abbreviation varchar(2),        -- State/U.S. abbreviation
    summary_level varchar(3),                -- Summary Level
    region smallint,                         -- Region
    division smallint,                       -- Division
    state_fips VARCHAR(2),                   -- State FIPS code
    county_fips VARCHAR(3),                  -- County code
    area_land bigint,                        -- Area (Land) in square meters
    area_water bigint,                        -- Area (Water) in square meters
    population_count_100_percent integer,    -- Population count (100%)
    housing_unit_count_100_percent integer,  -- Housing Unit count (100%)
    internal_point_lat numeric(10,7),        -- Internal point (latitude)
    internal_point_lon numeric(10,7),        -- Internal point (longitude)

    -- This section is referred to as P1. Race:
    p0010001 integer,   -- Total population
    p0010002 integer,   -- Population of one race:
    p0010003 integer,       -- White Alone
    p0010004 integer,       -- Black or African American alone
    p0010005 integer,       -- American Indian and Alaska Native alone
    p0010006 integer,       -- Asian alone
    p0010007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,       -- Some Other Race alone
    p0010009 integer,   -- Population of two or more races
    p0010010 integer,   -- Population of two races:
    p0010011 integer,       -- White; Black or African American
    p0010012 integer,       -- White; American Indian and Alaska Native
    p0010013 integer,       -- White; Asian
    p0010014 integer,       -- White; Native Hawaiian and Other Pacific Islander
    p0010015 integer,       -- White; Some Other Race
    p0010016 integer,       -- Black or African American; American Indian and Alaska Native
    p0010017 integer,       -- Black or African American; Asian
    p0010018 integer,       -- Black or African American; Native Hawaiian and Other Pacific Islander
    p0010019 integer,       -- Black or African American; Some Other Race
    p0010020 integer,       -- American Indian and Alaska Native; Asian
    p0010021 integer,       -- American Indian and Alaska Native; Native Hawaiian and Other Pacific Islander
    p0010022 integer,       -- American Indian and Alaska Native; Some Other Race
    p0010023 integer,       -- Asian; Native Hawaiian and Other Pacific Islander
    p0010024 integer,       -- Asian; Some Other Race
    p0010025 integer,       -- Native Hawaiian and Other Pacific Islander; Some Other Race
    p0010026 integer,   -- Population of three races
    p0010047 integer,   -- Population of four races
    p0010063 integer,   -- Population of five races
    p0010070 integer,   -- Population of six races

    -- This section is referred to as P2. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    p0020001 integer,   -- Total
    p0020002 integer,   -- Hispanic or Latino
    p0020003 integer,   -- Not Hispanic or Latino:
    p0020004 integer,   -- Population of one race:
    p0020005 integer,       -- White Alone
    p0020006 integer,       -- Black or African American alone
    p0020007 integer,       -- American Indian and Alaska Native alone
    p0020008 integer,       -- Asian alone
    p0020009 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0020010 integer,       -- Some Other Race alone
    p0020011 integer,   -- Two or More Races
    p0020012 integer,   -- Population of two races
    p0020028 integer,   -- Population of three races
    p0020049 smallint,   -- Population of four races
    p0020065 smallint,   -- Population of five races
    p0020072 smallint,   -- Population of six races

    -- This section is referred to as P3. RACE FOR THE POPULATION 18 YEARS AND OVER
    p0030001 integer,   -- Total
    p0030002 integer,   -- Population of one race:
    p0030003 integer,       -- White alone
    p0030004 integer,       -- Black or African American alone
    p0030005 integer,       -- American Indian and Alaska Native alone
    p0030006 integer,       -- Asian alone
    p0030007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0030008 integer,       -- Some Other Race alone
    p0030009 integer,   -- Two or More Races
    p0030010 integer,   -- Population of two races
    p0030026 integer,   -- Population of three races
    p0030047 SMALLINT,   -- Population of four races
    p0030063 SMALLINT,   -- Population of five races
    p0030070 SMALLINT,   -- Population of six races

    -- This section is referred to as P4. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    -- FOR THE POPULATION 18 YEARS AND OVER
    p0040001 integer,   -- Total
    p0040002 integer,   -- Hispanic or Latino
    p0040003 integer,   -- Not Hispanic or Latino:
    p0040004 integer,   -- Population of one race:
    p0040005 integer,   -- White alone
    p0040006 integer,   -- Black or African American alone
    p0040007 integer,   -- American Indian and Alaska Native alone
    p0040008 integer,   -- Asian alone
    p0040009 integer,   -- Native Hawaiian and Other Pacific Islander alone
    p0040010 integer,   -- Some Other Race alone
    p0040011 integer,   -- Two or More Races
    p0040012 integer,   -- Population of two races
    p0040028 integer,   -- Population of three races
    p0040049 SMALLINT,   -- Population of four races
    p0040065 SMALLINT,   -- Population of five races
    p0040072 SMALLINT,   -- Population of six races

    -- This section is referred to as H1. OCCUPANCY STATUS
    h0010001 integer,   -- Total housing units
    h0010002 integer,   -- Occupied
    h0010003 integer    -- Vacant
);

-- This table is for the 2000 US Census
CREATE TABLE us_counties_census_2000 (
	county_name varchar(90),
	state_abbreviation varchar(2),
	state_fips varchar(2),
	county_fips varchar(3),
	p0010001 integer,
	p0010002 integer,
	p0010003 integer,
	p0010004 integer,
	p0010005 integer,
	p0010006 integer,
	p0010007 integer,
	p0010008 integer,
	p0010009 integer,
	p0010010 integer,
	p0020002 integer,
	p0020003 integer
);

-- Import US census data set file into the postgresql database
COPY us_counties_census_2010 -- Import Query for 2010 county census data set
FROM '/Users/johnphillip/Desktop/us_counties_data.csv'
WITH (FORMAT CSV, HEADER);

COPY us_counties_census_2000  -- Import Query for 2000 county census data set
FROM '/Users/johnphillip/Desktop/us_counties_2000.csv'
WITH (FORMAT CSV, HEADER);

-- Export the whole table into a directory on your system
COPY us_counties_census_2010
TO '/Users/johnphillip/Desktop/us_county_census_data_2010.csv'
WITH (FORMAT CSV, HEADER);

-- Export a query from us_counties_census_2010 table
COPY (
	SELECT county_name, state_abbreviation, internal_point_latitude, internal_point_longitude, land_area
	FROM us_counties_census_2010
	WHERE state_abbreviation = 'NY'
	ORDER BY land_area DESC
)
TO '/Users/johnphillip/Desktop/new_york_county_census_2010.csv'
WITH (FORMAT CSV, HEADER);

SELECT county_name,
		state_abbreviation AS "State",
		p0010003 AS "White Alone",
		p0010004 AS "Black Alone",
		p0010003 + p0010004 AS "Total white and Black"
FROM us_counties_census_2010
WHERE state_abbreviation = 'CA'
ORDER BY "Total white and Black" DESC;


SELECT county_name,
		state_abbreviation AS "State",
		p0010001 AS "Total Population",
		p0010003 AS "White Alone",
		p0010004 AS "Black or African American Alone",
		p0010005 AS "Am Indian/ Alaskan Native Alone",
		p0010006 AS "Asian Alone",
		p0010007 AS "Native Hawaiian and Other Pacific Islander Alone",
		p0010008 AS "Some Other Race Alone",
		p0010009 AS "Mixed Race"
FROM us_counties_census_2010;


SELECT county_name,
		state_abbreviation AS "State",
		p0010001 AS "Total Population",
		p0010003 + p0010004 + p0010005 + p0010006 + p0010007 + p0010008 + p0010009 AS "All Races",
		(p0010003 + p0010004 + p0010005 + p0010006 + p0010007 + p0010008 + p0010009) - p0010001 AS "Difference"
FROM us_counties_census_2010
ORDER BY "Difference" DESC;

SELECT county_name,
		state_abbreviation AS "State",
		(CAST (p0010006 AS numeric(8,1)) / p0010001) * 100 AS "pct_asian"
FROM us_counties_census_2010
ORDER BY "pct_asian" DESC;

SELECT county_name,
		state_abbreviation AS "State",
		(CAST (p0010003 AS numeric(8,1)) / p0010001) * 100 AS "pct_white",
		(CAST (p0010004 AS numeric(8,1)) / p0010001) * 100 AS "pct_afr_american",
		(CAST (p0010006 AS numeric(8,1)) / p0010001) * 100 AS "pct_asian"
FROM us_counties_census_2010
ORDER BY "State" ASC;

SELECT category,
		budget_2019,
		budget_2018,
		(CAST (budget_2019 AS double precision) - budget_2018) / budget_2018 * 100 AS "pct_change_2019_vs_2018"
FROM us_annual_spending;

-- Using Aggregate functions : sum(), avg(), percentile()
-- Finding the sum of a column value. Example the total population in all counties from us_counties_census_2010
SELECT SUM(p0010001) AS "Total Population in all counties"
FROM us_counties_census_2010;
-- Finding the average of a column value. Example, the average population from all counties from us_counties_census_2010
SELECT AVG(p0010001) AS "Average Population"
FROM us_counties_census_2010;

-- Using the percentile function to find MEDIAN value in a dataset of numbers
CREATE TABLE percentile_test (
    numbers INTEGER
);

INSERT INTO percentile_test(numbers) VALUES (1), (2), (3), (4), (5), (6);
-- percentile_cont(n) function calculates percentiles as continous value. Meaning the results does not have to be one of the 
-- values in the data set but a decimal values between two values in the data set
SELECT percentile_cont(.5)  
WITHIN GROUP (ORDER BY numbers),
-- percentile_disc(n) function calculates percentiles as distinct value. Meaning the value returned will be rounded to one of the numbers in the data set.
percentile_disc(.5) WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;
-- Calculates the sum, avg and the median of the total population in all counties in the us_counties_census_2010 data set.
SELECT sum(p0010001) AS "Total population across all counties",
		round(avg(p0010001), 0) AS "County Average",
		percentile_cont(.5)
		WITHIN GROUP(ORDER BY p0010001) AS "County Median Population"
FROM us_counties_census_2010;

-- Calculating Quartile
SELECT unnest(
	percentile_cont(array[.25, .5, .75])
	WITHIN GROUP (ORDER BY p0010001) 
) AS "Quartiles"
FROM us_counties_census_2010; -- Returns the result without it being in a curly braces

-- 50th percentile
SELECT SUM(p0010001) AS "Total Population Across All Counties",
		round(AVG(p0010001), 0) AS "Average Population Across All Counties",
		median(p0010001) AS "Median Population Across Counties",
		percentile_cont(.5)
		WITHIN GROUP (ORDER BY p0010001) AS "50th Percentile"
FROM us_counties_census_2010;

-- MODE
SELECT MODE() WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_census_2010;

-- Comparing median county population within New York and california
SELECT state_abbreviation AS "State",
		percentile_cont(.5) 
		WITHIN GROUP (ORDER BY p0010001) AS "Median County Population"
FROM us_counties_census_2010
WHERE state_abbreviation IN ('NY', 'CA')
GROUP BY (state_abbreviation);
-- Alternatively (Faster runtime)
SELECT state_abbreviation AS "State",
		median(p0010001) AS "Median County Population"
FROM us_counties_census_2010
WHERE state_abbreviation IN ('NY', 'CA')
GROUP BY (state_abbreviation);

-- Performing population statistics on us_counties_census_2010 and us_counties_census_2000
SELECT c2010.county_name,
		c2010.state_abbreviation AS "State",
		c2010.p0010001 AS "pop_2010",
		c2000.p0010001 AS "pop_2000",
		c2010.p0010001 - c2000.p0010001 AS "Population change",
		round((CAST(c2010.p0010001 AS numeric(8, 1)) - c2000.p0010001) / c2000.p0010001 * 100, 1) AS "pct_change"
FROM us_counties_census_2010 AS c2010 INNER JOIN us_counties_census_2000 AS c2000
ON c2010.state_fips = c2000.state_fips 
	AND c2010.county_fips = c2000.county_fips 
	AND c2010.p0010001 <> c2000.p0010001
ORDER BY "pct_change" DESC;

-- Ranking Counties according to their total population using rank() and dense_rank()
SELECT county_name,
		state_abbreviation,
		p0010001 AS Total_Population,
		rank() OVER (ORDER BY p0010001 DESC),
		dense_rank() OVER (ORDER BY p0010001 DESC)
FROM us_counties_census_2000;

-- Ranking With Subgroups with PARTITION BY
SELECT county_name,
        state_abbreviation,
        p0010001 AS Total_Population,
        rank() OVER (PARTITION BY state_abbreviation ORDER BY p0010001 DESC)
FROM us_counties_census_2000;

-- Generating Values for a Query Expression. Using data from us_community_survey table, We'll show which U.S. counties are at or above the 80th
-- percentile, or top 20 percent using subquery in the WHERE clause

SELECT county_name, state_abbreviation, p0010001
FROM us_counties_census_2010
WHERE p0010001 >= (SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001) FROM us_counties_census_2010)
ORDER BY p0010001 DESC;

-- DELETING ROWS FROM A TABLE
CREATE TABLE us_counties_census_2010_bottom90 AS 
SELECT * FROM us_counties_census_2010; -- First create a table that copies all the content from us_counties_census_2010

DELETE FROM us_counties_census_2010_bottom90
WHERE p0010001 < (SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001) FROM us_counties_census_2010_bottom90); -- Query deletes counties 
-- within the top 10 percentile of the population