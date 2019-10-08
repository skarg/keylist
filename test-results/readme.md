# Folder for Unit Test Results in reflex XML format

# Report structure
Each report contains the &lt;test-case&gt; element that contains the summary of the tests launched in the following attributes :

* @tests indicates the number of atomic tests realized. An atomic test consist on testing a single assertion on a primitive type (string, boolean, number). A complex test consist on testing several other tests. For example, testing 2 XML documents is a complex test because each node will be checked.
* @errors indicates the number of assertions that weren't true.
* @failures indicates the number of test cases that fail to run. A single report should report 1 or 0, but if several reports are merged, a greater number could be reported.
* @name is the name of the test, and @label a short description.

Within the &lt;test-case&gt; element, other elements are used for reporting various informations :

* &lt;sysout&gt; : when some text is echoed to the standard output
* &lt;syserr&gt; : when some text is echoed to the standard error output
* &lt;skip&gt; : when using the &lt;xunit:skip&gt; element
* &lt;comment&gt; : when using the &lt;xunit:comment&gt; element
* &lt;error&gt; : when an error is reported ; it contains a @type attribute and a text content.
* &lt;nodes&gt; : if some nodes are involved, several nested &lt;nodes&gt; elements can wrap one or several &lt;error&gt; elements. The canonical paths of the node expected and the node get are indicated in the @expected and @result attributes of the &lt;nodes&gt; elements.

&lt;test-suite&gt; is used as the root element when running &lt;xunit:merge-reports&gt;. It summerize the number of tests, errors, and failures that occurred in the following attributes :

* @name : the name of the test suite
* @reports : the number of report files
* @test-cases : the number of test cases
* @tests : the number of all tests performed
* @skip : the number of test cases skipped
* @errors : the number of test cases that report at least one error
* @errors-detail : the number of errors reported in all test cases
* @failures : the number of test cases that report at least one failure
* @failures-detail : the number of failures reported in all test cases

Example Test Case:

```xml
    <test-case errors="2" failures="0" label="Purchase order transformation with a bad element in the output expected" name="report-bad-element-name" skip="0" tests="7">
        <nodes expected="/" result="/">
            <nodes xmlns:purchase="urn:acme-purchase-order" expected="/purchase:order[1]" result="/purchase-order[1]">
                <error type="Local name comparison"> Expected "order" but was "purchase-order" </error>
                <error type="Namespace URI comparison"> Expected "urn:acme-purchase-order" but was "" </error>
            </nodes>
        </nodes>
        <sysout>This text is captured by the report </sysout>
        <syserr/>
    </test-case>
```