package com.paraxialtech.vapals.vista;

import java.util.Arrays;
import java.util.List;

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

    /**
     * Static constructor generated from a definition file.
     *
     * @param items delimited values from a CSV
     * @param fieldTitles the title of the fields
     * @return fileman field definition
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
                // TODO more
            }
        }

        return field;
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
}
