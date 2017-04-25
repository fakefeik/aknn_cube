-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION aknn_cube" to load this file. \quit

-- Create the user-defined type for N-dimensional boxes

CREATE FUNCTION aknn_cube_in(cstring)
RETURNS aknn_cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube(float8[], float8[]) RETURNS aknn_cube
AS 'MODULE_PATHNAME', 'aknn_cube_a_f8_f8'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube(float8[]) RETURNS aknn_cube
AS 'MODULE_PATHNAME', 'aknn_cube_a_f8'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube_out(aknn_cube)
RETURNS cstring
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE TYPE aknn_cube (
	INTERNALLENGTH = variable,
	INPUT = aknn_cube_in,
	OUTPUT = aknn_cube_out,
	ALIGNMENT = double
);

COMMENT ON TYPE aknn_cube IS 'multi-dimensional cube ''(FLOAT-1, FLOAT-2, ..., FLOAT-N), (FLOAT-1, FLOAT-2, ..., FLOAT-N)''';

--
-- External C-functions for R-tree methods
--

-- Comparison methods

CREATE FUNCTION aknn_cube_eq(aknn_cube, aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_eq(aknn_cube, aknn_cube) IS 'same as';

CREATE FUNCTION aknn_cube_ne(aknn_cube, aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_ne(aknn_cube, aknn_cube) IS 'different';

CREATE FUNCTION aknn_cube_lt(aknn_cube, aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_lt(aknn_cube, aknn_cube) IS 'lower than';

CREATE FUNCTION aknn_cube_gt(aknn_cube, aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_gt(aknn_cube, aknn_cube) IS 'greater than';

CREATE FUNCTION aknn_cube_le(aknn_cube, aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_le(aknn_cube, aknn_cube) IS 'lower than or equal to';

CREATE FUNCTION aknn_cube_ge(aknn_cube, aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_ge(aknn_cube, aknn_cube) IS 'greater than or equal to';

CREATE FUNCTION aknn_cube_cmp(aknn_cube, aknn_cube)
RETURNS int4
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_cmp(aknn_cube, aknn_cube) IS 'btree comparison function';

CREATE FUNCTION aknn_cube_contains(aknn_cube, aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_contains(aknn_cube, aknn_cube) IS 'contains';

CREATE FUNCTION aknn_cube_contained(aknn_cube, aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_contained(aknn_cube, aknn_cube) IS 'contained in';

CREATE FUNCTION aknn_cube_overlap(aknn_cube, aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

COMMENT ON FUNCTION aknn_cube_overlap(aknn_cube, aknn_cube) IS 'overlaps';

-- support routines for indexing

CREATE FUNCTION aknn_cube_union(aknn_cube, aknn_cube)
RETURNS aknn_cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube_inter(aknn_cube, aknn_cube)
RETURNS aknn_cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube_size(aknn_cube)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;


-- Misc N-dimensional functions

CREATE FUNCTION aknn_cube_subset(aknn_cube, int4[])
RETURNS aknn_cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- proximity routines

CREATE FUNCTION aknn_cube_distance(aknn_cube, aknn_cube)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION distance_chebyshev(aknn_cube, aknn_cube)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION distance_taxicab(aknn_cube, aknn_cube)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Extracting elements functions

CREATE FUNCTION aknn_cube_dim(aknn_cube)
RETURNS int4
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube_ll_coord(aknn_cube, int4)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube_ur_coord(aknn_cube, int4)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube_coord(aknn_cube, int4)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube_coord_llur(aknn_cube, int4)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube(float8) RETURNS aknn_cube
AS 'MODULE_PATHNAME', 'aknn_cube_f8'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube(float8, float8) RETURNS aknn_cube
AS 'MODULE_PATHNAME', 'aknn_cube_f8_f8'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube(aknn_cube, float8) RETURNS aknn_cube
AS 'MODULE_PATHNAME', 'aknn_cube_c_f8'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION aknn_cube(aknn_cube, float8, float8) RETURNS aknn_cube
AS 'MODULE_PATHNAME', 'aknn_cube_c_f8_f8'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Test if aknn_cube is also a point

CREATE FUNCTION aknn_cube_is_point(aknn_cube)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Increasing the size of a aknn_cube by a radius in at least n dimensions

CREATE FUNCTION aknn_cube_enlarge(aknn_cube, float8, int4)
RETURNS aknn_cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

--
-- OPERATORS
--

CREATE OPERATOR < (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_lt,
	COMMUTATOR = '>', NEGATOR = '>=',
	RESTRICT = scalarltsel, JOIN = scalarltjoinsel
);

CREATE OPERATOR > (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_gt,
	COMMUTATOR = '<', NEGATOR = '<=',
	RESTRICT = scalargtsel, JOIN = scalargtjoinsel
);

CREATE OPERATOR <= (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_le,
	COMMUTATOR = '>=', NEGATOR = '>',
	RESTRICT = scalarltsel, JOIN = scalarltjoinsel
);

CREATE OPERATOR >= (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_ge,
	COMMUTATOR = '<=', NEGATOR = '<',
	RESTRICT = scalargtsel, JOIN = scalargtjoinsel
);

CREATE OPERATOR && (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_overlap,
	COMMUTATOR = '&&',
	RESTRICT = areasel, JOIN = areajoinsel
);

CREATE OPERATOR = (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_eq,
	COMMUTATOR = '=', NEGATOR = '<>',
	RESTRICT = eqsel, JOIN = eqjoinsel,
	MERGES
);

CREATE OPERATOR <> (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_ne,
	COMMUTATOR = '<>', NEGATOR = '=',
	RESTRICT = neqsel, JOIN = neqjoinsel
);

CREATE OPERATOR @> (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_contains,
	COMMUTATOR = '<@',
	RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR <@ (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_contained,
	COMMUTATOR = '@>',
	RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR -> (
	LEFTARG = aknn_cube, RIGHTARG = int, PROCEDURE = aknn_cube_coord
);

CREATE OPERATOR ~> (
	LEFTARG = aknn_cube, RIGHTARG = int, PROCEDURE = aknn_cube_coord_llur
);

CREATE OPERATOR <#> (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = distance_taxicab,
	COMMUTATOR = '<#>'
);

CREATE OPERATOR <-> (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_distance,
	COMMUTATOR = '<->'
);

CREATE OPERATOR <=> (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = distance_chebyshev,
	COMMUTATOR = '<=>'
);

-- these are obsolete/deprecated:
CREATE OPERATOR @ (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_contains,
	COMMUTATOR = '~',
	RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR ~ (
	LEFTARG = aknn_cube, RIGHTARG = aknn_cube, PROCEDURE = aknn_cube_contained,
	COMMUTATOR = '@',
	RESTRICT = contsel, JOIN = contjoinsel
);


-- define the GiST support methods
CREATE FUNCTION g_aknn_cube_consistent(internal,aknn_cube,smallint,oid,internal)
RETURNS bool
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION g_aknn_cube_compress(internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION g_aknn_cube_decompress(internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION g_aknn_cube_penalty(internal,internal,internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION g_aknn_cube_picksplit(internal, internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION g_aknn_cube_union(internal, internal)
RETURNS aknn_cube
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION g_aknn_cube_same(aknn_cube, aknn_cube, internal)
RETURNS internal
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE FUNCTION g_aknn_cube_distance (internal, aknn_cube, smallint, oid, internal)
RETURNS float8
AS 'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

-- Create the operator classes for indexing

CREATE OPERATOR CLASS aknn_cube_ops
    DEFAULT FOR TYPE aknn_cube USING btree AS
        OPERATOR        1       < ,
        OPERATOR        2       <= ,
        OPERATOR        3       = ,
        OPERATOR        4       >= ,
        OPERATOR        5       > ,
        FUNCTION        1       aknn_cube_cmp(aknn_cube, aknn_cube);

CREATE OPERATOR CLASS gist_aknn_cube_ops
    DEFAULT FOR TYPE aknn_cube USING gist AS
	OPERATOR	3	&& ,
	OPERATOR	6	= ,
	OPERATOR	7	@> ,
	OPERATOR	8	<@ ,
	OPERATOR	13	@ ,
	OPERATOR	14	~ ,
	OPERATOR	15	~> (aknn_cube, int) FOR ORDER BY float_ops,
	OPERATOR	16	<#> (aknn_cube, aknn_cube) FOR ORDER BY float_ops,
	OPERATOR	17	<-> (aknn_cube, aknn_cube) FOR ORDER BY float_ops,
	OPERATOR	18	<=> (aknn_cube, aknn_cube) FOR ORDER BY float_ops,

	FUNCTION	1	g_aknn_cube_consistent (internal, aknn_cube, smallint, oid, internal),
	FUNCTION	2	g_aknn_cube_union (internal, internal),
	FUNCTION	3	g_aknn_cube_compress (internal),
	FUNCTION	4	g_aknn_cube_decompress (internal),
	FUNCTION	5	g_aknn_cube_penalty (internal, internal, internal),
	FUNCTION	6	g_aknn_cube_picksplit (internal, internal),
	FUNCTION	7	g_aknn_cube_same (aknn_cube, aknn_cube, internal),
	FUNCTION	8	g_aknn_cube_distance (internal, aknn_cube, smallint, oid, internal);
