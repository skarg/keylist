# The Simplest Automated Unit Test Framework That Could Possibly Work
## by Chuck Allison

The title of this article is a variation on a theme from Extreme Programming (XP)[1]. XP is a code-centric discipline for
getting software done right, on time, within budget, while having fun along the way. Quit laughing[2]. The XP approach
is to take the best software practices to the extreme. For example, if code reviews are good, then code should be
reviewed constantly, even as it’s written, hence the XP practice of Pair Programming, where all code is written by two
developers sharing a single workstation. One programmer pilots the keyboard while the other watches to catch mistakes
and gives strategic guidance – then they switch roles as needed. The next day they may pair up with other folks.
Likewise, if testing is good, then all tests should be automated and run many times per day. An ever-growing suite of
unit tests should be executed whenever you create or modify any function, to ensure that the system is still stable.
Furthermore, developers should integrate code into the complete, evolving system and run functional tests often (at least
daily).

## Confront Change

You’ve probably seen the old cartoon that says, “You guys start coding while I go find out what they want.” I spent a
number of years as a developer wondering why users couldn’t figure out what they wanted before I started coding. I
found it very frustrating to attend a weekly status meeting only to discover that what I completed the week before
wasn’t quite going to fit the bill because the analysts changed their mind. It’s hard to reshape concrete while it’s drying.
Only once in my career have I had the luxury of a “finished spec.” to code from[3].

Over the years, however, I’ve discovered that it is unreasonable to expect mere humans to be able to articulate software
requirements in detail without sampling an evolving, working system. It’s much better to specify a little, design a little,
code a little, test a little, and then, after evaluating the outcome, do it all over again. The ability to develop from soup to
nuts in such an iterative fashion is one of the great advances of this object-oriented era in software history. But it
requires nimble programmers who can craft resilient (i.e., slow-drying) code. Change is hard.

Ironically, there is another kind of change that good programmers want desperately to perform, but that management
has always opposed: improving the physical design of working code. What maintenance programmer hasn’t had
occasion to curse the aging, flagship company product as a convoluted patchwork of spaghetti, wholly resistant to
modification? The fear of tampering with a functioning system, while not totally unfounded, robs code of the resilience
it needs to endure. “If it ain’t broke, don’t fix it” eventually gives way to “We can’t fix it – rewrite it.” Change is
necessary.

Fortunately, in our day there has arisen the discipline of Refactoring, the art of internally restructuring code to improve
its design, without changing the functionality visible to the user4
. Such tweaks include extracting a new function from
another, or its inverse, combining methods; replacing a method with an object; parameterizing a method or class; or
replacing conditionals with polymorphism. Now that this process of improving a program’s internal structure has a
name and the support of industry luminaries, we will likely be seeing more of it in the workplace.

## It Was Working When I Laid It Down

But should the force for change come from analysts or programmers, there is still the risk that changes today will break
what worked yesterday. What we’re all after is a way to build code that withstands the winds of change and actually
improves over time.

There are many practices that purport to support this quick-on-your-feet motif, of which XP is only one. In this article I
explore what I think is the key to making incremental development work: a ridiculously easy-to-use automated unit test
framework, which I have implemented in C++, C, and Java.

Unit tests are what developers write to gain the confidence to say the two most important things that any developer can
say:

1. I understand the requirements
2. My code meets those requirements

I can’t think of a better way ensure that you know what the code you’re about to write should do than to write the unit
tests first. This simple exercise helps focus the mind on the task ahead, and will likely lead to working code faster than
just jumping into coding. Or, to express it in XP terms, Testing + Programming is faster than just Programming. Writing
tests first also puts you on guard up front against boundary conditions that might cause your code to break, so your code
is more robust right out of the chute.

Once you have code that passes all your tests, you then have the peace of mind that if the system you contribute to isn’t
working, it’s not your fault. The phrase, “All my tests pass” is a powerful trump card in the workplace that cuts through
any amount of politics and hand waving.

Writing good unit tests is so important that I’m amazed I didn’t discover its value earlier in my career. Let me rephrase
that. I’m not really amazed, just disappointed. I still remember what turned me off to formal testing at my first job right
out of school. The testing manager (yes, we had one in 1978!) asked me to write a unit test plan, whatever that was.
Being an impatient youth I thought it was silly to waste time writing a plan – why not just write the test? That encounter
soured me on the idea of formal test plans for years thereafter.

## Automated Testing

I think most developers, like myself, would rather write code than write about code. But what does a unit test look like?
Quite often developers just verify that some well-behaved input produces the expected output, which they inspect
visually. There are two dangers in this approach. First, programs don’t always receive just well-behaved input. We all
know that we should test the boundaries of programs input, but it’s hard to think about it when you’re trying to just get
things working. If you write the test for a function first before you start coding, you can wear your QA hat and ask
yourself, “What could possibly make this break?” Code up a test that will prove the function you’ll write isn’t broken,
then put on your developer hat and make it happen. You’ll write better code than if you hadn’t written the test first.

The second danger is inspecting output visually to see if things work. It’s fine for toy programs, but production software
is too complex for that kind of activity. It is tedious and error-prone to visually inspect program output to see if a test
passed. Most any such thing a human can do a computer can do, but without error. It’s better to formulate tests as
collections of boolean expressions and have the test program report any failures.

As an example, suppose you need to build a Date class in C++ that does the following:

* A date can be initialized with a string (YYYY-MM-DD), 3 integers (Y,M,D), or nothing (today’s date).
* A date object can yield its year, month, and day or a string of the form “YYYY-MM-DD”.
* All relational comparisons are available, as well as computing the duration between two dates (in years, months,
and days), and adding or subtracting a duration.
* Dates need to span an arbitrary number of centuries (e.g., 1600-2200)

Your class could store three integers representing the year, month, and day (just be sure the year is 16 bits or more to
satisfy the last bullet above). The interface for your Date class might look like this:

```
// date.h
#include <string>
#include "duration.h" // a 3-int struct

class Date
{
public:
    Date();
    Date(int year, int month, int day);
    Date(const std::string&);

    int getYear() const;
    int getMonth() const;
    int getDay() const;
    std::string toString() const;
    friend Duration duration(const Date&, const Date&);
    friend bool operator<(const Date&, const Date&);
    friend bool operator<=(const Date&, const Date&);
    friend bool operator>(const Date&, const Date&);
    friend bool operator>=(const Date&, const Date&);
    friend bool operator==(const Date&, const Date&);
    friend bool operator!=(const Date&, const Date&);
private:
 …
};
```

You can now write tests for the functions you want to implement first, something like the following:

```
int main()
{
    Date mybday(1951,10,1);
    Date today;

    test(mybday < today);
    test(mybday <= today);
    test(mybday != today);
    test(mybday == mybday);

    cout << "Passed: " << getNumPassed() << ", Failed: "
    << getNumFailed() << endl;
}

/* Output:
Passed: 4, Failed: 0
*/
```

In this case you can assume that the function test maintains the global variables nPass and nFail. The only visual
inspection you do is to read the final score. If a test failed, then test would print out an appropriate message. The
framework described below has such a test function, among other things.

As you continue in the test-and-code cycle you’ll want to build a suite of tests that are always available to keep all your
related classes in good shape through any future maintenance. As requirements change, you add or modify tests
accordingly.

## The TestSuite Framework

As you learn more about XP you’ll discover that there are some automated unit test tools available for download, such
as JUnit for Java and CppUnit for C++. These are brilliantly designed and implemented, but I want something even
simpler. I want something that I can not only easily use but also understand internally and even tweak if necessary. And
I don’t need no steenking GUI, thank you very much. So, in the spirit of TheSimplestThingThatCouldPossibleWork, I
present the TestSuite Framework, as I call it, which consists of two classes: Test and Suite. Test is an abstract
class you derive from to override the run method, which should in turn call `test_`[^5] for each boolean test condition
you define. For the Date class above you could do something like the following:

```
// DateTest.h: Use the test class
#include "test.h"
#include "date.h"

class DateTest : public Test
{
    Date mybday;
    Date today;

public:
    DateTest() : mybday(1951, 10,1)
    {
    }
    void run()
    {
        testOps();
    }
    void testOps()
    {
        test_(mybday < today);
        test_(mybday <= today);
        test_(mybday != today);
        test_(mybday == mybday);
    }
};
```
You can now run the test very easily, like this:
 ```
// datetest.cpp: Automated Testing (with a Framework)
#include <iostream>
#include "DateTest.h"
using namespace std;

int main()
{
    DateTest test;
    test.run();
    test.report();
}

/* Output:
Test "DateTest":
    Passed: 4 Failed: 0
*/
```
As development continues on the Date class, you’ll add other tests called from `DateTest::run`, and then execute
the main program to see if they all pass.

The Test class uses RTTI to get the name of your class (e.g., `DateTest`) for the report[^6]. The output stream defaults
to `cout`, but there is a `setStream` method that lets you specify the output stream, and `report` sends output to that
stream. See [test.h](test.h) and [test.cpp](test.cpp) for the definition and implementation of `Test`. No rocket science here. `Test` just keeps
track of the number of successes and failures as well as the stream where you want `Test::report` to print the
results. `test_` and `fail_` are macros so that they can include filename and line number information available from
the preprocessor (which is not available in the Java version, of course).

In addition to `test_` there are the `succeed_` and `fail_` functions for cases where a boolean test won’t do. For
example, a simple stack class template might have the following specification:
```
// Stack.h
…

template<typename T>
class Stack
{
public:
    Stack(size_t) throw(StackError, bad_alloc);
    ~Stack();

    void push(const T&) throw(StackError);
    T pop() throw(StackError);
    T top() const throw(StackError);
    size_t size() const;
    …
};
```
Before giving any thought at all to implementation it’s easy to come up with general categories of tests for this class:
```
class StackTest : public Test
{
    enum {SIZE = 5};
    Stack<int> stk;

public:
    StackTest() : stk(SIZE)
    {
    }
    void run()
    {
        testUnderflow();
        testPopulate();
        testOverflow();
        testPop();
        testBadSize();
    }
…
```
But to test whether exceptions are working correctly, you have to generate an exception and call `succeed_` or `fail_`
explicitly, as `StackTest::testBadSize` class illustrates:
```
    void testBadSize()
    {
        try
        {
            Stack<int> s(0);
            fail_("Bad Size");
        }
        catch (StackError&)
        {
            succeed_();
        }
    }
```
Since a stack of size zero is prohibited, "success" in this case means that a `StackError` exception was caught, so I
have to call `succeed_` explicitly. The implementation of the `Stack` class template is in [stack.h](stack.h) and `StackTest`
and its results appear in [stack.cpp](stack.cpp).

## Test Suites

Real projects usually contain many classes, so there needs to be a way to group tests together so you can just push a
single button to test the entire project. The `Suite` class allows you to collect tests into a functional unit. You add a
derived `Test` object to a `Suite` with the `addTest` method, or you can swallow an entire existing `Suite` with
`addSuite`. To illustrate, I have four modules that work together to provide real-world date support. `JulianDate` is
what I call an API of C functions that implement the basics of Julian Date arithmetic[^7]. The `JulianTime` module uses
`JulianDate` but adds support for hours, minutes, and seconds. `Date` uses `JulianDate` and adds Nice Things for
C++ users – likewise `Time` and `JulianTime`. Since these classes are all interrelated and are packaged as a single
library, I want to test them together. After defining each test class (derived from `Test`, of course), I group them into a
suite entitled “Date and Time tests”. Here’s an actual test run:
```
// test Suite for the Date projects
#include <iostream>
#include "suite.h"
#include "JulianDateTest.h"
#include "JulianTimeTest.h"
#include "DateTest.h" #include "TimeTest.h"
using namespace std;

int main()
{
    Suite s("Date and Time Tests”, &cout);

    s.addTest(new JulianDateTest);
    s.addTest(new JulianTimeTest);
    s.addTest(new DateTest);
    s.addTest(new TimeTest);
    s.run();
    long nFail = s.report();
    s.free();
    cout << "\nTotal failures: " << nFail << endl;
    return nFail;
}

/* Output:
Suite "Date and Time Tests"
===========================
Test "class MonthInfoTest":
    Passed: 18 Failed: 0
Test "class JulianDate":
    Passed: 36 Failed: 0
Test "class JulianTime":
    Passed: 29 Failed: 0
Test "class Date":
    Passed: 57 Failed: 0
Test "class Time":
    Passed: 84 Failed: 0
===========================

Total failures: 0
*/
```
`Suite::run` calls `Test::run` for each of its contained tests - likewise for `Suite::report`. Individual test
results can be written to separate streams, if desired. If the test passed to `addSuite` has a stream pointer assigned
already, it keeps it; otherwise it gets its stream from the Suite object. The code for `Suite` is in [suite.h](suite.h) and [suite.cpp](suite.cpp). As you
can see, `Suite` just holds a vector of pointers to `Test`. When it’s time to run each test, it just loops through the tests in
the vector calling their `run` method.

## No C++? No Problem!

After I showed `TestSuite` to the developers where I used to work, a number of programmers were a little chagrined
that they couldn’t use it, because they were developing strictly in C. It took all of one afternoon to change all the classes
to structs and rename things accordingly to come up with a C version, in [ctest.h], [ctest.c], [csuite.h], & [csuite.c].
The Java version was even easier (of course!).

## Summary

It takes some discipline to write unit tests before you code, but if you have an automated tool, it’s a lot easier. I just add
a project in my IDE for a test suite for each project, and switch back and forth between the test and the real code as
needed. There’s no conceptual baggage, no extra test scripting language to learn, no worries – just point, click, and test!



## Footnotes

[^1]:See Kent Beck’s book, *eXtreme Programming Explained: Embrace Change* (Addison-Wesley, 2000, ISBN 0-201-
61641-6), or visit www.Xprogramming.com for more information on XP. The XP theme from which this article derives
its title is DoTheSimplestThingThatCouldPossiblyWork.

[^2]:"Stop laughing" are Kent’s own words. See ibid, p. xvi.

[^3]:Yes, you guessed it. It was a government project. For all the paperwork, at least I knew what to do.

[^4]:The seminal work on this subject is of course Martin Fowler’s *Refactoring: Improving the Design of Existing Code*
(Addison-Wesley, 2000, ISBN 0-201-48567-2). See www.refactoring.com.

[^5]:The trailing underscore is necessary so as not to conflict with `ios::fail`.

[^6]:If you’re using Microsoft Visual C++, you need to specify the compile option /GR"". If you don’t, you’ll get an
access violation at runtime.

[^7]:These functions hold a Julian Day as a long. The JulianTime functions hold a JulianDate plus hour, minute,
and second all in one double. These are free functions because I want them to support both C and C++. The Date and
Time classes wrap these modules and add more functionality. For more on Julian day arithmetic, see Chapter 19 of my
book, *C & C++ Code Capsules*, P-H, 1998.