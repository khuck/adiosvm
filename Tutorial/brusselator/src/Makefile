include Makefile.inc

.PHONY: all tau_stubs simulation analysis clean cleanall

all : var_checks tau_stubs simulation analysis
	@echo -n "\n------ Simulation and analysis built in their respective directories ------\n"

tau_stubs: var_checks
	cd tau_stubs; ${MAKE}

simulation: var_checks
	cd simulation; ${MAKE}

analysis: var_checks
	@set -e; cd analysis; ${MAKE}

clean:
	cd tau_stubs; ${MAKE} clean
	cd simulation; ${MAKE} clean
	cd analysis; ${MAKE} clean

cleanall:
	cd tau_stubs; ${MAKE} cleanall
	cd simulation; ${MAKE} cleanall
	cd analysis; ${MAKE} cleanall

clean-data:
	rm -rf *.bp* *.h5 *.sst *.png

