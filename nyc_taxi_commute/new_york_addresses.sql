-- Create Table for Data set.
CREATE TABLE new_york_addresses (
	longitude numeric(9,6),
	latitude numeric(9,6),
	street_number varchar(10),
	street varchar(40),
	unit varchar(10),
	postcode varchar(5),
	address_id bigserial CONSTRAINT address_key PRIMARY KEY
);

-- IMPORT TABLE 
COPY new_york_addresses
FROM '/Users/johnphillip/Desktop/new_york_addresses.csv'
WITH (FORMAT CSV, HEADER);

-- QUERY INDEX
EXPLAIN ANALYZE SELECT * FROM table_name
WHERE column_name = condition;

-- ADDING THE INDEX
CREATE INDEX index_name ON table_name (column_name);