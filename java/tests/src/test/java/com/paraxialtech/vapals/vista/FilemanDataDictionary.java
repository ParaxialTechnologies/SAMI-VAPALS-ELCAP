package com.paraxialtech.vapals.vista;

import javax.annotation.CheckForNull;
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
                fields.add(FilemanField.constructFromArray(items, fieldTitles));
            }
            else {
                // TODO: input the various possible values for radio/pulldown fields
            }
        }

        // 5) Sort and be done with it
        return fields;
    }

    /**
     * TODO udpate javadoc
     * When iterating through the record in Fileman, we need to find the next field
     * by name, but there may be duplicate string identifiers. Use this method to
     * find the next field, starting with the field after the previously-found field.
     * <p>
     * It also loops around to the 0th element in case the element was not found, but now that we sort hopefully this is no longer necessary
     * <p>
     * Also does some basic look-ahead in case the expected
     * order doesn't quite match up with what we actually encounter.
     *
     * @param filemanPrompt the name of the prompt FileMan
     * @return the field
     */
    @CheckForNull
    public FilemanField findField(final String filemanPrompt) {

        return fields.stream().filter(filemanField -> filemanField.getFilemanName().equalsIgnoreCase(filemanPrompt)).findFirst().orElse(null);

        //TODO: determine if this really necessary?

//        for (int index = finderIndex; index < fields.size(); index++) {
//            if (fields.get(index).filemanPrompt.equals(filemanPrompt)) {
//                finderIndex = index + 1;
//                return fields.get(index);
//            }
//        }
//        for (int index = 0; index < finderIndex; index++) {
//            if (fields.get(index).filemanPrompt.equals(filemanPrompt)) {
//                finderIndex = index + 1;
//                return fields.get(index);
//            }
//        }
//        return null;
    }


}
