package com.paraxialtech.vapals.filemanbot;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import net.sf.expectit.Expect;
import net.sf.expectit.Result;
import net.sf.expectit.matcher.Matcher;
import net.sf.expectit.matcher.Matchers;

/**
 * A bot that interacts with Fileman as a user with programmer permissions. This
 * bot expects to be given an expect object that has just been logged into a
 * Mumps instance.  For consistency's sake, it will return to this prompt at the end of each operation.
 *
 * @author Keith Powers
 */
public class ProgrammerBot extends FilemanBot {
    private static final Matcher<Result> MATCHER_DONE = Matchers.contains("Select OPTION:");
    private static final Matcher<Result> MATCHER_ITEM = Matchers.regexp("[\r\n]+([^:]+):(?: (.+)//)?");

    public ProgrammerBot(final Expect expect) throws IOException {
        super(expect);
    }

    @Override
    public Map<FilemanField, String> readRecord(final FilemanFile filemanFile, final String id) throws IOException {
        final Map<FilemanField, String> fieldValues = new LinkedHashMap<>();
        openFilemanFile(filemanFile);

        expect.expect(Matchers.contains("EDIT WHICH FIELD:"));
        expect.sendLine("ALL"); // TODO: allow to read select fields

        expect.expect(Matchers.contains(filemanFile.getIdPrompt()));
        expect.sendLine(id);

        // Set up the file to look for fields sequentially
        filemanFile.resetFieldFinder();
        while (true) {
            Result result = expect.expect(Matchers.anyOf(MATCHER_DONE, MATCHER_ITEM));
            if (MATCHER_DONE.matches(result.group(), false).isSuccessful()) {
                break;
            }

            // Find the next FilemanField
            FilemanField filemanField = filemanFile.findNextField(result.group(1));
            if (filemanField != null) {
                fieldValues.put(filemanField, result.groupCount() == 1 ? "" : normalizeValue(result.group(2)));
            } else {
                System.out.println("ProgrammerBot.readFieldValues() -> Problem reading this line: \"" + result.group() + "\"");
            }

            expect.sendLine();
        }
//      expect.expect(Matchers.contains("Select OPTION:")); Found by MATCHER_DONE
        expect.sendLine("^");

        return fieldValues;
    }

    @Override
    public void updateRecord(final FilemanFile filemanFile,
                             final String id,
                             final Map<FilemanField, String> newValues) throws IOException {
        openFilemanFile(filemanFile);

        expect.expect(Matchers.contains("EDIT WHICH FIELD:"));
        expect.sendLine("ALL"); // TODO: allow to edit select fields

        expect.expect(Matchers.contains(filemanFile.getIdPrompt()));
        expect.sendLine(id);

        // Set up the file to look for fields sequentially
        filemanFile.resetFieldFinder();
        while (true) {
            Result result = expect.expect(Matchers.anyOf(MATCHER_DONE, MATCHER_ITEM));
            if (MATCHER_DONE.matches(result.group(), false).isSuccessful()) {
                break;
            }

            // Find the next FilemanField
            FilemanField filemanField = filemanFile.findNextField(result.group(1));
//            fieldValues.put(filemanField, result.groupCount() == 1 ? "" : normalize(result.group(2)));  TODO
        }
//      expect.expect(Matchers.contains("Select OPTION:")); Found by MATCHER_DONE
        expect.sendLine("^");
    }

    /**
     * Get to the given Fileman File.
     *
     * @param filemanFile
     * @throws IOException
     */
    private void openFilemanFile(final FilemanFile filemanFile) throws IOException {
        expect.expect(Matchers.contains(">"));
        expect.sendLine("SET DUZ=1");

        expect.expect(Matchers.contains(">"));
        expect.sendLine("DO Q^DI");

        expect.expect(Matchers.contains("Select OPTION:"));
        expect.sendLine("1");

        expect.expect(Matchers.contains("Input to what File:"));
        expect.sendLine(filemanFile.filemanName);
    }
}
