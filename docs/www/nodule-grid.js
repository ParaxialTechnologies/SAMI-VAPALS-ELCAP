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

            // dicomStructuredReport is hard coded here for now
            const dicomStructuredReport = [
                {
                    "Tracking Identifier": "L1",
                    "Tracking Unique Identifier": "1.3.12.2.1107.5.8.21.192168059.30000021092410281563200001347",
                    "Finding": "Pulmonary nodule",
                    "Attenuation Characteristic": "Solid",
                    "Radiographic Lesion Margin": "Lesion with spiculated margin",
                    "Finding site": "Lower lobe of left lung",
                    "Lung-RADS assessment": "Lung-rads 4x",
                    "Lesion Review Status": "Accepted",
                    "Maximum 2D diameter": "36.3",
                    "Maximum 3D diameter": "42.2",
                    "Maximum perpendicular 2D diameter": "26.7",
                    "Mean 2D diameter": "31.5",
                    "Volume": "14789.7"
                },
                {
                    "Tracking Identifier": "R2",
                    "Tracking Unique Identifier": "1.3.12.2.1107.5.8.21.192168059.30000021092410281563200001347",
                    "Finding": "Pulmonary nodule",
                    "Attenuation Characteristic": "Solid",
                    "Radiographic Lesion Margin": "Lesion with circumscribed margin",
                    "Finding site": "Upper lobe of right lung",
                    "Lung-RADS assessment": "Lung-rads 4a",
                    "Lesion Review Status": "Accepted",
                    "Maximum 2D diameter": "15.0",
                    "Maximum 3D diameter": "17.3",
                    "Maximum perpendicular 2D diameter": "9.5",
                    "Mean 2D diameter": "12.2",
                    "Volume": "580.4"
                },
                {
                    "Tracking Identifier": "L3",
                    "Tracking Unique Identifier": "1.3.12.2.1107.5.8.21.192168059.30000021092410281563200001347",
                    "Finding": "Pulmonary nodule",
                    "Attenuation Characteristic": "PartSolid",
                    "Radiographic Lesion Margin": "Lesion with spiculated margin",
                    "Finding site": "Upper lobe of left lung",
                    "Lung-RADS assessment": "Lung-rads 4x",
                    "Lesion Review Status": "Accepted",
                    "Maximum 2D diameter": "14.5",
                    "Maximum 3D diameter": "24.4",
                    "Maximum perpendicular 2D diameter": "9.7",
                    "Mean 2D diameter": "12.1",
                    "Volume": "1145.7"
                },
                {
                    "Tracking Identifier": "R4",
                    "Tracking Unique Identifier": "1.3.12.2.1107.5.8.21.192168059.30000021092410281563200001347",
                    "Finding": "Pulmonary nodule",
                    "Attenuation Characteristic": "Solid",
                    "Radiographic Lesion Margin": "Lesion with spiculated margin",
                    "Finding site": "Upper lobe of right lung",
                    "Lung-RADS assessment": "Lung-rads 4x",
                    "Lesion Review Status": "Accepted",
                    "Maximum 2D diameter": "12.6",
                    "Maximum 3D diameter": "13.1",
                    "Maximum perpendicular 2D diameter": "7.8",
                    "Mean 2D diameter": "10.2",
                    "Volume": "381.3"
                },
                {
                    "Tracking Identifier": "L5",
                    "Tracking Unique Identifier": "1.3.12.2.1107.5.8.21.192168059.30000021092410281563200001347",
                    "Finding": "Pulmonary nodule",
                    "Attenuation Characteristic": "Solid",
                    "Radiographic Lesion Margin": "Lesion with circumscribed margin",
                    "Finding site": "Lower lobe of left lung",
                    "Lung-RADS assessment": "Lung-rads 4a",
                    "Lesion Review Status": "Accepted",
                    "Maximum 2D diameter": "11.5",
                    "Maximum 3D diameter": "11.7",
                    "Maximum perpendicular 2D diameter": "8.6",
                    "Mean 2D diameter": "10.1",
                    "Volume": "371.2"
                },
                {
                    "Tracking Identifier": "L6",
                    "Tracking Unique Identifier": "1.3.12.2.1107.5.8.21.192168059.30000021092410281563200001347",
                    "Finding": "Pulmonary nodule",
                    "Attenuation Characteristic": "Solid",
                    "Radiographic Lesion Margin": "Lesion with circumscribed margin",
                    "Finding site": "Lower lobe of left lung",
                    "Lung-RADS assessment": "Lung-rads 2",
                    "Lesion Review Status": "Accepted",
                    "Maximum 2D diameter": "7.8",
                    "Maximum 3D diameter": "7.8",
                    "Maximum perpendicular 2D diameter": "4.8",
                    "Mean 2D diameter": "6.3",
                    "Volume": "79.1"
                },
                {
                    "Tracking Identifier": "R7",
                    "Tracking Unique Identifier": "1.3.12.2.1107.5.8.21.192168059.30000021092410281563200001347",
                    "Finding": "Pulmonary nodule",
                    "Attenuation Characteristic": "Solid",
                    "Radiographic Lesion Margin": "Lesion with circumscribed margin",
                    "Finding site": "Upper lobe of right lung",
                    "Lung-RADS assessment": "Lung-rads 2",
                    "Lesion Review Status": "Accepted",
                    "Maximum 2D diameter": "6.1",
                    "Maximum 3D diameter": "6.2",
                    "Maximum perpendicular 2D diameter": "6.1",
                    "Mean 2D diameter": "6.1",
                    "Volume": "42.1"
                },
                {
                    "Tracking Identifier": "R8",
                    "Tracking Unique Identifier": "1.3.12.2.1107.5.8.21.192168059.30000021092410281563200001347",
                    "Finding": "Pulmonary nodule",
                    "Attenuation Characteristic": "Unknown",
                    "Radiographic Lesion Margin": "Lesion with circumscribed margin",
                    "Finding site": "Lower lobe of right lung",
                    "Lung-RADS assessment": "Lung-rads 0",
                    "Lesion Review Status": "Accepted",
                    "Maximum 2D diameter": "5.5",
                    "Maximum 3D diameter": "6.2",
                    "Maximum perpendicular 2D diameter": "4.2",
                    "Mean 2D diameter": "4.9",
                    "Volume": "34.5"
                },
                {
                    "Tracking Identifier": "R9",
                    "Tracking Unique Identifier": "1.3.12.2.1107.5.8.21.192168059.30000021092410281563200001347",
                    "Finding": "Pulmonary nodule",
                    "Attenuation Characteristic": "Solid",
                    "Radiographic Lesion Margin": "Lesion with circumscribed margin",
                    "Finding site": "Upper lobe of right lung",
                    "Lung-RADS assessment": "Lung-rads 2",
                    "Lesion Review Status": "Accepted",
                    "Maximum 2D diameter": "5.4",
                    "Maximum 3D diameter": "5.4",
                    "Maximum perpendicular 2D diameter": "4.0",
                    "Mean 2D diameter": "4.7",
                    "Volume": "21.4"
                }
            ];

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
                    if ($("#cect" + noduleId + "st").val() === "re" ) {
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
                    if ($(this).hasClass("import-data")) {
                        $(this).removeAttr("original-value");
                        $(this).removeClass("import-data");
                        if ($(this).parent().hasClass("import-data")) {
                            $(this).parent().removeClass("import-data");
                        }
                        if ($(this).parent().hasClass("import-data-parent")) {
                            $(this).parent().removeClass("import-data-parent");
                        }
                        $(this).parent().find(".revert-field").remove();
                    }
                });
            }

            function _revertData() {
                $("#nodule-table").find("[original-value]").each(function() {
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
                        $(this).removeClass("import-data");
                    }
                });
                $("#nodule-table").find(".import-data").each(function() {
                    $(this).removeClass("import-data");
                });
                $("#nodule-table").find(".import-data-parent").each(function() {
                    $(this).removeClass("import-data-parent");
                });
                $(".revert-field").remove(); // remove all revert-field buttons
            }

            function _importData() {
                _importDataX(dicomStructuredReport);
            }
            function _importDataX(theData) {
                // if number of nodules shown is less than the number of entries in theData array then increase the number of nodules
                if (settings.getNoduleCount() < theData.length) {
                    let noduleCount = theData.length;
                    _displayNodules(noduleCount);
                    settings.setNoduleCount(noduleCount);
                }

                noduleId = 1;
                theData.forEach(obj => {
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
                                const originalValue =  $(fieldSelectorWithVal).text().trim();
                                const iElementStr = "<i class=\"fa fa-undo revert-field\" title=\"Revert back to the original value (" + originalValue + ") for this field\"" +
                                " onclick=\"revertField(this, '" + fieldSelector + "')\"></i>";
                                $(iElementStr).insertAfter(fieldSelector);
                                $field.parent().addClass("import-data-parent");
                            }
                            if (value == "Upper lobe of right lung") {
                                $field.val("rul");
                            } else if (value == "Upper lobe of left lung") {
                                $field.val("lul");
                            } else if (value == "Lower lobe of right lung") {
                                $field.val("rll");
                            } else if (value == "Lower lobe of left lung") {
                                $field.val("lll");
                            } else if (value == "“Middle lobe of lung") {
                                $field.val("rml");
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
                                const originalValue =  $(fieldSelectorWithVal).text().trim();
                                const iElementStr = "<i class=\"fa fa-undo revert-field\" title=\"Revert back to the original value (" + originalValue + ") for this field\"" +
                                " onclick=\"revertField(this, '" + fieldSelector + "')\"></i>";
                                $(iElementStr).insertAfter(fieldSelector);
                            }
                            if (value == "Solid") {
                                $field.val("s");
                            } else if (value == "PartSolid") {
                                $field.val("m");
                            } else if (value == "NonSolid") {
                                $field.val("g");
                            } else if (value == "Unknown") {
                                $field.val("o");
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
                                
                                if ($fieldSe.prop("checked")) {
                                    originalValue = "checked";
                                } else {
                                    originalValue = "unchecked";
                                }
                                const iElementStr = "<i class=\"fa fa-undo revert-field\" title=\"Revert back to the original value (" + originalValue + ") for this field\"" +
                                " onclick=\"revertField(this, '" + fieldSelectorSe + "')\"></i>";
                                $(iElementStr).insertAfter(fieldSelectorSe);
                            }
                            if (!$fieldSp.hasClass("import-data")) {
                                $fieldSp.addClass("import-data");
                                $fieldSp.parent().addClass("import-data");
                                $fieldSp.attr("original-value", $fieldSp.prop("checked"));
                                if ($fieldSp.prop("checked")) {
                                    originalValue = "checked";
                                } else {
                                    originalValue = "unchecked";
                                }
                                const iElementStr = "<i class=\"fa fa-undo revert-field\" title=\"Revert back to the original value (" + originalValue + ") for this field\"" +
                                " onclick=\"revertField(this, '" + fieldSelectorSp + "')\"></i>";
                                $(iElementStr).insertAfter(fieldSelectorSp);
                            }
                            if (value == "Lesion with circumscribed margin") {
                                $fieldSe.prop("checked", true);
                                $fieldSp.prop("checked", false);
                            }
                            if (value == "Lesion with spiculated margin") {
                                $fieldSp.prop("checked", true);
                                $fieldSe.prop("checked", false);
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
                                const iElementStr = "<i class=\"fa fa-undo revert-field\" title=\"Revert back to the original value (" + originalValue + ") for this field\"" +
                                " onclick=\"revertField(this, '" + fieldSelector + "')\"></i>";
                                $(iElementStr).insertAfter(fieldSelector);
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
                                const iElementStr = "<i class=\"fa fa-undo revert-field\" title=\"Revert back to the original value (" + originalValue + ") for this field\"" +
                                " onclick=\"revertField(this, '" + fieldSelector + "')\"></i>";
                                $(iElementStr).insertAfter(fieldSelector);
                            }
                        }

                        // “Volume” maps to the "Volume (mm3)" field (cect1sv) of the form.
                        if (key === "Volume") {
                            const fieldSelector = "#cect" + noduleId + "sv";
                            const $field = $(fieldSelector);
                            if ($field.hasClass("import-data")) {
                                //originalValue = $field.attr("original-value").val();
                                $field.val(value);
                            } else {
                                $field.addClass("import-data");
                                $field.attr("original-value", $field.val());
                                const originalValue = $field.val();
                                $field.val(value);
                                $field.parent().addClass("import-data-parent");
                                const iElementStr = "<i class=\"fa fa-undo revert-field\" title=\"Revert back to the original value (" + originalValue + ") for this field\"" +
                                " onclick=\"revertField(this, '" + fieldSelector + "')\"></i>";
                                $(iElementStr).insertAfter(fieldSelector);
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
                return {
                    displayNodules: _displayNodules,
                    addNodule: _addNodule,
                    importData: _importData,
                    revertData: _revertData,
                    removeNodule: _removeNodule,
                    sortData: _sortData
                };
            }

            return _init();
        }
    });
}(jQuery));

