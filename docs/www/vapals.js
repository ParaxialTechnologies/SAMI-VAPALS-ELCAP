/**
 * VA-PALS Project Utility class.
 * Requires JQuery.
 */
var VAPALS = new function () {
    /**
     * Calculates the Body Mass Index
     * @param height the height
     * @param heightunits the height units, must start with "i" (for inches) or assumed centimeters.
     * @param weight the weight
     * @param weightunits the weight units, must start with "p" (for pounds) or assumed kilograms
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
     * @param bmi the calculated BMI
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
     * @param date the date
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


// function addNumericHandler(obj) {
//     $(obj).keydown(numericHandlerKeydown);
// }

//global application handlers
$(function () {
    $("body").on('keydown', 'input.numeric', numericHandlerKeydown);

});
