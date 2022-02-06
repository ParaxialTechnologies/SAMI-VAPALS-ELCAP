/**
 * The jQuery plugin namespace.
 * @external "jQuery.fn"
 * @see {@link http://learn.jquery.com/plugins/|jQuery Plugins}
 */


const AI = class {
    static revertData() {
        $("#nodule-table").find("[" + AI.IMPORT_ORIGINAL_VALUE_ATTR + "]").each(function () {
            if ($(this).hasClass(AI.IMPORT_FIELD_CLASS)) {
                if ($(this).prop('type') === "checkbox") {
                    if ($(this).attr(AI.IMPORT_ORIGINAL_VALUE_ATTR) === "false") {
                        $(this).prop("checked", false);
                    } else {
                        $(this).prop("checked", true);
                    }
                } else {
                    $(this).val($(this).attr(AI.IMPORT_ORIGINAL_VALUE_ATTR));
                }
                $(this).removeAttr(AI.IMPORT_ORIGINAL_VALUE_ATTR);
                $(this).removeAttr(AI.IMPORT_VALUE_ATTR);
                $(this).removeClass(AI.IMPORT_FIELD_CLASS);
            }
        });
        $("#nodule-table").find("." + AI.IMPORT_FIELD_CLASS).each(function () {
            $(this).removeClass(AI.IMPORT_FIELD_CLASS);
        });
        $("#nodule-table").find("." + AI.IMPORT_DATA_PARENT_CLASS).each(function () {
            $(this).removeClass(AI.IMPORT_DATA_PARENT_CLASS);
        });

        // for fields not in "#nodule-table"
        $("." + AI.IMPORT_FIELD_CLASS).each(function () {
            $(this).val($(this).attr(AI.IMPORT_ORIGINAL_VALUE_ATTR));
            if ($(this).attr("id") === "cectrst") {
                if ($(this).attr(AI.IMPORT_ORIGINAL_VALUE_ATTR) == "o") {
                    $("#cectrsto-container").show();
                } else {
                    $("#cectrsto-container").hide();
                }
            }
            $(this).removeAttr(AI.IMPORT_ORIGINAL_VALUE_ATTR);
            $(this).removeAttr(AI.IMPORT_VALUE_ATTR);
            $(this).removeClass(AI.IMPORT_FIELD_CLASS);
        });

        AI.removeImportIcons();
    }


    static revertField(element, fieldSelector) {
        const $ele = $(fieldSelector);
        let importValue = "";
        if ($ele.hasClass(AI.IMPORT_FIELD_CLASS)) {
            if ($ele.prop('type') === "checkbox") {
                if ($ele.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR) === "false") {
                    $ele.prop("checked", true);
                } else {
                    $ele.prop("checked", false);
                }
                if ($ele.attr(AI.IMPORT_VALUE_ATTR) === "false") {
                    importValue = "unchecked";
                } else {
                    importValue = "checked";
                }
            } else {
                $ele.val($ele.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR));

                if ($ele.prop('type') === "select-one") {
                    const fieldSelectorWithVal = fieldSelector + " option[value=\"" + $ele.attr(AI.IMPORT_VALUE_ATTR) + "\"]";
                    importValue = $(fieldSelectorWithVal).text().trim();
                } else {
                    importValue = $ele.attr(AI.IMPORT_VALUE_ATTR);
                }
            }

            $(element).tooltip('destroy').remove();

            if (fieldSelector === "#cedos") {
                AI.createImportElement(fieldSelector, importValue).insertAfter($("#cedos-addon").parent().parent());
            } else {
                AI.createImportElement(fieldSelector, importValue).insertAfter(fieldSelector);
                if (fieldSelector === "#cectrst") {
                    if ($ele.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR) == "o") {
                        $("#cectrsto-container").show();
                    } else {
                        $("#cectrsto-container").hide();
                    }
                }
            }
        }
    }

    static createImportElement(fieldName, importValue) {
        const html = "<i data-toggle=\"tooltip\" class=\"fa fa-repeat " + AI.IMPORT_ICON_CLASS + "\" title=\"Import '" +
            importValue + "'\"" + " onclick=\"AI.importField(this, '" + fieldName + "')\"></i>";
        const $importElement = $(html);
        $importElement.tooltip();
        return $importElement;
    }


    static importField(element, fieldSelector) {
        const $ele = $(fieldSelector);
        let origValue = "";
        if ($ele.hasClass(AI.IMPORT_FIELD_CLASS)) {
            if ($ele.prop('type') === "checkbox") {
                if ($ele.attr(AI.IMPORT_VALUE_ATTR) === "false") {
                    $ele.prop("checked", true);
                } else {
                    $ele.prop("checked", false);
                }
                if ($ele.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR) === "false") {
                    origValue = "unchecked";
                } else {
                    origValue = "checked";
                }
            } else {
                $ele.val($ele.attr(AI.IMPORT_VALUE_ATTR));

                if ($ele.prop('type') === "select-one") {
                    const fieldSelectorWithVal = fieldSelector + " option[value=\"" + $ele.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR) + "\"]";
                    origValue = $(fieldSelectorWithVal).text().trim();
                } else {
                    origValue = $ele.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR);
                }
            }

            $(element).tooltip('destroy').remove();

            if (fieldSelector === "#cedos") {
                AI.createRevertElement(fieldSelector, origValue).insertAfter($("#cedos-addon").parent().parent());
            } else {
                AI.createRevertElement(fieldSelector, origValue).insertAfter(fieldSelector);
                if (fieldSelector === "#cectrst") {
                    if ($ele.attr(AI.IMPORT_VALUE_ATTR) == "o") {
                        $("#cectrsto-container").show();
                    } else {
                        $("#cectrsto-container").hide();
                    }
                }
            }
        }
    }

    static createRevertElement(fieldName, originalValue) {
        const html = "<i data-toggle=\"tooltip\" class=\"fa fa-undo " + AI.REVERT_ICON_CLASS + "\" title=\"Revert to '" +
            originalValue + "'\"" + " onclick=\"AI.revertField(this, '" + fieldName + "')\"></i>";
        const $revertElement = $(html);
        $revertElement.tooltip();
        return $revertElement;
    }

    static queryStructuredReport(studyId, siteId, callback) {
        console.debug("AI.queryStructuredReport(): studyId=%s, siteId=%s", studyId, siteId);
        $.ajax(("/dcmquery/?studyId=" + studyId + "&siteId=" + siteId), {dataType: "json"})
            .done(function (json) {
                if (json.result !== undefined && json.result.length > 0) {
                    const sr = json.result[0]; //temporarily pick the first one. TODO: find one closest to study date.
                    callback(sr)
                }
            });
    }

    static displayModal(importDicomCallback, importAICallback) {
        $("#dataImportModal")
            .on("click", ".importDICOM", importDicomCallback)
            .on("click", ".importAI", importAICallback)
            .modal('show');
    }

    static removeImportIcons() {
        $("." + AI.REVERT_ICON_CLASS).remove();
        $("." + AI.IMPORT_ICON_CLASS).remove();
    }
}
AI.SR_PATIENT_STUDY_DETAILS_KEY = "patient_study_details";
AI.SR_NODULES_KEY = "nodules";
AI.IMPORT_FIELD_CLASS = "import-field"; // Added to input fields that have had their value imported
AI.IMPORT_ORIGINAL_VALUE_ATTR = "original-value"; // Attribute name used to track original value of a field before import
AI.IMPORT_VALUE_ATTR = "import-value"; // Attribute name used to track imported data value, for the purpose of revert
AI.IMPORT_DATA_PARENT_CLASS = "import-data-parent"; // Class used to wrap some fields
AI.IMPORT_ICON_CLASS = "import-field";
AI.REVERT_ICON_CLASS = "revert-field";
