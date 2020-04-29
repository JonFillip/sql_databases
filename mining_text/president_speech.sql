-- USING POSTGREQL FOR FULL TEXT SEARCH
-- The purpose of this analysis is to use PostgreSQL's full text text functions to structure text into a well organized table.
-- The data used in this analysis is the compilation of 35 speeches from U.S. presidents (mostly State of the Union addresses), mostly
-- from presidents who served after the W.W.2. The data source can be gotten through the Internet Archive 
-- https://archive.org/details/State-of-the-Union-Addresses-1945-2006 

-- CREATE TABLE FOR FULL TEXT SEARCH
CREATE TABLE president_speeches(
    sotu_id serial PRIMARY KEY,
    president varchar(100) NOT NULL,
    title varchar(250) NOT NULL,
    date_of_speech date NOT NULL,
    speech_text text NOT NULL,
    search_speech_text tsvector
);

-- IMPORT SPEECHES
COPY president_speeches(president, title, date_of_speech, speech_text)
FROM '/Users/username/filelocation/sotu-1946-1977.csv'
WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@');

-- Copy the contents of speech text to the tsvector column 'search_speech_text'
UPDATE president_speeches
SET search_speech_text = to_tsvector('english', speech_text);

-- Create an index for search_speech_text using PostgreSQL Generalized Inverted Index
CREATE INDEX search_text_idx ON president_speeches USING gin(search_speech_text);
-- GIN index contains an entry for each lexeme and its location, allowing the database to find matches more quickly

-- SEARCHING SPEECH TEXT
SELECT president, date_of_speech
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('Vietnam')
ORDER BY date_of_speech; -- It matches text in the speeches of presidents where 'Vietnam' is mentioned and returns the president's name and date of the speech

-- Showing Search Result Locations using ts_headline() function
SELECT president,
		date_of_speech,
		ts_headline(speech_text, to_tsquery('Vietnam'),
				    'StartSel = <,
					StopSel = >,
					MinWords=5,
					MaxWords=7,
					MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('Vietnam'); -- Matches the location in the speech where Vietnam is first mentioned and returns its location

-- USING MULTIPLE SEARCH TERMS
SELECT president,
        date_of_speech,
        ts_headline(speech_text, to_tsquery('Nuclear & !warhead & !weapon'),
                    'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=10,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('Nuclear & !warhead & !weapon'); -- Matches the location of the word Nuclear but the president did not mention warhead and weapon

-- Searching For Adjacent Words
SELECT president,
        date_of_speech,
        ts_headline(speech_text, to_tsquery('social <-> security'),
                    'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=10,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('social <-> security'); -- Searches for any text in the speeches that include the word social followed by security

-- Ranking Query Matches by Relevance using ts_rank() and ts_rank_cd() function
SELECT president,
        date_of_speech,
        ts_rank(search_speech_text, to_tsquery('security & power & economy & defense'), 2):: numeric AS score
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('security & power & economy & defense')
ORDER BY score DESC;

SELECT president,
        date_of_speech,
        ts_rank_cd(search_speech_text, to_tsquery('security & power & economy & defense'), 2):: numeric AS score
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('security & power & economy & defense')
ORDER BY score DESC;

-- Using any one of the State of the Union addresses, count the number of
-- unique words that are five characters or more. Hint: you can use
-- regexp_split_to_table() in a subquery to create a table of words to count.
-- Bonus: remove commas and periods at the end of each word.

WITH unique_words(word) AS (
	SELECT regexp_split_to_table(speech_text, '\s') AS word
	FROM president_speeches
	WHERE date_of_speech = '1977-01-12'
)
SELECT lower(
            replace(replace(replace(word, ',', ''), '.', ''), ':', '')
            ) AS cleaned_word,
        count(*)
FROM unique_words
WHERE length(word) >= 5
GROUP BY cleaned_word
ORDER BY count(*) DESC;