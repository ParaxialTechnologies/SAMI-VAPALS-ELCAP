package com.paraxialtech.vapals.vista;

import net.sf.expectit.Expect;
import net.sf.expectit.Result;
import net.sf.expectit.matcher.Matcher;
import net.sf.expectit.matcher.Matchers;

import javax.annotation.Nonnull;
import java.io.Closeable;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

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
            expect.sendLine(newValue.toFileman());
        }

        expect.sendLine(); //exit back to Fileman Main Menu
        expect.expect(Matchers.contains("Select OPTION:"));
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
            final FilemanValue value = getFilemanValue(result, filemanField);

            // Find the new value, or skip it if not found
            final FilemanValue newValue = newValues.get(filemanField);
            if (newValue == null) {
                System.err.println("FilemanInterface.updateRecord() -> No new value for field '" + filemanField + "'");
                expect.sendLine();
                continue;
            }

            // If the value isn't changing, just move on
            if (value.equals(newValue)) {
                expect.sendLine();
                continue;
            }

            // Write the new value
            if (newValue != FilemanValue.NO_VALUE) {
                expect.sendLine(newValue.toFileman());
            } else {
                // If the new value is to be blank, handle this differently
                expect.sendLine("@");
                expect.expect(Matchers.contains("SURE YOU WANT TO DELETE?"));
                expect.sendLine("Yes");
            }
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

    private static FilemanValue getFilemanValue(final Result result, final FilemanField filemanField) {
        if (result.groupCount() == 1) {
            return FilemanValue.NO_VALUE;
        }

        return filemanField.getValueFromFileman(result.group(2));
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
            final Result result = expect.expect(Matchers.anyOf(selectFilePrompt, MATCHER_ITEM));
            if (selectFilePrompt.matches(result.group(), false).isSuccessful()) {
                break;
            }

            final String promptName = result.group(1);
            final FilemanField filemanField = dataDictionary.findField(promptName);

            // Field not found, no further processing possible
            if (filemanField == null) {
                System.err.println("FilemanInterface.readRecord() -> There is no definition for a field called " + promptName); //TODO throw an exception so a unit test would fail on this field.
                expect.sendLine();
                continue;
            }

            // Find the value, store it in our map, and move on
            fieldValues.put(filemanField, getFilemanValue(result, filemanField));
            expect.sendLine();
        }
        return fieldValues;
    }
}
