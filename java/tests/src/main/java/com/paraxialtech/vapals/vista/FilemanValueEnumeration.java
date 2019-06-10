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

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.google.common.base.Preconditions;

/**
 * Represent a (possible or actual) value of an enumerated field in a Fileman file.
 *
 * @author Keith Powers
 */
public final class FilemanValueEnumeration implements FilemanValue {
    private String filemanValue;
    private String webValue;
    private String shortcut;

    private FilemanValueEnumeration() {
        //prevent public instantiation
    }

    // Package-private getters / setters.

    String getFilemanValue() {
        return filemanValue;
    }

    String getWebValue() {
        return webValue;
    }

    void setWebValue(final String webValue) {
        this.webValue = webValue;
    }

    String getShortcut() {
        return shortcut;
    }

    /**
     * Static constructor to construct a shortcut-value map from the "m-prop-det"
     * value list field in a definition file.
     *
     * @param valueListDefinition
     *            The whole value of the "m-prop-det" field in a definition file.
     *            This is expected to be a semicolon-delimited list of individual values;.
     * @return
     */
    public static Map<String, FilemanValueEnumeration> constructMapFromValueList(final String valueListDefinition) {
        Preconditions.checkNotNull(valueListDefinition);

        final Map<String, FilemanValueEnumeration> shortcutToValueMap = new LinkedHashMap<>();

        if (valueListDefinition.trim().length() > 0) {
            FilemanValueEnumeration value;
            for (final String valueDefinition : valueListDefinition.split(";")) {
                value = constructValueFromValue(valueDefinition);
                shortcutToValueMap.put(value.shortcut, value);
            }
        }

        return shortcutToValueMap;
    }

    /**
     * Static constructor to generate a single value from one item in the
     * "m-prop-det" list in a definition file.
     *
     * @param valueDefinition
     *            a definition of the value in "shortcut:fileman value" format.
     * @return a value for
     */
    private static FilemanValueEnumeration constructValueFromValue(final String valueDefinition) {
        Preconditions.checkNotNull(valueDefinition);

        final FilemanValueEnumeration value = new FilemanValueEnumeration();

        final String[] pair = valueDefinition.split(":");
        value.shortcut = pair[0];
        value.filemanValue = pair[1];

        return value;
    }

    /**
     * Static constructor to generate a single value from one line in the definition
     * file. May return <code>null</code> if the given line does not define an
     * enumerated value.
     *
     * @param items
     *            delimited values from a CSV
     * @param fieldTitles
     *            the title of the fields
     * @return an enumerated value for the given line, or <code>null</code> if the
     *         line does not define a value.
     * @see FilemanField#constructFromArray(List, List)
     */
    public static FilemanValueEnumeration constructValueFromArray(final List<String> items,
                                                                  final List<String> fieldTitles) {
        final FilemanValueEnumeration value = new FilemanValueEnumeration();

        String item;
        for (int index = 0; index < items.size(); index++) {
            item = items.get(index);
            switch (fieldTitles.get(index)) {
                case "Value":
                    value.shortcut = item;
                    break;
                case "Definition":
                    value.webValue = item;
                    break;
            }
        }

        if (value.shortcut == null || value.shortcut.trim().length() == 0/* ||  // TODO: unsure how strict we need to be here
            value.webValue == null || value.webValue.trim().length() == 0*/) {
            return null;
        }

        return value;
    }

    @Override
    public String toFileman() {
        return filemanValue;
    }

    @Override
    public String toWeb() {
        return webValue;
    }

    @Override
    public String toString() {
        return "FilemanValueEnumeration{" +
                "filemanValue='" + filemanValue + '\'' +
                ", webValue='" + webValue + '\'' +
                ", shortcut='" + shortcut + '\'' +
                '}';
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof FilemanValueEnumeration)) {
            return false;
        }

        final FilemanValueEnumeration that = (FilemanValueEnumeration) o;

        if (filemanValue != null ? !filemanValue.equals(that.filemanValue) : that.filemanValue != null) {
            return false;
        }
        if (webValue != null ? !webValue.equals(that.webValue) : that.webValue != null) {
            return false;
        }
        return shortcut != null ? shortcut.equals(that.shortcut) : that.shortcut == null;
    }

    @Override
    public int hashCode() {
        int result = filemanValue != null ? filemanValue.hashCode() : 0;
        result = 31 * result + (webValue != null ? webValue.hashCode() : 0);
        result = 31 * result + (shortcut != null ? shortcut.hashCode() : 0);
        return result;
    }
}
