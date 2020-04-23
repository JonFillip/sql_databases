-- Date & Time Data Types 
-- 1. date/DATE : Format; YYYY-MM-DD
-- 2. time/ TIME: Format; HH:MM:SS
-- 3. timestamp/timestamptz/timestamp with time zone: Format; YYYY-MM-DD HH:MM:SS TZ
-- 4. interval: keyword - quantity unit

-- EXTRACTING THE COMPONENTS OF A TIMESTAMP VALUE
-- Syntax:
SELECT date_part('text', value);
-- The 1st part of the statement is a string format that represents the part of the date or time to extract
-- such as hour, minute or week.
-- The 2nd part of the statement is the date, time or timestamp value

SELECT date_part('year', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "year",
        date_part('month', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "month",
        date_part('day', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "day",
        date_part('hour', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "hour",
        date_part('minute', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "minute",
        date_part('seconds', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "seconds",
        date_part('timezone_hour', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "time zone",
        date_part('week', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "week",
        date_part('quarter', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "quarter",
        date_part('epoch', '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "epoch";

-- Alternative Syntax for extracting date values
SELECT extract('text' from value);

SELECT extract('year' from'2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "year",
        extract('month' from '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "month",
        extract('day' from '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "day",
        extract('hour' from '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "hour",
        extract('minute' from '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "minute",
        extract('seconds' from '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "seconds",
        extract('timezone_hour' from '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "time zone",
        extract('week' from '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "week",
        extract('quarter' from '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "quarter",
        extract('epoch' from '2020-04-11 15:05:54 UTC+3:00'::timestamptz) AS "epoch";

-- CREATING DATETIMES VALUES FROM TIMESTAMP COMPONENTS
SELECT make_date(year, month, day); --Returns a value of type date

SELECT make_time(hour, minute, seconds); -- Returns a value of type time without time zone

SELECT make_timestamptz(year, month, day, hour, minute, second, time zone); -- Returns a timestamp with the time zone

-- Example:
SELECT make_date(1997, 10, 14);
SELECT make_time(22, 14, 52);
SELECT make_timestamptz(1997, 10, 14, 22, 14, 52, 'Africa/Lagos');

-- RETRIEVING THE CURRENT DATE AND TIME
CURRENT_DATE -- Returns the date

CURRENT_TIME -- Returns the current time with time zone

CURRENT_TIMESTAMP -- Returns the current timestamp with time zone. PostgreSQL specific version is now()

localtime -- Returns the current time without time zone.

localtimestamp -- Returns the current timestamp without the time zone

CLOCK_TIMESTAMP -- Returns the specific time an operation took place as it elapses.

-- Example:
CREATE TABLE current_time_example (
    time_id bigserial,
    current_timestamp_col TIMESTAMP WITH TIME ZONE,
    clock_timestamp_col TIMESTAMP WITH TIME ZONE
);

INSERT INTO current_time_example (current_timestamp_col, clock_timestamp_col)
(SELECT CURRENT_TIMESTAMP, CLOCK_TIMESTAMP() FROM generate_series(1,1000));

SELECT * FROM current_time_example;

-- FINDING YOUR TIME ZONE SETTING ON POSTGRESQL
SHOW timezone; -- To find the default time zone of your PostgreSQL server

SELECT * FROM pg_timezone_abbrevs; -- Returns all timezone abbreviations and their UTC offsets
SELECT * FROM pg_timezone_names; -- Returns all the names, abbreviations and their UTC offsets

-- SETTING A TIME ZONE
-- To set the timezone in the postgreSQL server use the following command:
SET TIMEZONE TO 'US/PACIFIC';

CREATE TABLE test_time_zone (
    test_date TIMESTAMP WITH TIME ZONE
);

INSERT INTO time_zone_test VALUES ('2020-04-11 16:00');

SELECT test_date FROM time_zone_test;

SET timezone TO 'US/Eastern';

SELECT test_date FROM test_time_zone;

SELECT test_date AT TIME ZONE 'Asia/Tokyo'
FROM test_time_zone;

-- CALCULATING WITH DATES AND TIMES
SELECT '9/30/2020'::DATE - '1/01/2020'::DATE; -- RETURNS THE NUMBER OF DAYS BETWEEN THE TWO DATES

SELECT '9/30/2020'::DATE + '5 years'::interval; -- Add 5 years to the first data

-- USING AT TIME ZONE TO FIND DATES 

SET TIMEZONE TO 'US/Eastern';

CREATE TABLE test_time_zone (
    test_date TIMESTAMP WITH TIME ZONE
);

INSERT INTO test_time_zone VALUES ('2100-01-01 00:00'); -- Set the timestamp in New York to first day of the year 2100

-- Find the time in London, Johannesburg, Moscow and Melbourne
SELECT test_date AT TIME ZONE 'Europe/London'
FROM test_time_zone; -- Returns the timestamp in London when its the first day of the year 2100 in NYC; 2100-01-01 05:00:00

SELECT test_date AT TIME ZONE 'Africa/Johannesburg'
FROM test_time_zone; -- Returns the timestamp in Johannesburg when its the first day of the year 2100 in NYC; 2100-01-01 07:00:00

SELECT test_date AT TIME ZONE 'Europe/Moscow'
FROM test_time_zone; -- Returns the timestamp in Moscow when its the first day of the day of the year 2100 in NYC; 2100-01-01 08:00:00

SELECT test_date AT TIME ZONE 'Australia/Melbourne'
FROM test_time_zone; -- Returns the timestamp in Melbourne when its the first day of the year 2100 NYC; 2100-01-01 16:00:00 


