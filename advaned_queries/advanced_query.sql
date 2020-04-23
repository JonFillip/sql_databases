-- USING SUBQUERY
UPDATE table_name
SET column_name = (SELECT column_name FROM table_b WHERE table_name.column_name = table_b.column_name)
WHERE EXISTS (SELECT column_name FROM table_b WHERE table_name.column_name = table_b.column_name); -- This is used to set a value for a column

-- FILTERING WITH SUBQUERIES IN A WHERE CLAUSE
-- Generating Values for a Query Expression. Using data from us_community_survey table, We'll show which U.S. counties are at or above the 80th
-- percentile, or top 20 percent using subquery in the WHERE clause

SELECT county_name, state_abbreviation, p0010001
FROM us_counties_census_2010
WHERE p0010001 >= (SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001) FROM us_counties_census_2010)
ORDER BY p0010001 DESC;

-- USING SUBQURIES TO IDENTIFY ROWS TO DELETE
CREATE TABLE us_counties_census_2010_bottom90 AS 
SELECT * FROM us_counties_census_2010; -- First create a table that copies all the content from us_counties_census_2010

DELETE FROM us_counties_census_2010_bottom90
WHERE p0010001 < (SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001) FROM us_counties_census_2010_bottom90); -- Query deletes counties 
-- within the top 10 percentile of the population

-- CREATING DERIVED TABLES WITH SUBQUERIES
-- When a subquery returns rows and columns of data, one can convert that data into a table by placing it in a FROM clause aka derived table
-- In the following subquery we derive the average, median and median-average difference from us_counties_census_2010 total county population
-- and convert it into a table

SELECT ROUND(calcs.average, 0) AS average,
        calcs.median,
        ROUND(calcs.average - calcs.median, 0) AS median_average_diff
FROM (SELECT AVG(p0010001) AS average,
        percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)::numeric(10,1) AS median
        FROM us_counties_census_2010)
AS calcs;

-- JOINING DERIVED TABLES
-- Derived tables behave just like regular tables and can perform multiple preprocessing steps. In the query below, we want to know
-- the states that have the most meat, egg, and poultry processing plants per million population; but before we can calculate the rate
-- we need to know the number of plants in each state and the population in each state.

-- Start by counting the produces by state in fsis_meat_poultry_inspect_feb_2020. Then use us_counties_census_2010 data to count the 
-- population in each state

SELECT census.state_abbreviation AS state,
        census.st_population,
        plants.plants_count,
        ROUND((plants.plants_count / census.st_population::numeric(10,1)) * 1000000, 1) AS plants_per_million
FROM (SELECT st, COUNT(*) AS plants_count
        FROM fsis_meat_poultry_inspect_feb_2020
        GROUP BY st) AS plants -- Counts the number of plants in a state and groups them by state. This also makes a derived table 'plants'
JOIN (SELECT state_abbreviation,
        SUM(p0010001) AS st_population
        FROM us_counties_census_2010
        GROUP BY state_abbreviation) AS census -- Sums the population in each state, groups the result by state and converts it into a derived table
ON plants.st = census.state_abbreviation
ORDER BY plants_per_million DESC;

-- GENERATING COLUMNS WITH SUBQUERIES
-- To generate new columns of data with subqueries by placing a subquery in the column list after SELECT
SELECT county_name,
        state_abbreviation as us_state,
        p0010001 AS total_pop,
        (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) FROM us_counties_census_2010) AS us_median,
        p0010001 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) FROM us_counties_census_2010) AS diff_from_median
FROM us_counties_census_2010
WHERE p0010001 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) FROM us_counties_census_2010) BETWEEN -1000 AND 1000;
-- The query above creates two new columns - us_median and diff_from_median. us_median column contains the median county population
-- while diff_from_median finds the difference between the county's population and the median population and the WHERE clause filters
-- the results to show counties that have a difference between -1000 to 1000 from the median county population

-- SUBQUERY EXPRESSIONS
-- Generating Values For the IN Operator

SELECT column_name
FROM table_a
WHERE value IN (SELECT value FROM table_b)

-- Checking Whether Values Exists
SELECT column_name
FROM table_a
WHERE EXISTS (SELECT id FROM table_b)

-- OR
SELECT column_name
FROM table_a
WHERE EXISTS (SELECT id FROM table_b WHERE id = table_a.id)  -- Returns true if the subquery finds a corresponding value in table_b

SELECT hardware_company
FROM hardware_companies
WHERE NOT EXISTS (SELECT id FROM software_companies WHERE id = hardware_companies.id) -- Returns true if the subquery finds a value that doesn't correspond to the value in software_companies


-- COMMON TABLE EXPRESSIONS
-- Common Table expression (CTE) is another approach to making temporary tables. It's syntax starts with a WITH clause. This method allows for the creation
-- of one or more tables up front with subqueries. For example, checking which county's library in each state imls_library_survey_2016 have more than 100000 visits

WITH popular_libraries(stabr, cnty, libname, visits)

AS (
    SELECT stabr, cnty, libname, visits
    FROM imls_library_survey_2016
    WHERE visits > 100000
)

SELECT stabr, COUNT(*) AS library_count
FROM popular_libraries
GROUP BY stabr
ORDER BY COUNT(*) DESC;

WITH 
    state_population(st, population) AS
    (SELECT
        state_abbreviation, SUM(p0010001)
        FROM us_counties_census_2010
        GROUP BY state_abbreviation
    ),
    
    food_processor(st, number_of_plants) AS
    (SELECT  st, COUNT(company)
            FROM fsis_meat_poultry_inspect_feb_2020
            GROUP BY st
    ),

    libraries(st, libname, city, cnty, visits) AS 
    (SELECT stabr, libname, city, cnty, visits
            FROM imls_library_survey_2016
    ),

    crimes(st, city, population, violent_crime, property_crime, burglary, larceny_crime, motor_vehicle_theft) AS 
    (SELECT * FROM fbi_crime_data_2015)

SELECT state_population.st, state_population.population, food_processor.number_of_plants, COUNT(libraries.libname) AS lib_per_state
FROM state_population JOIN food_processor
ON state_population.st = food_processor.st
JOIN libraries ON state_population.st = libraries.st
GROUP BY state_population.st, state_population.population, food_processor.number_of_plants
ORDER BY state_population.population DESC; -- Returns the population, number of libraries, food plants in each state

-- CROSS TABULATIONS
-- Cross tabulations also called Pivot table or Crosstabs provide a simple way to summerize and compare variable by displaying
-- them in a table layout or matrix. Standard ANSI SQL doesn't come with a crosstab() function but can be installed using the syntax:
CREATE EXTENSION tablefunc;

-- Tabulating Survey Results
-- The first analysis is on an ice cream survey.

CREATE TABLE ice_cream_survey(
	response_id integer PRIMARY KEY,
	office varchar(20),
	flavor varchar(20)
);

COPY ice_cream_survey
FROM '/Users/johnphillip/Desktop/ice_cream_survey.csv'
WITH (FORMAT CSV, HEADER);

-- Cross tabulate the table to tally the votes for each ice-cream flavor

SELECT *
FROM CROSSTAB('SELECT office, flavor, COUNT(*)
                FROM ice_cream_survey
                GROUP BY office, flavor
                ORDER BY office',
                
                'SELECT flavor
                FROM ice_cream_survey
                GROUP BY flavor
                ORDER BY flavor')
AS (
    office varchar(20),
    chocolate bigint,
    strawberry bigint,
    vanilla bigint
);

SELECT *
FROM CROSSTAB('SELECT flavor, office, COUNT(*)
			FROM ice_cream_survey
			GROUP BY office, flavor
			ORDER BY flavor',
			
			'SELECT office FROM ice_cream_survey
			GROUP BY office
			ORDER BY office')

AS (flavor varchar(20),
	Uptown integer,
	Midtown integer,
	Downtown integer
);


-- TABULATING CITY TEMPERTURE READING
-- Taking data from U.S National Oceanic and Atomspheric Administration which contains daily temperature reading from 3 observation 
-- stattion in the USA: Chicago, Seattle and Waikiki

CREATE TABLE temperature_readings(
    reading_id bigserial,
    station_name varchar(50),
    observation_date date,
    max_temp integer,
    min_temp integer
);

COPY temperature_readings (station_name, observation_date, max_temp, min_temp)
FROM '/Users/johnphillip/Desktop/temperature_readings.csv'
WITH (FORMAT CSV, HEADER);

SELECT *
FROM crosstab(
    'SELECT station_name,
            date_part(''month'', observation_date),
            percentile_cont(.5) WITHIN GROUP (ORDER BY max_temp)
    FROM temperature_readings
    GROUP BY station_name,
            date_part(''month'', observation_date)
    ORDER BY station_name', -- In the first part of a crosstab generates the data. Here we calculate the median max temperature for each each at each station

    'SELECT month
    FROM generate_series(1, 12) month' -- The 2nd part generates the columns for the cross table and uses the generate_series() function to generate a list of 12 numbers representing 
    -- the number of the months
)

AS (
    station varchar(50),
    jan numeric(3,0),
    feb numeric(3,0),
    mar numeric(3,0),
    apr numeric(3,0),
    may numeric(3,0),
    jun numeric(3,0),
    jul numeric(3,0),
    aug numeric(3,0),
    sep numeric(3,0),
    oct numeric(3,0),
    nov numeric(3,0),
    dec numeric(3,0)
);

-- RECLASSIFYING VALUES WITH CASE
-- Standard ANSI SQL CASE statement is a conditional expression, allowing programmers to add "if this, then..or if..else" logic to the query jsut like another 
-- programming language. The syntax for CASE follows this pattern:
CASE WHEN condition THEN result
    WHEN another_condition THEN result
    ELSE result
END;
-- The query show how to reclassify the temperature reading data into descriptive groups(Hot to freezing cold)
SELECT *,
        CASE WHEN max_temp >= 90 THEN 'Hot'
            WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
            WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
            WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
            WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
            ELSE 'Inhabitable'
        END AS temperature_group
FROM temperature_readings;

-- USING CASE IN A COMMON TABLE EXPRESSION
WITH temps_aggregate(station_name, max_temp_group) AS 
        (
        SELECT station_name,
            CASE WHEN max_temp >= 90 THEN 'Hot'
                WHEN max_temp BETWEEN 70 AND 89 THEN 'Warm'
                WHEN max_temp BETWEEN 50 AND 69 THEN 'Pleasant'
                WHEN max_temp BETWEEN 33 AND 49 THEN 'Cold'
                WHEN max_temp BETWEEN 20 AND 32 THEN 'Freezing'
                ELSE 'Inhabitable'
            END AS temperature_group
        FROM temperature_readings
        )

SELECT station_name, max_temp_group, COUNT(*)
FROM temps_aggregate
GROUP BY station_name, max_temp_group
ORDER BY station_name, COUNT(*) DESC;  -- Returns

WITH temps_wikiki(stattion_name, max_temp_group) AS 
        (
        SELECT station_name,
                CASE WHEN max_temp >= 90 THEN '90 or more'
                WHEN max_temp BETWEEN 88 AND 89 THEN '88 - 89'
                WHEN max_temp BETWEEN 86 AND 87 THEN '86 - 87'
                WHEN max_temp BETWEEN 84 AND 85 THEN '84 - 85'
                WHEN max_temp BETWEEN 82 AND 83 THEN '82 - 83'
                WHEN max_temp BETWEEN 80 AND 81 THEN '80 - 81'
                ELSE '79 or less'
                END AS temperature_description
        FROM temperature_readings
        )

SELECT station_name, max_temp_group, COUNT(*)
FROM temps_wikiki
WHERE station_name = 'WAIKIKI 717.2 HI US'
GROUP BY station_name, max_temp_group
ORDER BY max_temp_group DESC;
