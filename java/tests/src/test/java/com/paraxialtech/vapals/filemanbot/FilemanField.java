package com.paraxialtech.vapals.filemanbot;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

/**
 * Rrepresent a Field in a Fileman file.
 * <p/>
 * An instance of this class represents the actual field.
 *
 * @author Keith Powers
 */
public class FilemanField {
    public String filemanName;
    public String webName;
    public String[] classNum;
    public BigDecimal propNum;

    /**
     * Static constructor generated from a definition file.
     *
     * @param definitionFilePath
     * @return
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
                    field.propNum = new BigDecimal(item);
                    break;
                // TODO more
            }
        }

        return field;
    }

    /* ----==== auto-generated code ====---- */

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + Arrays.hashCode(classNum);
        result = prime * result + ((filemanName == null) ? 0 : filemanName.hashCode());
        result = prime * result + ((propNum == null) ? 0 : propNum.hashCode());
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
        FilemanField other = (FilemanField) obj;
        if (!Arrays.equals(classNum, other.classNum))
            return false;
        if (filemanName == null) {
            if (other.filemanName != null)
                return false;
        } else if (!filemanName.equals(other.filemanName))
            return false;
        if (propNum == null) {
            if (other.propNum != null)
                return false;
        } else if (!propNum.equals(other.propNum))
            return false;
        return true;
    }


}
