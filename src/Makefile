MPICC=/usr/bin/mpicc.mpich
MPICXX=/usr/bin/mpicxx.mpich
CPPFLAGS= # Use for directory inclusion
CFLAGS= -g -Wall -Werror -pedantic
CXXFLAGS= -g - Wall -Werror -pedantic

LDFLAGS= 
LD_LIBRARY_FLAGS= -lm 
LIBS= 

SOURCES=pathological.c 
OBJECTS=
OBJECTS = $(SOURCES:.c=.o)
TARGETS = $(OBJECTS:.o=.exe)

default: $(TARGETS)

all: default

$(OBJECTS): $(SOURCES)
	$(MPICC) -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(TARGETS): $(OBJECTS)
	$(MPICC) $(LDFLAGS) $< -o $@ $(LD_LIBRARY_FLAGS) $(LIBS)

clean:
	rm *.o
	rm *.exe


