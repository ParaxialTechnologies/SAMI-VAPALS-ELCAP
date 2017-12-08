package com.paraxialtech.vapals.vista;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

/**
 * Represent a grouping of more than one selected values.
 *
 * @author Keith Powers
 */
public final class FilemanValueMulti implements FilemanValue {
    private final Set<FilemanValue> values = new HashSet<>();

    public FilemanValueMulti(final Collection<? extends FilemanValue> values) {
        this.values.addAll(values);
    }

    // Package-private getters / setters.

    Set<FilemanValue> getValues() {
        return values;
    }

    @Override
    public String toFileman() {
        return null;    // TODO
    }

    @Override
    public String toWeb() {
        return null;    // TODO
    }

    @Override
    public String toString() {
        return "FilemanValueMulti{" +
                "values=" + values +
                '}';
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof FilemanValueMulti)) {
            return false;
        }

        final FilemanValueMulti that = (FilemanValueMulti) o;

        return values != null ? values.equals(that.values) : that.values == null;
    }

    @Override
    public int hashCode() {
        return values != null ? values.hashCode() : 0;
    }
}
