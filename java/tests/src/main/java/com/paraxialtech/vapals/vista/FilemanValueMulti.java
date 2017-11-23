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

    public FilemanValueMulti(final Collection<FilemanValue> values) {
        values.addAll(values);
    }

    public Set<FilemanValue> getValues() {
        return values;
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("FilemanValueMulti [values=").append(values).append("]");
        return builder.toString();
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((values == null) ? 0 : values.hashCode());
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
        FilemanValueMulti other = (FilemanValueMulti) obj;
        if (values == null) {
            if (other.values != null)
                return false;
        } else if (!values.equals(other.values))
            return false;
        return true;
    }

}
