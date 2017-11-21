package com.paraxialtech.vapals.vista;

/**
 * Represent a string value of a field in a Fileman file.
 * <p/>
 * An instance of this class represents the actual enumerated value.
 *
 * @author Keith Powers
 */
public final class FilemanValueString implements FilemanValue {
    private final String value;

    public FilemanValueString(final String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("FilemanValueString [value=\"").append(value).append("\"]");
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
        FilemanValueString other = (FilemanValueString) obj;
        if (value == null) {
            if (other.value != null)
                return false;
        } else if (!value.equals(other.value))
            return false;
        return true;
    }
}
