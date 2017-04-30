CREATE EXTENSION IF NOT EXISTS aknn_cube;

\timing
\o out.txt

DROP TABLE IF EXISTS dataset10k_aknn_cube;
CREATE TABLE dataset10k_aknn_cube AS
	SELECT aknn_cube(v) AS c FROM dataset10k;

DROP TABLE IF EXISTS query10k_aknn_cube;
CREATE TABLE query10k_aknn_cube AS
	SELECT aknn_cube(v) AS c FROM query10k;

DROP INDEX IF EXISTS aknn_idx;
CREATE INDEX aknn_idx ON dataset10k_aknn_cube using gist(c);

DROP TABLE IF EXISTS aknn_query10k_result;
CREATE TABLE aknn_query10k_result AS
	SELECT q.c AS p, (
		SELECT d.c FROM dataset10k_aknn_cube AS d
		ORDER BY d.c<->q.c
		LIMIT 1
	) AS n FROM query10k_aknn_cube AS q;

SELECT sum(r.p<->r.n) FROM aknn_query10k_result AS r;

\timing
