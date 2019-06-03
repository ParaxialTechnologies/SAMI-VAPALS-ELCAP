/*
 * Copyright (c) 2019 Early Diagnosis and Treatment Research Foundation, Vista Expertise Network (VEN), and Paraxial
 *
 * The original management system was created and donated by Early Diagnosis and Treatment Research Foundation within the
 * International Early Lung Cancer Action Program (I-ELCAP), an international program of lung cancer screening.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at: http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

package com.paraxialtech.vapals.vista;

import com.google.common.base.Preconditions;

import javax.annotation.CheckForNull;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Comparator;
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
    private FilemanField prevSubrecordField = null;

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
     * Get the fields from a definition file.
     *
     * @param definitionFilePath path to the data dictionary definition file
     * @return List of fields
     * @throws IOException if file cannot be read
     */
    private List<FilemanField> parseFields(final Path definitionFilePath) throws IOException {
        final List<String> fieldTitles = new ArrayList<>();
        final List<FilemanField> fields = new ArrayList<>();

        final List<String> lines = Files.readAllLines(definitionFilePath);
        final String delimeter = "\t";  // TODO: determine if this is a CSV or a TSV file. For now we assume it's a TSV file

        FilemanField field = null;
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
            // 4) The lines beginning with "1" contain the fields we will find in the file
            else if (items.get(0).equals("1")) {
                field = FilemanField.constructFromArray(items, fieldTitles);
                fields.add(field);
            }
            // 5) The rest of the lines contain (additional?) possible values for enumerated types
            else {
                Preconditions.checkNotNull(field);
                field.mergeWithWebFieldValue(FilemanValueEnumeration.constructValueFromArray(items, fieldTitles));
            }
        }

        // 6) Sort and be done with it
        fields.sort(getFieldComparator());

        return fields;
    }

    /**
     * Get a comparator that sorts the fields on their class nums &amp; prop nums.
     * The data dictionary files, for some reason, do NOT necessarily show these
     * fields in the same order they appear when editing in Fileman, so it is up to
     * us to do the sorting.
     * <p>
     * This code is brittle and may break in the future if there are ever more or
     * less than 2 parts of the class num.
     *
     * @see #findField(String)
     * @see #resetFieldFinder()
     */
    private static Comparator<FilemanField> getFieldComparator() {
        return (lhs, rhs) -> {
            int val = lhs.getClassNum()[0].compareTo(rhs.getClassNum()[0]);
            if (val != 0) {
                return val;
            }

            val = lhs.getClassNum()[1].compareTo(rhs.getClassNum()[1]);
            if (val != 0) {
                return val;
            }

            return lhs.getPropNum().compareTo(rhs.getPropNum());    // TODO: what about the other class #s?
        };
    }

    /**
     * Because of the way VistA stores its data and the order that Fileman accesses
     * it, {@linkplain FilemanDataDictionary} maintains a pointer to the last
     * subrecord field that was returned by a <code>findField...</code> method
     * (except for {@linkplain #findNextSubrecordFieldSameSubKey(String)}) so that
     * subsequent calls to a <code>findField...</code> method return the correct
     * field.
     * <p>
     * Call this method before iterating through a list in Fileman to reset this
     * subrecord pointer, so that calls to the <code>findField...</code> methods do
     * not inadvertently retrieve the incorrect sub-field.
     *
     * @see #findField(String)
     * @see #findNextSubrecordField(String)
     * @see #findNextSubrecordFieldSameClass(String)
     * @see #findNextSubrecordFieldSameSubKey(String)
     * @see #sortFields(List)
     */
    public void resetFieldFinder() {
        prevSubrecordField = null;
    }

    /**
     * Find the first (by class number) field whose
     * {@linkplain FilemanField#getFilemanName()} method matches the given prompt.
     *
     * @param filemanPrompt
     *            The name of the prompt in FileMan, {@linkplain String#trim()
     *            trimmed} and pruned of any extraneous characters (eg: "SYMPTOMS"
     *            rather than "Select SYMPTOMS ").
     * @return The first matching field, or <code>null</code> if no fields match.
     * @see #resetFieldFinder()
     * @see #findNextSubrecordField(String)
     * @see #findNextSubrecordFieldSameClass(String)
     * @see #findNextSubrecordFieldSameSubKey(String)
     * @see #sortFields(List)
     */
    @CheckForNull
    public FilemanField findField(final String filemanPrompt) {
        // Step through each field to find the matching one
        for (final FilemanField field : fields) {
            // Find the field
            if (field.getFilemanName().equals(filemanPrompt)) {
                if (field.isSubRecordField()) {
                    prevSubrecordField = field;
                }
                return field;
            }
        }

        return null;
    }

    /**
     * Find the next (starting from the previously-returned subrecord field) field
     * whose {@linkplain FilemanField#getFilemanName()} method matches the given
     * prompt.
     *
     * @param filemanPrompt
     *            The name of the prompt in FileMan, {@linkplain String#trim()
     *            trimmed} and pruned of any extraneous characters (eg: "SYMPTOMS"
     *            rather than "Select SYMPTOMS ").
     * @return The next matching subrecord field, or <code>null</code> if no fields match.
     * @see #resetFieldFinder()
     * @see #findField(String)
     * @see #findNextSubrecordFieldSameClass(String)
     * @see #findNextSubrecordFieldSameSubKey(String)
     * @see #sortFields(List)
     */
    public FilemanField findNextSubrecordField(final String filemanPrompt) {
        for (int idx = fields.indexOf(prevSubrecordField) + 1; idx < fields.size(); idx++) {
            final FilemanField field = fields.get(idx);
            if (field.isSubRecordField()
             && field.getFilemanName().equals(filemanPrompt)) {
                prevSubrecordField = field;
                return field;
            }
        }

        return null;
    }

    /**
     * Find the next (starting from the previously-returned subrecord field) field
     * whose {@linkplain FilemanField#getFilemanName()} method matches the given
     * prompt, and whose class number matches that of the previously-returned field
     * (or if no subrecord field has yet been returned).
     *
     * @param filemanPrompt
     *            The name of the prompt in FileMan, {@linkplain String#trim()
     *            trimmed} and pruned of any extraneous characters (eg: "SYMPTOMS"
     *            rather than "Select SYMPTOMS ").
     * @return The next matching subrecord field, or <code>null</code> if no fields
     *         match.
     * @see #resetFieldFinder()
     * @see #findField(String)
     * @see #findNextSubrecordField(String)
     * @see #findNextSubrecordFieldSameSubKey(String)
     * @see #sortFields(List)
     */
    public FilemanField findNextSubrecordFieldSameClass(final String filemanPrompt) {
        for (int idx = fields.indexOf(prevSubrecordField) + 1; idx < fields.size(); idx++) {
            final FilemanField field = fields.get(idx);
            if (field.isSubRecordField()
             && ( filemanPrompt == null || field.getFilemanName().equals(filemanPrompt))
             && ( prevSubrecordField == null || field.isSameClassNum(prevSubrecordField))) {
                prevSubrecordField = field;
                return field;
            }
        }

        return null;
    }

    /**
     * Find the next (starting from the previously-returned subrecord field) field
     * matching all of the following:
     * <ol>
     * <li>whose {@linkplain FilemanField#getFilemanName()} method matches the given
     * prompt
     * <li>whose class number matches that of the previously-returned field.
     * <li>whose subrecord key matches that of the previously-returned field.
     * </ol>
     * This method is also noteworthy because it does NOT update the internal record
     * of the previously-returned subrecord field.
     *
     * @param filemanPrompt
     *            The name of the prompt in FileMan, {@linkplain String#trim()
     *            trimmed} and pruned of any extraneous characters (eg: "SYMPTOMS"
     *            rather than "Select SYMPTOMS ").
     * @return The next matching subrecord field, or <code>null</code> if no fields
     *         match.
     * @see #resetFieldFinder()
     * @see #findField(String)
     * @see #findNextSubrecordField(String)
     * @see #findNextSubrecordFieldSameClass(String)
     * @see #sortFields(List)
     */
    public FilemanField findNextSubrecordFieldSameSubKey(final String filemanPrompt) {
        for (int idx = fields.indexOf(prevSubrecordField) + 1; idx < fields.size(); idx++) {
            final FilemanField field = fields.get(idx);
            if (field.isSubRecordField()
             && field.getFilemanName().equals(filemanPrompt)
             && field.isSameClassNum(prevSubrecordField)
             && field.isSameSubrecordKey(prevSubrecordField)) {
                return field;
            }
        }

        return null;
    }

    @Override
    public String toString() {
        return "FilemanDataDictionary [fileName=" + fileName + ", fields=" + fields + "]";
    }
}
