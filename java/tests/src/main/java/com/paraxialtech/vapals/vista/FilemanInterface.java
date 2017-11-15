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
    private static final Matcher<Result> MATCHER_ITEM = Matchers.regexp("[\r\n]+([^:]+):(?: (.+)//)?");
    private final Expect expect;
    private final VistaServer vistaServer;

    public FilemanInterface(@Nonnull final Expect expect, @Nonnull final VistaServer vistaServer) {
        this.expect = checkNotNull(expect);
        this.vistaServer = checkNotNull(vistaServer);
    }

    private String normalizeValue(final String value) {
        if (value == null) {
            return "";
        }

        // TODO: dates, etc


        return value;
    }

    /**
     * Step through the fields in the given Fileman File and return their values in
     * a map of fields to {@link #normalizeValue(String) normalized} Strings.
     *
     * @param dataDictionary the fileman data dictionary
     * @param studyID study id
     * @return Map of fields and corresponding values
     * @throws IOException if expectations fail
     */
    public Map<FilemanField, String> readRecord(final FilemanDataDictionary dataDictionary, final String studyID) throws IOException {
        checkState(vistaServer.getCurrentState() == VistaServer.StateEnum.FILEMAN);
        final Map<FilemanField, String> fieldValues = new LinkedHashMap<>();

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


        while (true) {
            final Result result = expect.expect(Matchers.anyOf(selectFilePrompt, MATCHER_ITEM));
            if (selectFilePrompt.matches(result.group(), false).isSuccessful()) {
                break;
            }

            final String promptName = result.group(1);

            final FilemanField filemanField = dataDictionary.findField(promptName);

            if (filemanField != null) {
                fieldValues.put(filemanField, result.groupCount() == 1 ? "" : normalizeValue(result.group(2)));
            } else {
                System.err.println("FilemanInterface.readFieldValues() -> There is no definition for a field called " + promptName); //TODO throw an exception so a unit test would fail on this field.
            }
            expect.sendLine();
        }

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
                             final Map<FilemanField, String> newValues) throws IOException {
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

        while (true) {
            final Result result = expect.expect(Matchers.anyOf(selectFilePrompt, MATCHER_ITEM));
            if (selectFilePrompt.matches(result.group(), false).isSuccessful()) {
                break;
            }

            // Find the next FilemanField
            final FilemanField filemanField = dataDictionary.findField(result.group(1));
            //TODO: determine a good value and set it


//            fieldValues.put(filemanField, result.groupCount() == 1 ? "" : normalize(result.group(2)));  TODO
        }
//      expect.expect(Matchers.contains("Select OPTION:")); Found by MATCHER_DONE
        expect.sendLine("^");
    }


}
