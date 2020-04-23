-- When creating a database there are key rules a database developer must follow in order 
-- to create a well designed database that is intuitive and easy to relate and query key data points.
-- When creating a database one must be knowledgeable of the following practices:
-- 1. Naming scheme: It is in best practice to name tables and columns using the snake case naming scheme e.g: customer_orders.
-- 2. Also in naming tables and columns it is always recommended to name a table in plural form.
-- 3. When making copies of tables, use names that will help find them later: Best practice is to attach a date to new copy of a table.

-- Controlling Column Values With CONSTRAINTS
--  CONSTRAINTS allows the designer to specify acceptables values for a column based on rules and logical tests. And it helps in 
-- maintaining data quality and ensure integrity of the relationships among the tables.
-- N.B; Constraints can only to be declared at the beginning when creating a table

-- TYPES OF CONSTRAINTS USED
-- 1. PRIMARY KEY: Specifys the main identiying column(s) values that are unique to each row in a table.
-- 2. FOREIGN KEY: 
-- 3. CHECK: Evaluates whether the data falls within values we specify
-- 4. UNIQUE: Ensures that values in a column or group of columns are unique in each row in the table.
-- 5. NOT NULL: Prevents NULL values in a column

-- We can add constraints in two ways:
-- COLUMN CONSTRAINTS: The constraints apply only to that column. For exmaple:
CREATE TABLE column_constraints (
    column_item serial CONSTRAINT column_key PRIMARY KEY, -- This primary key column is a surrogate key
    row_item VARCHAR(10)
);

-- TABLE CONSTRAINTS: This constraint is declared after the declaring the last column has been stated. And is used
-- when one needs to declare more than one column in a constraint condition. Also the column(s) must be declared in a parentheses(). The syntax is written as such:
CREATE TABLE table_constraints (
    table_id VARCHAR(6),
    first_column VARCHAR(20),
    second_column VARCHAR (20)
    CONSTRAINT key_name PRIMARY KEY (table_id, first_column) -- Two columns are declared in the constraint ()
);

-- PRIMARY KEYS: Natural vs Surrogate
-- Primary key is a column or group of columns whose values uniquely identity each row in a table. A primary key constraint
-- provides a means of relating tables to each other maintaining REFERENTIAL INTEGRITY and it imposes two rules on the column(s) that make up the key:
-- 1. Each column in the key must have a unique value in each row.
-- 2. No column in the key can have missing values


-- TYPES OF CONSTRAINTS USED
-- 1. PRIMARY KEY: Specifys the main identiying column(s) values that are unique to each row in a table.
-- 2. FOREIGN KEY: 
-- 3. CHECK: Evaluates whether the data falls within values we specify
-- 4. UNIQUE: Ensures that values in a column or group of columns are unique in each row in the table.
-- 5. NOT NULL: Prevents NULL values in a column

-- We can add constraints in two ways:
-- COLUMN CONSTRAINTS: The constraints apply only to that column. For exmaple:
CREATE TABLE column_constraints (
    column_item serial CONSTRAINT column_key PRIMARY KEY, -- This primary key column is a surrogate key
    row_item VARCHAR(10)
);

-- TABLE CONSTRAINTS: This constraint is declared after the declaring the last column has been stated. And is used
-- when one needs to declare more than one column in a constraint condition. Also the column(s) must be declared in a parentheses(). The syntax is written as such:
CREATE TABLE table_constraints (
    table_id VARCHAR(6),
    first_column VARCHAR(20),
    second_column VARCHAR (20),
    CONSTRAINT key_name PRIMARY KEY (table_id, first_column) -- Two columns are declared in the constraint (), AKA composite primary key as a natural key
);

-- PRIMARY KEYS: Natural vs Surrogate
-- Primary key is a column or group of columns whose values uniquely identity each row in a table. A primary key constraint
-- provides a means of relating tables to each other maintaining REFERENTIAL INTEGRITY and it imposes two rules on the column(s) that make up the key:
-- 1. Each column in the key must have a unique value in each row.
-- 2. No column in the key can have missing values

-- NATURAL KEYS: These are implemented by using one or more already existing columns in a table rather than creating
-- a column and filling it artificial values. For example:
CREATE TABLE natural_key_composite_example (
    student_id varchar(10),
    school_day date,
    present boolean,
    CONSTRAINT student_key PRIMARY KEY (student_id, school_day) -- This is an example of a composite primary key
);

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/22/2017', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/23/2017', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/23/2017', 'N'); -- This will result in an error because the primary key already exists in the table

-- SURROGATE KEYS: This key typically consists of a single column that is filled with artificial values. Which can be
-- sequential number auto-generated by the database e.g Auto-Increment Integers or a Universally Unique Identifier (UUID)
-- which is a code comprised of 32 hexadecimal. Surrogate Key syntax looks like this:
CREATE TABLE earthquakes (
    event_id bigserial,
	event_location varchar(50),
	time_occured timestamptz,
	duration interval,
	magnitude numeric(3,2),
    CONSTRAINT eq_id PRIMARY KEY (event_id)
);
INSERT INTO earthquakes (event_location, magnitude, time_occured, duration)
VALUES ('11km NNE of North Nenana, Alaska', 1.2, '2020-01-30 23:00 UTC', '5 hours'),
		('69km NNW of Ayna, Peru', 4.3, '2020-01-30 15:00 UTC ', '5 days'),
		('3km SSE of Belden, CA', 3.08, '2019-12-31 02:00 PST', '16 days'),
		('18km SSE of Honokaa, Hawaii', 2.23, '2020-02-01 06:00 PST', '1 week');

SELECT * FROM earthquakes;

-- FOREIGN KEY: A foreign key is one or more columns in a table that match the primary key of another table.
-- Foreign key constraints allows SQL to provide a way to ensure data in related tables doesn't end up unrelated or orphaned
-- It also imposes a constraint: Values entered must already exists in the primary key or unique key of the table it references.
-- If not, the value is rejected. Foreign Key Syntax looks like this:
CREATE TABLE licenses (
    license_id varchar(10),
    first_name varchar(50),
    last_name varchar(50),
    CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

CREATE TABLE registrations (
    registration_id varchar(10),
    registration_date date,
    license_id varchar(10) REFERENCES licenses (license_id) ON DELETE CASCADE, -- AUTOMATICALLY DELETING RALATED RECORDS WITH 'CASCADE'
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '3/17/2017', 'T229901');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A75772', '3/17/2017', 'T000001');

-- AUTOMATICALLY DELETING RALATED RECORDS WITH 'CASCADE'
-- To automatically delete a row in the a group of relating table for example licenses and have that action automatically delete
-- any related rows in other columns in this case the registration table, we can specify that behavior by adding ON DELETE CASCADE
-- when defining the foreign  key constraint

-- The CHECK Constraint: This constraint evaluates whether data added to a column meets the expected criteria, which is specified with
-- a logical test. If the criteria aren't met the database will throw an error. CHECK constraint can be implemeted as a columm or table constraint.
-- To use the CHECK constraint as a column constraint. Use the folliwing syntax: CONSTRAINT constraint_name CHECK (logical_expression)

CREATE TABLE column_name (
    column_id bigserial,
    first_column VARCHAR(20),
    second_column INTEGER,
    CONSTRAINT column_id_key PRIMARY KEY (column_id),
    CONSTRAINT check_first_column CHECK (first_column IN ('Item1', 'Item2')), -- tests wether value entered match one of the two predefined strings Item1 or Item2
    CONSTRAINT check_sec_column CHECK (second_column > 0) -- tests wether the value entered is more than zero
);

-- UNIQUE CONSTRAINT: The UNIQUE constraint is very much like the PRIMARY KEY constraint with one important difference in that 
-- the UNIQUE constraint allows for multiple missing values (NULL) in a column. Here is a syntax example:
CREATE TABLE unique_constraint_example (
    contact_id bigserial,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(200),
    CONSTRAINT contact_id_key PRIMARY KEY (contact_id),
    CONSTRAINT email_unique UNIQUE (email) -- Indicates that contact must have a unique email address
);

INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES ('Samantha', 'Lee', 'slee@example.org');

INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES ('Betty', 'Diaz', 'bdiaz@example.org');

INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES ('Sasha', 'Lee', 'slee@example.org');

-- THE NOT NULL CONSTRAINT: This constraint prevents a column from accepting empty values. To specify a NOT NULL constraint
-- use the following syntax:
CREATE TABLE not_null_example (
    student_id bigserial,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    CONSTRAINT student_id_key PRIMARY KEY (student_id)
);

-- REMOVING CONSTRAINTS OR ADDING THEM LATER
-- To remove a primary key, foreign key, a UNIQUE or a NOT NULL constraint, one would have write an ALTER TABLE statement in this format:
ALTER TABLE table_name DROP CONSTRAINT constraint_name;
-- To add a primary key, foreign key, or a UNIQUE constraint, one would have write an ALTER TABLE statement in this format:
ALTER TABLE table_name ADD CONSTRAINT constraint_name PRIMARY KEY (column_name)
-- To drop a NOT NULL constraint, the statement operates on the column, so you must use the additional ALTER COLUMN keywords:
ALTER TABLE table_name ALTER COLUMN column_name DROP NOT NULL;
-- To add a NOT NULL constraint, the statement operates on the column, so you must use the additional ALTER COLUMN keywords:
ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL;