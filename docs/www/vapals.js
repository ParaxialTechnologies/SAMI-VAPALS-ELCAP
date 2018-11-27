/**
 * VAPALS-ELCAP Project Utility class.
 * @link https://github.com/OSEHRA/VA-PALS
 * @author Domenic DiNatale <domenic.dinatale@paraxialtech.com>
 * @license [Apache-2.0]{@link https://www.apache.org/licenses/LICENSE-2.0.html}
 * @copyright 2018 [VAPALS-ELCAP]{@link http://va-pals.org/}
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
        var fromMoment = this.toMoment(from);
        var toMoment = this.toMoment(to);
        if (fromMoment.isValid() && toMoment.isValid()) {
            return Math.abs(parseInt(fromMoment.diff(toMoment, "months", true)))
        }
        return 0;
    };

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
     * Retrieves a Date representing "now", without time information.
     * @returns {Date}
     */
    this.todaysDate = function () {
        const now = new Date();
        now.setHours(0,0,0,0); // beginning of day
        return now;
    };

    /**
     * Retrieves the current year.
     * @returns {number}
     */
    this.todaysYear = function () {
        return parseInt(moment().format('YYYY'));
    };

    this.DATE_FORMAT = "MM/DD/YYYY";

    this.DATE_TIME_FORMAT = "MM/DD/YYYY hh:mm:ss";


    this.displayNotification = function (title, message, msgType) {
        if (!msgType) {
            msgType = BootstrapDialog.TYPE_INFO;
        }
        BootstrapDialog.alert({
            type: msgType,
            title: title,
            message: message,
            closable: true
        });
    };

    this.autoScrollToErrorField = function () {
        //focus on first error
        var firstErrEl = $(".fv-plugins-message-container [data-validator]:visible")
            .first()
            .closest(".form-group")
            .find(":input").first().prop("id");

        if (firstErrEl) {
            var $el = $("#" + firstErrEl);
            var top = $el.offset().top - 150; //150 here to scroll a bit higher

            $([document.documentElement, document.body]).animate({
                scrollTop: Math.max(0, top)
            }, 250);

            $el.focus();
        }
    };

    this.hideSuccessFormatting = function (e) {
        // e.element presents the field element
        // e.valid indicates the field is valid or not
        if (e.valid) {
            // Remove has-success from the container
            const groupEle = FormValidation.utils.closest(e.element, '.form-group');
            if (groupEle) {
                FormValidation.utils.classSet(groupEle, {
                    'has-success': false,
                });
            }

            // Remove is-valid from the element
            FormValidation.utils.classSet(e.element, {
                'is-valid': false,
            });
        }
    };

    this.calculatePulmonaryFunction = function(fev1, fvc){
        if (fev1 > 0 && fvc > 0) {
            return Math.round(100.0 * fev1 / fvc);
        }
        else {
            return 0;
        }
    }

};
