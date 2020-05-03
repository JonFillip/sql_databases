-- CREATE TABLE FOR FARMERS MARKET

CREATE TABLE farmers_market(
    market_id BIGSERIAL PRIMARY KEY,
    market_name VARCHAR(100) NOT NULL,
    street VARCHAR(200),
    city VARCHAR(50),
    county VARCHAR(30),
    st VARCHAR(30) NOT NULL,
    zip VARCHAR(10),
    longitude NUMERIC(10,7),
    latitude NUMERIC(10,7),
    organic VARCHAR(1) NOT NULL
);

-- IMPORT DATA TO TABLE
COPY farmers_market
FROM '/Users/username/filelocation/farmers_market.csv'
WITH (FORMAT CSV, HEADER);

-- CREATE A GEOGRAGHY COLUMN 
-- Convert the market's longitude and latitude into a single column of a spatail data type. 
-- Because the area I'm working with is large (the whole U.S.) convert to geography data type.

ALTER TABLE farmers_market ADD COLUMN geog_point GEOGRAGHY(POINT, 4326);

UPDATE farmers_market
SET geog_point = ST_SetSRID(
    ST_MakePoint(longitude, latitude), 4326 -- Takes the longitude and latitude as inputs from the table and the SRID 4326 as the second arguement
)::geography;  -- cast the output from geometry data type by default to geography

CREATE INDEX market_geop_idx ON farmers_market USING GIST(geog_point);

SELECT longitude,
        latitude,
        geog_point,
        ST_AsText(geog_point)
FROM farmers_market
WHERE longitude IS NOT NULL; -- If you're using a GUI like PGAdmin, from the results click on the eye icon in the geog_point column to see a geographical 
-- visualization of the geographical point on the world map.

-- FINDING MARKETS WITHIN A GIVEN DISTANCE USING ST_DWithin() function
-- In the statement below, I want to find markets within 25000 meters (25km) from 18th Street Farmer's Market, Scottsbluff, Nebraska
-- The coordinates -103.662538, 41.864268 longitude and latitude
SELECT market_name,
        city,
        st
FROM farmers_market
WHERE ST_DWithin(
    geog_point,
    ST_GeogFromText('POINT(-103.662538 41.864268)'),
    25000
)
ORDER BY market_name;

-- FINDING THE DISTANCE BETWEEN GEOGRAPHIES USING ST_Distance() FUNCTION
-- Here we find the distance between Pickens County Farmers Market and GEORGIANA FARMERS MARKET both are markets in Albama
SELECT ST_Distance(
    ST_GeogFromText('POINT(-86.7428000 31.6396000)'),
    ST_GeogFromText('POINT(-88.0937970 33.2755340)')
) / 1609.344 AS distance_btw_distinations -- The result is returned in miles after dividing the output of ST_Distance() by 1609.344(The number of meters in a mile)
-- distance_btw_distinations = 137.60803719211057 miles

SELECT market_name,
        city,
        ROUND(
            (
                ST_Distance(
                    geog_point,
                    ST_GeogFromText('POINT(-86.7428000 31.6396000)')
                ) / 1609.344
            )::NUMERIC(8,2),2
        ) AS miles_from_distination
FROM farmers_market
WITH ST_DWithin(
    geog_point,
    ST_GeogFromText('POINT(-86.7428000 31.6396000)'),
    25000
)
ORDER BY miles_from_distination ASC;