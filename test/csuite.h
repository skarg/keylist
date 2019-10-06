/* csuite.h
 * Author: Chuck Allison
 * Source:
 *       The Simplest Automated Unit Test Framework That Could Possibly Work:
 *       http://www.ddj.com/184401279?pgno=1
 *
 * Modified:
 *       By Seth Ellsworth @ Quest.
 * (c) 2007 Quest Software, Inc. All rights reserved.
 */
#ifndef CSUITE_H
#define CSUITE_H

#include <stdio.h>
#include <stdbool.h>
#include "ctest.h"

typedef struct Suite Suite;

#ifdef __cplusplus
extern "C" {
#endif

    Suite *cs_create(const char *name);
    void cs_destroy(Suite * pSuite,
        bool freeTests);

    const char *cs_getName(Suite * pSuite);
    long cs_getNumPassed(Suite * pSuite);
    long cs_getNumFailed(Suite * pSuite);
    long cs_getNumTests(Suite * pSuite);
    FILE *cs_getStream(Suite * pSuite);
    void cs_setStream(Suite * pSuite,
        FILE * stream);

    bool cs_addTest(Suite * pSuite,
        Test * pTest);
    bool cs_addSuite(Suite * pSuite,
        Suite * pSuite2);
    void cs_run(Suite * pSuite);
    long cs_report(Suite * pSuite);
    void cs_reset(Suite * pSuite);

#ifdef __cplusplus
}
#endif
#endif
