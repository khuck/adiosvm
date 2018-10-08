include ../Makefile.inc

all: var_checks norm_calc
	@echo -n "\n------ DONE BUILDING ANALYSIS analysis/norm_calc ------\n"

norm_calc: var_checks norm_calc.cpp
	${CXX} ${CXXFLAGS} norm_calc.cpp -o norm_calc -I${ADIOS2_DIR}/include/ ${ADIOS2_LIB} -I../tau_stubs ../tau_stubs/tau_stubs.o

clean:
	rm -f *.o norm_calc
cleanall: clean

.PHONY: all clean cleanall

