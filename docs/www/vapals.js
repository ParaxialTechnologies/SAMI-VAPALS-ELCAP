/**
 * VA-PALS Project Utility class.
 * @link https://github.com/OSEHRA/VA-PALS
 * @author Domenic DiNatale <domenic.dinatale@paraxialtech.com>
 * @license [Apache-2.0]{@link https://www.apache.org/licenses/LICENSE-2.0.html}
 * @copyright 2018 [VA-PALS]{@link http://va-pals.org/}
 * @class
 */
var VAPALS = new function () {
    /**
     * Calculates the Body Mass Index
     * @param {number} height the height
     * @param {string} heightunits the height units, must start with "i" (for inches) or assumed centimeters.
     * @param {number} weight the weight
     * @param {string} weightunits the weight units, must start with "p" (for pounds) or assumed kilograms
     * @returns {number} the calculated Body Mass Index as a decimal with 2 digit precision
     */
    this.computeBMI = function (height, heightunits, weight, weightunits) {
        console.log("computeBMI() entered. height=" + height + ", heightunits=" + heightunits + ", weight=" + weight + ", weightunits=" + weightunits);

        height = parseInt(height) || 0;
        heightunits = heightunits || "c";
        console.log("height is " + height)
        if (height === NaN) throw "value for height is not a number";
        if ($.type(heightunits) !== "string") throw "value for heightunits is not a string";
        if (height <= 0) throw "height must be greater than 0";

        weight = parseInt(weight) || 0;
        weightunits = weightunits || "k";
        if (weight === NaN) throw "value for weight is not a number";
        if ($.type(weightunits) !== "string") throw "value for weightunits is not a string";
        if (weight <= 0) throw "weight must be greater than 0";

        //Convert all units to metric
        var meters = (heightunits.indexOf("i") === 0) ? height * 0.0254 : height / 100;
        var kilograms = (weightunits.indexOf("p") === 0) ? weight * 0.453592 : weight;

        //Perform calculation kg/(m^2)
        var bmiRaw = kilograms / Math.pow(meters, 2);

        //Display result of calculation
        var bmi = Math.round(bmiRaw * 100) / 100;
        console.log("computeBMI() returning. bmi=" + bmi);
        return bmi;
    };

    /**
     * Determines the descriptive text used to represent a BMI value.
     * @param {number} bmi the calculated BMI
     * @returns {string} The human-readable text indicating how overweight the given BMI is.
     * @throws error if input is not a number
     */
    this.computeBmiDescriptor = function (bmi) {
        console.log("computeBmiDescriptor() entered. bmi=" + bmi);
        if ($.type(bmi) !== "number") throw "value for bmi is not a number";

        if (bmi < 18.5)
            return "Underweight";
        else if (bmi >= 18.5 && bmi < 25)
            return "Normal";
        else if (bmi >= 25 && bmi < 30)
            return "Overweight";
        else if (bmi >= 30)
            return "Obese";

    };

    /**
     * Computes the number of years from {date} to now
     * @param {date} date the date to compute age from
     * @returns {(number)} number of years rounded down to the nearest integer, or null if input is not a date.
     */
    this.computeAge = function (date) {
        console.log("computeAge() entered. date=" + date);
        if ($.type(date) !== "date") {
            throw "value for date is not a Date";
        }
        var ageDifMs = Date.now() - date.getTime();
        var ageDate = new Date(ageDifMs); // milliseconds from epoch
        var response = Math.abs(ageDate.getUTCFullYear() - 1970);
        console.log("computeAge() returning. response=" + response);
        return response
    }

    this.notCovered = function () {
        console.log("cover me!")
    }

    this.DATE_FORMAT = "DD/MMM/YYYY";

    this.DATE_TIME_FORMAT = "DD/MMM/YYYY hh:mm:ss";
};


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

function validateDatePickerOnChange(e) {
    var $datePicker = $(e.target)
    var fv = $datePicker.closest(".validated").data("formValidation");
    var $datePickerInput = $datePicker.find("input").addBack("input");
    if (fv && $datePickerInput.is(":enabled")) {
        fv.revalidateField($datePickerInput);
    }
    return true;
}

// function addNumericHandler(obj) {
//     $(obj).keydown(numericHandlerKeydown);
// }

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

    $("#save-for-later-button").on('click', function(){
        $("input[name=status]").val("incomplete");
    });

    $("#submit-button").on('click', function(){
        $("input[name=status]").val("complete");
    });

});
