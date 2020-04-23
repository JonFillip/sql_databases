-- RENAME DATABASE
ALTER DATABASE db RENAME TO new_db;

-- RENAMING A TABLE
ALTER TABLE IF EXISTS table_name
RENAME TO new_table_name;

-- TO ADD NEW COLUMN
ALTER TABLE table_name ADD COLUMN column_name TYPE datatype;

-- CHANGE A COLUMN'S DATA TYPE
ALTER TABLE table_name ALTER COLUMN column_name SET DATA TYPE data_type;

-- DROP A COLUMN
ALTER TABLE table_name DROP COLUMN column_name;

-- REMOVING CONSTRAINTS OR ADDING THEM LATER
-- To remove a primary key, foreign key, a UNIQUE or a NOT NULL constraint, one would have write an ALTER TABLE statement in this format:
ALTER TABLE table_name DROP CONSTRAINT constraint_name;
-- To add a primary key, foreign key, or a UNIQUE constraint, one would have write an ALTER TABLE statement in this format:
ALTER TABLE table_name ADD CONSTRAINT constraint_name PRIMARY KEY (column_name)
-- To drop a NOT NULL constraint, the statement operates on the column, so you must use the additional ALTER COLUMN keywords:
ALTER TABLE table_name ALTER COLUMN column_name DROP NOT NULL;
-- To add a NOT NULL constraint, the statement operates on the column, so you must use the additional ALTER COLUMN keywords:
ALTER TABLE table_name ALTER COLUMN column_name SET NOT NULL;

-- MODIFYING VALUES WITH UPDATE
-- UPDATE allows one to update the data in a column in all rows or a subset of rows that meet a particular condition.
UPDATE table_name
SET column_name = value;

-- TO UPDATE MULTIPLE COLUMNS
UPDATE table_name
SET column_name = value,
    column_name_2 = value;

-- TO UPDATE COLUMN(S) WITH WHERE
UPDATE table_name
SET column_name = value
WHERE criteria;

-- TO UPDATE A TABLE WITH VALUES FROM ANOTHER TABLE
UPDATE table_name
SET COLUMN_NAME = (SELECT column_name
            FROM table_b
            WHERE table_name.column_name = table_b.column_name)
WHERE EXISTS (SELECT column_name_b
            FROM table_b
            WHERE table_name.column_name = table_b.column_name);

-- OR 
UPDATE table_name
SET column_name = table_b.column_name
FROM table_b
WHERE table_name.column_name = table_b.column_name;

-- CREATING BACKUP TABLE
CREATE TABLE table_backup AS SELECT * FROM table_original;

-- RESTORING ORIGINAL VALUES
UPDATE table_name_original
SET column_edited = column_copy
WHERE criteria; -- RESTORING ORIGINAL VALUES IN A COLUMN

