-- The table contains data derived from the U.S. Census Bureau from its 2011 - 2015 American Community Service (ACS)
-- 5 year estimates. The aim of analysing this data is to explore, analysis and visualize trends in the data set.

-- Creating and importing dataset

START TRANSACTION;

CREATE TABLE acs_2011_2015_stats(
	goeid varchar(14) CONSTRAINT geoid_key PRIMARY KEY,
	county varchar(40) NOT NULL,
	st varchar(20) NOT NULL,
	pct_travel_60_min numeric(5,3) NOT NULL,
	pct_bachelors_higher numeric(5,3) NOT NULL,
	pct_masters_higher numeric(5,3) NOT NULL,
	median_hh_income integer,
	CHECK (pct_masters_higher <= pct_bachelors_higher)
);

COPY acs_2011_2015_stats
FROM '/Users/johnphillip/Desktop/acs_2011_2015_stats.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

COMMIT;

-- Measuring Correlation with corr(Y,X)
-- To understand the relationship between variables and measure the relatioships between variables it is important to understand correlations.
-- First, I'll use the corr(Y,X) function to measure correlation between the percentage of people in a county, who've attained a bachelors
-- degree and the median household income in that county. I'll also determine whether according to our data, a better educated population
-- typically equates to higher income and how strong the relationship between education level and income is if it does.
-- N.B: Using Pearson Correlation Coeffient, the result ranges from -1 to 1. With either range indicating a perfect correlation.
-- If the correlation gives a negative value it indicates an inverse correlation while a positve values indicates a direct correlation

SELECT ROUND(CORR(median_hh_income, pct_bachelors_higher)::numeric, 2) AS bachelors_income_corr
FROM acs_2011_2015_stats; -- The result is 0.68 indicating a fairly strong correlation. Meaning a county's educational attainment 
-- is directly correlated with it's household income(the higher the educational level the higher the income).

SELECT ROUND(CORR(median_hh_income, pct_bachelors_higher)::numeric, 2) AS bachelors_income_corr,
    ROUND(CORR(pct_travel_60_min, median_hh_income)::numeric, 2) AS income_travel_corr,
    ROUND(CORR(pct_travel_60_min, pct_bachelors_higher)::numeric, 2) AS bachelors_travel_corr
FROM acs_2011_2015_stats;

-- In income_travel_corr the result is 0.05 which indicate there is little to no correlation that higher income holdhold travel for an hour to get to work.
-- In bachelors_travel_corr the result is -0.14. This indicates the correlation is inversely related. As the education level increases the percentage of 
-- people that travel more than an hour to work decreases. But 0.14 is a weak indicator of this phenomenom or a weak relationship

-- PREDICTING  VALUE WITH REGRESSION ANALYSIS.
-- In this analysis, the aim is to predict the county's median household income if the 30% of the county's has a bachelors degree or higher
-- to be and what each percentage increase in education, how much increase,
-- on average, would we expect in income. The formula for linear regression slope -intercept: Y = bX + a, where:
--------------------------------------------------------------------------------------------------------------------
-- Y is the predicted value, which is also the value on the y-axis, or dependent value

-- b is the slope of the line, which can be positive or negative. It measures how many units the y-axis value will increase or decrease for each unit
-- of the x-axis value

-- X represents a value in the x-axis, or independent variable

-- a is the y-intercept, the value at which the line crosses the y-axis when the X value is zero
---------------------------------------------------------------------------------------------------------------------
SELECT round(regr_slope(median_hh_income, pct_bachelors_higher)::numeric, 2) AS slope,
		round(regr_intercept(median_hh_income, pct_bachelors_higher)::numeric, 2) AS y_intercept
FROM acs_2011_2015_stats; -- slope : 926.95 , y_intercept: 27901.15

-- Now substitute the slope and y-intercept values in the regression formula
SELECT ((926.95 * 30) + 27901.15) AS Y; -- 55709.65

-- FINDING THE EFFECT OF AN INDEPENDENT VARIABLE WITH r-squared
-- To calculate the extent that the variation in the x(independent) variable explains the variation in the y(dependent) variable
-- by squaring the r value to find the coefficient of determination(r-squared). This value ranges from 0 to 1 and indicates the
-- percentage of the variation that is explained by the independent variable. Use regr_r2(Y, X) function to find the r-squared value.

SELECT ROUND(regr_r2(median_hh_income, pct_bachelors_higher)::numeric, 3) AS r_squared
FROM acs_2011_2015_stats; -- Result: 0.465. This indicates that 47% of the variation in median household income in a county can be 
-- explained the percentage of people with a bachelors degree or higher in that county.


SELECT ROUND(CORR(median_hh_income, pct_masters_higher)::numeric, 2) AS masters_income_r,
		ROUND(CORR(pct_travel_60_min, pct_masters_higher)::numeric, 2) AS master_travel_r,
		ROUND(CORR(pct_travel_60_min, median_hh_income)::numeric, 2) AS income_travel_r
FROM acs_2011_2015_stats;

-- In masters_income_r: The correlation is 0.57 which indicates a moderate relationship between a county's population having a masters degree and having a higher income.
-- In master_travel_r: The correlation is -0.07 which indicates a very weak inverse correlation. Indicating there is little to no correlation that masters degree holders tend to travel more than 60 mins to work
-- In income_travel_r the result is 0.05 which indicate there is little to no correlation that higher income holdhold travel for an hour to get to work.