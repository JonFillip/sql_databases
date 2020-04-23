-- INSPECTING AND MODIFYING DATA
-- DATA TITLE: FOOD SATETY ON MEAT, POULTRY AND EGG PRODUCERS IN THE USA
-- DATA SOURCE: The survey on food safety is conducted by the Food Safety and Inspection Service (FSIS) 
-- The FSIS is responsible for inspecting animals and food produce across meat processing plants 
-- across the US. Website: https://www.fsis.usda.gov
-- DATA SOURCE URL: https://catalog.data.gov/dataset/fsis-meat-poultry-and-egg-inspection-directory-by-establishment-name

-- CREATE TABLE AND IMPORT DATASET
CREATE TABLE fsis_meat_poultry_inspect_feb_2020 (
    est_number varchar(50) CONSTRAINT est_number_key PRIMARY KEY,
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

-- IMPORT THE DATASET
COPY fsis_meat_poultry_inspect_feb_2020
FROM '/Users/johnphillip/Desktop/postgresql_database/MPI_Directory_by_Establishment_Names.csv'
WITH (FORMAT CSV, HEADER);

-- CREATE INDEX FOR company
CREATE INDEX company_idx ON fsis_meat_poultry_inspect_feb_2020(company);

-- INSPECTING DATA SET (CHECKING FOR DUPLICATE VALUES)
-- The following statement helps to find companies that might have a duplicate address in the same location.
SELECT company,
		street,
		city,
		st,
		COUNT(*) AS address_count
FROM fsis_meat_poultry_inspect_feb_2020
GROUP BY company, street, city, st
HAVING count(*) > 1 -- Filters for companies that may have the same combination of values more than once in the table
ORDER BY company, street, city, st; -- The result shows 35 cases where comapnies have the same combination of values
-- as their address multiple times

-- CHECKING FOR MISSING VALUES
SELECT st, COUNT(*) AS st_count
FROM fsis_meat_poultry_inspect_feb_2020
GROUP BY st 
ORDER BY st; -- From the results there no states(st) with missing values/ NULL values

SELECT city, count(*) AS city_count
FROM fsis_meat_poultry_inspect_feb_2020
GROUP BY city
ORDER BY city ; -- From the results we know we have no NULL values in the city column


-- CHECKING FOR INCONSISTENT DATA VALUES
-- We start checking for inconsistencies in the most likely columns, the company name column for mispellings
SELECT COMPANY, COUNT(*) AS COMPANY_COUNT
FROM fsis_meat_poultry_inspect_feb_2020
GROUP BY COMPANY
ORDER BY COMPANY ASC; -- Visualizing scanning through the query result two companies already display potential inconsistencies.


-- Checking for Malformed Values Using length()
SELECT LENGTH(ZIP),
		COUNT(*) AS length_count
FROM fsis_meat_poultry_inspect_feb_2020
GROUP BY LENGTH(ZIP)
ORDER BY LENGTH(ZIP) ASC;  -- All values have a lenght of 5 characters

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
