-- INSPECTING AND MODIFYING DATA
-- DATA TITLE: FOOD SATETY ON MEAT, POULTRY AND EGG PRODUCERS IN THE USA
-- DATA SOURCE: The survey on food safety is conducted by the Food Safety and Inspection Service (FSIS) 
-- The FSIS is responsible for inspecting animals and food produce across meat processing plants 
-- across the US. Website: https://www.fsis.usda.gov
-- DATA SOURCE URL: https://catalog.data.gov/dataset

-- CREATE TABLE AND IMPORT DATASET
CREATE TABLE meat_poultry_egg_inspect (
    est_number varchar(50) CONSTRAINT est_numb_key PRIMARY KEY,
    company varchar(100),
    street varchar(100),
    city varchar(30),
    st varchar(2),
    zip varchar(5),
    phone varchar(14),
    grant_date date,
    activities text,
    dbas text
);

-- IMPORT DATA SET
COPY meat_poultry_egg_inspect
FROM '/Users/postgresql_database/meat_poultry_egg_inspection.csv'
WITH (FORMAT CSV, HEADER);

-- CREATE INDEX USING company AS THE INDEX KEY
CREATE INDEX company_name_idx ON meat_poultry_egg_inspect(company);

-- INSPECTING DATA SET (CHECKING FOR DUPLICATE VALUES)
-- The following statement helps to find companies that might have a duplicate address in the same location.
SELECT company,
		street,
		city,
		st,
		COUNT(*) AS address_count
FROM meat_poultry_egg_inspect
GROUP BY company, street, city, st
HAVING count(*) > 1 -- Filters for companies that may have the same combination of values more than once in the table
ORDER BY company, street, city, st; -- The result shows 23 cases where comapnies have the same combination of values
-- as their address multiple times

-- CHECKING FOR MISSING VALUES
SELECT st, COUNT(*) AS st_count
FROM meat_poultry_egg_inspect
GROUP BY st 
ORDER BY st; -- From the results we can see there are 3 cases where the state(st) is not given

-- TO INSPECT FURTHER USE MORE IDENTIFIERS TO FIND THE COMPANIES WITH MISSING VALUES st:
SELECT est_number,
		company,
		city,
		st,
		zip
FROM meat_poultry_egg_inspect
WHERE st IS NULL; -- Shows the three companies with missing values

-- CHECKING FOR INCONSISTENT DATA VALUES
-- We start checking for inconsistencies in the most likely columns, the company name column for mispellings
SELECT COMPANY, COUNT(*) AS COMPANY_COUNT
FROM meat_poultry_egg_inspect
GROUP BY COMPANY
ORDER BY COMPANY ASC; -- There are few companies that have multiple spelling variations e.g Armour - Eckrich Meats, LLC and AGRO Merchants Oakland LLC

-- Checking for Malformed Values Using length()
SELECT LENGTH(ZIP),
		COUNT(*) AS length_count
FROM meat_poultry_egg_inspect
GROUP BY LENGTH(ZIP)
ORDER BY LENGTH(ZIP) ASC; -- In the query results there a 86 zip code with value length of 3, 496 zips with lenght of 4 and 5705 with length of 5

-- TO INSPECT FURTHER STATES(ST) WITH LESS THAN 5 VALUES IN THEIR ZIP
SELECT ST,
        COUNT(*) AS st_count
FROM meat_poultry_egg_inspect
WHERE LENGTH(ZIP) < 5
GROUP BY ST
ORDER BY ST ASC;

-- UPDATING MISSING VALUES
-- When inspecting the table for missing values I discovered 3 rows had missing st and city values. To fill in those missing
-- Use the following statements

UPDATE meat_poultry_egg_inspect
SET st = 'MN'
WHERE est_number = 'V18677A';

UPDATE meat_poultry_egg_inspect
SET st = 'AL' , city = 'Chickasaw'
WHERE est_number = 'M45319+P45319';

UPDATE meat_poultry_egg_inspect
SET st = 'WI', city = 'Fort Atkinson'
WHERE est_number = 'M263A+P263A+V263A';

-- UPDATING VALUES FOR INCONSISTENCY
-- Earlier when inspecting the data I discovered that certain companies appeared multiple times with various mispellings

-- FIRST CREATE A BACKUP COLUMN FOR COMPANY
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN company_standard TYPE varchar(100);

-- COPY the values in the company column to company_standard:
UPDATE meat_poultry_egg_inspect
SET company_standard = company;

-- SET A STANDARD COMPANY NAME
UPDATE meat_poultry_egg_inspect
SET company_standard = 'Armour-Eckrich Meats'
WHERE company_standard LIKE 'Armour%';

UPDATE meat_poultry_egg_inspect
SET company_standard = 'AGRO Merchants Oakland LLC'
WHERE company_standard LIKE 'AGRO%';

-- INSPECT THAT THE CHANGES WERE SUCCESSFUL

SELECT company, company_standard
FROM meat_poultry_egg_inspect
WHERE company LIKE 'Armour%' OR company LIKE 'AGRO%';

-- REPAIRING ZIP CODE USING CONCATENATION
-- When inspecting the data in 'meat_poultry_egg_inspect' in the zip column using length(). We discovered that some zip codes 
-- in the column had a shorter lenght than the expected lenght of 5. To update this use the double-pipe string operator (||), 
-- which performs concatenation.

-- FIRST CREATE AN ADDITIONAL COLUMN AND COPY zip INTO THE NEW zip_copy COLUMN

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN zip_copy varchar(5);

-- COPY the values in the zip column into zip_copy column
UPDATE meat_poultry_egg_inspect
SET zip_copy = zip;

-- CHECK THE STATE(st) that have less than 5 values in their zip code
SELECT st, LENGTH(zip)
FROM meat_poultry_egg_inspect
GROUP BY st, LENGTH(zip)
HAVING LENGTH(zip) < 5
ORDER BY LENGTH(zip);

-- AMEND THE ZIP CODES WITH LESS THAN 5 VALUES BY PREFIXING ZEROS TO THEM
UPDATE meat_poultry_egg_inspect
SET zip = '00' || zip
WHERE st IN ('PR', 'VI') AND LENGTH(zip) = 3; -- FOR STATES THAT HAVE LENGTH(zip) = 3

UPDATE meat_poultry_egg_inspect
SET zip = '0' || zip
WHERE st IN('CT', 'MA', 'ME','NH', 'NJ', 'RI', 'VT') AND LENGTH(zip) = 4;

-- CHECK TO SEE ALL THE zip values all have 5 values 
SELECT LENGTH(zip), COUNT(*) AS zip_len_count
FROM meat_poultry_egg_inspect
GROUP BY LENGTH(zip)
ORDER BY LENGTH(zip) ASC;

-- UPDATING VALUES ACROSS TABLES
-- To have data in the table for inspection dates across regions. First create a new table called state_regions
-- with two columns states (st) and region. Then import the data for this table from local storage on the computer

CREATE TABLE state_regions(
    st varchar(2) CONSTRAINT st_key PRIMARY KEY,
    region varchar(50)
);

-- IMPORT THE DATA 
COPY state_regions
FROM '/Users/filelocation/state_regions.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',')

-- ADD A NEW COLUMN CALLED inspection_date IN meat_poultry_egg_inspect

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN inspection_date DATE;


UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-08-17'
WHERE EXISTS (
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
			AND state_regions.region = 'New England'
); -- Sets inspection dates for all states (st) in the New England region

UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-09-19'
WHERE EXISTS (
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
	AND state_regions.region = 'East North Central'
); -- Sets inspection dates for all states (st) in the East North Central region

UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-05-12'
WHERE EXISTS (
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
	AND state_regions.region = 'East South Central'
); -- Sets inspection dates for all states (st) in the East South Central region

UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-09-30'
WHERE EXISTS(
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
	AND state_regions.region = 'Mountain'
); -- Sets inspection dates for all states (st) in the Mountain region

UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-08-03'
WHERE EXISTS (
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
	AND state_regions.region = 'Middle Atlantic'
); -- Sets inspection dates for all states (st) in the Middle Atlantic region

UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-10-01'
WHERE EXISTS(
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
	AND state_regions.region = 'Outlying Area'
); -- Sets inspection dates for all states (st) in the Outlying Area region

UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-10-14'
WHERE EXISTS(
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
	AND state_regions.region = 'Pacific'
); -- Sets inspection dates for all states (st) in the Pacific region

UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-11-03'
WHERE EXISTS(
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
	AND state_regions.region = 'South Atlantic'
); -- Sets inspection dates for all states (st) in the South Atlantic region

UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-11-29'
WHERE EXISTS(
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
	AND state_regions.region = 'West South Central'
); -- Sets inspection dates for all states (st) in the West South Central region

UPDATE meat_poultry_egg_inspect AS inspect
SET inspection_date = '2020-11-29'
WHERE EXISTS(
	SELECT state_regions.region
	FROM state_regions
	WHERE inspect.st = state_regions.st
	AND state_regions.region = 'West North Central'
); -- Sets inspection dates for all states (st) in the West North Central region

-- TO INSPECT THAT ALL UPDATES WERE MADE
SELECT st,
		inspection_date
FROM meat_poultry_egg_inspect
GROUP BY st, inspection_date
ORDER BY inspection_date;

-- OR
SELECT est_number,
		company,
		st,
		city,
		zip,
		inspection_date
FROM meat_poultry_egg_inspect
GROUP BY est_number, company, st, city, zip, inspection_date
ORDER BY inspection_date NULLS FIRST;

-- CHECKING IF A PLANT IS A MEAT PROCESSING OR POULTRY PROCESSING PLANT OR BOTH FROM THE ACTIVITIES COLUMN
-- First create two columns named meat_processing and poultry_processing both with a boolean data type

START TRANSACTION;

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN meat_processing boolean;

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN poultry_processing boolean;

COMMIT;

-- UPDATE meat_processing column and set the value to 'TRUE' where 'Meat Processing' appears in the activities column
UPDATE meat_poultry_egg_inspect
SET meat_processing = 'TRUE'
WHERE activities LIKE '%Meat Processing' OR activities LIKE 'Meat Processing%';

-- UPDATE poultry_processing column and set the value to 'TRUE' where 'Poultry Processing' appears  in the activities column
UPDATE meat_poultry_egg_inspect
SET poultry_processing = 'TRUE'
WHERE activities LIKE '%Poultry Processing' OR activities LIKE 'Poultry Processing%';

-- COUNT HOW MANY PLANTS perform each type of activity and those that perform both
SELECT meat_processing, poultry_processing, COUNT(*) AS activity_count
FROM meat_poultry_egg_inspect
WHERE meat_processing = 'TRUE' OR poultry_processing = 'TRUE'
GROUP BY meat_processing, poultry_processing
ORDER BY activity_count;