/*
 * Copyright (c) 2019 Early Diagnosis and Treatment Research Foundation, Vista Expertise Network (VEN), and Paraxial
 *
 * The original management system was created and donated by Early Diagnosis and Treatment Research Foundation within the
 * International Early Lung Cancer Action Program (I-ELCAP), an international program of lung cancer screening.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at: http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

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
