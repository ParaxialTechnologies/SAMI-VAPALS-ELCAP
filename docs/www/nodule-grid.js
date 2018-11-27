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
 * @param {string|function} [options.availableNodules="10"] - number of nodules externally rendered in the grid. Depends on nodule_grid.jinja2
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

                    // All fields related to this nodule.
                    // NB: Note that we use regex instead of startsWith and endsWith jQuery selectors because
                    // nodule 10 would match cect1*
                    const regex = new RegExp("cect" + noduleIdx + "[a-z]");
                    const $fields = $('input,select').filter(function () {
                        const name = $(this).attr('name');
                        const id = $(this).attr('id');
                        return id !== "cect" + noduleIdx + "ch" && (regex.test(name) || regex.test(id));
                    });

                    if ($(this).val() === "-") {
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
                    }
                });
            }

            function setupMeanDiameterCalculation(lengthFieldSuffix, widthFieldSuffix, diamFieldSuffix) {
                const lengthFields = $("[name^=cect][name$=" + lengthFieldSuffix + "],[name^=cect][name$=" + widthFieldSuffix + "]");
                lengthFields.on('keyup change', function (e) {
                    const targetField = $(e.target);
                    const noduleId = targetField.closest("td").attr("data-nodule-id");
                    const noduleDiamLabel = $("#cect" + noduleId + diamFieldSuffix + "-val");
                    const wval = $("#cect" + noduleId + widthFieldSuffix).val();
                    const lval = $("#cect" + noduleId + lengthFieldSuffix).val();
                    const w = wval ? Number(wval) : 0;
                    const l = lval ? Number(lval) : 0;

                    if (w > 0 && l > 0) {
                        const meanDiam = (l + w) / 2;
                        if (meanDiam > 0) {
                            noduleDiamLabel.text(meanDiam.toFixed(1));
                        } else {
                            noduleDiamLabel.text("-");
                        }
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

            function markNoduleVolumeManuallyEntered(noduleIdx, isManual) {
                if (isManual) {
                    $("#cect" + noduleIdx + "sv").addClass("volumeOverride");
                    $("#cect" + noduleIdx + "svovrrde").val("true");
                    $("#cect" + noduleIdx + "svovrrde-warn").removeClass("invisible");
                } else {
                    $("#cect" + noduleIdx + "sv").removeClass("volumeOverride");
                    // set the manually overriden hidden field to false
                    $("#cect" + noduleIdx + "svovrrde").val("false");
                    $("#cect" + noduleIdx + "svovrrde-warn").addClass("invisible");
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
                    const fv = $(this).closest("form.validated").data('formValidation');
                    if (fv) {
                        fv.revalidateField("cect" + noduleIdx + "sv")
                    }
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
                setupMeanDiameterCalculation("sl", "sw", "sd");

                // solid mean diameter calculation
                setupMeanDiameterCalculation("ssl", "ssw", "ssd");

                for (let i = 0; i < settings.availableNodules; i++) {
                    setupNoduleVolumeCalculations(i);
                    setupNoduleEnabledState(i);
                }

                _displayNodules(settings.getNoduleCount());
                return {
                    displayNodules: _displayNodules,
                    addNodule: _addNodule,
                    removeNodule: _removeNodule,
                };
            }

            return _init();
        }
    });
}(jQuery));

