# USING POSTGRESQL POSTGIS FUNCTIONS TO ANALYZE GEOSPATIAL DATA

This analysis explores Farmers market to know the geographies of these markets

  The National Farmer's Markets Directory from the U.S. Department of Agriculture catalogs
the locations and offerings of more than of more than 8000 markets that feature two or more
farm vendors selling agriculture products directly to customers at a common, recurrent 
physical location. The data can be downloaded from [USDA](https://www.ams.usda.gov/local-food-directories/farmersmarkets/).


To activate POSTGIS, first create a database that you wish to work with:
```sql
CREATE DATABASE gis_analysis;
```

Then activate the postgis extension
```sql
CREATE EXTENSION postgis;
```

On enabling POSTGIS, it automatically creates a table called 'spatial_ref_sys'
this table contains the Spatial Reference System Identifier (SRID) which will
be used to specify the coordinates system to use in the project. In this project
SRID 4326 is used, the ID for the geographic coordinate system (GCS) 
World Geographic System (WGS) 84 which is the current standard using by GPS.
```sql
SELECT srtext
FROM spatial_ref_sys
WHERE srid = 4326;
```