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
