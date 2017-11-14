package com.paraxialtech.vapals.filemanbot;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
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
public class FilemanFile {
    public final String filemanName;
    private final List<FilemanField> fields;
    private int finderIndex = 0;
    private static final Pattern DOUBLE_QUOTE_TRIM_REGEX = Pattern.compile("^\"?(.*?)\"?$");

    public FilemanFile(FileDefinition definition) throws IOException {
        this(definition.name,
             definition.fieldDefinitionPath);
    }

    public FilemanFile(final String filemanName,
                       final String definitionFilePath) throws IOException {
        this(filemanName, getFields(Paths.get(definitionFilePath)));
    }

    public FilemanFile(final String filemanName,
                       final List<FilemanField> fields) {
        this.filemanName = filemanName;
        this.fields = fields;
    }

    /**
     * Static constructor generated from a definition file.
     *
     * @param definitionFilePath
     * @return
     * @throws IOException
     */
    public static List<FilemanField> getFields(final Path definitionFilePath) throws IOException {
        final List<String> fieldTitles = new ArrayList<>();
        final List<FilemanField> fields = new ArrayList<>();

        final List<String> lines = Files.readAllLines(definitionFilePath);
        final String delim = "\t";  // TODO: determine if this is a CSV or a TSV file. For now we know (assume) it's a TSV file

        for (int lineNum = 1; lineNum <= lines.size(); lineNum++) {
            final String line = lines.get(lineNum - 1);

            // 1) Skip blank lines (eg: at end of file)
            if (line.trim().length() == 0) {
                continue;
            }

            // 2) Split the line into its parts
            final List<String> items =
                Stream.of(line.split(delim))
                    .map(item -> trimDoubleQuotes(item))
                    .collect(Collectors.toList());

            // 3) The first line is full of headers
            if (lineNum == 1) {
                fieldTitles.addAll(items);

                /* TODO: remove this debugging block */ {
                    System.out.print("1>");
                    for (final String title : fieldTitles) {
                        System.out.print(String.format("'%s',", title));
                    }
                    System.out.println("");
                }
            }
            // 4) The rest of the lines contain the fields we will (should) find in the file
            else if (items.get(0).equals("1")) {
                fields.add(FilemanField.constructFromArray(items, fieldTitles));

                /* TODO: remove this debugging block */ {
                    System.out.print(" >");
                    for (String item : items) {
                        System.out.print(String.format("'%s',", item));
                    }
                    System.out.println("");
                }
            } else {
                // TODO: input the various possible values for radio/pulldown fields
            }
        }

        // 5) Sort and be done with it
        return sortFields(fields);
    }

    /**
     * Sort the fields on their class nums &amp; prop nums.
     *
     * This code is brittle and may break in the future if there are ever more or
     * less than 2 parts of the class num.
     *
     * @param fields
     */
    private static List<FilemanField> sortFields(final List<FilemanField> fields) {
        fields.sort((lhs,rhs) -> { int val = lhs.classNum[0].compareTo(rhs.classNum[0]);
                                   if (val != 0) {
                                       return val;
                                   }

                                   val = lhs.classNum[1].compareTo(rhs.classNum[1]);
                                   if (val != 0) {
                                       return val;
                                   }

                                   return lhs.propNum.compareTo(rhs.propNum); }); // TODO: what about the other class #s?

        return fields;
    }

    /**
     * Get a map of each field to a null value.
     *
     * @return
     */
    public Map<FilemanField, String> getEmptyFieldMap() {
        final Map<FilemanField, String> map = new LinkedHashMap<>();

        for (final FilemanField field : fields) {
            map.put(field, null);
        }

        return map;
    }

    private static String trimDoubleQuotes(final String string) {
        final Matcher matcher = DOUBLE_QUOTE_TRIM_REGEX.matcher(string);
        if (matcher.matches()) {
            return matcher.group(1);
        }
        return string;
    }

    /**
     * Get the ID prompt string.
     *
     * @return
     */
    public String getIdPrompt() {
        return "Select " + filemanName + " " + fields.get(0).filemanName + ":";
    }

    public void resetFieldFinder() {
        finderIndex = 0;
    }

    /**
     * When iterating through the record in Fileman, we need to find the next field
     * by name, but there may be duplicate string identifiers. Use this method to
     * find the next field, starting with the field after the previously-found field.
     *
     * It also loops around to the 0th element in case the element was not found, but now that we sort hopefully this is no longer necessary
     *
     *  Also does some basic look-ahead in case the expected
     * order doesn't quite match up with what we actually encounter.
     *
     * @param fieldName
     * @return
     */
    public FilemanField findNextField(final String filemanName) {
        for (int index = finderIndex; index < fields.size(); index++) {
            if (fields.get(index).filemanName.equals(filemanName)) {
                finderIndex = index + 1;
                return fields.get(index);
            }
        }
        for (int index = 0; index < finderIndex; index++) {
            if (fields.get(index).filemanName.equals(filemanName)) {
                finderIndex = index + 1;
                return fields.get(index);
            }
        }
        return null;
    }

    /**
     * A Fileman file can be defined by two items:
     * <ul>
     * <li>The name of the file in Fileman.
     * <li>The definition file that describes the file's fields.
     * </ul>
     *
     * @author Keith Powers
     */
    public static class FileDefinition {
        public String name;
        public String fieldDefinitionPath;

        public FileDefinition (final String name, final String fieldDefinitionPath ) {
            this.name = name;
            this.fieldDefinitionPath = fieldDefinitionPath;
        }
    }
}
