package com.paraxialtech.vapals.vista;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import com.google.common.base.Preconditions;

/**
 * Represent a Field in a Fileman file.
 * <p/>
 * An instance of this class represents the actual field.
 *
 * @author Keith Powers
 */
public final class FilemanField {
    private String filemanName;
    private String webName;
    private String[] classNum;
    private double propNum;
    private DataTypeEnum dataType;
    private Map<String, FilemanValueEnumeration> possibleValues;

    private FilemanField() {
        //prevent public instantiation
    }

    public String getFilemanName() {
        return filemanName;
    }

    public String getWebName() {
        return webName;
    }

    public String[] getClassNum() {
        return classNum;
    }

    public Double getPropNum() {
        return propNum;
    }

    public DataTypeEnum getDataType() {
        return dataType;
    }

    public Map<String, FilemanValueEnumeration> getPossibleValues() {
        return possibleValues;
    }

    /**
     * Static constructor generated from a definition file.
     *
     * @param items delimited values from a CSV
     * @param fieldTitles the title of the fields
     * @return fileman field definition
     * @see FilemanValueEnumeration#constructValueFromArray(List, List)
     */
    public static FilemanField constructFromArray(final List<String> items,
                                                  final List<String> fieldTitles) {
        final FilemanField field = new FilemanField();

        String item;
        for (int index = 0; index < items.size(); index++) {
            item = items.get(index);
            switch (fieldTitles.get(index)) {
                case "m-prop-name":
                    field.filemanName = item;
                    break;
                case "Field Name":
                    field.webName = item;
                    break;
                case "m-class-#":
                    field.classNum = item.split("\\.");
                    break;
                case "m-prop-#":
                    field.propNum = Double.parseDouble(item);
                    break;
                case "Data Type":
                    field.dataType = DataTypeEnum.valueOf(item);
                    break;
                case "m-prop-det":  // This value comes after "Data Type" so we can assume a non-null dataType value, but we don't
                    Preconditions.checkNotNull(field.dataType);
                    if (Preconditions.checkNotNull(field.dataType).isEnumeration()) {
                        field.possibleValues = FilemanValueEnumeration.constructMapFromValueList(item);
                        field.mergeWithWebFieldValue(FilemanValueEnumeration.constructValueFromArray(items, fieldTitles));
                    }
                    break;
                // TODO more
            }
        }

        return field;
    }

    /**
     * Take a web field value that was constructed from a definition file (on a
     * different line than the Fileman field values) and merge its value into the
     * list of possible values.
     *
     * @param webFieldValue
     *            A possibly-<code>null</code> web field value constructed from a
     *            line in the definition file.
     */
    void mergeWithWebFieldValue(final FilemanValueEnumeration webFieldValue) {
        if (webFieldValue == null) {
            return;
        }

        final FilemanValueEnumeration filemanFieldValue = this.possibleValues.get(webFieldValue.getShortcut());
        if (filemanFieldValue == null) {
            // TODO: We now have a possible web field value without a corresponding fileman field value. What do we do about this?
            this.possibleValues.put(webFieldValue.getShortcut(), webFieldValue);
        } else {
            filemanFieldValue.setWebValue(webFieldValue.getWebValue());
        }
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof FilemanField)) {
            return false;
        }

        final FilemanField that = (FilemanField) o;

        if (Double.compare(that.propNum, propNum) != 0) {
            return false;
        }
        if (filemanName != null ? !filemanName.equals(that.filemanName) : that.filemanName != null) {
            return false;
        }
        if (webName != null ? !webName.equals(that.webName) : that.webName != null) {
            return false;
        }
        // Probably incorrect - comparing Object[] arrays with Arrays.equals
        return Arrays.equals(classNum, that.classNum);
    }

    @Override
    public int hashCode() {
        int result;
        long temp;
        result = filemanName != null ? filemanName.hashCode() : 0;
        result = 31 * result + (webName != null ? webName.hashCode() : 0);
        result = 31 * result + Arrays.hashCode(classNum);
        temp = Double.doubleToLongBits(propNum);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        return result;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("FilemanField{");
        sb.append("filemanName='").append(filemanName).append('\'');
        sb.append(", webName='").append(webName).append('\'');
        sb.append(", classNum=").append(Arrays.toString(classNum));
        sb.append(", propNum=").append(propNum);
        sb.append('}');
        return sb.toString();
    }

    public enum DataTypeEnum {
        CHECKBOX (true),
        DATE     (false),
        INTEGER  (false),
        PNUM     (false),   // What is this? a calculated number?
        PULLDOWN (true),
        RADIO    (true),
        RDATE    (false),
        REAL     (false),
        TEXT     (false),
        YEAR     (false);

        private boolean enumeratedValues;
        private DataTypeEnum(final boolean enumeratedValues) {
            this.enumeratedValues = enumeratedValues;
        }

        /**
         * Whether the value for this data type must conform to one of the enumerated
         * values, or whether it may be freely-entered.
         *
         * @return <code>true</code> if this data type is an enumeration,
         *         <code>false</code> otherwise.
         */
        public boolean isEnumeration() {
            return enumeratedValues;
        }
    }
}
