package com.paraxialtech.vapals.vista;

/**
 * Blank interface to make our lives easier when reading values.
 *
 * @author Keith Powers
 */
public interface FilemanValue {
    FilemanValue NO_VALUE = new FilemanValueNothing();

    /**
     * Get a String that, if typed into Fileman's Roll N Scroll interface, would
     * store the desired value in Vista.
     *
     * @return A String suitable for exporting this value out to Vista via the
     *         Fileman interface.
     */
    String toFileman();

    /**
     * Get a String that, if typed into the web interface, would store the desired
     * value in the Vista.
     *
     * @return A String suitable for exporting this value out to Vista via the web
     *         interface.
     */
    String toWeb();

    /**
     * Package-private class because is should be accessed via
     * {@linkplain FilemanValue#NO_VALUE}.
     *
     * @author Keith Powers
     */
    final class FilemanValueNothing implements FilemanValue {

        @Override
        public String toFileman() {
            return "";
        }

        @Override
        public String toWeb() {
            return "";
        }

        @Override
        public String toString() {
            return "FilemanValueNothing{}";
        }

        @Override
        public boolean equals(final Object obj) {
            return this == obj;
        }

        @Override
        public int hashCode() {
            return 0;
        }
    }
}
