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
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;
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
    private static final Matcher<Result> MATCHER_ITEM = Matchers.regexp("[\r\n]+([^:\r\n]+):(?: (.+)//)?");
    private static final Pattern WHOLE_LINE = Pattern.compile(".*[^\r\n]+?");
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

            final String promptName = result.group(1);
            final FilemanField filemanField = dataDictionary.findField(promptName);

            // Field not found, no further processing possible
            if (filemanField == null) {
                System.err.println("FilemanInterface.createRecord() -> There is no definition for a field called " + promptName); //TODO throw an exception so a unit test would fail on this field.
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
            if (filemanField.getDataType() == DataTypeEnum.CHECKBOX) {
                // Checkboxes require special handling
                createCheckboxValue(filemanField, newValue);
            } else {
                expect.sendLine(newValue.toFileman());
            }
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
    private void createCheckboxValue(final FilemanField filemanField, final FilemanValue newValue) throws IOException {
        if (newValue == FilemanValue.NO_VALUE) {
            return;
        }

        final FilemanValueMulti newMultiValue = (FilemanValueMulti)newValue;

        if (newMultiValue.getValues().isEmpty()) {
            return;
        }

        boolean first = true;
        for (final FilemanValue value : newMultiValue.getValues()) {
            if (!first) {
                expect.expect(MATCHER_ITEM);
            }
            first = false;

            expect.sendLine(value.toFileman());
            expect.expect(Matchers.regexp("Are you adding '" + value.toFileman() + "' as[\r\n\t ]+a new " + filemanField.getFilemanName()));

            expect.sendLine("Yes");
        }
        expect.expect(MATCHER_ITEM);

        expect.sendLine();
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

        // Set up the file to look for fields sequentially
        dataDictionary.resetFieldFinder();

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
        expect.sendLine("ALL"); // TODO: allow to edit select fields

        final Matcher<Result> selectFilePrompt = Matchers.contains("Select " + dataDictionary.getFileName());

        expect.expect(selectFilePrompt);
        expect.sendLine(studyId);

        // Set up the file to look for fields sequentially
        dataDictionary.resetFieldFinder();

        while (true) {
            final Result result = expect.expect(Matchers.anyOf(selectFilePrompt, MATCHER_ITEM));
            if (selectFilePrompt.matches(result.group(), false).isSuccessful()) {
                break;
            }

            final String promptName = result.group(1);
            final FilemanField filemanField = dataDictionary.findField(promptName);

            // Field not found, no further processing possible
            if (filemanField == null) {
                System.err.println("FilemanInterface.updateRecord() -> There is no definition for a field called " + promptName); //TODO throw an exception so a unit test would fail on this field.
                expect.sendLine();
                continue;
            }

            // Find the current value
            final FilemanValue currentValue;
            if (filemanField.getDataType() == DataTypeEnum.CHECKBOX) {
                currentValue = getCheckboxValue(expect, filemanField);
            } else {
                currentValue = getFilemanValue(result, filemanField);
            }

            // Find the new value, or skip it if not found
            final FilemanValue newValue = newValues.get(filemanField);
            if (newValue == null) {
                System.err.println("FilemanInterface.updateRecord() -> No new value for field '" + filemanField + "'");
                expect.sendLine();
                continue;
            }

            // If the value isn't changing, just move on
            if (currentValue.equals(newValue)) {
                expect.sendLine();
                continue;
            }

            // Write the new value!

            // Checkboxes require special handling, of course
            if (filemanField.getDataType() == DataTypeEnum.CHECKBOX) {
                clearCheckboxValue(filemanField, (FilemanValueMulti)currentValue);

                if (newValue != FilemanValue.NO_VALUE) {
                    createCheckboxValue(filemanField, newValue);
                }
                continue;
            }

            // More special handling if the new value is to be blank
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
     * Checkbox fields require special handling.
     * <p>
     * Delete the given selected checkbox value(s) from the given field. Will fail
     * if the value isn't actually selected.
     *
     * @param filemanField
     *            The field we are deleting this value from.
     * @param values
     *            The value(s) we are deleting from the given field.
     * @throws IOException
     *             If something goes wrong communicating with the Fileman server.
     */
    private void clearCheckboxValue(final FilemanField filemanField, final FilemanValueMulti values) throws IOException {
        for (final FilemanValue value : values.getValues()) {
            final String filemanValue = ((FilemanValueEnumeration)value).getFilemanValue();
            expect.sendLine(filemanValue);
            expect.expect(MATCHER_ITEM);

            expect.sendLine("@");
            expect.expect(Matchers.regexp("SURE YOU WANT TO DELETE THE ENTIRE .+? " + filemanField.getFilemanName()));

            expect.sendLine("Yes");
            expect.expect(MATCHER_ITEM);
        }
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
     * Checkbox fields require special handling.
     * <p>
     * Retrieving the list of selected values also gives the list of possible
     * values. It also might add a page break if it's at the bottom of the terminal
     * window. Handling all of this got messy when using pure ExpectIt, so I wrote
     * this mini-FSM to do the parsing.
     *
     * @param expect
     * @param filemanField
     * @return
     * @throws IOException
     */
    private static FilemanValue getCheckboxValue(final Expect expect, final FilemanField filemanField) throws IOException {
        final Set<FilemanValueEnumeration> values = new LinkedHashSet<>();

        // Whether we are reading the selected values, or the possible values
        boolean read = true;

        // Get the details for this field
        expect.sendLine("?");

        // Read the output from the above command line-by-line
        while (true) {
            final Result result = expect.expect(Matchers.regexp(WHOLE_LINE));
            final String line = result.group();

            // All done
            if (line.contains("Select " + filemanField.getFilemanName() + ":")) {
                break;
            }

            // Fileman thinks we are at the bottom of the terminal window. Continue...
            if (line.contains("Type <Enter> to continue or '^' to exit:")) {
                expect.sendLine();
                continue;
            }

            // We are reading the selected values, one per line
            if (read) {
                // We are done with the selected values
                if (line.contains("You may enter a new " + filemanField.getFilemanName() + ", if you wish")) {
                    read = false;
                    continue;
                }

                // Find the selected value
                for (final FilemanValueEnumeration possibleValue : filemanField.getPossibleValues().values()) {
                    if (line.contains(possibleValue.getFilemanValue())) {
                        values.add(possibleValue);
                    }
                }
            }
        }

        if (values.isEmpty()) {
            return FilemanValue.NO_VALUE;
        }

        return new FilemanValueMulti(values);
    }

    /**
     * Static method to read from Fileman and build a map of fields to values.
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
        final Map<FilemanField, FilemanValue> fieldValues = new LinkedHashMap<>();
        while (true) {
            final MultiResult result = expect.expect(new FirstOfMultiMatcher(MATCHER_ITEM, selectFilePrompt));
            if (selectFilePrompt.matches(result.group(), false).isSuccessful()) {
                // We have stepped through all of the fields and are back at the Fileman prompt. Exit the loop.
                break;
            }

            final String promptName = result.group(1);
            final FilemanField filemanField = dataDictionary.findField(promptName);

            if (filemanField == null) {
                // Field not found, no further processing is possible for this field. Move on to the next field.
                System.err.println("FilemanInterface.readRecord() -> There is no definition for a field called " + promptName); //TODO throw an exception so a unit test would fail on this field.
                expect.sendLine();
                continue;
            }

            // Find the value, store it in our map, and move on
            if (filemanField.getDataType() == DataTypeEnum.CHECKBOX) {
                fieldValues.put(filemanField, getCheckboxValue(expect, filemanField));
            } else {
                fieldValues.put(filemanField, getFilemanValue(result, filemanField));
            }
            expect.sendLine();
        }
        return fieldValues;
    }
}
