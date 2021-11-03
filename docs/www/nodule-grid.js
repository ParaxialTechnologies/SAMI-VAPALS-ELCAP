/**
 * The jQuery plugin namespace.
 * @external "jQuery.fn"
 * @see {@link http://learn.jquery.com/plugins/|jQuery Plugins}
 */

/**
 * A jQuery plugin to manage a nodule grid
 * @link https://github.com/OSEHRA/VA-PALS
 * @author Domenic DiNatale <domenic.dinatale@paraxialtech.com>
 * @license [Apache-2.0]{@link https://www.apache.org/licenses/LICENSE-2.0.html}
 * @copyright 2018 [VAPALS-ELCAP]{@link http://va-pals.org/}
 * @param {string|function} [options.availableNodules="10"] - number of nodules externally rendered in the grid. Depends on _nodule-grid.jinja2
 * @param {string|function|object} [options.getNoduleCount=fn()] - function used to get the number of visible nodules
 * @param {string|function|object} [options.setNoduleCount=fn(noduleCount)] - function used to set the number of visible nodules


 * @todo add github link, author, copyright, license information
 * @class noduleGrid
 * @memberof jQuery
 */
(function ($) {
    $.extend({
        noduleGrid: function (options) {
            const settings = $.extend({
                availableNodules: 10,
                getNoduleCount: function () {
                    return 0;
                },
                setNoduleCount: function (noduleCount) {
                    return noduleCount;
                },
            }, options);


            function setupNoduleEnabledState(noduleId) {
                $("#cect" + noduleId + "nt").conditionallyEnable({
                    sourceValues: "m",
                    enable: "#cect" + noduleId + "-container"
                });

                $("#cect" + noduleId + "ch").on('change.cteval', function () {
                    toggleFields(noduleId);
                });

                const currentIsItNewValue = $("#cect" + noduleId + "ch").val();
                // console.log("setupNoduleEnabledState(noduleIndex=" + noduleId + "): currentIsItNewValue=" + currentIsItNewValue);
                if (currentIsItNewValue !== '-') {
                    toggleFields(noduleId);
                }
            }

            function toggleFields(noduleId) {
                // const logPrefix = 'toggleFields(noduleIndex=' + noduleId + '): ';
                // console.log(logPrefix + 'entered');

                // $fields is an array of fields related to this nodule with the exception of "is it new"
                // NB: Note that we use regex instead of startsWith and endsWith jQuery selectors because
                // nodule 10 would match cect1*
                const regex = new RegExp("cect" + noduleId + "[a-z]");
                let $fields = $('input,select').filter(function () {
                    const name = $(this).attr('name');
                    const id = $(this).attr('id');
                    return id !== "cect" + noduleId + "ch" && (regex.test(name) || regex.test(id));
                });
                let isItNewValue = $("#cect" + noduleId + "ch").val();
                // console.log(logPrefix + 'isItNewValue=' + isItNewValue);
                // if the "is it new" selection is a value that means the nodule is no longer present or otherwise
                // resolved, clear MOST fields. These values include: resolved (pw), not a nodule (px),
                // resected (pr)
                // NB: For IE support, we must use indexOf() instead of .includes(...);
                let noduleResolved = ['pw', 'px', 'pr'].indexOf(isItNewValue) > -1;
                // console.log(logPrefix + 'noduleResolved=' + noduleResolved);
                if (noduleResolved) {
                    //reduce the list to exclude the fields: status (st) and likely location (ll)
                    $fields = $fields.filter(function () {
                        const id = $(this).attr('id');
                        const idsToMatch = [
                            'cect' + noduleId + 'll', // likely location
                            'cect' + noduleId + 'st', // nodule status
                            'cect' + noduleId + 'pd', // pathological diagnosis
                        ];
                        // NB: For IE support, we must use indexOf() instead of !idsToMatch.includes(...);
                        return idsToMatch.indexOf(id) === -1;
                    })
                }

                if (isItNewValue === "-" || noduleResolved) {
                    // console.log(logPrefix + 'disabling fields');
                    //empty out values
                    $fields.filter("select").val("-");
                    $fields.filter(":radio, :checkbox").prop('checked', false);
                    $fields.filter(":text").val("");

                    //change trigger added to clear any calculated text values
                    $fields.trigger("change");

                    //reset form validation messages (hide them)
                    const fv = $("form.validated").data("formValidation");
                    if (fv) {
                        $.each($fields, function (i, el) {
                            const fieldName = $(el).prop('name');
                            if (fv.fields[fieldName]) {
                                fv.resetField(fieldName);
                            }
                        });
                    }

                    //finally disable the fields
                    $fields.prop('disabled', true);
                } else { //re-enable fields
                    // console.log(logPrefix + 'enabling fields');
                    $fields
                        .prop('disabled', false)
                        .trigger('change.conditionally-enable'); //set state according to other rules (i.e. part-solid fields)

                    // fixes a bug where L & W fields were required when nodule was solid and "is it new" was
                    // changed from "-" to anything else; which occurs on subsequent scans.
                    $("#cect" + noduleId + "nt").trigger('change');
                }
                if (isItNewValue === "pw") {
                    $("#cect" + noduleId + "st").val("re");
                } else {
                    if ($("#cect" + noduleId + "st").val() === "re") {
                        $("#cect" + noduleId + "st").val("-");
                    }
                }
                // console.log(logPrefix + 'exiting');
            }

            function mean(v1, v2) {
                const w = v1 ? Number(v1) : 0;
                const l = v2 ? Number(v2) : 0;

                if (w > 0 && l > 0) {
                    return (l + w) / 2;
                } else {
                    return 0;
                }
            }

            function setupMeanDiameterCalculation(lengthFieldSuffix, widthFieldSuffix, labelSuffix) {
                const lengthFields = $("[name^=cect][name$=" + lengthFieldSuffix + "],[name^=cect][name$=" + widthFieldSuffix + "]");
                lengthFields.on('keyup change', function (e) {
                    const targetField = $(e.target);
                    const noduleId = targetField.closest("td").attr("data-nodule-id");
                    const noduleDiamLabel = $("#cect" + noduleId + labelSuffix);
                    const widthValue = $("#cect" + noduleId + widthFieldSuffix).val();
                    const lengthValue = $("#cect" + noduleId + lengthFieldSuffix).val();
                    const m = mean(widthValue, lengthValue);

                    if (m > 0) {
                        noduleDiamLabel.text(m.toFixed(1));
                    } else {
                        noduleDiamLabel.text("-");
                    }
                }).first().trigger('change');
            }

            // noinspection JSUnusedLocalSymbols
            function checkConsistentVolumeCalculations() {
                const overrideValues = $(".volume-override-flag").map(function (idx, elem) {
                    return $(elem).val();
                }).filter(function (idx, v) {
                    return v !== ""
                });

                if (overrideValues.length > 0) {
                    let identicalElems = true;
                    for (let i = 1; i < overrideValues.length; i++) {
                        if (overrideValues[i] !== overrideValues[0]) {
                            identicalElems = false;
                            break;
                        }
                    }

                    if (!identicalElems) {
                        VAPALS.displayNotification(
                            "Warning : Inconsistent measuring techniques!",
                            "The volume measuring techniques are inconsistent, some values of the 'Volume' field are calculated, others manually entered. " +
                            "It is recommended that the volume for all nodes is specified using the same method. " +
                            "Please review and update the values in the 'Volume' fields for all nodules",
                            BootstrapDialog.TYPE_WARNING
                        );
                    }
                }

            }

            function markNoduleVolumeManuallyEntered(noduleId, isManual) {
                // console.log("markNoduleVolumeManuallyEntered() noduleId=" + noduleId + ", isManual=" + isManual)
                if (isManual) {
                    $("#cect" + noduleId + "sv").addClass("volumeOverride");
                    $("#cect" + noduleId + "svovrrde").val("true");
                    $("#cect" + noduleId + "svovrrde-warn").removeClass("invisible");
                } else {
                    $("#cect" + noduleId + "sv").removeClass("volumeOverride");
                    // set the manually overriden hidden field to false
                    $("#cect" + noduleId + "svovrrde").val("false");
                    $("#cect" + noduleId + "svovrrde-warn").addClass("invisible");
                }
            }

            function setupNoduleVolumeCalculations(noduleId) {
                const lenWidthHeightFields = $("#cect" + noduleId + "sl, #cect" + noduleId + "sw, #cect" + noduleId + "sh");
                lenWidthHeightFields.on("keyup", function () {
                    let allFilled = true;

                    lenWidthHeightFields.each(function () {
                        const v = $(this).val() || 0;
                        if (v == 0) {
                            allFilled = false;
                        }
                    });

                    const btnElem = $("#cect" + noduleId + "svb");
                    if (allFilled) {
                        btnElem.attr("disabled", false);
                    } else {
                        btnElem.attr("disabled", true);
                    }
                }).first().trigger("keyup");

                $("#cect" + noduleId + "svb").on('click', function () {
                    const l = $("#cect" + noduleId + "sl").val() || 0;
                    const w = $("#cect" + noduleId + "sw").val() || 0;
                    const h = $("#cect" + noduleId + "sh").val() || 0;

                    const v = Math.PI * (4 / 3) * l / 2 * w / 2 * h / 2;

                    $("#cect" + noduleId + "sv").val(v.toFixed(1));
                    markNoduleVolumeManuallyEntered(noduleId, false);
                    //temporarily disabled
                    // checkConsistentVolumeCalculations();
                    return false;
                });


                $("#cect" + noduleId + "sv").on('change', function () {
                    // manually overriding the volume calculation
                    if ($(this).val() !== "") {
                        markNoduleVolumeManuallyEntered(noduleId, true);
                        //temporarily disabled
                        //checkConsistentVolumeCalculations();
                    }
                });
            }

            function _sortData() {
                let sorted = false;
                //i = index based. Start at 1 because if there's only 1 nodule no sorting.
                for (let i = 1; i < settings.getNoduleCount(); i++) {
                    let index = i;
                    while (index > 0 && getNoduleSizeForSorting(index) > getNoduleSizeForSorting(index - 1)) {
                        swapFields(index, index - 1);
                        sorted = true;
                        index--;
                    }
                }

                if (sorted) {
                    //TODO: replace alert with notification. However don't submit the form until user has dismissed it.
                    //VAPALS.displayNotification("Nodule sort", "Nodules have been sorted by solid component mean diameter.");
                    alert("Nodules have been sorted by non-calcified solid component mean diameter.");
                }
            }

            function swapValues(selector1, selector2) {
                const $f1 = $(selector1);
                const $f2 = $(selector2);

                //special handling of checkboxes
                if ($f1.is(":checkbox")) {
                    const checked1 = $f1.is(":checked");
                    const checked2 = $f2.is(":checked");
                    $f1.prop('checked', checked2);
                    $f2.prop('checked', checked1);
                } else { //normal swap for inputs, selects, etc
                    const temp1 = $(selector1).val();
                    const temp2 = $(selector2).val();
                    $(selector1).val(temp2).data("previous-value", temp2);
                    $(selector2).val(temp1).data("previous-value", temp1);
                }
            }

            function swapFields(noduleIndex, otherIndex) {
                // console.log("swapFields() entered. noduleIndex=" + noduleIndex + ", other=" + otherIndex);
                const nodeId1 = noduleIndex + 1;
                const nodeId2 = otherIndex + 1;
                const prefix1 = '#cect' + nodeId1;
                const prefix2 = '#cect' + nodeId2;
                const suffixes = ['ch', 'en', 'll', 'sn', 'inl', 'inh', 'st', 'nt', 'sl', 'sw', 'sd', 'sh', 'sv',
                    'ssl', 'ssw', 'ssd', 'ssd-val', 'se', 'ca', 'in', 'sp', 'pld', 'ac', 'co', 'pd'];
                const selectorMap = []; //map of elements (i.e. arr['elementA'] = 'elementB' ) that needs to swap values.
                //let x of suffixes won't wor in IE11
                for (let i = 0; i < suffixes.length; ++i) {
                    const suffix = suffixes[i];
                    selectorMap[prefix1 + suffix] = prefix2 + suffix;
                }

                //NB: When we call the change event on updated fields, the volume override field will always be true.
                // To get around this, we keep the original field values, manually swap them, then re-evaluate if the
                // volume was manually entered
                const $override1 = $("#cect" + nodeId1 + "svovrrde");
                const $override2 = $("#cect" + nodeId2 + "svovrrde");
                const origOverrideVal1 = $override1.val();
                const origOverrideVal2 = $override2.val();

                const changeQueue = [];
                // for (let i = 0; i < selectorMap.length; ++i) {
                for (let key in selectorMap) {
                    const selector1 = key;
                    const selector2 = selectorMap[key];
                    swapValues(selector1, selector2);
                    changeQueue.push(selector1, selector2);
                }


                //trigger change events on every field so any conditional fields are triggered.
                $.each(changeQueue, function (i, el) {
                    $(el).trigger('change');
                });


                //As noted above, restore volume override values
                $override1.val(origOverrideVal2);
                $override2.val(origOverrideVal1);
                markNoduleVolumeManuallyEntered(nodeId1, $override1.val() === 'true');
                markNoduleVolumeManuallyEntered(nodeId2, $override2.val() === 'true')
            }

            function getNoduleSizeForSorting(tableColumnIndex) {
                const noduleId = tableColumnIndex + 1;
                let v1 = 0;
                let v2 = 0;
                const consistencyType = $("#cect" + noduleId + "nt").val();
                if (consistencyType === 'm') { //part solid
                    v1 = $("#cect" + noduleId + "ssl").val();
                    v2 = $("#cect" + noduleId + "ssw").val();
                } else {
                    v1 = $("#cect" + noduleId + "sl").val();
                    v2 = $("#cect" + noduleId + "sw").val();
                }
                let m = mean(v1, v2);
                //console.log("nodule size of nodule" + noduleId + " is: " + m);


                //Subtract 100000 to make nodules with no solid component sorted after those with a solid component
                if (consistencyType !== 's' && consistencyType !== 'm') {
                    m -= 100000; //insane number that would never be a real nodule size (100 meters)
                    //console.log("nodule size adjusted for non-solid: " + m);
                }

                //Subtract 200000 to make calcified nodules sort after non-calcified.
                // Calcified nodules are those with a status of Benign (Ca++) or Prob benign, prob Ca++. All other
                // statuses, including blank are considered "non-calcified".
                const noduleStatus = $("#cect" + noduleId + "st").val();
                const calcified = noduleStatus === 'bc' || noduleStatus === 'pc';
                if (calcified === true) {
                    m -= 200000; //insane number that would never be a real nodule size (100 meters)
                    //console.log("nodule size adjusted for calcification: " + m);
                }
                return m;
            }

            function _displayNodules(count) {
                $("[data-nodule-id]").hide().filter(function () {
                    return $(this).data("nodule-id") <= count;
                }).show();

                // Only show the delete icon on the last (rightmost) nodule;
                // NB: there is currently no support renumbering fields so removing from the middle is not an option
                $(".remove-nodule").hide().filter(function () {
                    return $(this).data("nodule-id") === count;
                }).show();

                $("#nodule-table").toggle(count > 0);
                $("#add-first-nodule").toggle(count === 0);
            }

            function setUpImportDataOnChange() {
                $("#nodule-table").find("[original-value]").on('change', function () {
                    if (importFieldHit || revertFieldHit) {
                        importFieldHit = false;
                        revertFieldHit = false;
                    } else {
                        let importValue = "";
                        if ($(this).hasClass("import-data")) {
                            if ($(this).prop('type') === "checkbox") {
                                if ($(this).attr("import-value") === "false") {
                                    importValue = "unchecked";
                                } else {
                                    importValue = "checked";
                                }
                            } else {
                                if ($(this).prop('type') === "select-one") {
                                    const fieldSelectorWithVal = "#" + $(this).attr("name") + " option[value=\"" + $(this).attr("import-value") + "\"]";
                                    importValue = $(fieldSelectorWithVal).text().trim();
                                } else {
                                    importValue = $(this).attr("import-value");
                                }
                            }
                            $(this).parent().find(".revert-field").remove();
                            $(this).parent().find(".import-field").remove();

                            createImportElement("#" + $(this).attr("name"), importValue).insertAfter($(this));
                        }
                    }
                });
            }

            function _revertData() {
                $("#nodule-table").find("[original-value]").each(function () {
                    if ($(this).hasClass("import-data")) {
                        if ($(this).prop('type') === "checkbox") {
                            if ($(this).attr("original-value") === "false") {
                                $(this).prop("checked", false);
                            } else {
                                $(this).prop("checked", true);
                            }
                        } else {
                            $(this).val($(this).attr("original-value"));
                        }
                        $(this).removeAttr("original-value");
                        $(this).removeAttr("import-value");
                        $(this).removeClass("import-data");
                    }
                });
                $("#nodule-table").find(".import-data").each(function () {
                    $(this).removeClass("import-data");
                });
                $("#nodule-table").find(".import-data-parent").each(function () {
                    $(this).removeClass("import-data-parent");
                });

                // for fields not in "#nodule-table"
                $(".import-data").each(function () {
                    $(this).val($(this).attr("original-value"));
                    if ($(this).attr("id") === "cectrst") {
                        if ($(this).attr("original-value") == "o") {
                            $("#cectrsto-container").show();
                        } else {
                            $("#cectrsto-container").hide();
                        }
                    }
                    $(this).removeAttr("original-value");
                    $(this).removeAttr("import-value");
                    $(this).removeClass("import-data");
                });

                $(".revert-field").remove(); // remove all revert-field icons
                $(".import-field").remove(); // remove all import-field icons
            }

            function _importDicomHeader(structuredReport) {
                structuredReport.forEach(obj => {
                    Object.entries(obj).forEach(([key, value]) => {
                        if (key === "CT Study Date") {
                            const fieldSelector = "#cedos";
                            const $field = $(fieldSelector);
                            if ($field.hasClass("import-data")) {
                                $field.val(value);
                            } else {
                                $field.addClass("import-data");
                                $field.attr("original-value", $field.val());
                                const originalValue = $field.val();
                                $field.val(value);
                                $field.attr("import-value", value);

                                createRevertElement(fieldSelector, originalValue).insertAfter($("#cedos-addon").parent().parent());
                            }
                        }
                        if (key === "Reconstructed slice thickness (mm)") {
                            const fieldSelector = "#cectrst";
                            const $field = $(fieldSelector);
                            if ($field.hasClass("import-data")) {
                                $field.val(value);
                            } else {
                                $field.addClass("import-data");
                                $field.attr("original-value", $field.val());
                                const originalValue = $field.val();
                                $field.val(value);
                                $field.attr("import-value", value);
                                if (value === "o") {
                                    $("#cectrsto-container").show();
                                } else {
                                    $("#cectrsto-container").hide();
                                }
                                createRevertElement(fieldSelector, originalValue).insertAfter(fieldSelector);
                            }
                        }
                        if (key === "Specify") {
                            const fieldSelector = "#cectrsto";
                            const $field = $(fieldSelector);
                            $("#cectrsto-container").show();
                            if ($field.hasClass("import-data")) {
                                $field.val(value);
                            } else {
                                $field.addClass("import-data");
                                $field.attr("original-value", $field.val());
                                const originalValue = $field.val();
                                $field.val(value);
                                $field.attr("import-value", value);
                                createRevertElement(fieldSelector, originalValue).insertAfter(fieldSelector);
                            }
                        }
                    });
                });
            }

            function _importData(structuredReport) {
                _importDicomHeader(structuredReport);

                importFieldHit = false;
                revertFieldHit = false;
                // if number of nodules shown is less than the number of entries in structuredReport array then increase the number of nodules
                if (settings.getNoduleCount() < structuredReport.length) {
                    let noduleCount = structuredReport.length;
                    _displayNodules(noduleCount);
                    settings.setNoduleCount(noduleCount);
                }

                noduleId = 1;
                structuredReport.forEach(obj => {
                    Object.entries(obj).forEach(([key, value]) => {
                        // Need to work: “Finding”: “Pulmonary nodule”,

                        // “Finding site” maps to the "Most likely location" field (cect1ll) of the form.
                        if (key === "Finding site") {
                            const fieldSelector = "#cect" + noduleId + "ll";
                            const $field = $(fieldSelector);
                            if (!$field.hasClass("import-data")) {
                                $field.addClass("import-data");
                                $field.attr("original-value", $field.val());
                                const fieldSelectorWithVal = fieldSelector + " option[value=\"" + $field.val() + "\"]";
                                const originalValue = $(fieldSelectorWithVal).text().trim();
                                createRevertElement(fieldSelector, originalValue).insertAfter(fieldSelector);
                                $field.parent().addClass("import-data-parent");
                            }
                            if (value.indexOf("Upper lobe of right lung") !== -1) {
                                $field.val("rul");
                                $field.attr("import-value", "rul");
                            } else if (value.indexOf("Upper lobe of left lung") !== -1) {
                                $field.val("lul");
                                $field.attr("import-value", "lul");
                            } else if (value.indexOf("Lower lobe of right lung") !== -1) {
                                $field.val("rll");
                                $field.attr("import-value", "rll");
                            } else if (value.indexOf("Lower lobe of left lung") !== -1) {
                                $field.val("lll");
                                $field.attr("import-value", "lll");
                            } else if (value.indexOf("Middle lobe of lung") !== -1) {
                                $field.val("rml");
                                $field.attr("import-value", "rml");
                            }
                        }

                        // “Attenuation Characteristic” maps to the "Nodule consistency" field (cect1nt) of the form.
                        if (key === "Attenuation Characteristic") {
                            const fieldSelector = "#cect" + noduleId + "nt";
                            const $field = $(fieldSelector);
                            if (!$field.hasClass("import-data")) {
                                $field.addClass("import-data");
                                $field.attr("original-value", $field.val());
                                const fieldSelectorWithVal = fieldSelector + " option[value=\"" + $field.val() + "\"]";
                                const originalValue = $(fieldSelectorWithVal).text().trim();
                                createRevertElement(fieldSelector, originalValue).insertAfter(fieldSelector);
                            }
                            if (value.indexOf("PartSolid") !== -1) {
                                $field.val("m");
                                $field.attr("import-value", "m");
                            } else if (value.indexOf("NonSolid") !== -1) {
                                $field.val("g");
                                $field.attr("import-value", "g");
                            } else if (value.indexOf("Solid") !== -1) {
                                $field.val("s");
                                $field.attr("import-value", "s");
                            } else if (value.indexOf("Unknown") !== -1) {
                                $field.val("o");
                                $field.attr("import-value", "o");
                            }
                        }

                        // “Radiographic Lesion Margin” maps to the "Smooth edges" and "Spiculated" fields (cect1se and cect1sp) of the form.
                        if (key === "Radiographic Lesion Margin") {
                            const fieldSelectorSe = "#cect" + noduleId + "se";
                            const $fieldSe = $(fieldSelectorSe);
                            const fieldSelectorSp = "#cect" + noduleId + "sp";
                            const $fieldSp = $(fieldSelectorSp);
                            if (!$fieldSe.hasClass("import-data")) {
                                $fieldSe.addClass("import-data");
                                $fieldSe.parent().addClass("import-data");
                                $fieldSe.attr("original-value", $fieldSe.prop("checked"));
                                const originalValue = $fieldSe.prop("checked") ? "checked" : "unchecked";
                                createRevertElement(fieldSelectorSe, originalValue).insertAfter(fieldSelectorSe);
                            }
                            if (!$fieldSp.hasClass("import-data")) {
                                $fieldSp.addClass("import-data");
                                $fieldSp.parent().addClass("import-data");
                                $fieldSp.attr("original-value", $fieldSp.prop("checked"));
                                const originalValue = $fieldSp.prop("checked") ? "checked" : "unchecked";
                                createRevertElement(fieldSelectorSp, originalValue).insertAfter(fieldSelectorSp);
                            }
                            if (value === "Lesion with circumscribed margin") {
                                $fieldSe.prop("checked", true);
                                $fieldSp.prop("checked", false);
                                $fieldSe.attr("import-value", true);
                                $fieldSp.attr("import-value", false);
                            }
                            if (value === "Lesion with spiculated margin") {
                                $fieldSp.prop("checked", true);
                                $fieldSe.prop("checked", false);
                                $fieldSp.attr("import-value", true);
                                $fieldSe.attr("import-value", false);
                            }
                        }

                        // “Maximum 2D diameter” maps to the "Length (mm)" field (cect1sl) of the form.
                        if (key === "Maximum 2D diameter") {
                            const fieldSelector = "#cect" + noduleId + "sl";
                            const $field = $(fieldSelector);
                            if ($field.hasClass("import-data")) {
                                $field.val(value);
                            } else {
                                $field.addClass("import-data");
                                $field.attr("original-value", $field.val());
                                const originalValue = $field.val();
                                $field.val(value);
                                $field.attr("import-value", value);
                                createRevertElement(fieldSelector, originalValue).insertAfter(fieldSelector);
                            }
                        }

                        // “Maximum perpendicular 2D diameter” maps to the "Maximum width (mm)" field (cect1sw) of the form.
                        if (key === "Maximum perpendicular 2D diameter") {
                            const fieldSelector = "#cect" + noduleId + "sw";
                            const $field = $(fieldSelector);
                            if ($field.hasClass("import-data")) {
                                $field.val(value);
                            } else {
                                $field.addClass("import-data");
                                $field.attr("original-value", $field.val());
                                const originalValue = $field.val();
                                $field.val(value);
                                $field.attr("import-value", value);
                                createRevertElement(fieldSelector, originalValue).insertAfter(fieldSelector);
                            }
                        }

                        // “Volume” maps to the "Volume (mm3)" field (cect1sv) of the form.
                        if (key === "Volume") {
                            const fieldSelector = "#cect" + noduleId + "sv";
                            const $field = $(fieldSelector);
                            if ($field.hasClass("import-data")) {
                                $field.val(value);
                            } else {
                                $field.addClass("import-data");
                                $field.attr("original-value", $field.val());
                                const originalValue = $field.val();
                                $field.val(value);
                                $field.attr("import-value", value);
                                $field.parent().addClass("import-data-parent");
                                createRevertElement(fieldSelector, originalValue).insertAfter(fieldSelector);
                            }
                        }
                    });
                    noduleId++;
                });
                setUpImportDataOnChange();
            }

            function _addNodule() {
                let noduleCount = settings.getNoduleCount();

                if (noduleCount === 10) {
                    VAPALS.displayNotification("Maximum Nodules Reached", "No more than 10 nodules are allowed. You may need to scroll to the right to see the additional nodule fields.");
                } else {
                    _displayNodules(++noduleCount);
                    settings.setNoduleCount(noduleCount);

                    const $isItNew = $("#cect" + noduleCount + "ch");
                    // set nodule "is it new?" to "new" when type of exam (tex) is baseline
                    if ($("[name=cetex]:checked").val() === "b") {
                        $isItNew.val("n");
                    }
                    $isItNew.focus().trigger('change.cteval');
                }
            }

            function _removeNodule() {
                let noduleCount = settings.getNoduleCount();
                if (noduleCount > 0) {
                    $("#cect" + noduleCount + "ch").val("-").trigger('change.cteval');
                    _displayNodules(--noduleCount);
                    settings.setNoduleCount(noduleCount)
                }
            }

            function _init() {

                // mean diameter calculation
                setupMeanDiameterCalculation("sl", "sw", "sd-val");

                // solid mean diameter calculation
                setupMeanDiameterCalculation("ssl", "ssw", "ssd-val");

                for (let i = 1; i < settings.availableNodules; i++) {
                    setupNoduleVolumeCalculations(i);
                    setupNoduleEnabledState(i);
                }

                _displayNodules(settings.getNoduleCount());

                $(".import-data-button").hide();
                $(".revert-data-button").hide();
                $("[name=cetex]").on('change', function () {
                    if ($("[name=cetex]:checked").val() === "b") {
                        $(".import-data-button").show();
                        $(".revert-data-button").show();
                    } else {
                        $(".import-data-button").hide();
                        $(".revert-data-button").hide();
                    }
                });

                return {
                    displayNodules: _displayNodules,
                    addNodule: _addNodule,
                    importData: _importData,
                    importDicomHeader: _importDicomHeader,
                    revertData: _revertData,
                    removeNodule: _removeNodule,
                    sortData: _sortData
                };
            }

            return _init();
        }
    });
}(jQuery));
