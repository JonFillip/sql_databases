# Exploring the Census 2010 Counties Shapefile

This analysis consists of three shapefiles containing the following geospatial data:

- U.S. 2010 counties census information including each county's name as well as the
Federal Information Processing Standard (FIPS) codes uniquely assigned to each state and county.
The ``geom`` column contains the spatial data on each county's boundary

- The U.S waterlines and roadlines geospatial shapefiles that contains the geospatial data
for waterways and roads.

## Contents of Shapefile

Typically in a compressed archive, for example .zip, once unzipped one can access other
individual files in the folder. Per ArcGIS (the company that developed the shapefile)
documentation, these are the file extensions that are typically found in a shapefile:

- **_.shp_**  Main file that stores the feature geometry.

- **_.shx_**  Index file that stores the index of the feature geometry

- **_.dbf_**  Database table (in dBASE format) that stores the attribute information of features

- **_.xml_**  XML-format file that stores metadata about the shapefile

- **_.prj_**  Projection file that stores that coordinate system information.

## Data Sources
- US counties boundaries 2010
 - TIGER/Line® Shapefiles and TIGER/Line® Files
   https://www.census.gov/geo/maps-data/data/tiger-line.html
   Cartographic Boundary Shapefiles - Counties
   https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html

- Santa Fe Water and Roads 2016
 - https://www.census.gov/geo/maps-data/data/tiger-line.html
   https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2016&layergroup=Roads 
   https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2016&layergroup=Water

## Loading Shapefiles into the database (On MacOS)
To import a shapefile into a new table from the command line, use the following syntax:

```bash
shp2pgsql -I -s -W encoding shapefile_name table_name | psql -d database -U user
```