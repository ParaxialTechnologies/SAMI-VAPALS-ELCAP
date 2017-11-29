package com.paraxialtech.vapals.vista;

import javax.annotation.CheckForNull;

import com.google.common.base.Preconditions;
import com.paraxialtech.vapals.vista.FilemanField.DataTypeEnum;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Represent the various aspects of a Fileman File.
 * <p/>
 * An instance of this class represents a particular file. It has various
 * properties and methods that you may expect/find useful while programmatically
 * interacting with Fileman.
 *
 * @author Keith Powers
 */
public class FilemanDataDictionary {
    //TODO change this to parse the ODS file which includes all potential values.

    private static final Pattern DOUBLE_QUOTE_TRIM_REGEX = Pattern.compile("^\"?(.*?)\"?$");
    private final String fileName;
    private final List<FilemanField> fields;
    private int finderIndex = 0;

    /**
     * Parses a CSV file into an object representing the data dictionary
     *
     * @param fileName           The FileMan file name (the container where all data is stored)
     * @param definitionFilePath path to the CSV file
     * @throws IOException if file cannot be read
     */
    public FilemanDataDictionary(final String fileName,
                                 final Path definitionFilePath) throws IOException {
        this.fileName = fileName;
        this.fields = parseFields(definitionFilePath);
    }

    private static String trimDoubleQuotes(final String string) {
        final Matcher matcher = DOUBLE_QUOTE_TRIM_REGEX.matcher(string);
        if (matcher.matches()) {
            return matcher.group(1);
        }
        return string;
    }

    public String getFileName() {
        return fileName;
    }

    /**
     * Static constructor generated from a definition file.
     *
     * @param definitionFilePath path to the data dictionary definition file
     * @return List of fields
     * @throws IOException if file cannot be read
     */
    private List<FilemanField> parseFields(final Path definitionFilePath) throws IOException {
        final List<String> fieldTitles = new ArrayList<>();
        final List<FilemanField> fields = new ArrayList<>();

        final List<String> lines = Files.readAllLines(definitionFilePath);
        final String delimeter = "\t";  // TODO: determine if this is a CSV or a TSV file. For now we know (assume) it's a TSV file

        FilemanField priorField = null;
        for (int lineNum = 1; lineNum <= lines.size(); lineNum++) {
            final String line = lines.get(lineNum - 1);

            // 1) Skip blank lines (eg: at end of file)
            if (line.trim().length() == 0) {
                continue;
            }

            // 2) Split the line into its parts
            final List<String> items =
                    Stream.of(line.split(delimeter))
                            .map(FilemanDataDictionary::trimDoubleQuotes)
                            .collect(Collectors.toList());

            // 3) The first line is full of headers
            if (lineNum == 1) {
                fieldTitles.addAll(items);
            }
            // 4) The rest of the lines contain the fields we will (should) find in the file
            else if (items.get(0).equals("1")) {
                FilemanField field = FilemanField.constructFromArray(items, fieldTitles);
                // The CHECKBOX fields are fully defined on each line, with the only difference being the web info
                if (priorField != null
                 && priorField.getDataType() == DataTypeEnum.CHECKBOX
                 && field.getDataType() == DataTypeEnum.CHECKBOX
                 && priorField.getFilemanName().equals(field.getFilemanName())) {
                    priorField.mergeWithWebFieldValue(FilemanValueEnumeration.constructValueFromArray(items, fieldTitles));
                } else {
                    priorField = field;
                    fields.add(priorField);
                }
            }
            // 5) The rest of the lines contain (additional?) possible values for enumerated types
            else {
                Preconditions.checkNotNull(priorField);
                priorField.mergeWithWebFieldValue(FilemanValueEnumeration.constructValueFromArray(items, fieldTitles));
            }
        }

        // 5) Sort and be done with it
        return sortFields(fields);
    }

    /**
     * Sort the fields on their class nums &amp; prop nums. The data dictionary
     * files, for some reason, do NOT necessarily show these fields in the same
     * order they appear when editing in Fileman, so it is up to us to do the
     * sorting.
     * <p>
     * This code is brittle and may break in the future if there are ever more or
     * less than 2 parts of the class num.
     *
     * @param fields
     * @see #findField(String)
     * @see #resetFieldFinder()
     */
    private static List<FilemanField> sortFields(final List<FilemanField> fields) {
        fields.sort((lhs,rhs) -> { int val = lhs.getClassNum()[0].compareTo(rhs.getClassNum()[0]);
                                   if (val != 0) {
                                       return val;
                                   }

                                   val = lhs.getClassNum()[1].compareTo(rhs.getClassNum()[1]);
                                   if (val != 0) {
                                       return val;
                                   }

                                   return lhs.getPropNum().compareTo(rhs.getPropNum()); }); // TODO: what about the other class #s?

        return fields;
    }

    /**
     * Call this method before iterating through a list in Fileman, so that calls to
     * {@linkplain #findField(String)} get the most likely field when there are
     * multiple with the same name.
     *
     * @see #findField(String)
     * @see #sortFields(List)
     */
    public void resetFieldFinder() {
        finderIndex = 0;
    }

    /**
     * TODO update javadoc
     * <p>
     * When iterating through the record in Fileman, we need to find the next field
     * by name, but there may be duplicate string identifiers.
     * <p>
     * When starting to iterate through a file in Fileman, first call the
     * {@linkplain #resetFieldFinder()} method to reset the internal counter to the
     * 0th field. Alternatively, change this method to take a second parameter that
     * indicates which matching field (if > 1) to return. The downside with this
     * approach is that the calling code needs to keep track of how many it has
     * seen.
     * <p>
     * Use this method to find the next field, starting with the field after the
     * previously-found field.
     * <p>
     * If the element is not found, start the search over from 0. This should only
     * be needed if we iterate through the fields in Fileman out-of-order (TODO:
     * check if this happens when editing <i>some,/i> fields as opposed to
     * <i>ALL</i> fields?)
     * <p>
     * Also does some basic look-ahead in case the expected order doesn't quite
     * match up with what we actually encounter.
     *
     * @param filemanPrompt
     *            the name of the prompt in FileMan
     * @return the field
     * @see #resetFieldFinder()
     * @see #sortFields(List)
     */
    @CheckForNull
    public FilemanField findField(final String filemanPrompt) {

//        return fields.stream().filter(filemanField -> filemanField.getFilemanName().equalsIgnoreCase(filemanPrompt)).findFirst().orElse(null);

        //TODO: determine if this really necessary?
        // Yes it is, unfortunately. See how Fileman handles "AGE RANGE" (sbsehsa1/2/3/4, sbhsa1/2/3/4).
        // This is also why we need to sort the fields when building from the data dictionary.
        for (int index = finderIndex; index < fields.size(); index++) {
            if (fields.get(index).getFilemanName().equals(filemanPrompt)) {
                finderIndex = index + 1;
                return fields.get(index);
            } else if (fields.get(index).getDataType().isMultiSelect() &&
                       filemanPrompt.endsWith(fields.get(index).getFilemanName())) {
                finderIndex = index + 1;
                return fields.get(index);
            }
        }
        for (int index = 0; index < finderIndex; index++) {
            if (fields.get(index).getFilemanName().equals(filemanPrompt)) {
                finderIndex = index + 1;
                return fields.get(index);
            } else if (fields.get(index).getDataType().isMultiSelect() &&
                       filemanPrompt.endsWith(fields.get(index).getFilemanName())) {
                finderIndex = index + 1;
                return fields.get(index);
            }
        }
        return null;
    }

    @Override
    public String toString() {
        return "FilemanDataDictionary [fileName=" + fileName + ", fields=" + fields + "]";
    }
}
