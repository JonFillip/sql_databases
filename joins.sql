-- JOINING TABLES IN RELATIONAL DATABASE
-- The syntax for joining matching values from one table to another in a database during a database query is as follows:
SELECT *
FROM table_a JOIN table_b
ON table_a.key_column = table_b.foreign_key_column

-- Creating relational database tables. In the example table below I created two table; a department and employee table for an organisation
CREATE TABLE departments (
	dept_id bigserial,
	dept varchar(100),
	city varchar(50),
	CONSTRAINT dept_key PRIMARY KEY (dept_id),
	CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE employees(
	emp_id bigserial,
	first_name varchar(50),
	last_name varchar(50),
	salary integer,
	dept_id integer REFERENCES departments (dept_id),
	CONSTRAINT emp_key PRIMARY KEY (emp_id),
	CONSTRAINT emp_dept_unique UNIQUE (emp_id, dept_id)
);

-- TYPES OF JOINS
-- There are 5 different types of joins in SQL
-- JOIN/ INNER JOIN: Returns rows from both tables where matching values are found in the joined column of both tables. Alternate syntax is INNER JOIN.
SELECT *
FROM table_a INNER JOIN table_b
ON table_a.key_column = table_b.foreign_key_column;

-- LEFT JOIN: Returns every row from the left table plus rows that match values in the joined column from the right table. When a left table row
-- doesn't have any matching values in the right  table, the result shows no values from the right table
SELECT *
FROM table_a LEFT JOIN table_b
ON table_a.key_column = table_b.foreign_key_column;

-- RIGHT JOIN: Returns every row from the right table plus the rows that match values in the key values in the key column from the left table.
-- When a right table row doesn't have any matching values in the left table, the results shows no values from the left table.
SELECT *
FROM table_a RIGHT JOIN table_b
ON table_a.key_column = table_b.foreign_key_column;

-- FULL OUTER JOIN: Returns every row from both tables and matches rows; then joins the rows where values in the joined columns match.
-- If there's no matching values in either the left or right table, the query result contains an empty row for the other table.
SELECT *
FROM table_a FULL OUTER JOIN table_b
ON table_a.key_column = table_b.foreign_key_column;

-- CROSS JOIN: Returns every possible combinations of rows from both tables.

-- EXAMPLE: I created a two tables that contains a list of software and hardware companies.
CREATE TABLE software_companies(
	id integer CONSTRAINT software_id_key PRIMARY KEY,
	software_company varchar(30)
);

CREATE TABLE hardware_companies(
	id integer CONSTRAINT hardware_id_key PRIMARY KEY,
	hardware_company varchar(30)
);

-- Then insert the values into the tables:
INSERT INTO software_companies(id, software_company)
VALUES (1, 'Apple Inc'),
		(2, 'Google'),
		(5, 'Microsoft'),
		(6, 'Amazon');

INSERT INTO hardware_companies(id, hardware_company)
VALUES (1, 'Apple Inc'),
		(2, 'Google'),
		(3, 'Intel'),
		(4, 'AMD'),
		(5, 'Microsoft'),
		(6, 'Amazon');

-- JOIN/ INNER JOIN:
SELECT * 
FROM software_companies INNER JOIN hardware_companies
ON software_companies.id = hardware_companies.id;

-- LEFT JOIN 
SELECT *
FROM software_companies LEFT JOIN hardware_companies
ON software_companies.id = hardware_companies.id;

-- RIGHT JOIN
SELECT *
FROM software_companies RIGHT JOIN hardware_companies
ON software_companies.id = hardware_companies.id;

-- FULL OUTER JOIN
SELECT *
FROM software_companies FULL OUTER JOIN hardware_companies
ON software_companies.id = hardware_companies.id;

-- FILTERING THROUGH DATA
-- Using NULL to find rows with missing values
SELECT *
FROM software_companies RIGHT JOIN hardware_companies
ON software_companies.id = hardware_companies.id
WHERE software_companies.id IS NULL;

-- SELECTING SPECIFIC COLUMN IN A JOINT QUERY
SELECT table_a.key_column, table_a.key_column, table_b.foreign_key_column
FROM table_a LEFT JOIN table_b
ON table_a.key_column = table_b.foreign_key_column;

SELECT software_companies.id AS software_id, software_companies.software_company, hardware_companies.hardware_company
FROM software_companies LEFT JOIN hardware_companies
ON software_companies.id = hardware_companies.id;

-- SIMPLIFYING JOIN SYNTAX WITH TABLE ALIASES
SELECT ta.key_column, ta.key_column, tb.foreign_key_column
FROM table_a AS ta LEFT JOIN table_b AS tb -- Where ta and tb are the table aliases
ON ta.key_column = tb.foreign_key_column;

-- JOINING MULTIPLE TABLES
SELECT first_table.primary_key_column, first_table.key_column, sec_table.key_column, third_table.key_column
FROM first_table LEFT JOIN sec_table
ON first_table.primary_key_column = sec_table.key_column
LEFT JOIN third_table ON first_table.primary_key_column = third_table.key_column