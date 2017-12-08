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

    // Package-private getters / setters.

    String getValue() {
        return value;
    }

    @Override
    public String toFileman() {
        return value;
    }

    @Override
    public String toWeb() {
        return value;
    }

    @Override
    public String toString() {
        return "FilemanValueString{" +
                "value='" + value + '\'' +
                '}';
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof FilemanValueString)) {
            return false;
        }

        final FilemanValueString that = (FilemanValueString) o;

        return value != null ? value.equals(that.value) : that.value == null;
    }

    @Override
    public int hashCode() {
        return value != null ? value.hashCode() : 0;
    }
}
