CREATE EXTENSION IF NOT EXISTS aknn_cube;

\timing
\o out.txt

DROP TABLE IF EXISTS dataset100k_aknn_cube;
CREATE TABLE dataset100k_aknn_cube AS
	SELECT aknn_cube(v) AS c FROM dataset100k;

DROP TABLE IF EXISTS query100k_aknn_cube;
CREATE TABLE query100k_aknn_cube AS
	SELECT aknn_cube(v) AS c FROM query100k;

DROP INDEX IF EXISTS aknn_idx;
CREATE INDEX aknn_idx ON dataset100k_aknn_cube using gist(c);

DROP TABLE IF EXISTS aknn_query100k_result;
CREATE TABLE aknn_query100k_result AS
	SELECT q.c AS p, (
		SELECT d.c FROM dataset100k_aknn_cube AS d
		ORDER BY d.c<->q.c
		LIMIT 1
	) AS n FROM query100k_aknn_cube AS q;

SELECT sum(r.p<->r.n) FROM aknn_query100k_result AS r;

\timing
