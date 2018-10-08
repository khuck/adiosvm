include ../Makefile.inc

all: tau_stubs.o
	@echo -n "\n------ DONE BUILDING tau_stubs.o ------\n"

tau_stubs.o: tau_stubs.c
	${CC} ${CFLAGS} -c tau_stubs.c -o tau_stubs.o -I.

clean:
	rm -f *.o
cleanall: clean

.PHONY: all clean cleanall

