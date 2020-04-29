-- TURNING TEXT TO DATA WITH REGEX FUNCTIONS
-- The purpose of work in this analysis is to extract and structurize the text of a sheriffs department in a 
-- Washington, D.C, surburbs daily publishing that details the time, date, location, type of crime, incident description
-- and the unique ID for the incident into a table using regular expression functions.

-- Data Source File: crime_reports.csv

-- CREATING A TABLE FOR CRIME REPORTS

CREATE TABLE dc_crime_reports(
    crime_id bigserial PRIMARY KEY,
    date_of_crime TIMESTAMP WITH TIME ZONE,
    date_of_crime2 TIMESTAMP WITH TIME ZONE,
    street varchar(200),
    city varchar(20),
    crime varchar(50),
    crime_description text,
    case_number varchar(20),
    original_text text NOT NULL
);

-- IMPORT CRIME REPORT DATA
COPY dc_crime_reports(original_text) -- Specify that only the original text column should be filled/ the data should be imported in the original_text column
FROM '/Users/username/file_location/crime_reports.csv'
WITH (FORMAT CSV, HEADER OFF, QUOTE '"'); 

-- MATCHING CRIME REPORT DATE PATTERNS USING regexp_match() FUNCTION
SELECT crime_id,
		regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')
FROM dc_crime_reports;

-- MATCHING THE SECOND DATE WHEN PRESENT
SELECT crime_id,
		regexp_matches(original_text, '\d{1,2}\/\d{1,2}\/\d{2}', 'g')
FROM dc_crime_reports;

-- MATCHING THE SECOND DATE ONLY
SELECT crime_id,
		regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})')
FROM dc_crime_reports;

-- MATCHING THE HOUR(s)
SELECT crime_id,
        regexp_match(original_text, '\/\d{2}\n(\d{4})')
FROM dc_crime_reports; -- Extracts and returns the first hour in an array

SELECT crime_id,
        regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})')
FROM dc_crime_reports; -- Extracts and returns the second hour in an array if it exists

-- MATCHING THE LOCATION
SELECT crime_id,
        regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))')
FROM dc_crime_reports; -- Extracts and returns the street address

SELECT crime_id,
        regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n')
FROM dc_crime_reports; -- Extracts and returns the city name

SELECT crime_id,
        regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):')
FROM dc_crime_reports; -- Extracts and returns the type of crime committed

SELECT crime_id,
        regexp_match(original_text, ':\s(.+)(?:C0|SO)')
FROM dc_crime_reports; -- Extracts and returns the crime description

SELECT crime_id,
        regexp_match(original_text, '(?:C0|SO)[0-9]+')
FROM dc_crime_reports; -- Extracts and returns the case IDs

SELECT crime_id,
		regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_of_crime,
		regexp_match(original_text, '(?:C0|SO)[0-9]+') AS case_number,
		regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))') AS street,
		regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city,
		regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime,
		regexp_match(original_text, ':\s(.+)(?:C0|SO)') AS crime_description
FROM dc_crime_reports;

-- UPDATING THE dc_crime_reports TABLE WITH THE EXTRACTED DATA
UPDATE dc_crime_reports
SET date_of_crime = (
    (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
        || ' ' ||
    (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1]
        ||' US/Eastern'
)::TIMESTAMP WITH TIME ZONE;

-- USING CASE TO HANDLE SPECIAL INSTANCES
UPDATE dc_crime_reports
SET date_of_crime = (
    (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
        || ' ' ||
    (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1]
        ||' US/Eastern'
)::TIMESTAMP WITH TIME ZONE,

date_of_crime2 = 
CASE
    WHEN(SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})') IS NULL)
        AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})')IS NOT NULL)

    THEN
        (
    (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
        || ' ' ||
    (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1]
        ||' US/Eastern'
    )::TIMESTAMP WITH TIME ZONE -- When a second hour exisit but not a second date. The reports covers a range of hours of the 1st date
WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})')IS NOT NULL)
        AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})')IS NOT NULL)
THEN
    (
    (regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})'))[1]
        || ' ' ||
    (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1]
        ||' US/Eastern'
    )::TIMESTAMP WITH TIME ZONE -- When a 2nd hour exisits and together with a 2nd date. The reports the report covers more than one date
ELSE NULL -- If none exists. The report returns a NULL value
END,
street = (regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1],
city = (regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n'))[1],
crime = (regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):'))[1],
crime_description = (regexp_match(original_text, ':\s(.+)(?:C0|SO)'))[1],
case_number = (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1];