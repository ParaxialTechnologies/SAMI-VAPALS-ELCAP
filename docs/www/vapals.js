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
    };

    /**
     * Computes the number of months between the provided date and now.
     * @param {date|moment|string} sinceDate the date
     * @returns {number}
     */
    this.computeMonthsFrom = function (sinceDate) {
        console.log("computeMonthsFrom() entered. sinceDate=" + sinceDate);
        var since = this.toMoment(sinceDate);
        if (since != null && since.isValid()) {
            return this.computeMonthsBetween(since, moment());
        }
        return 0;
    }

    /**
     * Computes the number of months between the provided date and now.
     * @param {date|moment|string} from a from date
     * @param {date|moment|string} to a to date
     * @returns {number}
     */
    this.computeMonthsBetween = function (from, to) {
        console.log("computeMonthsBetween() entered. from=" + from + ", to=" + to);

        var fromMoment = this.toMoment(from);
        var toMoment = this.toMoment(to);
        if (fromMoment.isValid() && toMoment.isValid()) {
            return Math.abs(parseInt(fromMoment.diff(toMoment, "months", true)))
        }
        return 0;
    }

    /**
     * Converts a value into a moment object
     * @param {date|moment|string} value the value
     * @returns {moment}
     */
    this.toMoment = function (value) {
        if (moment.isMoment(value)) {
            return value;
        }
        else if ($.type(value) === "date") {
            return moment(value);
        }
        else {
            return moment(value, VAPALS.DATE_FORMAT);
        }
    };

    this.DATE_FORMAT = "DD/MMM/YYYY";

    this.DATE_TIME_FORMAT = "DD/MMM/YYYY hh:mm:ss";
};
