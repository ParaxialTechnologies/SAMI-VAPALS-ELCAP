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

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;

/**
 * Represent a date value of a field in a Fileman file.
 * <p/>
 * TODO: should this class be FilemanValueTemporal instead, because we also have
 * 'year' values? Or should we have FilemanValueYear instead? Or is
 * FilemanValueNumber sufficient?
 *
 *
 * @author Keith Powers
 */
public final class FilemanValueDate implements FilemanValue {
    private static final DateTimeFormatter FILEMAN_DATE_FORMAT = new DateTimeFormatterBuilder().parseCaseInsensitive().appendPattern("MMM d[d],yyyy").toFormatter();
    private static final DateTimeFormatter FILEMAN_DATE_FORMAT_OUT = new DateTimeFormatterBuilder().appendPattern("MMM dd, yyyy").toFormatter();
    private static final DateTimeFormatter WEB_DATE_FORMAT = new DateTimeFormatterBuilder().parseCaseInsensitive().appendPattern("dd/MMM/yyyy").toFormatter();

    private final LocalDate value;

    private FilemanValueDate(final LocalDate value) {
        this.value = value;
    }

    // Package-private getters / setters.

    LocalDate getValue() {
        return value;
    }

    public static FilemanValueDate fromFileman(final String value) {
        return new FilemanValueDate(LocalDate.parse(value, FILEMAN_DATE_FORMAT));
    }

    public static FilemanValueDate fromWeb(final String value) {
        return new FilemanValueDate(LocalDate.parse(value, WEB_DATE_FORMAT));
    }

    @Override
    public String toFileman() {
        return FILEMAN_DATE_FORMAT_OUT.format(value);
    }

    @Override
    public String toWeb() {
        return WEB_DATE_FORMAT.format(value);
    }

    @Override
    public String toString() {
        return "FilemanValueDate{" +
                "value=" + value +
                '}';
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof FilemanValueDate)) {
            return false;
        }

        final FilemanValueDate that = (FilemanValueDate) o;

        return value != null ? value.equals(that.value) : that.value == null;
    }

    @Override
    public int hashCode() {
        return value != null ? value.hashCode() : 0;
    }
}
