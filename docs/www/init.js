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
 * Extension of form validation framework to validate a date field in DD/MMM/YYYY fommat
 * @param value the value to validate
 * @param validator the validator name
 * @param $field object of the field being validated
 * @returns {boolean} true if valid.
 */
function validateInternationalDate(value, validator, $field) {
    var enabled = $field.is(":enabled");
    console.log("validateInternationalDate() Entered. value=" + value + ", validator=" + validator + ", field=" + $field.attr("id") + ", enabled: " + enabled)
    if (!enabled) {
        console.log("validateInternationalDate() field is disabled. Returning true")
        return true;
    }
    var m = new moment(value, VAPALS.DATE_FORMAT, true);
    if (!m.isValid()) {
        console.log("validateInternationalDate() field is invalid. Returning false")
        return false;
    }
    console.log("validateInternationalDate() field is valid. Returning true")
    return true;   // return true instead of value
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


//global application handlers
$(function () {
    $("body").on('keydown', 'input.numeric', numericHandlerKeydown);

    $.each($(".datepicker"), function (i, el) {
        var $input = $(el).find("input").addBack("input"); //find the actual input control
        var maxDateValue = $input.data('max-date');
        var maxDate = maxDateValue ? moment(maxDateValue, "DD/MMM/YYYY").endOf('day') : false; //false == no max
        $(el).datetimepicker({
            format: 'DD/MMM/YYYY',
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

});
