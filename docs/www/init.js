/**
 * VA-PALS Global helper functions.
 * @link https://github.com/OSEHRA/VA-PALS
 * @author Domenic DiNatale <domenic.dinatale@paraxialtech.com>
 * @license [Apache-2.0]{@link https://www.apache.org/licenses/LICENSE-2.0.html}
 * @copyright 2018 [VA-PALS]{@link http://va-pals.org/}
 * @class
 */

function numericHandlerKeydown(e) {
    //console.log("k:" + e.keyCode + " s:" + e.shiftKey + " m:" + e.metaKey + " c:" + e.ctrlKey)
    // Allow: backspace, delete, tab, escape, enter, . (decimal) (add 173 for - key)
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
        // Allow: Ctrl+A,C,V,X
        ($.inArray(e.keyCode, [65, 67, 86, 88]) !== -1 && (e.ctrlKey === true || e.metaKey === true)) ||
        // Allow: home, end, left, right
        (e.keyCode >= 35 && e.keyCode <= 39)) {
        // let it happen, don't do anything
        return;
    }
    // Ensure that it is a number and stop the keypress
    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
        e.preventDefault();
    }
}

/**
 * Adds a formValidation validator that ensures at least one of the checkboxes in $fields is selected.
 * This validator is dynamically enabled/disabled based on how many of it's triggering $fields are enabled.
 * @param $fields the checkbox fields
 * @param $validatorControl a hidden input field used to track how many checkboxes are selected.
 */
function requireOneValidator($fields, $validatorControl) {
    var fv = $("form.validated").data("formValidation");
    if (fv) {
        //put the list of fields onto the validator control so we can refer back to them to determine if the
        // validators should be enabled when triggered.
        $validatorControl.data("fv-fields", $fields);

        // set the initial value of the field to the state of the watched fields
        $validatorControl.val($fields.filter(":checked").length);
        
        $fields.on('change', function () {
            $validatorControl.val($fields.filter(":checked").length);
            fv.revalidateField($validatorControl);
        })
        fv.addField($validatorControl.attr("name"), {
            excluded: function ($field, validator) {
                //enabled only if at least one of its controlling fields is enabled
                //return $field.data("fv-fields").filter(":enabled").length == 0;
                //return $field.closest(":disabled").length>0;
                return false;
            },
            validators: {
                callback: {
                    callback: function (value, validator, $field) {
                        return {
                            //valid if all $fields are disabled or if the number of checked boxes is > 0
                            valid: $field.data("fv-fields").filter(":enabled").length == 0 || $field.val() > 0,
                            message: 'At least one selection is required'
                        }
                    }
                }
            }
        });
    }
}

/**
 * Helper function that revalidates a date when it has changed by manual change or via the datepicker plugin
 * @param e
 * @returns {boolean}
 */
function validateDatePickerOnChange(e) {
    var $datePicker = $(e.target)
    var fv = $datePicker.closest(".validated").data("formValidation");
    var $datePickerInput = $datePicker.find("input").addBack("input");
    if (fv && $datePickerInput.is(":enabled")) {
        fv.revalidateField($datePickerInput);
    }
    return true;
}

function initTabbedNavigation(tabContainerId, tabContentContainerId) {
    //setup tab navigation prev/next buttons
    function getCurrentTab() {
        return $("#" + tabContentContainerId).find("> div:visible");
    }

    function getNextTabId() {
        return getCurrentTab().next().attr("id");
    }

    function getPrevTabId() {
        return getCurrentTab().prev().attr("id");
    }

    function checkCompleteness($container) {
        var $requiredFields = $container.find("[required], [data-fv-notempty=true]").filter(":enabled"),
            $tab = $(".nav-tabs").find("a[href='#" + $container.attr("id") + "']");
        var emptyRequiredFields = $requiredFields.filter(function () {
            var $c = $(this);
            var value = $c.val();
            if ($c.is(":radio")) {
                var radioName = $c.attr("name");
                value = $("input[type='radio'][name='" + radioName + "']:checked").val();
            }
            return typeof value === "undefined" || value === "";
        });
        // check tab container validity

        var valid = emptyRequiredFields.length === 0; //consider unvalidated (null) as "valid".

        //add completeness flag to tab if all required fields are filled in and form is likely valid.
        $tab.toggleClass("complete", valid);

    }


    $(".btn-next").on("click", function () {
        var nextTabId = getNextTabId();
        // CB: form validation occurs on tab hide event
        $("#" + tabContainerId).find("a[href='#" + nextTabId + "']").tab('show');

    }).toggleClass("disabled", !getNextTabId());

    $(".btn-prev").on("click", function () {
        var prevTabId = getPrevTabId();
        // CB: form validation occurs on tab hide event
        $("#" + tabContainerId).find("a[href='#" + prevTabId + "']").tab('show');
    }).toggleClass("disabled", !getPrevTabId());

    $('a[data-toggle="tab"]').on('hide.bs.tab', function (e) {
        //validate each tab as it is navigated away from.
        var currentTab = e.target;
        var tabContentSelector = $(currentTab).attr("href");
        var fv = $(".validated").data('formValidation');
        fv.validateContainer(tabContentSelector);
        $(tabContentSelector).find("input, select").first().trigger('change'); //TODO: is this necessary?
    }).on("shown.bs.tab", function () {
        $(".btn-next").toggleClass("disabled", !getNextTabId());
        $(".btn-prev").toggleClass("disabled", !getPrevTabId());
        $("#" + tabContentContainerId).find("input:visible, textarea:visible, select:visible").not(".no-auto-focus").first().focus();
    });


    // trigger a check of completeness of each tab at page load and also any time an input changes.
    $(".tab-pane").each(function () {
        checkCompleteness($(this))
    }).on("keyup change", function () {
        var $container = $(this).closest(".tab-pane");
        checkCompleteness($container);
    });
}

/*
    Sets up a checkbox with the given name to behave as an "exclusive" selection, that is: 
    - Only one of the checkboxes that have this name can be selected at a time
    - The selected checkbox can be unchecked. 

    To a large extent the behavior of an exclusive checkbox is similar to that of a 
    radio button; however, the difference is that in a radio button, at least one of the radios
    is selected, where for an exclusive checkbox, all checkboxes could be unselected

    @param checkboxName the 'name' attribute of the checkbox input element
*/
function exclusiveCheckbox(elemSelector, commonParentSelector) {
    $(elemSelector).on("click",function() {
        const thisId = $(this).attr("id");
        const thisName = $(this).attr("name");
        if (this.checked) {
            $(this).closest(commonParentSelector).find('input[name="' + thisName + '"]:checked').filter(
                function(idx,elem) {
                    return $(elem).attr("id")!=thisId
                }
            ).prop('checked', false);
        }
    }); 
}

//global application handlers
$(function () {
    $("body").on('keydown', 'input.numeric', numericHandlerKeydown);

    $.each($(".datepicker"), function (i, el) {
        var $input = $(el).find("input").addBack("input"); //find the actual input control
        var maxDateValue = $input.data('max-date');
        var maxDate = maxDateValue ? moment(maxDateValue, "MM/DD/YYYY").endOf('day') : false; //false == no max
        $(el).datetimepicker({
            format: 'MM/DD/YYYY',
            useCurrent: false,
            keepInvalid: true,
            maxDate: maxDate //hack to not select today
        })
            .on("dp.change", validateDatePickerOnChange);
    });

    $.each($(".yearpicker"), function (i, el) {
        $(el).datetimepicker({
            format: 'YYYY',
            maxDate: moment().add(1, 'h'), //hack to not select today
            minDate: moment().subtract(100, 'y')
        }).on("dp.change", validateDatePickerOnChange);
    });

    //Globally enabled popovers for things like help text.
    $('[data-toggle="popover"]').popover();

    $("#save-for-later-button").on('click', function () {
        $("input[name=samistatus]").val("incomplete");
    });

    $("#submit-button").on('click', function () {
        $("input[name=samistatus]").val("complete");
    });

    /** Handling of the delete form modal */
    $("#delete-form").on("click", function(e) {
        $('#delete-confirm-modal').modal('show');
        e.preventDefault();
        e.stopPropagation();
    })

    $('#delete-form-cancel').on("click", function (e) {
        e.preventDefault();
        e.stopPropagation();

        $('#delete-confirm-modal').modal('hide');
    });
    
    $('#delete-confirm-modal').keypress(function(e) {
        var c = String.fromCharCode(e.which);
        if (e.which == 13 /* key code for Enter */ || c == "y" || c == "Y") {
            $("#delete-form-btn").trigger("click");
        } else if (c == "n" || c == "N") {
            $('#delete-form-cancel').trigger("click");
        }
    });
    /* ---------------- delete form modal dialog end ------*/

    /**
     * Attach an onclick handler to "a.navigation" elements such that when clicked, submits a form POST or GET using
     * parameters in the elements <code>data-*</code> attributes.
     *
     * Note that the <code>studyid</code> parameter is always injected based on the global <code>studyId</code>
     * variable.
     */
    $("a.navigation").on("click", function () {
        const data = $(this).data();
        const method = data.method === undefined ? "GET" : data.method;
        delete data.method;

        //field names are case-sensitive when POSTing to the backend. Generally lowercase is preferred.
        data.studyid = studyId;

        const form = document.createElement('form');
        form.style.visibility = 'hidden'; // no user interaction is necessary
        form.method = method; //'POST'; // forms by default use GET query strings
        form.action = method.toLowerCase() === "get" ? $(this).attr("href") : "/vapals";

        for (key in data) {
            const input = document.createElement('input');
            input.name = key;
            input.value = data[key];
            form.appendChild(input); // add key/value pair to form
        }
        document.body.appendChild(form);
        form.submit();

        return false;
    })

});
