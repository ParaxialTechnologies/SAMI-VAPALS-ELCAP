package com.paraxialtech.vapals.vista;

/**
 * Blank interface to make our lives easier when reading values.
 *
 * @author Keith Powers
 */
public interface FilemanValue {
    public static FilemanValue NO_VALUE = new FilemanValueNothing();

    /**
     * Package-private class because is should be accessed via
     * {@linkplain FilemanValue#NO_VALUE}.
     *
     * @author Keith Powers
     */
    static final class FilemanValueNothing implements FilemanValue {

        @Override
        public String toString() {
            StringBuilder builder = new StringBuilder();
            builder.append("FilemanValueNothing []");
            return builder.toString();
        }

        @Override
        public boolean equals(Object obj) {
            return this == obj;
        }

        @Override
        public int hashCode() {
            return 0;
        }
    }
}
