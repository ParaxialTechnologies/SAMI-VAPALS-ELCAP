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

            function setupNoduleEnabledState(noduleIdx) {
                $("#cect" + noduleIdx + "nt").conditionallyEnable({
                    sourceValues: "m",
                    enable: "#cect" + noduleIdx + "-container"
                });

                $("#cect" + noduleIdx + "ch").on('change.cteval', function () {

                    // $fields is an array of fields related to this nodule with the exception of "is it new"
                    // NB: Note that we use regex instead of startsWith and endsWith jQuery selectors because
                    // nodule 10 would match cect1*
                    const regex = new RegExp("cect" + noduleIdx + "[a-z]");
                    let $fields = $('input,select').filter(function () {
                        const name = $(this).attr('name');
                        const id = $(this).attr('id');
                        return id !== "cect" + noduleIdx + "ch" && (regex.test(name) || regex.test(id));
                    });
                    let isItNewValue = $(this).val();

                    // if the "is it new" selection is a value that means the nodule is no longer present or otherwise
                    // resolved, clear MOST fields. These values include: resolved (pw), not a nodule (px),
                    // resected (pr), Not in outside report (pk), not included in scan (pv)
                    let noduleResolved = ['pw', 'px', 'pr', 'pk', 'pv'].includes(isItNewValue);
                    if (noduleResolved) {
                        //reduce the list to exclude the fields: status (st) and likely location (ll)
                        $fields = $fields.filter(function () {
                            const id = $(this).attr('id');
                            const idsToMatch = [
                                'cect' + noduleIdx + 'st',
                                'cect' + noduleIdx + 'll'
                            ];
                            return !idsToMatch.includes(id);
                        })
                    }

                    if (isItNewValue === "-" || noduleResolved) {
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
                        $fields
                            .prop('disabled', false)
                            .trigger('change.conditionally-enable'); //set state according to other rules (i.e. part-solid fields)

                        // fixes a bug where L & W fields were required when nodule was solid and "is it new" was
                        // changed from "-" to anything else; which occurs on subsequent scans.
                        $("#cect" + noduleIdx + "nt").trigger('change');
                    }
                }).trigger('change.cteval'); //triggered in the event that the nodule grid is loaded with one of the
                // above resolved nodule states
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

            function setupNoduleVolumeCalculations(noduleIdx) {
                const lenWidthHeightFields = $("#cect" + noduleIdx + "sl, #cect" + noduleIdx + "sw, #cect" + noduleIdx + "sh");
                lenWidthHeightFields.on("keyup", function () {
                    let allFilled = true;

                    lenWidthHeightFields.each(function () {
                        const v = $(this).val() || 0;
                        if (v == 0) {
                            allFilled = false;
                        }
                    });

                    const btnElem = $("#cect" + noduleIdx + "svb");
                    if (allFilled) {
                        btnElem.attr("disabled", false);
                    } else {
                        btnElem.attr("disabled", true);
                    }
                }).first().trigger("keyup");

                $("#cect" + noduleIdx + "svb").on('click', function () {
                    const l = $("#cect" + noduleIdx + "sl").val() || 0;
                    const w = $("#cect" + noduleIdx + "sw").val() || 0;
                    const h = $("#cect" + noduleIdx + "sh").val() || 0;

                    const v = Math.PI * (4 / 3) * l / 2 * w / 2 * h / 2;

                    $("#cect" + noduleIdx + "sv").val(v.toFixed(1));
                    markNoduleVolumeManuallyEntered(noduleIdx, false);
                    //temporarily disabled
                    // checkConsistentVolumeCalculations();
                    return false;
                });


                $("#cect" + noduleIdx + "sv").on('change', function () {
                    // manually overriding the volume calculation
                    if ($(this).val() !== "") {
                        markNoduleVolumeManuallyEntered(noduleIdx, true);
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
                console.log("swapFields() entered. noduleIndex=" + noduleIndex + ", other=" + otherIndex);
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

                for (let i = 0; i < settings.availableNodules; i++) {
                    setupNoduleVolumeCalculations(i);
                    setupNoduleEnabledState(i);
                }

                _displayNodules(settings.getNoduleCount());
                return {
                    displayNodules: _displayNodules,
                    addNodule: _addNodule,
                    removeNodule: _removeNodule,
                    sortData: _sortData
                };
            }

            return _init();
        }
    });
}(jQuery));

