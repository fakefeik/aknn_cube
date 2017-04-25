# contrib/aknn_cube/Makefile

MODULE_big = aknn_cube
OBJS= aknn_cube.o cubeparse.o $(WIN32RES)

EXTENSION = aknn_cube
DATA = aknn_cube--1.0.sql
PGFILEDESC = "cube - multidimensional cube data type"

EXTRA_CLEAN = y.tab.c y.tab.h

SHLIB_LINK += $(filter -lm, $(LIBS))

ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/aknn_cube
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif


# cubescan is compiled as part of cubeparse
cubeparse.o: cubescan.c

distprep: cubeparse.c cubescan.c

maintainer-clean:
	rm -f cubeparse.c cubescan.c
