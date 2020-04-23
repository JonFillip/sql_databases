-- The data analyzed in this script is derived from the New York City Taxi and Limousine Commission
-- The purpose of the analysis is to discover patterns in the data with regards to time.

-- CREATE TABLE

START;

CREATE TABLE nyc_yellow_taxi_trips_2016_06_01(
	trip_id bigserial CONSTRAINT trip_id_key PRIMARY KEY,
	vendor_id varchar(1) NOT NULL,
	tpep_pickup_datetime TIMESTAMP WITH TIME ZONE NOT NULL,
	tpep_dropoff_datetime TIMESTAMP WITH TIME ZONE NOT NULL,
	passenger_count integer NOT NULL,
	trip_distance numeric(8,2) NOT NULL,
	pickup_longitude numeric(18,15) NOT NULL,
	pickup_latitude numeric(18,15) NOT NULL,
	rate_code_id varchar(2) NOT NULL,
	store_and_fwd_flag varchar(1) NOT NULL,
	dropoff_longitude numeric(18,15) NOT NULL,
	dropoff_latitude numeric(18,15) NOT NULL,
	payment_type varchar(1) NOT NULL,
	fare_amount numeric(9,2) NOT NULL,
	extra numeric(9,2) NOT NULL,
	mta_tax numeric(5,2) NOT NULL,
	tip_amount numeric(9,2) NOT NULL,
	tolls_amount numeric(9,2) NOT NULL,
	improvement_surcharge numeric(9,2) NOT NULL,
	total_amount numeric(9,2) NOT NULL
);

COPY nyc_yellow_taxi_trips_2016_06_01(
	vendor_id,
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	passenger_count,
	trip_distance,
	pickup_longitude,
	pickup_latitude,
	rate_code_id,
	store_and_fwd_flag,
	dropoff_longitude,
	dropoff_latitude,
	payment_type,
	fare_amount,
	extra,
	mta_tax,
	tip_amount,
	tolls_amount,
	improvement_surcharge,
	total_amount
)
FROM '/Users/johnphillip/Desktop/postgresql_database/nyc_taxi_commute/yellow_tripdata_2016_06_01.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

CREATE INDEX tpep_pickup_idx
ON nyc_yellow_taxi_trips_2016_06_01(tpep_pickup_datetime);

COMMIT;

-- COUNT THE NUMBER OF ROWS AND VALUES IN THE TABLE
SELECT COUNT(*) FROM nyc_yellow_taxi_trips_2016_06_01;

-- SET THE TIME ZONE
SET timezone TO 'US/Eastern';

-- Finding the Busiest Time of Day
SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour,
        COUNT(*)
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY  trip_hour
ORDER BY trip_hour;

-- Exporting to CSV for Visualization in Google Sheet / Excel
COPY (SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour,
            COUNT(*)
    FROM nyc_yellow_taxi_trips_2016_06_01
    GROUP BY trip_hour
    ORDER BY trip_hour)
TO '/Users/johnphillip/nyc_cabs_hourly_pickups_2016_06_01.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

-- When do trips take the longest
SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour,
        percentile_cont(.5) WITHIN GROUP (ORDER BY tpep_dropoff_datetime - tpep_pickup_datetime) AS median_trip
FROM nyc_yellow_taxi_trips_2016_06_01
GROUP BY trip_hour
ORDER BY trip_hour;

-- Calculating the duration for each trip
SELECT *,
		to_char(tpep_pickup_datetime, 'YYYY-MM-DD HH12:MI a.m TZ') AS pickup_time,
		trip_distance,
		tpep_dropoff_datetime - tpep_pickup_datetime AS segment_time
FROM nyc_yellow_taxi_trips_2016_06_01
ORDER BY segment_time DESC;

-- Finding the correlation efficient and causality (r-squared)
-- First I added a new column called trip_time (TYPE interval) which will hold the values for the amount of time each trip took
ALTER TABLE nyc_yellow_taxi_trips_2016_06_01 ADD COLUMN trip_time interval;

-- UPDATE the trip_column and SET the trip times
UPDATE nyc_yellow_taxi_trips_2016_06_01
SET trip_time = tpep_dropoff_datetime - tpep_pickup_datetime;

SELECT ROUND(CORR(trip_time, total_amount)::numeric, 2) AS time_cost_corr,
		ROUND(regr_r2(trip_time, total_amount)::numeric, 3) AS distance_cost_r_squared
FROM nyc_yellow_taxi_trips_2016_06_01
WHERE trip_time <= '3 hours'::interval;-- N/A


SELECT ROUND(CORR(trip_distance, total_amount)::numeric, 2) AS distance_cost_corr,
        ROUND(regr_r2(trip_distance, total_amount)::numeric, 3) AS distance_cost_r_squared
FROM nyc_yellow_taxi_trips_2016_06_01; -- Returns the correlation coefficient and causality between the distance of a trip and cost of the trip
-- The correlation between trip distance and the cost indicates strong direct positve correlation of 0.86
-- The causality(r_squared) the cost of a trip is driven by the distance 

-- Finding trips that lasted less than 3 hours
SELECT *
FROM nyc_yellow_taxi_trips_2016_06_01
WHERE trip_time <= '3 hours'::interval;


-- Finding Patterns in Amtrak Data
-- Calculating the Duration of Trains Trips

START TRANSACTION;

SET TIMEZONE TO 'US/Central';

CREATE TABLE train_rides (
    trip_id bigserial CONSTRAINT trid_id_key PRIMARY KEY,
    segment varchar(50) NOT NULL,
    departure TIMESTAMP WITH TIME ZONE NOT NULL,
    arrival TIMESTAMP WITH TIME ZONE NOT NULL
);

INSERT INTO train_rides (segment, departure, arrival)
VALUES ('CHICAGO TO NEW YORK', '2020-11-13 21:30 CST', '2020-11-14 18:23 EST'),
        ('NEW YORK TO NEW ORLEANS', '2020-11-15 14:15 EST', '2020-11-16 19:32 CST'),
    ('NEW ORLEANS TO LOS ANGELES', '2020-11-17 13:45 CST', '2020-11-18 9:00 PST'),
    ('LOS ANGELES TO SAN FRANCISCO', '2020-11-19 10:10 PST', '2020-11-19 21:24 PST'),
    ('SAN FRANCISCO TO DENVER', '2020-11-20 9:10 PST', '2020-11-21 18:38 MST'),
    ('DENVER TO CHICAGO', '2020-11-22 19:10 MST', '2020-11-23 14:50 CST');

COMMIT;

SELECT segment,
		to_char(departure, 'YYYY-MM-DD HH12:MI a.m TZ') AS departure,
		arrival - departure AS segment_time
FROM train_rides; -- Returns the segment time for each trip

-- Cumilative Trip Time
SELECT segment,
        arrival - departure AS segment_time,
        SUM(arrival - departure) OVER (ORDER BY trip_id) AS cume_time
FROM train_rides; -- Results are accurate but format is unhelpful

SELECT segment,
        arrival - departure AS segment_time,
        SUM(date_part('epoch', (arrival - departure))) OVER (ORDER BY trip_id) * INTERVAL '1 second' AS cume_time
FROM train_rides;