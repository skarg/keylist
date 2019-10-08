#Makefile to build unit test
LOG_DIR := test-results
LOGFILE ?= $(LOG_DIR)/test-results.xml

TARGET1_SRC = key.c
TARGET2_SRC = keylist.c
TEST_DIR = test
CTEST_SRC = $(TEST_DIR)/ctest.c
INCLUDES = -I. -I./test

TARGET1_OBJS := ${TARGET1_SRC:.c=.o}
TARGET1_OBJS += ${CTEST_SRC:.c=.o}

TARGET2_OBJS := ${TARGET2_SRC:.c=.o}
TARGET2_OBJS += ${CTEST_SRC:.c=.o}

CFLAGS  = -Wall $(INCLUDES) -g -DTEST -DTEST_KEY -DTEST_KEYLIST

TARGET1 = key.exe
TARGET2 = keylist.exe

all: $(TARGET1) $(TARGET2)

$(TARGET1): ${TARGET1_OBJS}
	${CC} -o $@ ${TARGET1_OBJS}

$(TARGET2): ${TARGET2_OBJS}
	${CC} -o $@ ${TARGET2_OBJS}

test:
	./${TARGET1} >> ${LOGFILE}
	./${TARGET2} >> ${LOGFILE}

pretty: $(TARGET1_SRC) $(TARGET2_SRC)
	clang-format -i $(TARGET1_SRC)
	clang-format -i $(TARGET2_SRC)

pretty-check: $(TARGET1_SRC) $(TARGET2_SRC)
	echo "Not ready to pretty-check yet!"

.c.o:
	${CC} -c ${CFLAGS} $*.c -o $@

clean:
	rm -rf ${TARGET1_OBJS} ${TARGET1}
	rm -rf ${TARGET2_OBJS} ${TARGET2}

depend:
	rm -f .depend
	${CC} -MM ${CFLAGS} *.c >> .depend

include: .depend

.PHONY: all test pretty clean
