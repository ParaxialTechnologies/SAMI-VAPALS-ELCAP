package com.paraxialtech.vapals.vista;

import com.paraxialtech.vapals.vista.FilemanField.DataTypeEnum;
import com.paraxialtech.vapals.vista.expectit.FirstOfMultiMatcher;

import net.sf.expectit.Expect;
import net.sf.expectit.MultiResult;
import net.sf.expectit.Result;
import net.sf.expectit.matcher.Matcher;
import net.sf.expectit.matcher.Matchers;

import javax.annotation.Nonnull;

import java.io.Closeable;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Preconditions.checkState;

/**
 * A bot that interacts with Fileman as a user with programmer permissions. This
 * bot expects to be given an expect object that has just been logged into a
 * Mumps instance.  For consistency's sake, it will return to this prompt at the end of each operation.
 *
 * @author Keith Powers
 */
public final class FilemanInterface implements Closeable {
    private static final String MATCHER_REGEX_STUB = "[\r\n]+\\s*([^:\r\n]+):(?: (%s)//)?";
    private static final Matcher<Result> MATCHER_ITEM = Matchers.regexp(String.format(MATCHER_REGEX_STUB, ".+"));
    private static final Pattern WHOLE_LINE = Pattern.compile(".*[^\r\n]+?");
    private static final String SELECT_ = "Select ";
    private final Expect expect;
    private final VistaServer vistaServer;

    public FilemanInterface(@Nonnull final Expect expect, @Nonnull final VistaServer vistaServer) {
        this.expect = checkNotNull(expect);
        this.vistaServer = checkNotNull(vistaServer);
    }

    /**
     * Create the given record in VistA, with the given values. Will throw an error
     * if the record already exists.
     *
     * @param dataDictionary
     *            the fileman data dictionary
     * @param studyID
     *            study id
     * @param values
     *            the values to insert into the record
     * @throws IOException
     *             if expectations fail
     */
    public void createRecord(final FilemanDataDictionary dataDictionary,
                             final String studyID,
                             final Map<FilemanField, FilemanValue> values) throws IOException {
        checkState(vistaServer.getCurrentState() == VistaServer.StateEnum.FILEMAN);

        expect.expect(Matchers.contains("Select OPTION:")); //ensure we're at the main menu
        expect.sendLine("1"); //ENTER OR EDIT FILE ENTRIES

        expect.expect(Matchers.contains("Input to what File:"));
        expect.sendLine(dataDictionary.getFileName());

        expect.expect(Matchers.contains("EDIT WHICH FIELD:"));
        expect.sendLine("ALL");

        final Matcher<Result> selectFilePrompt = Matchers.contains("Select " + dataDictionary.getFileName());

        expect.expect(selectFilePrompt);
        expect.sendLine(studyID);

        expect.expect(Matchers.contains("Are you adding '" + studyID + "' as a new " + dataDictionary.getFileName()));
        expect.sendLine("Yes");

        // Set up the file to look for fields sequentially
        dataDictionary.resetFieldFinder();

        while (true) {
            final Result result = expect.expect(Matchers.anyOf(selectFilePrompt, MATCHER_ITEM));
            if (selectFilePrompt.matches(result.group(), false).isSuccessful()) {
                break;
            }

            final String prompt = result.group(1);

            if (prompt.startsWith(SELECT_)) {
                FilemanField field = dataDictionary.findNextSubrecordField(prompt.substring(SELECT_.length()));
                if (field.getDataType() == DataTypeEnum.CHECKBOX) {
                    createCheckboxValues(dataDictionary, values, field);
                } else {
                    createSubrecordValues(dataDictionary, values, field);
                }
                expect.sendLine();
                continue;
            }
            final FilemanField filemanField = dataDictionary.findField(prompt);

            // Field not found, no further processing possible
            if (filemanField == null) {
                System.err.println("FilemanInterface.createRecord() -> There is no definition for a field called " + prompt); //TODO throw an exception so a unit test would fail on this field.
                expect.sendLine();
                continue;
            }

            // Find the new value, or skip it if not found
            final FilemanValue newValue = values.get(filemanField);
            if (newValue == null) {
                System.err.println("FilemanInterface.createRecord() -> No value for field '" + filemanField + "'");
                expect.sendLine();
                continue;
            }

            // Write the new value
            expect.sendLine(newValue.toFileman());
        }

        expect.sendLine(); //exit back to Fileman Main Menu
        expect.expect(Matchers.contains("Select OPTION:"));
    }

    /**
     * Checkbox fields require special handling.
     * <p>
     * Write the given checkbox value to Fileman. The trickiest part here is
     * maintaining state on the Expect object.
     *
     * @param filemanField
     *            The field we are writing a value for.
     * @param newValue
     *            The value we are writing.
     * @throws IOException
     *             If something goes wrong communicating with the Fileman server.
     */
    private void createCheckboxValues(final FilemanDataDictionary dataDictionary,
                                      final Map<FilemanField, FilemanValue> values,
                                      FilemanField field) throws IOException {
        while (field != null) {
            FilemanValue value = values.get(field);

            if (value != null && value != FilemanValue.NO_VALUE) {
                expect.sendLine(value.toFileman());
                expect.expect(Matchers.regexp("Are you adding '" + value.toFileman() + "' as[\r\n\t ]+a new " + field.getFilemanName()));

                expect.sendLine("Yes");
                expect.expect(MATCHER_ITEM);
            }

            field = dataDictionary.findNextSubrecordFieldSameClass(field.getFilemanName());
        }
    }

    private void createSubrecordValues(final FilemanDataDictionary dataDictionary,
                                       final Map<FilemanField, FilemanValue> values,
                                       FilemanField field) throws IOException {

        while (field != null) {
            final FilemanValue value = values.get(field);

            if (value == null || value == FilemanValue.NO_VALUE) {
                field = dataDictionary.findNextSubrecordFieldSameClass(field.getFilemanName());
                continue;
            }

            expect.sendLine(value.toFileman());

            final Result result = expect.expect(MATCHER_ITEM);
            field = dataDictionary.findNextSubrecordFieldSameSubKey(result.group(1));

            if (field == null) {
                field = dataDictionary.findNextSubrecordFieldSameClass(result.group(1).substring(SELECT_.length()));
            }
        }
    }

    /**
     * Step through the fields in the given Fileman File and return their values in
     * a map of fields to {@linkplain FilemanValue} objects.
     *
     * @param dataDictionary the fileman data dictionary
     * @param studyID study id
     * @return Map of fields and corresponding values
     * @throws IOException if expectations fail
     */
    public Map<FilemanField, FilemanValue> readRecord(final FilemanDataDictionary dataDictionary, final String studyID) throws IOException {
        checkState(vistaServer.getCurrentState() == VistaServer.StateEnum.FILEMAN);
        final Map<FilemanField, FilemanValue> fieldValues;

        //TODO There is a better way to output all values of a study...
//        Select OPTION: 2  PRINT FILE ENTRIES
//
//        Output from what File: SAMI BACKGROUND//   (8 entries)
//        Sort by: STUDY ID//
//        Start with STUDY ID: FIRST// PA0001
//        Go to STUDY ID: LAST// PA0001
//        Within STUDY ID, Sort by:
//        First Print FIELD: [CAPTIONED
//
//        Include COMPUTED fields:  (N/Y/R/B): NO// NO - No record number (IEN), no Computed Fields
//        Heading (S/C): SAMI BACKGROUND List  Replace
//        START at PAGE: 1//
//        DEVICE: ;80;99999  TELNET
        // DEVICE FORMAT IS: ";<width>;<length>"

        expect.expect(Matchers.contains("Select OPTION:")); //ensure we're at the main menu
        expect.sendLine("1"); //ENTER OR EDIT FILE ENTRIES

        expect.expect(Matchers.contains("Input to what File:"));
        expect.sendLine(dataDictionary.getFileName());

        expect.expect(Matchers.contains("EDIT WHICH FIELD:"));
        expect.sendLine("ALL");

        final Matcher<Result> selectFilePrompt = Matchers.contains("Select " + dataDictionary.getFileName());

        expect.expect(selectFilePrompt);
        expect.sendLine(studyID);

        fieldValues = readRecord(expect, selectFilePrompt, dataDictionary);

        expect.sendLine(); //exit back to Fileman Main Menu
        expect.expect(Matchers.contains("Select OPTION:"));

        return fieldValues;
    }

    @Override
    public void close() throws IOException {
        vistaServer.exitFileman();
    }

    /**
     * Step through the fields in the given Fileman File and set their values to the
     * specified values.
     *
     * @param dataDictionary fileman file data dictionary
     * @param studyId study id
     * @param newValues new values to assign
     * @throws IOException if expectations fail
     */
    public void updateRecord(final FilemanDataDictionary dataDictionary,
                             final String studyId,
                             final Map<FilemanField, FilemanValue> newValues) throws IOException {
        checkState(vistaServer.getCurrentState() == VistaServer.StateEnum.FILEMAN);

        expect.expect(Matchers.contains("Select OPTION:")); //ensure at main menu
        expect.sendLine("1");

        expect.expect(Matchers.contains("Input to what File:"));
        expect.sendLine(dataDictionary.getFileName());


        expect.expect(Matchers.contains("EDIT WHICH FIELD:"));
        expect.sendLine("ALL");

        final Matcher<Result> selectFilePrompt = Matchers.contains("Select " + dataDictionary.getFileName());

        expect.expect(selectFilePrompt);
        expect.sendLine(studyId);

        // Set up the file to look for fields sequentially
        dataDictionary.resetFieldFinder();

        while (true) {
            final Result result = expect.expect(Matchers.anyOf(MATCHER_ITEM, selectFilePrompt));
            if (selectFilePrompt.matches(result.group(), false).isSuccessful()) {
                break;
            }

            final String prompt = result.group(1);

            // This is a sub-record field
            if (prompt.startsWith(SELECT_)) {
                // Get the details for this field
                expect.sendLine("?");
                // Read the raw output from the above command
                final List<String> rawValues = readSubrecordRawValues(expect, prompt);

                // Delete them all, one at a time
                for (final String rawValue : rawValues) {
                    expect.sendLine(rawValue);
                    expect.expect(Matchers.regexp(String.format(MATCHER_REGEX_STUB, Pattern.quote(rawValue))));

                    expect.sendLine("@");
                    expect.expect(Matchers.contains("SURE YOU WANT TO DELETE "));

                    expect.sendLine("Yes");
                    expect.expect(MATCHER_ITEM);
                }

                FilemanField field = dataDictionary.findNextSubrecordField(prompt.substring(SELECT_.length()));
                if (field.getDataType() == DataTypeEnum.CHECKBOX) {
                    createCheckboxValues(dataDictionary, newValues, field);
                } else {
                    createSubrecordValues(dataDictionary, newValues, field);
                }
                expect.sendLine();
                continue;
            }

            final FilemanField field = dataDictionary.findField(prompt);

            // Field not found, no further processing possible
            if (field == null) {
                System.err.println("FilemanInterface.updateRecord() -> There is no definition for a field called " + prompt); //TODO throw an exception so a unit test would fail on this field.
                expect.sendLine();
                continue;
            }

            // Find the current value
            final FilemanValue currentValue;
            currentValue = getFilemanValue(result, field);

            // Find the new value, or skip it if not found
            final FilemanValue newValue = newValues.get(field);
            if (newValue == null) {
                System.err.println("FilemanInterface.updateRecord() -> No new value for field '" + field + "'");
                expect.sendLine();
                continue;
            }

            // If the value isn't changing, just move on
            if (currentValue.equals(newValue)) {
                expect.sendLine();
                continue;
            }

            // Write the new value!

            // Special handling if the new value is to be blank
            if (newValue == FilemanValue.NO_VALUE) {
                expect.sendLine("@");
                expect.expect(Matchers.contains("SURE YOU WANT TO DELETE?"));
                expect.sendLine("Yes");
                continue;
            }

            expect.sendLine(newValue.toFileman());
        }

        expect.sendLine(); //exit back to Fileman Main Menu
        expect.expect(Matchers.contains("Select OPTION:"));
    }

    /**
     * Delete the given study from Vista. Exit gracefully if if it does not exist.
     *
     * @param dataDictionary
     *            the fileman data dictionary
     * @param studyID
     *            study id
     * @throws IOException
     *             if expectations fail
     */
    public void deleteRecord(final FilemanDataDictionary dataDictionary, final String studyID) throws IOException {
        checkState(vistaServer.getCurrentState() == VistaServer.StateEnum.FILEMAN);

        expect.expect(Matchers.contains("Select OPTION:")); //ensure we're at the main menu
        expect.sendLine("1"); //ENTER OR EDIT FILE ENTRIES

        expect.expect(Matchers.contains("Input to what File:"));
        expect.sendLine(dataDictionary.getFileName());

        expect.expect(Matchers.contains("EDIT WHICH FIELD:"));
        expect.sendLine("ALL");

        final Matcher<Result> selectFilePrompt = Matchers.contains("Select " + dataDictionary.getFileName());

        expect.expect(selectFilePrompt);
        expect.sendLine(studyID);

        final Matcher<Result> addingNew = Matchers.contains("Are you adding '" + studyID + "' as a new " + dataDictionary.getFileName());
        // It might not exist yet...
        final Result result = expect.expect(Matchers.anyOf(addingNew, Matchers.contains("STUDY ID: " + studyID + "//")));

        // If the record doesn't exist yet, we are done
        if (addingNew.matches(result.group(), false).isSuccessful()) {
            expect.sendLine("No");
        } else {
            expect.sendLine("@");

            expect.expect(Matchers.contains("SURE YOU WANT TO DELETE THE ENTIRE '" + studyID + "' " + dataDictionary.getFileName() + "?"));
            expect.sendLine("Yes");
        }

        expect.expect(Matchers.contains("Select " + dataDictionary.getFileName()));
        expect.sendLine(); //exit back to Fileman Main Menu

        expect.expect(Matchers.contains("Select OPTION:"));
    }

    /**
     * Read the value for the given field.
     *
     * @param result
     *            The output of an expect.expect(...) operation.
     * @param filemanField
     *            The field we are reading a value for.
     * @return The value contained in the given field.
     */
    private static FilemanValue getFilemanValue(final Result result, final FilemanField filemanField) {
        if (result.groupCount() == 1) {
            return FilemanValue.NO_VALUE;
        }

        return filemanField.getValueFromFileman(result.group(2));
    }

    /**
     * General-case method to find the value(s) of a field with sub-records.
     *
     * @param expect
     * @param dataDictionary
     * @param prompt
     *            The whole first part (before the ':') of the Fileman entry that we
     *            are on (eg: "Select AGE RANGE").
     * @return
     * @throws IOException
     */
    private static Map<FilemanField, FilemanValue> getSubrecordValues(final Expect expect,
                                                                      final FilemanDataDictionary dataDictionary,
                                                                      final String prompt) throws IOException {
        final Map<FilemanField, FilemanValue> values = new LinkedHashMap<>();
        final Matcher<Result> promptMatcher = Matchers.contains(prompt);

        // Get the details for this field
        expect.sendLine("?");
        // Read the raw output from the above command
        final List<String> rawValues = readSubrecordRawValues(expect, prompt);

        final String trimmedPrompt = prompt.substring(SELECT_.length());
        FilemanField field = dataDictionary.findNextSubrecordField(trimmedPrompt);

        // Finding checkbox values requires enough logic that it is better suited to its own method
        if (field.getDataType() == DataTypeEnum.CHECKBOX) {
            // Short-circuit the rest of the steps
            return findCheckboxValues(dataDictionary, rawValues, field);
        }

        Iterator<String> rawValueIter = rawValues.iterator();
        while (field != null) {
            if (rawValueIter.hasNext()) {
                final String rawValue = rawValueIter.next();

                expect.sendLine(rawValue);
                Result result = expect.expect(Matchers.regexp(String.format(MATCHER_REGEX_STUB, Pattern.quote(rawValue))));

                // Iterate over the various sub-fields
                while (field != null) {
                    // Find the value
                    values.put(field, getFilemanValue(result, field));

                    expect.sendLine();
                    result = expect.expect(new FirstOfMultiMatcher(MATCHER_ITEM, promptMatcher));

                    // We are back at the main prompt; move on to the next raw value
                    if (promptMatcher.matches(result.group(), false).isSuccessful()) {
                        field = null;
                        continue;
                        //break;
                    }

                    // Find the next sub-field
                    field = dataDictionary.findNextSubrecordFieldSameSubKey(result.group(1));
                }
            } else {
                // We are out of raw values. Assign NO VALUE to this and all sub-fields
                while (field != null) {
                    if (!values.containsKey(field) ) {
                        values.put(field, FilemanValue.NO_VALUE);
                    }

                    field = dataDictionary.findNextSubrecordFieldSameClass(null);
                }
            }

            // Find the next subrecord field
            field = dataDictionary.findNextSubrecordFieldSameClass(trimmedPrompt);
        }

        return values;
    }

    /**
     * Parse the output of a "?&lt;enter>" command on a "Select &lt;something>:"
     * line, and get the selected values.
     *
     * @param expect
     * @param prompt
     *            The whole first part (before the ':') of the Fileman entry that we
     *            are on (eg: "Select AGE RANGE").
     * @return
     * @throws IOException
     */
    private static final List<String> readSubrecordRawValues(final Expect expect, final String prompt) throws IOException {
        final List<String> rawValues = new ArrayList<>();
        boolean wait = true;   // Whether we are ready to read the selected values

        while (true) {
            final Result result = expect.expect(Matchers.regexp(WHOLE_LINE));
            final String line = result.group();

            // All done
            if (line.contains(prompt + ":") ||
                line.contains("You may enter a new "/* + filemanField.getFilemanName() + ", if you wish"*/)) {
                break;
            }

            // Fileman thinks we are at the bottom of the terminal window. Continue...
            if (line.contains("Type <Enter> to continue or '^' to exit:")) {
                expect.sendLine();
                continue;
            }

            // We haven't gotten to the good stuff yet
            if (wait) {
                if (line.trim().endsWith(":")) {
                    wait = false;
                }
                continue;
            }

            // Finally read in the raw selected values, one per line
            if (line.trim().length() > 0) {
                rawValues.add(line.trim());
            }
        }

        // Consume the rest of the output
        while (true) {
            final Result result = expect.expect(new FirstOfMultiMatcher(Matchers.contains(prompt), Matchers.regexp(WHOLE_LINE)));

            // Fileman thinks we are at the bottom of the terminal window. Continue...
            if (result.group().contains("Type <Enter> to continue or '^' to exit:")) {
                expect.sendLine();
                continue;
            }

            if (result.group().contains(prompt)) {
                break;
            }
        }

        return rawValues;
    }

    /**
     * Using the {@linkplain #readSubrecordRawValues(Expect, String) raw values} for
     * the given field, get a map of all the checkbox fields/values.
     *
     * @param dataDictionary
     *            The data dictionary we are reading.
     * @param rawValues
     *            The raw values for the given checkbox field.
     * @param field
     *            The first checkbox field defined in the group.
     * @return A mapping of fields to values (either their only possible enumerated
     *         value, or FilemanValue.NO_VALUE).
     * @throws IOException
     *             If something goes wrong reading from the Fileman server.
     */
    private static final Map<FilemanField, FilemanValue> findCheckboxValues(final FilemanDataDictionary dataDictionary,
                                                                            final List<String> rawValues,
                                                                            FilemanField field) throws IOException {
        final Map<FilemanField, FilemanValue> values = new LinkedHashMap<>();

        while (field != null) {
            FilemanValueEnumeration possibleValue = field.getPossibleValues().values().iterator().next();
            values.put(field, rawValues.contains(possibleValue.getFilemanValue()) ? possibleValue : FilemanValue.NO_VALUE);
            field = dataDictionary.findNextSubrecordFieldSameClass(field.getFilemanName());
        }

        return values;
    }

    /**
     * Static method to read from Fileman and build a map of fields to values.
     * <p>
     * Any sub-fields in the specified FilemanDataDictionary are flattened here to
     * their individual representations in the resultant map.
     *
     * @param expect
     * @param dataDictionary
     * @param fieldValues
     * @param selectFilePrompt
     * @throws IOException
     */
    public static Map<FilemanField, FilemanValue> readRecord(final Expect expect,
                                                             final Matcher<Result> selectFilePrompt,
                                                             final FilemanDataDictionary dataDictionary) throws IOException {
        // Set up the file to look for fields sequentially
        dataDictionary.resetFieldFinder();

        final Map<FilemanField, FilemanValue> fieldValues = new LinkedHashMap<>();
        while (true) {
            final MultiResult result = expect.expect(new FirstOfMultiMatcher(MATCHER_ITEM, selectFilePrompt));
            if (selectFilePrompt.matches(result.group(), false).isSuccessful()) {
                // We have stepped through all of the fields and are back at the Fileman prompt. Exit the loop.
                break;
            }

            final String prompt = result.group(1);

            // This is a sub-record field
            if (prompt.startsWith(SELECT_)) {
                fieldValues.putAll(getSubrecordValues(expect, dataDictionary, prompt));
                expect.sendLine(); // TODO: ???
                continue;
            }

            // We _should_ be able to find the field normally
            final FilemanField field = dataDictionary.findField(prompt);

            // Oops, maybe not
            if (field == null) {
                // Field not found, no further processing is possible for this field. Move on to the next field.
                System.err.println("FilemanInterface.readRecord() -> There is no definition for a field called " + prompt); //TODO throw an exception so a unit test would fail on this field.
                expect.sendLine();
                continue;
            }

            fieldValues.put(field, getFilemanValue(result, field));

            expect.sendLine();
        }
        return fieldValues;
    }
}
