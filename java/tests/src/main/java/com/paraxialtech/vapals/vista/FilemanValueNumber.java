package com.paraxialtech.vapals.vista;

import java.math.BigDecimal;

/**
 * Represent a numeric value of a field in a Fileman file.
 *
 * @author Keith Powers
 */
public final class FilemanValueNumber implements FilemanValue {

    private final BigDecimal value;

    public FilemanValueNumber(final String value) {
        this.value = new BigDecimal(value);
    }

    // Package-private getters / setters.

    BigDecimal getValue() {
        return value;
    }

    @Override
    public String toFileman() {
        return value.toPlainString();
    }

    @Override
    public String toWeb() {
        return value.toString();
    }

    @Override
    public String toString() {
        return "FilemanValueNumber{" +
                "value=" + value +
                '}';
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof FilemanValueNumber)) {
            return false;
        }

        final FilemanValueNumber that = (FilemanValueNumber) o;

        return value != null ? value.equals(that.value) : that.value == null;
    }

    @Override
    public int hashCode() {
        return value != null ? value.hashCode() : 0;
    }
}
