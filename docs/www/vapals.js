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

    /**
     * Retrieves a Date representing "now".
     * @returns {Date}
     */
    this.todaysDate = function() {
        return new Date();
    }

    this.DATE_FORMAT = "MM/DD/YYYY";

    this.DATE_TIME_FORMAT = "MM/DD/YYYY hh:mm:ss";
};
