package com.paraxialtech.vapals.filemanbot;

import java.io.IOException;
import java.util.Map;

import net.sf.expectit.Expect;

/**
 * The methods defined in this class represent basic CRUD* actions that can be
 * performed against a Vista/Fileman server. The primary use of this class and
 * its subclasses is for automated testing.
 * <p/>
 * * For now we only have the R and U part of CRUD. We will add the C and D
 * parts as needed...
 *
 * @author Keith Powers
 */
public abstract class FilemanBot {
    protected Expect expect;

    /**
     * These bots use an {@link Expect} object, which they return to the same state
     * after each (public) operation.
     *
     * @param expect
     * @throws IOException
     */
    public FilemanBot(final Expect expect) throws IOException {
        this.expect = expect;
    }

    /**
     * Step through the fields in the given Fileman File and return their values in
     * a map of fields to {@link #normalizeValue(String) normalized} Strings.
     *
     * @param filemanFile
     * @param id
     * @return
     * @throws IOException
     */
    public abstract Map<FilemanField, String> readRecord(final FilemanFile filemanFile, final String id) throws IOException;

    /**
     * Step through the fields in the given Fileman File and set their values to the
     * specified values.
     *
     * @param filemanFile
     * @param id
     * @param newValues
     * @throws IOException
     */
    public abstract void updateRecord(final FilemanFile filemanFile,
                                      final String id,
                                      final Map<FilemanField, String> newValues)
                                          throws IOException;

    /**
     * Return a normalized value (standard-format dates, trimmed whitespace, etc).
     *
     * @param value
     * @return
     */
    protected String normalizeValue(final String value)
    {
        if (value == null) {
            return "";
        }

        // TODO: dates, etc


        return value;
    }
}
