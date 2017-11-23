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
        FilemanValueNumber other = (FilemanValueNumber) obj;
        if (value == null) {
            if (other.value != null)
                return false;
        } else if (!value.equals(other.value))
            return false;
        return true;
    }
}
