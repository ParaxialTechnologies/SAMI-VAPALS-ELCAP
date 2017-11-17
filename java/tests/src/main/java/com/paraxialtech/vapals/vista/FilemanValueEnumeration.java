package com.paraxialtech.vapals.vista;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.google.common.base.Preconditions;

/**
 * Represent a (possible or actual) value of an enumerated field in a Fileman file.
 * <p/>
 * An instance of this class represents the actual enumerated value.
 *
 * @author Keith Powers
 */
public final class FilemanValueEnumeration {
    private String filemanValue;
    private String webValue;
    private String shortcut;

    private FilemanValueEnumeration() {
        //prevent public instantiation
    }

    public String getFilemanValue() {
        return filemanValue;
    }

    public String getWebValue() {
        return webValue;
    }

    public void setWebValue(final String webValue) {
        this.webValue = webValue;
    }

    public String getShortcut() {
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
}
