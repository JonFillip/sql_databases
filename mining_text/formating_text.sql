-- Text data exists in structured and semi-structured and occassionally one might need extract data, quantify data
-- from speeches, reports, press releases and other documents.

-- FORMATTING TEXT USING STRINGS FUNCTIONS

-- CASE FORMATTING
SELECT UPPER('string'); -- Returns a capitalized version of the string
SELECT LOWER('StRinG'); -- Returns the string in all lower case characters
SELECT INITCAP('string'); -- Returns a title version of the string, capitalizing the first character of the string (postgresql specific)

-- CHARACTER INFORMATION
SELECT CHAR_LENGTH('string'); -- Returns the length of the string
SELECT LENGTH('string'); -- NON ANSI SQL; Returns the lenght of the string
SELECT POSITION('character' IN 'string'); -- Returns the position of the specified character in a string

-- REMOVING CHARACTERS
SELECT TRIM('character' FROM 'string'); -- Remove a specified character from a string
SELECT TRIM(TRAILING 'character' FROM 'string'); -- Removes the character at the end of a string
SELECT TRIM(LEADING 'character' FROM 'string'); -- Removes the character at the beginning of a string
SELECT TRIM(' string '); -- Removes any spaces at the start and end of a string

-- EXTRACTING AND REPLACING CHARACTERS
SELECT LEFT(string, number); -- Extracts and returns the number of characters at the beginning of the string
SELECT RIGHT(string, number); -- Extracts and retuns the number of characters at the end of the string
SELECT REPLACE(string, 'from', 'to'); -- Replaces a specified substring and returns a new string

-- MATCHING TEXT PATTERNS WITH REGULAR EXPRESSIONS
-- Regular Expressions (REGEX) are a type of notational language that describes text patterns

-- Regular Expression Notation
--------------------------------------------------------------------------------------------------------------
. -- A dot is a wildcard that finds any character except a newline
[azAZ] -- Any character in the square brackets. Here, a, z, A, Z.
[a-z] -- A range of characters. Here, lowercase a to z
[A-Z] -- A range of characters. Here, uppercase A to Z
[A-Za-z] -- A range of characters. Here will match any uppercase or lowercase letter.
\w -- Any word character or underscore. Same as [A-Za-z0-9_]
\d -- Match any digits
\s -- A space
\t -- Tab character
\n -- Match newline character
\r -- Carriage return character
^ -- Match the start of a string
$ -- Match the end of a string
? -- Get the preceding match zero or one time.
* -- Get the preceding match zero or more times
+ -- Get the preceding match one or more times
{m} -- Get the preceding match m times
{m,n} -- Get the preceding match between m and n times
a|b -- The pipe denotes alternation. Find either a or b
() -- Create and report a capture group or set precedence
(?: ) -- Negate the reporting of a capture group
(\) -- Escape character; placed in front of character to indicate the preceding character should be treated as a literal rather than letting it have a special meaning
(~) -- Tilde is used to make case-sensitive match 
(~*) -- Is used to perform case insensitive match 
----------------------------------------------------------------------------------------------------------------

-- Extracting patterns from this following string: "New Years countdown in Times Square starts at 11:59 p.m on Dec 31, 2020"
SELECT substring('New Years countdown in Times Square starts at 11:59 p.m on Dec 31, 2020' FROM '.+') -- Matches any character one or more times
SELECT substring('New Years countdown in Times Square starts at 11:59 p.m on Dec 31, 2020' 
                FROM '(?:\d{2}:\d{2}) (?:a.m|p.m)'); -- Two two digits seperated by a colon in a noncapture group followed by a space and a.m or p.m in a noncapture group
SELECT substring('New Years countdown in Times Square starts at 11:59 p.m on Dec 31, 2020' FROM '^\w+'); -- One or more word characters at the start of the string
SELECT substring('New Years countdown in Times Square starts at 11:59 p.m on Dec 31, 2020' FROM '\w+.$'); -- One or more word characters at the end of the string
SELECT substring('New Years countdown in Times Square starts at 11:59 p.m on Dec 31, 2020' FROM 'May|Dec'); -- Either May or Dec
SELECT substring('New Years countdown in Times Square starts at 11:59 p.m on Dec 31, 2020' FROM '\d{4}'); -- Any four digits
SELECT substring('New Years countdown in Times Square starts at 11:59 p.m on Dec 31, 2020' FROM 'Dec \d{2}, \d{4}'); -- Dec followed by space two digits, a comma, space and four digits

-- Another Syntax for extracting data from text specific to PostgreSQL
SELECT regexp_match(string, pattern)

SELECT regexp_matches(string, pattern, 'g'); --The regex function when supplied the g flag returns each match the expression finds as a row in the results rather than
-- just returning the first match

-- USING REGEX WITH WHERE CLAUSE
SELECT city
FROM fbi_crime_data_2015
WHERE city ~* '(.+bay)'
ORDER BY city; -- Matches and returns any city ending with 'bay'

SELECT county_name
FROM us_counties_census_2016
WHERE county_name ~* '.+ash.+' AND county_name !~ 'Wash.+'
ORDER BY county_name; -- Matches and returns all county with 'ash' inbetween its spelling except for counties starting with 'Wash'

-- OTHER REGEX FUNCTIONS

SELECT regexp_replace(string, pattern, to); -- Matches and replaces pattern in a given string
SELECT regexp_replace('14/10/1997', '\d{4}', '2021'); -- Matches and replaces any four digit value in the string

SELECT regexp_split_to_table(string, pattern);
SELECT regexp_split_to_table('Eggs, Meat, Poultry', ','); -- Matches and splits any word or character into seperate rows in the table

SELECT regexp_split_to_array(string, pattern);
SELECT regexp_split_to_array('Fee Fii Foo', ' ') -- Matches and returns the characters with space in the string in an array

SELECT array_length(SELECT regexp_split_to_array(string, pattern), 1); -- Returns the number of elements in the array


-- FULL TEXT SEARCH 
-- PostgreSQL has two data types for Text search. tsvector which represents the text to be searched and store in an optimized form.
-- The tsquery data type which represents the search query terms and operators

-- Storing Text as Lexemes with tsvector
-- tsvector reduces text to a sorted list of lexemes, which represents units of meaning in language. The syntax for tsvector:
SELECT to_tsvector(string);

-- Creating search terms for with tsquery
-- The tsquery also optimized as lexemes, provides operators for controlling the search. For exmaple: (&) ampersand for AND,
-- the pipe symbol (|) for OR, excalmation (!) for NOT and the special operator (<->) to allow for adjacent search for words or 
-- words certain distance apart. The syntax for tsquery:
SELECT to_tsquery(string);

-- Using the @@ Match operator for searching 
SELECT to_tsvector('I wokeup to read in the early hours of the morning then I took a morning walk') @@ to_tsquery('reading & walking'); -- Returns true
SELECT to_tsvector('I wokeup to read in the early hours of the morning then I took a morning walk') @@ to_tsquery('reading & running');-- Returns False


-- Write a Function to remove ',' before a suffix
SELECT replace('Alvarez, Jr.', ', ', '  '); -- using replace function
SELECT regexp_replace('William, Snr.', ', ', '  ') -- using regexp replace function
SELECT (regexp_match('Anderson, Phd.', '.*, (.*)'))[1]; -- Captures just the suffix