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
