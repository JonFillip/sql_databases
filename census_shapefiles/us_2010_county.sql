-- In us_counties_2010_shp table contains columns that include the names of the counties, coordinates 
-- boundaries geometry, Federal Information Processing Standards (FIPS) codes uniquely assigned to each state 
-- and county. The 'geom' column contains the spatial data on each county's boundary.

-- USING ST_AsText FUNCTION TO INVESTIGATE THE CONTENT OF THE geom COLUMN
-- Using the ST_AsText function shows the Well Known Text (WKT) representation of the geom values in the table

SELECT ST_AsText(geom)
FROM us_counties_2010_shp
LIMIT 1; -- Limits the returned row to 1 or the first row

-- Finding the largest Counties by Square Miles using ST_Area() Function

SELECT name10,
        statefp10 AS st,
        ROUND(
            (ST_Area(geom::geography) / 2589988.110336)::numeric, 2
        ) AS landmass_per_squaremiles
FROM us_counties_2010_shp
ORDER BY landmass_per_squaremiles DESC;

-- Finding a County by Longitude and Latitude

SELECT name10,
        statefp10 AS st
FROM us_counties_2010_shp
WHERE ST_Within('SRID=4269;POINT(-77.2990252 38.8531833)'::geometry, geom);  -- Returns FairFax, State 51 (Virginia)


-- PERFORMING SPATIAL JOINS

-- Here I joined the tables from the Santa Fe Water ways and Road lines 
-- Santa Fe is a city in New Mexico, U.S.A. In this analysis I explored the Santa Fe River and Road lines from the a 
-- 2016 dataset http://www.santafenm.gov/santa_fe_river

-- RTTYP - Route Type Code Description
-- https://www.census.gov/geo/reference/rttyp.html
-- C County
-- I Interstate
-- M Common Name
-- O Other
-- S State recognized
-- U U.S.

-- MTFCC MAF/TIGER feature class code
-- https://www.census.gov/geo/reference/mtfcc.html
-- Here, H3010: A natural flowing waterway

-- Using ST_GeometryType() to Determine Geometry

SELECT ST_GeometryType(geom)
FROM santafe_linearwater_2016;

SELECT ST_GeometryType(geom)
FROM santafe_roads_2016;

-- Joining the Census Roads and Water Tables with ST_Intersects() to Find Roads crossing the Santa Fe River

SELECT water.fullname AS waterway,
        roads.rttyp,
        roads.fullname AS road
FROM santafe_linearwater_2016 AS water JOIN santafe_roads_2016 AS roads
    ON ST_Intersects(water.geom, roads.geom)
WHERE water.fullname = 'Santa Fe Riv'
ORDER BY roads.fullname;

-- Finding the Location Where Objects Intersect
SELECT water.fullname AS waterway,
        roads.rttyp,
        roads.fullname AS road,
		ST_AsText(ST_Intersection(water.geom, roads.geom))
FROM santafe_linearwater_2016 AS water JOIN santafe_roads_2016 AS roads
    ON ST_Intersects(water.geom, roads.geom)
WHERE water.fullname = 'Santa Fe Riv'
ORDER BY roads.fullname;