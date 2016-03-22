#Makefile to build unit tests
CC      = gcc
BASEDIR = .
CFLAGS  = -Wall -I. -g -DTEST -DTEST_KEY -DTEST_KEYLIST

KEY_OBJS  = key.o ctest.o

KEYLIST_OBJS  = keylist.o ctest.o

all: key keylist
 
key: ${KEY_OBJS}
	${CC} -o $@ ${KEY_OBJS} 

keylist: ${KEYLIST_OBJS}
	${CC} -o $@ ${KEYLIST_OBJS} 

.c.o:
	${CC} -c ${CFLAGS} $*.c
	
depend:
	rm -f .depend
	${CC} -MM ${CFLAGS} *.c >> .depend
	
clean:
	rm -rf core key keylist *.o

include: .depend
