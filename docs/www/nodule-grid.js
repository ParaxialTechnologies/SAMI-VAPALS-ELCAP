/**
 * The jQuery plugin namespace.
 * @external "jQuery.fn"
 * @see {@link http://learn.jquery.com/plugins/|jQuery Plugins}
 */

/**
 * A jQuery plugin to manage a nodule grid
 * @link https://github.com/VA-PALS-ELCAP/SAMI-VAPALS-ELCAP
 * @author Domenic DiNatale <domenic.dinatale@paraxialtech.com>
 * @license [Apache-2.0]{@link https://www.apache.org/licenses/LICENSE-2.0.html}
 * @copyright 2018 [VAPALS-ELCAP]{@link http://va-pals.org/}
 * @param {string|function} [options.availableNodules="10"] - number of nodules externally rendered in the grid. Depends on _nodule-grid.jinja2
 * @param {string|function|object} [options.getNoduleCount=fn()] - function used to get the number of visible nodules
 * @param {string|function|object} [options.setNoduleCount=fn(noduleCount)] - function used to set the number of visible nodules
 * @class noduleGrid
 * @memberof jQuery
 */
(function ($) {
    $.extend({
        noduleGrid: function (options) {
            const settings = $.extend({
                availableNodules: 10,
                frozen: "",
                getNoduleCount: function () {
                    return 0;
                },
                setNoduleCount: function (noduleCount) {
                    return noduleCount;
                },
            }, options);

            function setupNoduleEnabledState(noduleNumber) {
                $("#cect" + noduleNumber + "nt").conditionallyEnable({
                    sourceValues: "m",
                    enable: "#cect" + noduleNumber + "-container"
                });

                $("#cect" + noduleNumber + "ch").on('change.cteval', function () {
                    toggleFields(noduleNumber);
                });

                const currentIsItNewValue = $("#cect" + noduleNumber + "ch").val();
                console.debug("setupNoduleEnabledState(noduleIndex=%s): currentIsItNewValue=%s", noduleNumber, currentIsItNewValue);
                if (currentIsItNewValue !== '-') {
                    toggleFields(noduleNumber);
                }
            }

            function toggleFields(noduleNumber) {
                const logPrefix = 'toggleFields(noduleIndex=' + noduleNumber + '): ';
                console.debug(logPrefix + 'entered');

                // $fields is an array of fields related to this nodule with the exception of "is it new"
                // NB: Note that we use regex instead of startsWith and endsWith jQuery selectors because
                // nodule 10 would match cect1*
                const regex = new RegExp("cect" + noduleNumber + "[a-z]");
                let $fields = $('input,select').filter(function () {
                    const name = $(this).attr('name');
                    const id = $(this).attr('id');
                    return id !== "cect" + noduleNumber + "ch" && (regex.test(name) || regex.test(id));
                });
                let isItNewValue = $("#cect" + noduleNumber + "ch").val();
                console.debug(logPrefix + 'isItNewValue=%s', isItNewValue);
                // if the "is it new" selection is a value that means the nodule is no longer present or otherwise
                // resolved, clear MOST fields. These values include: resolved (pw), not a nodule (px),
                // resected (pr)
                // NB: For IE support, we must use indexOf() instead of .includes(...);
                let noduleResolved = ['pw', 'px', 'pr'].indexOf(isItNewValue) > -1;
                console.debug(logPrefix + 'noduleResolved=%s', noduleResolved);
                if (noduleResolved) {
                    //reduce the list to exclude the fields: status (st) and likely location (ll)
                    $fields = $fields.filter(function () {
                        const id = $(this).attr('id');
                        const idsToMatch = [
                            'cect' + noduleNumber + 'll', // likely location
                            'cect' + noduleNumber + 'st', // nodule status
                            'cect' + noduleNumber + 'pd', // pathological diagnosis
                        ];
                        // NB: For IE support, we must use indexOf() instead of !idsToMatch.includes(...);
                        return idsToMatch.indexOf(id) === -1;
                    })
                }

                if (isItNewValue === "-" || noduleResolved) {
                    console.log(logPrefix + 'disabling fields');
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
                    console.debug(logPrefix + 'enabling fields');
                    $fields
                        .prop('disabled', false)
                        .trigger('change.conditionally-enable'); //set state according to other rules (i.e. part-solid fields)

                    // fixes a bug where L & W fields were required when nodule was solid and "is it new" was
                    // changed from "-" to anything else; which occurs on subsequent scans.
                    $("#cect" + noduleNumber + "nt").trigger('change');
                }
                if (isItNewValue === "pw") {
                    $("#cect" + noduleNumber + "st").val("re");
                } else {
                    if ($("#cect" + noduleNumber + "st").val() === "re") {
                        $("#cect" + noduleNumber + "st").val("-");
                    }
                }
                console.debug(logPrefix + 'exiting');
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
                lengthFields.on('keyup change change.cteval', function (e) {
                    const targetField = $(e.target);
                    const noduleNumber = targetField.closest("td").attr("data-nodule-number");
                    const noduleDiamLabel = $("#cect" + noduleNumber + labelSuffix);
                    const widthValue = $("#cect" + noduleNumber + widthFieldSuffix).val();
                    const lengthValue = $("#cect" + noduleNumber + lengthFieldSuffix).val();
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

            function calculateVolumeError(noduleNumber) {
                //See https://services.accumetra.com/NoduleCalculator.html
                const volumeValue = parseFloat($("#cect" + noduleNumber + "sv").val());
                let deviation = 0;
                if (volumeValue >= 113.0 && volumeValue < 154.0)
                    deviation = 0.29;
                else if (volumeValue >= 154.0 && volumeValue < 268.0)
                    deviation = 0.23;
                else if (volumeValue >= 268.0 && volumeValue < 382.0)
                    deviation = 0.19;
                else if (volumeValue >= 382.0 && volumeValue < 524.0)
                    deviation = 0.16;
                else if (volumeValue >= 524.0 && volumeValue < 697.0)
                    deviation = 0.14;
                else if (volumeValue >= 697.0 && volumeValue < 905.0)
                    deviation = 0.12;
                else if (volumeValue > 905.0)
                    deviation = 0.11;
                //and the error percent = 1.96 x CV1 x V1
                return Math.round(1.96 * volumeValue * deviation);
            }

            function markNoduleVolumeManuallyEntered(noduleNumber, isManual) {
                // console.log("markNoduleVolumeManuallyEntered() noduleNumber=" + noduleNumber + ", isManual=" + isManual)
                const $messageContainer = $("#cect" + noduleNumber + "svovrrde-message").removeClass("invisible");
                if (isManual) {
                    $("#cect" + noduleNumber + "sv").addClass("volumeOverride");
                    $("#cect" + noduleNumber + "svovrrde").val("true");
                    $messageContainer.find(".text-warning").text("Manually entered")
                    $messageContainer.removeClass("invisible");
                } else {
                    $("#cect" + noduleNumber + "sv").removeClass("volumeOverride");
                    // set the manually override hidden field to false
                    $("#cect" + noduleNumber + "svovrrde").val("false");
                    const errorPercent = calculateVolumeError(noduleNumber);
                    if (!isNaN(errorPercent) && errorPercent > 0) {
                        $messageContainer.find(".text-warning").html("+/- " + errorPercent + "mm<sup>3</sup> (QIBA SLN Profile)")
                        $messageContainer.removeClass("invisible");
                    } else {
                        $messageContainer.addClass("invisible");
                    }
                }
            }

            function setupNoduleVolumeCalculations(noduleNumber) {
                const lenWidthHeightFields = $("#cect" + noduleNumber + "sl, #cect" + noduleNumber + "sw, #cect" + noduleNumber + "sh");
                lenWidthHeightFields.on("keyup", function () {
                    let allFilled = true;

                    lenWidthHeightFields.each(function () {
                        const v = $(this).val() || 0;
                        if (v == 0) {
                            allFilled = false;
                        }
                    });

                    const btnElem = $("#cect" + noduleNumber + "svb");
                    if (allFilled) {
                        btnElem.attr("disabled", false);
                    } else {
                        btnElem.attr("disabled", true);
                    }
                }).first().trigger("keyup");

                $("#cect" + noduleNumber + "svb").on('click', function () {
                    const l = $("#cect" + noduleNumber + "sl").val() || 0;
                    const w = $("#cect" + noduleNumber + "sw").val() || 0;
                    const h = $("#cect" + noduleNumber + "sh").val() || 0;

                    const v = Math.PI * (4 / 3) * l / 2 * w / 2 * h / 2;

                    $("#cect" + noduleNumber + "sv").val(v.toFixed(1));
                    markNoduleVolumeManuallyEntered(noduleNumber, false);
                    //temporarily disabled
                    // checkConsistentVolumeCalculations();
                    return false;
                });


                $("#cect" + noduleNumber + "sv").on('change', function () {
                    // manually overriding the volume calculation
                    if ($(this).val() !== "") {
                        markNoduleVolumeManuallyEntered(noduleNumber, true);
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
                for (const suffix of suffixes) {
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
                const noduleNumber = tableColumnIndex + 1;
                let v1 = 0;
                let v2 = 0;
                const consistencyType = $("#cect" + noduleNumber + "nt").val();
                if (consistencyType === 'm') { //part solid
                    v1 = $("#cect" + noduleNumber + "ssl").val();
                    v2 = $("#cect" + noduleNumber + "ssw").val();
                } else {
                    v1 = $("#cect" + noduleNumber + "sl").val();
                    v2 = $("#cect" + noduleNumber + "sw").val();
                }
                let m = mean(v1, v2);
                //console.log("nodule size of nodule" + noduleNumber + " is: " + m);


                //Subtract 100000 to make nodules with no solid component sorted after those with a solid component
                if (consistencyType !== 's' && consistencyType !== 'm') {
                    m -= 100000; //insane number that would never be a real nodule size (100 meters)
                    //console.log("nodule size adjusted for non-solid: " + m);
                }

                //Subtract 200000 to make calcified nodules sort after non-calcified.
                // Calcified nodules are those with a status of Benign (Ca++) or Prob benign, prob Ca++. All other
                // statuses, including blank are considered "non-calcified".
                const noduleStatus = $("#cect" + noduleNumber + "st").val();
                const calcified = noduleStatus === 'bc' || noduleStatus === 'pc';
                if (calcified === true) {
                    m -= 200000; //insane number that would never be a real nodule size (100 meters)
                    //console.log("nodule size adjusted for calcification: " + m);
                }
                return m;
            }

            function _displayNodules(count) {
                $("[data-nodule-number]").hide().filter(function () {
                    return $(this).data("nodule-number") <= count;
                }).show();

                $("#nodule-table").toggle(count > 0);
                $("#add-first-nodule").toggle(count === 0);
            }

            function setUpImportDataOnChange() {
                $("#nodule-table").find("[" + AI.IMPORT_ORIGINAL_VALUE_ATTR + "]").on('change', function () {
                    let importValue = "";
                    if ($(this).hasClass(AI.IMPORT_FIELD_CLASS)) {
                        if ($(this).prop('type') === "checkbox") {
                            if ($(this).attr(AI.IMPORT_VALUE_ATTR) === "false") {
                                importValue = "unchecked";
                            } else {
                                importValue = "checked";
                            }
                        } else {
                            if ($(this).prop('type') === "select-one") {
                                const fieldSelectorWithVal = "#" + $(this).attr("name") + " option[value=\"" + $(this).attr(AI.IMPORT_VALUE_ATTR) + "\"]";
                                importValue = $(fieldSelectorWithVal).text().trim();
                            } else {
                                importValue = $(this).attr(AI.IMPORT_VALUE_ATTR);
                            }
                        }
                        AI.removeImportIcons();
                        AI.createImportElement("#" + $(this).attr("name"), importValue).insertAfter($(this));
                    }
                });
            }

            function _revertData() {
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
            }

            function _importData(nodules, seriesNumber) {
                // if current number of nodules shown is less than the number nodules provided, increase the number visible
                if (settings.getNoduleCount() < nodules.length) {
                    let noduleCount = nodules.length;
                    _displayNodules(noduleCount);
                    settings.setNoduleCount(noduleCount);
                }

                function applyTextValue(fieldNameSelector, value) {
                    const $field = $(fieldNameSelector);
                    if (!$field.hasClass(AI.IMPORT_FIELD_CLASS)) {
                        $field.addClass(AI.IMPORT_FIELD_CLASS);
                        const originalValue = $field.val();
                        $field.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR, originalValue);
                        $field.attr(AI.IMPORT_VALUE_ATTR, value);
                        $field.parent().addClass(AI.IMPORT_DATA_PARENT_CLASS); //NB: used to fix wrapping of revert element
                        AI.createRevertElement(fieldNameSelector, originalValue).insertAfter(fieldNameSelector);
                    }
                    $field.val(value);
                }

                let noduleNumber = 1;
                let lungRads = "";

                nodules.forEach(nodule => {
                    Object.entries(nodule).forEach(([key, value]) => {
                        // Need to work: “Finding”: “Pulmonary nodule”,

                        // “Finding site” maps to the "Most likely location" field (cect1ll) of the form.
                        if (key === "Finding site") {
                            const fieldSelector = "#cect" + noduleNumber + "ll";
                            const $field = $(fieldSelector);
                            if (!$field.hasClass(AI.IMPORT_FIELD_CLASS)) {
                                $field.addClass(AI.IMPORT_FIELD_CLASS);
                                $field.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR, $field.val());
                                const fieldSelectorWithVal = fieldSelector + " option[value=\"" + $field.val() + "\"]";
                                const originalValue = $(fieldSelectorWithVal).text().trim();
                                AI.createRevertElement(fieldSelector, originalValue).insertAfter(fieldSelector);
                                $field.parent().addClass(AI.IMPORT_DATA_PARENT_CLASS);
                            }
                            if (value.indexOf("Upper lobe of right lung") !== -1) {
                                $field.val("rul");
                                $field.attr(AI.IMPORT_VALUE_ATTR, "rul");
                            } else if (value.indexOf("Upper lobe of left lung") !== -1) {
                                $field.val("lul");
                                $field.attr(AI.IMPORT_VALUE_ATTR, "lul");
                            } else if (value.indexOf("Lower lobe of right lung") !== -1) {
                                $field.val("rll");
                                $field.attr(AI.IMPORT_VALUE_ATTR, "rll");
                            } else if (value.indexOf("Lower lobe of left lung") !== -1) {
                                $field.val("lll");
                                $field.attr(AI.IMPORT_VALUE_ATTR, "lll");
                            } else if (value.indexOf("Middle lobe of lung") !== -1) {
                                $field.val("rml");
                                $field.attr(AI.IMPORT_VALUE_ATTR, "rml");
                            }
                        }

                        // Nodule seen in series #.
                        if (!isNaN(parseFloat(seriesNumber))) {
                            const fieldSelectorLow = "#cect" + noduleNumber + "sn";
                            applyTextValue(fieldSelectorLow, seriesNumber);
                        }

                        // “Attenuation Characteristic” maps to the "Nodule consistency" field (cect1nt) of the form.
                        if (key === "Attenuation Characteristic") {
                            const fieldSelector = "#cect" + noduleNumber + "nt";
                            const $field = $(fieldSelector);
                            if (!$field.hasClass(AI.IMPORT_FIELD_CLASS)) {
                                $field.addClass(AI.IMPORT_FIELD_CLASS);
                                $field.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR, $field.val());
                                const fieldSelectorWithVal = fieldSelector + " option[value=\"" + $field.val() + "\"]";
                                const originalValue = $(fieldSelectorWithVal).text().trim();
                                AI.createRevertElement(fieldSelector, originalValue).insertAfter(fieldSelector);
                            }
                            if (value.indexOf("PartSolid") !== -1) {
                                $field.val("m");
                                $field.attr(AI.IMPORT_VALUE_ATTR, "m");
                            } else if (value.indexOf("NonSolid") !== -1) {
                                $field.val("g");
                                $field.attr(AI.IMPORT_VALUE_ATTR, "g");
                            } else if (value.indexOf("Solid") !== -1) {
                                $field.val("s");
                                $field.attr(AI.IMPORT_VALUE_ATTR, "s");
                            } else if (value.indexOf("Unknown") !== -1) {
                                $field.val("o");
                                $field.attr(AI.IMPORT_VALUE_ATTR, "o");
                            }
                        }

                        // “Radiographic Lesion Margin” maps to the "Smooth edges" and "Spiculated" fields (cect1se and cect1sp) of the form.
                        if (key === "Radiographic Lesion Margin") {
                            const fieldSelectorSe = "#cect" + noduleNumber + "se";
                            const $fieldSe = $(fieldSelectorSe);
                            const fieldSelectorSp = "#cect" + noduleNumber + "sp";
                            const $fieldSp = $(fieldSelectorSp);
                            if (!$fieldSe.hasClass(AI.IMPORT_FIELD_CLASS)) {
                                $fieldSe.addClass(AI.IMPORT_FIELD_CLASS);
                                $fieldSe.parent().addClass(AI.IMPORT_FIELD_CLASS);
                                $fieldSe.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR, $fieldSe.prop("checked"));
                                const originalValue = $fieldSe.prop("checked") ? "checked" : "unchecked";
                                AI.createRevertElement(fieldSelectorSe, originalValue).insertAfter(fieldSelectorSe);
                            }
                            if (!$fieldSp.hasClass(AI.IMPORT_FIELD_CLASS)) {
                                $fieldSp.addClass(AI.IMPORT_FIELD_CLASS);
                                $fieldSp.parent().addClass(AI.IMPORT_FIELD_CLASS);
                                $fieldSp.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR, $fieldSp.prop("checked"));
                                const originalValue = $fieldSp.prop("checked") ? "checked" : "unchecked";
                                AI.createRevertElement(fieldSelectorSp, originalValue).insertAfter(fieldSelectorSp);
                            }
                            if (value === "Lesion with circumscribed margin") { // smooth edges
                                $fieldSe.prop("checked", true);
                                $fieldSp.prop("checked", false);
                                $fieldSe.attr(AI.IMPORT_VALUE_ATTR, true);
                                $fieldSp.attr(AI.IMPORT_VALUE_ATTR, false);
                            }
                            if (value === "Lesion with spiculated margin") { // spiculated
                                $fieldSp.prop("checked", true);
                                $fieldSe.prop("checked", false);
                                $fieldSp.attr(AI.IMPORT_VALUE_ATTR, true);
                                $fieldSe.attr(AI.IMPORT_VALUE_ATTR, false);
                            }
                        }

                        // “Maximum 2D diameter” maps to the "Length (mm)" field (cect1sl) of the form.
                        if (key === "Maximum 2D diameter") {
                            const fieldSelector = "#cect" + noduleNumber + "sl";
                            applyTextValue(fieldSelector, value);
                        }

                        // “Maximum perpendicular 2D diameter” maps to the "Maximum width (mm)" field (cect1sw) of the form.
                        if (key === "Maximum perpendicular 2D diameter") {
                            const fieldSelector = "#cect" + noduleNumber + "sw";
                            applyTextValue(fieldSelector, value);
                        }

                        // “Volume” maps to the "Volume (mm3)" field (cect1sv) of the form.
                        if (key === "Volume") {
                            const fieldSelector = "#cect" + noduleNumber + "sv";
                            applyTextValue(fieldSelector, value);
                        }

                        if (key === "slice number of lesion epicenter") {
                            const fieldSelectorLow = "#cect" + noduleNumber + "inl";
                            applyTextValue(fieldSelectorLow, value);
                            const fieldSelectorHigh = "#cect" + noduleNumber + "inh";
                            applyTextValue(fieldSelectorHigh, value);
                        }

                        if (key === "Lung-RADS assessment") {
                            let thisLungRads = "0";
                            switch (value) {
                                case "Lung-rads 1":
                                    thisLungRads = "1";
                                    break;
                                case "Lung-rads 2":
                                    thisLungRads = "2";
                                    break;
                                case "Lung-rads 3":
                                    thisLungRads = "3";
                                    break;
                                case "Lung-rads 4a":
                                    thisLungRads = "4A";
                                    break;
                                case "Lung-rads 4b":
                                    thisLungRads = "4B";
                                    break;
                                case "Lung-rads 4x":
                                    thisLungRads = "4X";
                                    break;
                            }
                            lungRads = thisLungRads > lungRads ? thisLungRads : lungRads; //Update if more severe
                        }

                        // Image processing
                        if (key === "Nodule") {
                            const mimeType = value["mimeType"];
                            const content = value["content"];
                            const fileName = value["fileName"]
                            if (mimeType && content) {
                                const $img = $("<img width=\"175\" " +
                                    "alt=\"" + fileName + "\" " +
                                    "title=\"" + fileName + "\" " +
                                    "class=\"ai\" " +
                                    "src=\"data:" + mimeType + ";base64," + content + "\"/>");
                                const $th = $("th[data-nodule-number=" + noduleNumber + "]");
                                const $imgContainer = $th.find(".nodule-image-container")
                                $th.find("img.ai").remove(); //remove previously imported image icons.
                                $imgContainer.append($img);
                            }
                        }
                    });

                    noduleNumber++;
                });
                if (lungRads > "") {
                    const $field = $("[name=celrad][value=" + lungRads + "]");
                    const $wrapper = $field.parents(".form-group");
                    $wrapper.addClass(AI.IMPORT_FIELD_CLASS);
                    //TODO handle revert.
                    // const originalValue = $("[name=celrad]:checked").val()
                    // $wrapper.attr(AI.IMPORT_ORIGINAL_VALUE_ATTR, originalValue);
                    // $wrapper.attr(AI.IMPORT_VALUE_ATTR, value);
                    // $field.parent().addClass(AI.IMPORT_DATA_PARENT_CLASS); //NB: used to fix wrapping of revert element
                    // createRevertElement(fieldNameSelector, originalValue).insertAfter(fieldNameSelector);
                    $field.prop("checked", true);
                }
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

            function _markVisibleComplete() {
                let noduleCount = settings.getNoduleCount();
                for (let i = 1; i <= noduleCount; i++) {
                    $("[name^='cect" + i + "dr']").val("false")
                }
            }

            function _markVisibleIncomplete() {
                let noduleCount = settings.getNoduleCount();
                for (let i = 1; i <= noduleCount; i++) {
                    $("[name^='cect" + i + "dr']").val("true")
                }
            }

            function _removeNodule(noduleNumber) {
                let noduleCount = settings.getNoduleCount();

                // copy nodules at the right to the left
                for (let i = noduleNumber; i < noduleCount; i++) {
                    const sourceNodule = i + 1;
                    const targetNodule = i;
                    $("[name^='cect" + sourceNodule + "']:input").each(function () {
                        const $sourceInput = $(this);
                        const elementType = ($sourceInput.attr("type") || this.tagName).toLowerCase();
                        const sourceName = $sourceInput.attr("name");
                        const suffix = sourceName.replace("cect" + sourceNodule, "");
                        const targetName = "cect" + targetNodule + suffix;
                        const $targetInput = $("[name='" + targetName + "']");

                        if (["hidden", "text", "textarea", "select"].includes(elementType)) {
                            $targetInput.val($sourceInput.val());
                            $sourceInput.val("")
                        } else if (elementType === "checkbox") {
                            $targetInput.prop("checked", $sourceInput.prop("checked"));
                            $sourceInput.prop("checked", false);
                        } else {
                            console.log("Unsupported elementType=%s, sourceName=%s", elementType, sourceName);
                        }
                        $targetInput.trigger('change.cteval');
                    })
                    // remove the AI image if present
                    $("th[data-nodule-number=" + i + "]").find(".ai").remove();
                }

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

                const ctComplete = settings.frozen === "true";
                const initalNoduleCount = settings.getNoduleCount();
                for (let i = 1; i < initalNoduleCount + 1; i++) {
                    setupNoduleVolumeCalculations(i);
                    setupNoduleEnabledState(i);

                    const draftValue = $("#cect" + i + "dr").val();
                    const isDraft = !ctComplete && (draftValue === "true" || draftValue === "");
                    console.log("_init(): nodule='" + i + "', draftValue='" + draftValue + "', isDraft='" + isDraft + "'");
                    if (!isDraft) {
                        console.log("init(): nodule='" + i + "', removing delete link")
                        $("th[data-nodule-number=" + i + "]").find(".remove-nodule").remove();
                    }
                }

                _displayNodules(initalNoduleCount);


                return {
                    displayNodules: _displayNodules,
                    addNodule: _addNodule,
                    importData: _importData,
                    // importDicomHeader: _importDicomHeader,
                    revertData: _revertData,
                    removeNodule: _removeNodule,
                    sortData: _sortData,
                    markVisibleComplete: _markVisibleComplete,
                    markVisibleIncomplete: _markVisibleIncomplete
                };
            }

            return _init();
        }
    });
}(jQuery));
