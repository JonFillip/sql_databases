-- In this analysis I'll be using views to create a virtual tables dynamically using a saved query,  
-- and triggers to run functions automatically when certain conditions are met in a table
-- To perform the analysis I'll be using data in the Decennial U.S Census us_counties_census_2010 
-- table from the us_census_analysis.sql file

-- CREATING AND QUERYING VIEW TO SHOW CENSUS DATA FOR CALIFORNIA (CA)

CREATE OR REPLACE VIEW california_counties_pop_2010 AS
    SELECT county_name,
            state_fips,
            county_fips,
            p0010001 AS county_pop_2010
    FROM us_counties_census_2010
    WHERE state_abbreviation = 'CA'
    ORDER BY county_fips;

-- CREATING AND QUERYING VIEW TO SHOW THE POPULATION CHANGE IN COUNTIES FROM 2010 - 2000

CREATE OR REPLACE VIEW county_pop_change_2010_2000 AS
    SELECT c2010.county_name,
            c2010.state_abbreviation,
            c2010.state_fips,
            c2010.county_fips,
            c2010.p0010001 AS pop_2010,
            c2000.p0010001 AS pop_2000,
            ROUND((c2010.p0010001 - c2000.p0010001)::numeric(8,1) / c2000.p0010001 * 100, 1) AS pct_change_pop_2010_2000
FROM us_counties_census_2010 AS c2010 INNER JOIN us_counties_census_2000 AS c2000
ON c2010.state_fips = c2000.state_fips
ORDER BY c2010.state_fips, c2010.county_fips;

-- CREATING VIEW OF EMPLOYEES
-- The data in this analysis comes from a employees table in my database. In this command
-- I want to give employees in the software department the ability to change their names 
-- without changing their salaries or any other data of other employees in the company

CREATE OR REPLACE VIEW employees_software_dept AS
    SELECT emp_id, -- employee ID
            first_name,
            last_name,
            dept_id
    FROM employees
    WHERE dept_id = 2 -- DEPARTMENT ID FOR SOFTWARE DEPARTMENT IS 2
    ORDER BY emp_id
    WITH LOCAL CHECK OPTION;

-- CREATING THE PERCENTAGE CHANGE FUNCTION percent_change()

CREATE OR REPLACE FUNCTION
percentage_change(
    new_value NUMERIC,
    old_value NUMERIC,
    decimal_places INTEGER DEFAULT 1
)
RETURNS NUMERIC AS 
'SELECT ROUND(
    ((new_value - old_value) / old_value) * 100, decimal_places
);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

-- CREATING AN UPDATE FUNCTION
-- In the employees table I will update the table to include a date of employment and personal days 
-- an employee to determine the number of personal days each employee has based on their date of employment

ALTER TABLE employees ADD COLUMN date_of_hire DATE;

ALTER TABLE employees ADD COLUMN personal_days INTEGER;

UPDATE employees
SET date_of_hire =  CASE WHEN emp_id = 1 OR emp_id = 6 THEN '2010-06-25'::DATE
                        WHEN emp_id = 3 OR emp_id = 7 THEN '2018-08-01'::DATE
                        WHEN emp_id = 5 THEN '2010-10-14'::DATE
                        WHEN emp_id = 4 THEN '2018-10-20'::DATE
                        WHEN emp_id = 2 THEN '2010-03-17'::DATE
                        ELSE '2020-01-15'::DATE
                    END;

-- These are the following rules governing personal days off
-- Less than one year to a year since hire: 3 personal days
-- Between more 1 year and 5 years since hire: 5 personal days
-- Between 6 and 10 years since hire: 10 personal days 
-- More than 10 years since hire: 15 personal days

CREATE OR REPLACE FUNCTION
update_personal_days()
RETURNS VOID AS $$
BEGIN
    UPDATE employees
    SET personal_days = 
    CASE WHEN (NOW() - date_of_hire) BETWEEN '3 months'::interval AND '1 year'::interval THEN 3
        WHEN (NOW() - date_of_hire) BETWEEN '1 year 1 day'::interval AND '5 years'::interval THEN 5
        WHEN (NOW() - date_of_hire) BETWEEN '6 years'::interval AND '10 years'::interval THEN 10
        WHEN (NOW() - date_of_hire) > '10 years'::interval THEN 15
        ELSE 1
    END;
RAISE NOTICE 'personal_days updated!';
END;
$$ LANGUAGE plpgsql; -- Procedural Language within PostgreSQL

-- TO ACTIVATE OR USE THE update_personal_days() FUNCTION
SELECT update_personal_days();

-- Using Python 3 in a Function

-- INSTALL PYTHON PL/Pyhton MODULE
CREATE EXTENSION plpython3u; -- It might work on some versions of PostgreSQL

-- USING PL/Python to create the trim_county() function
CREATE OR REPLACE FUNCTION trim_county(input_string TEXT)
RETURNS TEXT AS $$
    import re
    cleaned = re.sub(r' County', '', input_string)
    return cleaned
$$ LANGUAGE plpythonu;

-- CREATING TRIGGERS FOR FUNCTIONS
CREATE TABLE grades (
    student_id bigint,
    bigint,
    course varchar(30) NOT NULL,
    grade varchar(5) NOT NULL,
PRIMARY KEY (student_id, course_id)
);

INSERT INTO grades
VALUES
    (1, 1, 'Biology 2', 'F'),
    (1, 2, 'English 11B', 'D'),
    (1, 3, 'World History 11B', 'C'),
    (1, 4, 'Trig 2', 'B');

CREATE TABLE grades_history (
    student_id bigint NOT NULL,
    course_id bigint NOT NULL,
    change_time timestamp with time zone NOT NULL,
    course varchar(30) NOT NULL,
    old_grade varchar(5) NOT NULL,
    new_grade varchar(5) NOT NULL,
PRIMARY KEY (student_id, course_id, change_time)
);  

-- Creating the record_if_grade_changed() function

CREATE OR REPLACE FUNCTION record_if_grade_changed()
    RETURNS trigger AS
$$
BEGIN
    IF NEW.grade <> OLD.grade THEN
    INSERT INTO grades_history (
        student_id,
        course_id,
        change_time,
        course,
        old_grade,
        new_grade)
    VALUES
        (OLD.student_id,
        OLD.course_id,
        now(),
        OLD.course,
        OLD.grade,
        NEW.grade);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creating the grades_update trigger

CREATE TRIGGER grades_update
    AFTER UPDATE
    ON grades
    FOR EACH ROW
    EXECUTE PROCEDURE record_if_grade_changed();

-- Testing the grades_update trigger

-- Initially, there should be 0 records in the history
SELECT * FROM grades_history;

-- Check the grades
SELECT * FROM grades;

-- Update a grade
UPDATE grades
SET grade = 'C'
WHERE student_id = 1 AND course_id = 1;

-- Now check the history
SELECT student_id,
        change_time,
        course,
        old_grade,
        new_grade
FROM grades_history;

-- Creating a temperature_test table

CREATE TABLE temperature_test (
    station_name varchar(50),
    observation_date date,
    max_temp integer,
    min_temp integer,
    max_temp_group varchar(40),
PRIMARY KEY (station_name, observation_date)
);

-- Creating the classify_max_temp() function

CREATE OR REPLACE FUNCTION classify_max_temp()
    RETURNS trigger AS
$$
BEGIN
    CASE
        WHEN NEW.max_temp >= 90 THEN
            NEW.max_temp_group := 'Hot';
        WHEN NEW.max_temp BETWEEN 70 AND 89 THEN
            NEW.max_temp_group := 'Warm';
        WHEN NEW.max_temp BETWEEN 50 AND 69 THEN
            NEW.max_temp_group := 'Pleasant';
        WHEN NEW.max_temp BETWEEN 33 AND 49 THEN
            NEW.max_temp_group :=  'Cold';
        WHEN NEW.max_temp BETWEEN 20 AND 32 THEN
            NEW.max_temp_group :=  'Freezing';
        ELSE NEW.max_temp_group :=  'Inhumane';
    END CASE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creating the temperature_insert trigger

CREATE TRIGGER temperature_insert
    BEFORE INSERT
    ON temperature_test
    FOR EACH ROW
    EXECUTE PROCEDURE classify_max_temp();

-- Inserting rows to test the temperature_update trigger

INSERT INTO temperature_test (station_name, observation_date, max_temp, min_temp)
VALUES
    ('North Station', '1/19/2019', 10, -3),
    ('North Station', '3/20/2019', 28, 19),
    ('North Station', '5/2/2019', 65, 42),
    ('North Station', '8/9/2019', 93, 74);

SELECT * FROM temperature_test;

-- CREATING A RATES PER THOUSAND FUNCTION rate_per_1000()
CREATE OR REPLACE FUNCTION
rate_per_thousand(observed_number numeric,
                    base_number numeric,
                    decimal_places integer DEFAULT 1)
RETURNS numeric(10,2) AS $$
BEGIN
    RETURN
        round(
        (observed_number / base_number) * 1000, decimal_places
        );
END;
$$ LANGUAGE plpgsql;