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
    public static FilemanValueEnumeration constructValueFromValue(final String valueDefinition) {
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
        StringBuilder builder = new StringBuilder();
        builder.append("FilemanValueEnumeration [filemanValue=").append(filemanValue).append(", webValue=")
                .append(webValue).append(", shortcut=").append(shortcut).append("]");
        return builder.toString();
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((filemanValue == null) ? 0 : filemanValue.hashCode());
        result = prime * result + ((shortcut == null) ? 0 : shortcut.hashCode());
        result = prime * result + ((webValue == null) ? 0 : webValue.hashCode());
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
        FilemanValueEnumeration other = (FilemanValueEnumeration) obj;
        if (filemanValue == null) {
            if (other.filemanValue != null)
                return false;
        } else if (!filemanValue.equals(other.filemanValue))
            return false;
        if (shortcut == null) {
            if (other.shortcut != null)
                return false;
        } else if (!shortcut.equals(other.shortcut))
            return false;
        if (webValue == null) {
            if (other.webValue != null)
                return false;
        } else if (!webValue.equals(other.webValue))
            return false;
        return true;
    }
}
