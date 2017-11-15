package com.paraxialtech.vapals;

import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Sets;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.paraxialtech.vapals.vista.FilemanDataDictionary;
import com.paraxialtech.vapals.vista.FilemanField;
import com.paraxialtech.vapals.vista.FilemanInterface;
import com.paraxialtech.vapals.vista.VistaServer;
import io.github.bonigarcia.wdm.ChromeDriverManager;
import net.sf.expectit.Expect;
import net.sf.expectit.ExpectBuilder;
import net.sf.expectit.Result;
import net.sf.expectit.matcher.Matcher;
import net.sf.expectit.matcher.Matchers;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.commons.lang3.tuple.Triple;
import org.hamcrest.CoreMatchers;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestFactory;
import org.junit.platform.runner.JUnitPlatform;
import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

import java.awt.*;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.google.common.collect.Lists.newArrayList;
import static com.google.common.collect.Maps.newHashMap;
import static com.paraxialtech.vapals.BackgroundConstants.FIELDS;
import static org.apache.commons.lang3.ObjectUtils.defaultIfNull;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.greaterThan;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.fail;


/**
 * Tests background forms persistence by using a browser to load the form, submit data, re-navigate to the page and validate input.
 */
@RunWith(JUnitPlatform.class)
class SamiBackgroundTest {
    private static final String ASCII_VALUE = "a Z  0!\\\"#$%^&*()-./<>=?@[]_`{}~";
    private static final String EXTENDED_ASCII_VALUE = "È\u0089q§Òú_" + (char) 138;
    private static final String SSH_PRIVATE_KEY = defaultIfNull(System.getProperty("privateKey"), "~/.ssh/id_rsa");
    private static final String SSH_USER = defaultIfNull(System.getProperty("user"), System.getProperty("user.name"));
    private static final String SERVER = defaultIfNull(System.getProperty("server"), "localhost");
    private static final String PORT = defaultIfNull(System.getProperty("port"), "9080");
    private static final String STUDY_IDS = defaultIfNull(System.getProperty("studyId"), "PA0001");
    private static final String BASE_URL = getUrl(STUDY_IDS.split(",")[0].trim());
    private static final Set<String> ignoreFields = ImmutableSet.of(); //Temporarily ignore these fields so remaining tests can run. "sbwcos"
    private static WebDriver driver = new HtmlUnitDriver();

    /**
     * Setup the Selenium driver to use an actual Chrome instance or a headless one.
     */
    @BeforeClass
    static void beforeClass() {
        ChromeDriverManager.getInstance().setup();
        if (System.getProperty("headless") != null || GraphicsEnvironment.isHeadless()) {
            final ChromeOptions o = new ChromeOptions();
            o.addArguments("headless");
            driver = new ChromeDriver(o);
        }
        else {
            driver = new ChromeDriver();
        }
    }

    /**
     * Cleanup/destroy our web driver
     *
     */
    @AfterClass
    static void afterClass() {
        driver.quit();
    }

    /**
     * Establish our base URL and navigate to it.
     */
    @BeforeEach
    void beforeEach() {
        final Properties p = System.getProperties();
        driver.get(BASE_URL);   // TODO: make this get the right page for the study being tested in each fileman/web equality test. Or does this even run for each item in that list?
    }

    @Test
    void testVisitDate() {
        final String fieldName = "sbdop";

        submitField(fieldName, "foobar");
        assertFieldValueIsNotValid(fieldName);

        submitField(fieldName, "25/Oct/2017");
        assertFieldValueEquals(fieldName, "25/Oct/2017");
    }

    @Test
    void testDateOfBirth() {
        final String fieldName = "sbdob";

        submitField(fieldName, "foobar");
        assertFieldValueIsNotValid(fieldName);

        submitField(fieldName, "25/Oct/2017");
        assertFieldValueEquals(fieldName, "25/Oct/2017");
    }

    @Test
    void testAge() {

        final String fieldName = "sbage";

        submitField(fieldName, "foobar");
        assertFieldValueIsNotValid(fieldName);

        submitField(fieldName, "45");
        assertFieldValueEquals(fieldName, "45");
    }


    @TestFactory
    Iterator<DynamicTest> testFilemanWebEquality() {
        return Stream.of(STUDY_IDS.split(",")) //for each study id we have
                .map(StringUtils::trim) //trim them
                .map(this::generateFilemanWebEqualityTests) //list of tests
                .flatMap(Collection::stream) //merge the lists
                .collect(Collectors.toList()).iterator(); //return iterator

    }

    private List<DynamicTest> generateFilemanWebEqualityTests(final String studyId) {

        final List<DynamicTest> tests = newArrayList();

        try {

            //Load the data dictionary for the BACKGROUND form
            final FilemanDataDictionary filemanDataDictionary = new FilemanDataDictionary("SAMI BACKGROUND", Paths.get("../../docs/dd/background-dd-map.csv"));

            //Store read values from VistA FileMan
            final Map<FilemanField, String> filemanValues = newHashMap();

            //Connect to a VISTA server and read in all values of the studyId
            try (final VistaServer server = new VistaServer(SERVER)) { // Auto Closeable

                assertThat(server.getCurrentState(), is(VistaServer.StateEnum.DISCONNECTED));

                server.connect(SSH_PRIVATE_KEY, SSH_USER);
                assertThat(server.getCurrentState(), is(VistaServer.StateEnum.CONNECTED));

                //Startup Fileman
                try(final FilemanInterface filemanInterface = server.startFileman()){
                    assertThat(server.getCurrentState(), is(VistaServer.StateEnum.FILEMAN));

                    //Read the record (TODO: assumes that it exists)
                    filemanValues.putAll(filemanInterface.readRecord(filemanDataDictionary, studyId));
                }

            }


            // final Map<String, String> filemanValues = createFilemanRecord(studyId);
            // assertThat("Not all fileman fields were updated", filemanValues.size(), is(FIELDS.size()));
            assertThat(filemanValues.size(), greaterThan(0)); //make sure we did something

            //refresh the page so we have up-to-date values
            driver.navigate().to(getUrl(studyId));

            //Assert that all web values are equivalent to what we just pulled out of Fileman.
            for (final Map.Entry<FilemanField, String> entry : filemanValues.entrySet()) {
                tests.add(DynamicTest.dynamicTest("Study=" + studyId + ":" + entry.getKey(), () -> assertFieldValueEquals(driver.getPageSource(), entry.getKey().getWebName(), entry.getValue())));
            }
        } catch (final IOException e) {
            fail("Unable to start shell or invoke Fileman on VistA server", e);
        } catch (final JSchException e) {
            fail(String.format("Failed to connect to SERVER='%s' with cert='%s' and user='%s'", SERVER, SSH_PRIVATE_KEY, SSH_USER), e);
        }
        return tests;
    }

    @TestFactory
    Iterator<DynamicTest> testBasicAccessibility() {
        final String pageSource = driver.getPageSource();
        final Document doc = Jsoup.parse(pageSource);

        // 1) Get all <input>, <select>, and <textarea> elements
        final Elements inputElements = doc.select("input,select,textarea");
        final List<DynamicTest> tests = newArrayList();

        // 2) For each element from step 1, add a test to ensure it has a non-empty "name" attribute
        tests.addAll(inputElements.stream().map(element -> DynamicTest.dynamicTest("has name attribute: " + element.toString(), () -> assertThat("name attribute is missing or empty: " + element.toString(), element.attr("name"), CoreMatchers.not("")))).collect(Collectors.toList()));

        // 3) For each element from step 1, add a test to ensure it has a non-empty "id" attribute
        tests.addAll(inputElements.stream().map(element -> DynamicTest.dynamicTest("has id attribute: " + element.toString(), () -> assertThat("id attribute is missing or empty: " + element.toString(), element.attr("id"), CoreMatchers.not("")))).collect(Collectors.toList()));

        // 4) For each element from step 1, add a test to ensure it has exactly one label
        tests.addAll(inputElements.stream().map(element -> DynamicTest.dynamicTest("has label: " + element.toString(), () -> {
            final String elementId = element.attr("id");
            if (StringUtils.isNotBlank(elementId)) {
                //could check for a wrapped label like this: element.parents().stream().anyMatch(parent -> parent.tagName().equals("label")), but that's not a preferred method
                assertThat("field with id=" + elementId + "missing label", doc.getElementsByAttributeValue("for", elementId).size(), is(1));
            }
            else {
                fail("field with id=" + elementId + "missing label");
            }
        })).collect(Collectors.toList()));

        return tests.iterator();
    }

    @TestFactory
    Iterator<DynamicTest> testDateFields() {

        final Document doc = Jsoup.parse(driver.getPageSource());

        // 1) Parse the page with jsoup, find the elements with class "ddmmmyyyy", and collect into a list their name attributes
        final List<String> fieldNames = doc.getElementsByClass("ddmmmyyyy").stream().map(element -> element.attr("name")).collect(Collectors.toList());

        // 2) For each name from step 1, add a (set of 3) tests
        return fieldNames.stream().map(textFieldName -> DynamicTest.dynamicTest("testDateField: " + textFieldName, () -> {

            // 2.1) The elements we are testing are date fields; they should give a formatted date after form submission
            final DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("MM/dd/yyyy"); //TODO: What is the actual expected output format for date fields?

            final String today = LocalDate.now().format(dateFormat);

            // 2.2) We will be testing 3 input values: a formatted date, "T" (today), and "T-1" (yesterday)
            //format of this set is K: input, V: expected output
            Set<Pair<String, String>> tests = Sets.newHashSet(
                    ImmutablePair.of(today, today),
                    ImmutablePair.of("T", today),
                    ImmutablePair.of("T-1", LocalDate.now().minusDays(1).format(dateFormat))
            );

            // 2.3) For each test: find the element (with Selenium), set its value, submit the form, reload the form, read the value & compare to the expected output
            for (Pair<String, String> test : tests) {
                final WebElement textField = driver.findElement(By.name(textFieldName));    // 2.3.1) Find the element (with Selenium)
                String input = test.getKey();
                String expected = test.getValue();
                textField.clear();                                                          // 2.3.2) Set the element's value to be the test input
                textField.sendKeys(input);
                textField.submit();                                                         // 2.3.3) Submit the element's value
                driver.navigate().to(BASE_URL);                                              // 2.3.4) Reload the initial page
                assertThat("Incorrect value for field " + textFieldName                     // 2.3.5) Read the new value & compare to the expected value
                                + " when using " + input
                                + " as input",
                        driver.findElement(By.name(textFieldName)).getAttribute("value"),
                        is(expected));
            }

        })).iterator();
    }

    @TestFactory
    Iterator<DynamicTest> testAsciiSaveForTextFields() {
        // 1) Find <input type="text" name="???"> elements and collect their "name" attribute values
        final List<String> textFieldNames = findElements(driver, "input[type='text'][name]").stream().map(webElement -> webElement.getAttribute("name")).collect(Collectors.toList());

        // 2) Make sure that these elements accept & reflect the pre-defined static ASCII text
        return textFieldNames.stream().map(textFieldName -> DynamicTest.dynamicTest("ASCII - " + textFieldName, () -> {
            final WebElement textField = driver.findElement(By.name(textFieldName));
            final String asciiText = ASCII_VALUE;
            assertNotNull(textField, "Could not find field by name " + textFieldName);
            textField.clear();
            textField.sendKeys(asciiText);
            textField.submit();                                                         // 1.4) Submit the element's value
            driver.navigate().to(BASE_URL);                                              // 1.5) Reload the initial page
            assertThat("Incorrect value in text field " + textFieldName,                // 1.6) Read the new value & compare to the expected value
                    driver.findElement(By.name(textFieldName)).getAttribute("value"),
                    is(asciiText));
        })).iterator();
    }


    @TestFactory
    Iterator<DynamicTest> testExtendedAsciiSaveForTextFields() {
        final List<String> textFieldNames = findElements(driver, "input[type='text'][name]").stream().map(webElement -> webElement.getAttribute("name")).collect(Collectors.toList());
        return textFieldNames.stream().map(textFieldName -> DynamicTest.dynamicTest("Extended ASCII - " + textFieldName, () -> {
            final String validText = "1"; //covers date and numeric fields

            final WebElement textField = driver.findElement(By.name(textFieldName));
            textField.clear();
            textField.sendKeys(validText);
            textField.submit();
            driver.navigate().to(BASE_URL); //reload the initial page
            assertThat("Incorrect pre-test value in text field " + textField.toString(), driver.findElement(By.name(textFieldName)).getAttribute("value"), is(validText));

            final WebElement textField2 = driver.findElement(By.name(textFieldName));
            assertNotNull(textField2, "Could not find field by name " + textFieldName);
            textField2.clear();
            textField2.sendKeys(EXTENDED_ASCII_VALUE);
            textField2.submit();
            driver.navigate().to(BASE_URL); //reload the initial page
            assertThat("Expected failure to save of field " + textFieldName, driver.findElement(By.name(textFieldName)).getAttribute("value"), is(validText));
        })).iterator();
    }

    @TestFactory
    Iterator<DynamicTest> testSaveEachTextField() {
        final List<String> textFieldNames = findElements(driver, "input[type='text'][name]").stream().map(webElement -> webElement.getAttribute("name")).collect(Collectors.toList());
        return textFieldNames.stream().map(textFieldName -> DynamicTest.dynamicTest("Test save text " + textFieldName, () -> {
            final WebElement textField = driver.findElement(By.name(textFieldName));
            final String asciiText = ASCII_VALUE;
            assertNotNull(textField, "Could not find field by name " + textFieldName);
            textField.clear();
            textField.sendKeys(asciiText);
            textField.submit();
            driver.navigate().to(BASE_URL); //reload the initial page
            assertThat("Incorrect value in text field " + textField.toString(), driver.findElement(By.name(textFieldName)).getAttribute("value"), is(asciiText));
        })).iterator();
    }

    @TestFactory
    Iterator<DynamicTest> testSaveEachDropdown() {
        // 1) Find <select> elements and collect their "name" attribute values
        final List<String> dropdownNames = findElements(driver, "select").stream().map(webElement -> webElement.getAttribute("name")).collect(Collectors.toList());

        // 2) For each name from step 1, add a test
        return dropdownNames.stream().map(dropdownName -> DynamicTest.dynamicTest("Test save dropdown " + dropdownName, () -> {
            // 2.1) Get the list of possible values for this dropdown element
            final WebElement dropdown = driver.findElement(By.name(dropdownName));
            final List<WebElement> options = dropdown.findElements(By.tagName("option"));
            // 2.2) Choose each option
            for (WebElement selectedOption : options) {
                selectedOption.click();
                String savedValue = selectedOption.getAttribute("value");

                // 2.3) Submit the element
                dropdown.submit();

                // 2.4) Reload the initial page
                driver.navigate().to(BASE_URL); //reload the initial page

                // 2.5) Find the dropdown element
                WebElement updatedDropdown = driver.findElement(By.name(dropdownName));
                assertNotNull(updatedDropdown, "No dropdown by name of " + dropdownName);

                // 2.6) Get its selected value
                final WebElement updatedOption = updatedDropdown.findElement(By.cssSelector("option[selected]"));
                assertNotNull(selectedOption, "No selected option for dropdown " + dropdownName);

                // 2.7) Read the value and compare to what we set it to in step 2.2
                final String actual = updatedOption.getAttribute("value");
                assertThat("Incorrect value in dropdown field " + selectedOption.toString(), actual, is(savedValue));
            }
        })).iterator();
    }

    @TestFactory
    Iterator<DynamicTest> testSaveEachRadio() {
        // 1) Find <input type="radio"> elements and collect their "name" attribute values
        final Set<String> radioElementGroups = findElements(driver, "input[type='radio']").stream().map(webElement -> webElement.getAttribute("name")).distinct().collect(Collectors.toSet());

        // 2) For each name from step 1, add a test
        return radioElementGroups.stream().map(radioGroupName -> DynamicTest.dynamicTest("Test save radio " + radioGroupName, () -> {

            final String selector = "input[type='radio'][name='" + radioGroupName + "']";

            // 3) Find the element by name, select each of its options in turn and make sure it reflects back after submitting
            final List<WebElement> radioOptions = findElements(driver, selector);
            for (int i = 0; i < radioOptions.size(); i++) {
                // 3.1) Select the value and submit
                WebElement option = findElements(driver, selector).get(i);
                String submittedValue = option.getAttribute("value");
                option.click();
                option.submit();

                // 3.2) Reload the initial page
                driver.navigate().to(BASE_URL); //reload the initial page

                // 3.3) Find the element again, and find the selected option
                final WebElement updatedOption = driver.findElement(By.cssSelector("input[type=radio][name=" + radioGroupName + "]:checked"));
                assertNotNull(updatedOption, "No value selected for radio field " + radioGroupName);

                // 3.4) Read the value and compare to what we set in step 3.1
                final String actual = updatedOption.getAttribute("value");
                assertThat("Incorrect value in radio field " + radioGroupName, actual, is(submittedValue));
            }

        })).iterator();
    }

    @TestFactory
    Iterator<DynamicTest> testSaveEachTextArea() {
        // 1) Find <textarea> elements and collect their "name" attribute values
        final Set<String> textAreaNames = findElements(driver, "textarea").stream().map(webElement -> webElement.getAttribute("name")).distinct().collect(Collectors.toSet());

        // 2) For each name from step 1, add a test
        return textAreaNames.stream().map(textAreaName -> DynamicTest.dynamicTest("Test save textarea " + textAreaName, () -> {
            // 2.1) Find the element by name
            final WebElement textarea = driver.findElement(By.name(textAreaName));
            assertNotNull(textarea, "No textarea by name of " + textAreaName);

            // 2.2) Set the element's value to be the test input, then submit
            final String submittedValue = ASCII_VALUE + "\r\n\r\n\t" + ASCII_VALUE + "\n";
            textarea.clear();
            textarea.sendKeys(submittedValue);
            textarea.submit();

            // 2.3) Reload the initial page
            driver.navigate().to(BASE_URL);

            // 2.4) Find the element again
            final WebElement updatedTextarea = driver.findElement(By.name(textAreaName));
            assertNotNull(updatedTextarea, "No textarea found by name of " + textAreaName);

            // 2.5) Read the value and compare to what we set in step 2.2
            assertThat("Incorrect value in textarea field " + textAreaName, updatedTextarea.getText(), is(submittedValue.trim()));
        })).iterator();
    }


    @TestFactory
    Iterator<DynamicTest> testSaveAllCheckboxes() {
        // 1) Find <input type="checkbox"> elements and collect their "name" attribute values
        final Set<String> checkboxNames = findElements(driver, "input[type='checkbox']").stream().map(webElement -> webElement.getAttribute("name")).distinct().collect(Collectors.toSet());

        // 2) For each name from step 1, add a test
        return checkboxNames.stream().map(checkboxName -> DynamicTest.dynamicTest("Test save checkbox " + checkboxName, () -> {
            // 2.1) Find the element by name
            WebElement checkbox = driver.findElement(By.name(checkboxName));
            assertNotNull(checkbox, "Checkbox by name " + checkboxName + " not found");

            // 2.2) ?Invert the box's selection?
            String submittedValue = checkbox.getAttribute("value");
            checkbox.click();
            checkbox.submit();

            // 2.3) Reload the initial page
            driver.navigate().to(BASE_URL);

            // 2.4) Find the element again
            final WebElement updatedCheckbox = driver.findElement(By.cssSelector("input[type='checkbox'][name='" + checkboxName + "'][value='" + submittedValue + "']"));
            assertNotNull(updatedCheckbox, "No checkbox by name of " + checkboxName);

            // 2.5) Read the "checked" attribute value make sure it is "true"
            final String checked = updatedCheckbox.getAttribute("checked");
            assertThat("Checkbox " + checkboxName + " should be checked", checked, is("true"));
        })).iterator();
    }

    @Test
    void testElementsHaveUniqueName() {
        final String[] duplicateNames =
                // 1) Get all <select>, <textarea>, and <input> elements - provided the <input> elements are NOT radio or submit buttons
                findElements(driver, "input:not([type='radio']):not([type='submit']),select,textarea").stream()
                        // 2) Reduce the elements to their names
                        .map(webElement -> webElement.getAttribute("name"))
                        // 3) Count each name
                        .collect(Collectors.groupingBy(name -> name, Collectors.counting()))
                        .entrySet().stream()
                        // 4) Filter for duplicate names
                        .filter(entry -> entry.getValue() > 1)
                        // 5) Pretty print the 'name':count
                        .map(entry -> "'" + entry.getKey() + "':" + entry.getValue())
                        .toArray(String[]::new);

        assertThat("Duplicate element name: " + String.join(", ", duplicateNames), duplicateNames.length, is(0));
    }

    private List<WebElement> findElements(final WebDriver driver, final String selector) {
        return driver.findElements(By.cssSelector(selector)).stream()
                .filter(WebElement::isEnabled)
                .filter(webElement -> !ignoreFields.contains(webElement.getAttribute("name")))
                .collect(Collectors.toList());
    }

    private void submitField(final String fieldName, final String fieldValue) {
        final WebElement element = driver.findElement(By.name(fieldName));
        Assert.assertNotNull("element " + fieldName + " not found", element);

        element.clear();
        element.sendKeys(fieldValue);
        element.submit();
    }

    private void assertFieldValueEquals(final String fieldName, final String fieldValue) {
        driver.navigate().to(BASE_URL);
        assertFieldValueEquals(driver.getPageSource(), fieldName, fieldValue);

    }

    private void assertFieldValueEquals(final String pageSource, final String fieldName, final String fieldValue) {
        final Elements elements = Jsoup.parse(pageSource).getElementsByAttributeValue("name", fieldName);
        assertThat("Could not find field " + fieldName + " on webpage", elements.size(), is(1));
        assertThat("Incorrect value for field " + fieldName, elements.get(0).val(), is(fieldValue));
    }

    private void assertFieldValueIsNotValid(final String fieldName) {
        final Elements elements = Jsoup.parse(driver.getPageSource()).getElementsByAttributeValue("name", fieldName);
        assertThat(elements.size(), is(1));
        elements.get(0).parent().getElementsContainingText("Input invalid");
        assertThat("Expected element indicating " + fieldName + " field was invalid", elements.size(), is(1));
    }

    Map<String, String> createFilemanRecord(final String studyId) {
        final Map<String, String> filemanValues = new HashMap<>();

        Session session = null;
        Channel channel = null;

        try {
            // 1) Login
            final JSch jSch = new JSch();
            jSch.addIdentity(SSH_PRIVATE_KEY);
            session = jSch.getSession(SSH_USER, SERVER);
            final Properties config = new Properties();
            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);
            session.connect();
            channel = session.openChannel("shell");
            channel.connect();

            // 2) Set up the Expect object
            final Expect expect = new ExpectBuilder()
                    .withOutput(channel.getOutputStream())
                    .withInputs(channel.getInputStream(), channel.getExtInputStream())
//                    .withEchoOutput(System.err)
                    .withEchoInput(System.out)
//                    .withInputFilters(removeColors(), removeNonPrintable())
                    .withExceptionOnFailure()
                    .withTimeout(1, TimeUnit.SECONDS)
                    .build();

            // 3) Get to FileMan
            expect.expect(Matchers.contains("~$"));
            expect.sendLine("osehra");

            expect.expect(Matchers.contains("~$"));
            expect.sendLine("mumps -dir");

            expect.expect(Matchers.contains(">"));
            expect.sendLine("SET DUZ=1");

            expect.expect(Matchers.contains(">"));
            expect.sendLine("DO Q^DI");

            // 4) Enter/edit file entries
            expect.expect(Matchers.contains("Select OPTION:"));
            expect.sendLine("1");

            expect.expect(Matchers.contains("Input to what File:"));
            expect.sendLine("SAMI BACKGROUND");

            expect.expect(Matchers.contains("EDIT WHICH FIELD:"));
            expect.sendLine("ALL");

            expect.expect(Matchers.contains("Select SAMI BACKGROUND STUDY ID:"));
            expect.sendLine(studyId);

            //new record?
            try {
                expect.expect(Matchers.contains("Are you adding"));
                expect.sendLine("Yes");
            }
            catch (final Exception ex) {
                //intentionally ignore
            }

            // 5) Loop through each entry
            final Matcher<Result> matcherDone = Matchers.contains("Select SAMI BACKGROUND STUDY ID:"); //finished input of record
            final Matcher<Result> matcherItem = Matchers.regexp("[\r\n]+([^:]+):(?: (.+)//)?"); //requesting input
            while (true) {
                final Result result = expect.expect(Matchers.anyOf(matcherDone, matcherItem));
                if (matcherDone.matches(result.group(), false).isSuccessful()) {
                    break;
                }

                //found an input request. Look at the first part (before the ":") and see if we can find a match
                final String key = result.group(1);
                final Optional<Triple<String, String, String>> triple = FIELDS.stream().filter(t -> t.getMiddle().contains(key)).findFirst();
                String value = "";
                if (triple.isPresent()) {
                    final String filemanKey = triple.get().getLeft();
                    value = triple.get().getRight();
                    filemanValues.put(filemanKey, value);
                }

                expect.sendLine(value);
            }

            expect.sendLine("^");

            // 6) Log out
            expect.expect(Matchers.contains(">"));
            expect.sendLine("HALT");

            expect.expect(Matchers.contains("~$"));
            expect.sendLine("exit");

            expect.expect(Matchers.contains("~$"));
            expect.sendLine("exit");

            expect.expect(Matchers.eof());

            expect.close();
        }
        catch (final JSchException e) {
            fail(String.format("Failed to connect to SERVER='%s' with cert='%s' and user='%s'", SERVER, SSH_PRIVATE_KEY, SSH_USER), e);
        }
        catch (final IOException e) {
            fail("Error communicating with SERVER.", e);
        }
        finally {
            if (channel != null) {
                channel.disconnect();
            }
            if (session != null) {
                session.disconnect();
            }
        }

        return filemanValues;
    }

    private static String getUrl(final String studyId) {
        return "http://" + SERVER + ":" + PORT + "/form?form=sbform&studyid=" + studyId;
    }
}
