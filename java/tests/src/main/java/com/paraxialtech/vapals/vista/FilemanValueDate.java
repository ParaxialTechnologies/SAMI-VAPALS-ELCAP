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

    public FilemanValueDate(final LocalDate value) {
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
        StringBuilder builder = new StringBuilder();
        builder.append("FilemanValueString [value=").append(value).append("]");
        return builder.toString();
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((value == null) ? 0 : value.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        FilemanValueDate other = (FilemanValueDate) obj;
        if (value == null) {
            if (other.value != null)
                return false;
        } else if (!value.equals(other.value))
            return false;
        return true;
    }
}
