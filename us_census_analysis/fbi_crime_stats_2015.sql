-- Calculating Rates For Meaningful Comparisons
-- The data used in this analysis is derived from the FBI crime statistics 2015
-- Purpose of work: Determine crime rates across different cities in the USA per 1000 persons. 
-- The formula for finding rate is dividing the number of offences by the population and then multiply the quotient by 1000

START TRANSACTION;

CREATE TABLE fbi_crime_data_2015(
	st varchar(20),
	city varchar(50),
	population integer,
	violent_crime integer,
	property_crime integer,
	burglary integer,
	larceny_theft integer,
	motor_vehicle_theft integer,
	CONSTRAINT st_city_key PRIMARY KEY (st, city)
);

COPY fbi_crime_data_2015
FROM '/Users/johnphillip/Desktop/fbi_crime_data_2015.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

SELECT * FROM fbi_crime_data_2015
ORDER BY population DESC;

COMMIT;

-- FINDING THE RATE OF PROPERTY CRIME IN STATES WITH POP. OF 500000 ABOVE
SELECT city,
		st,
		population,
		property_crime,
		ROUND((property_crime::numeric / population) * 1000, 1) AS pc_per_1000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY (property_crime::numeric / population) DESC;

-- FINDING THE RATE OF MOTOR VEHICLE THEFT IN STATES WITH POP. OF 500000 ABOVE
SELECT city,
        st,
        population,
        motor_vehicle_theft,
        ROUND((motor_vehicle_theft::numeric / population) * 1000, 1) mct_per_1000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY mct_per_1000 DESC;

-- FINDING THE RATE OF VIOLENT CRIME IN STATES WITH POP. OF 500000 ABOVE
SELECT city,
        st,
        population,
        violent_crime,
        ROUND((violent_crime::numeric / population) * 1000, 1) vc_per_1000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY vc_per_1000 DESC;