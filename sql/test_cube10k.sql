CREATE EXTENSION IF NOT EXISTS cube;

\timing
\o out.txt

DROP TABLE IF EXISTS dataset10k_cube;
CREATE TABLE dataset10k_cube AS
	SELECT cube(v) AS c FROM dataset10k;

DROP TABLE IF EXISTS query10k_cube;
CREATE TABLE query10k_cube AS
	SELECT cube(v) AS c FROM query10k;

DROP INDEX IF EXISTS idx;
CREATE INDEX idx ON dataset10k_cube using gist(c);

DROP TABLE IF EXISTS query10k_result;
CREATE TABLE query10k_result AS
	SELECT q.c AS p, (
		SELECT d.c FROM dataset10k_cube AS d
		ORDER BY d.c<->q.c
		LIMIT 1
	) AS n FROM query10k_cube AS q;

SELECT sum(r.p<->r.n) FROM query10k_result AS r;

\timing
