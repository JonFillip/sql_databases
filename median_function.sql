-- Creating a median function in SQL
CREATE FUNCTION _final_median(anyarray) RETURNS float8 AS $$ WITH q AS
(
    SELECT val
    FROM unnest($1) val
    WHERE VAL IS NOT NULL
    ORDER BY 1
),
cnt AS
(
    SELECT COUNT(*) AS c FROM q
)
SELECT AVG(val), CAST(AVG(val) AS float8)
FROM 
(
    SELECT val FROM q
    LIMIT  2 - MOD((SELECT c FROM cnt), 2)
    OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0)  
) q2;
$$ LANGUAGE SQL IMMUTABLE;

CREATE AGGREGATE median(anyelement) (
SFUNC=array_append,
STYPE=anyarray,
FINALFUNC=_final_median,
INITCOND='{}'
);

-- USAGE:
SELECT median(VALUE) AS median_value FROM table_name;


CREATE OR REPLACE FUNCTION final_median(anyarray) RETURNS float8 AS
$$ 
DECLARE cnt INTEGER;
BEGIN cnt := (SELECT COUNT(*) FROM unnest($1) val WHERE val IS NOT NULL);
RETURN (SELECT avg(tmp.val)::float8 
FROM (SELECT val FROM unnest($1) val
WHERE val IS NOT NULL 
ORDER BY 1 
LIMIT 2 - MOD(cnt, 2) 
OFFSET CEIL(cnt/ 2.0) - 1) AS tmp
);
END
$$ LANGUAGE plpgsql;

CREATE AGGREGATE median(anyelement) (
SFUNC=array_append,
STYPE=anyarray,
FINALFUNC=final_median,
INITCOND='{}'
);