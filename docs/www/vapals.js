/**
 * VAPALS-ELCAP Project Utility class.
 * @link https://github.com/OSEHRA/VA-PALS
 * @author Domenic DiNatale <domenic.dinatale@paraxialtech.com>
 * @license [Apache-2.0]{@link https://www.apache.org/licenses/LICENSE-2.0.html}
 * @copyright 2018 [VAPALS-ELCAP]{@link http://va-pals.org/}
 * @class
 */
VAPALS = new function () {
    this.DATE_FORMAT = "MM/DD/YYYY";

    this.DATE_TIME_FORMAT = "MM/DD/YYYY hh:mm:ss";

    /**
     * Computes the number of months between the provided date and now.
     * @param {date|moment|string} from a from date
     * @param {date|moment|string} to a to date
     * @returns {number}
     */
    this.computeMonthsBetween = function (from, to) {
        const fromMoment = this.toMoment(from);
        const toMoment = this.toMoment(to);
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
        } else if ($.type(value) === "date") {
            return moment(value);
        } else {
            return moment(value, VAPALS.DATE_FORMAT);
        }
    };

    /**
     * Retrieves a Date representing "now", without time information.
     * @returns {Date}
     */
    this.todaysDate = function () {
        const now = new Date();
        now.setHours(0, 0, 0, 0); // beginning of day
        return now;
    };

    /**
     * Retrieves the current year.
     * @returns {number}
     */
    this.todaysYear = function () {
        return parseInt(moment().format('YYYY'));
    };


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
        const firstErrEl = $(".fv-plugins-message-container [data-validator]:visible")
            .first()
            .closest(".form-group")
            .find(":input").first().prop("id");

        if (firstErrEl) {
            const $el = $("#" + firstErrEl);
            const top = $el.offset().top - 150; //150 here to scroll a bit higher

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

    this.calculatePulmonaryFunction = function (fev1, fvc) {
        if (fev1 > 0 && fvc > 0) {
            return Math.round(100.0 * fev1 / fvc);
        } else {
            return 0;
        }
    };

    /**
     * Computes packs per year.
     * @param {date|moment|string} from a from date
     * @param {date|moment|string} to a to date
     * @returns {number}
     */
    this.calculatePacksPerDay = function (cigarettesPerDay) {

        if (cigarettesPerDay >= 0) {
            return (cigarettesPerDay / 20).toFixed(2);
        }

        return 0;
    };

    /**
     * Computes packs per year.
     * @param {date|moment|string} from a from date
     * @param {date|moment|string} to a to date
     * @returns {number}
     */
    this.calculatePackYears = function (packsPerDay, years) {

        if (packsPerDay > 0 && years > 0) {
            const packYears = (packsPerDay * years).toFixed(1);
            return packYears;
        }

        return 0;
    };


    /**
     * Sleeps the UI thread for the given number of milliseconds
     * @param ms
     * @returns {Promise<any>}
     */
    this.sleep = function (ms) {
        // return new Promise(resolve => setTimeout(resolve, ms)); // Won't work in IE11
        return new Promise(function (resolve) {
            return setTimeout(resolve, ms)
        })
    };

    /**
     * reduces an array to unique values <code>array.filter(unique)
     * @param value
     * @param index
     * @param self
     * @returns {boolean}
     */
    this.unique = function (value, index, self) {
        return self.indexOf(value) === index;
    };

    /**
     * Returns the data dictionary of the current page.
     */
    this.dd = function () {

        let report = "";

        function line(text) {
            report = report + text + "\n"
        }

        const processed = [];
        line("QUESTION\tNAME\tTYPE\tREQUIRED\tPLACEHOLDER\tVALUES\tLABELS");
        $.each($("form").find(":input, p.lead, h3, h4, label.doc-heading"), function (i, el) {
            const $el = $(el);
            let name = $el.prop('name');
            let type = $el.prop('type');
            const tagName = $el.prop("tagName");
            //A ? signifies could be conditionally required. Rules could be complex
            // const required = $el.prop("required") === true ? "Yes" : "?";
            // Changing this for now so we have a boolean value in the graph store
            const required = $el.prop("required") === true ? "1" : "0";

            //skip hidden fields since they can be pseudo elements for checkboxes
            if (type !== 'hidden' && type !== 'submit' && !processed.includes(name)) {
                processed.push(name);

                let values = [];
                let labels = [];
                if (type === 'radio') {
                    const $options = $("[name=" + name + "]");
                    values = Array.from($options.map(function () {
                        return $(this).val()
                    }));
                    labels = Array.from($options.map(function () {
                        return $(this).closest("label").text().trim()
                    }));
                } else if (type === 'select' || type === 'select-one') {
                    const $options = $el.find("option");
                    values = Array.from($options.map(function () {
                        return $(this).val()
                    }));
                    labels = Array.from($options.map(function () {
                        return $(this).text().trim()
                    }));
                } else if (type === 'checkbox') {
                    values.push($el.val());
                    labels.push($el.closest("label").text().trim())
                } else if (type === 'text' || type === 'textarea') {
                    const label = $el.prop('placeholder') || $el.prop('title') || $el.closest(".form-group").find("label").first().text().trim().replace(/(\r\n|\n|\r)/gm, " ").replace(/\t/g, " ").replace(/\s+/g, " ");
                    labels.push(label);
                } else if (tagName === "P" || tagName === "H3" || tagName === "H4" || tagName === "LABEL") {
                    name = "-";
                    type = "-";
                    values.push("-");
                    labels.push($el.text().trim().replace(/(\r\n|\n|\r)/gm, " ").replace(/\t/g, " ").replace(/\s+/g, " "));
                } else {
                    console.log(name + " is a " + type)
                }

                // Additions by Alexis
                let question = '';
                question = $el.closest('.form-group').prev('label').text().trim().replace(/(\r\n|\n|\r)/gm, " ").replace(/\t/g, " ").replace(/\s+/g, " ");
                // Call out the absence of a meaningful question so a human can provide it.
                // if (question === labels.toString()) question = '';
                if (question == '') {
                    question = $el.prev('label').text().trim().replace(/(\r\n|\n|\r)/gm, " ").replace(/\t/g, " ").replace(/\s+/g, " ");
                }
                if (question == '') {
                    question = $el.closest('.input-group').prev('label').text().trim().replace(/(\r\n|\n|\r)/gm, " ").replace(/\t/g, " ").replace(/\s+/g, " ");
                }
                if (question == '') {
                    question = $el.closest('.form-group').find('label').first().text().trim().replace(/(\r\n|\n|\r)/gm, " ").replace(/\t/g, " ").replace(/\s+/g, " ");
                }

                // Additions by Alexis
                // For now we'll capture this manually; it's simply to provide a blank column.
                let placeholder = '';

                // Additions by Alexis
                values = values.join(';');
                labels = labels.join(';');

                line([question, name, type, required, placeholder, values, labels].join("\t"));
                // console.log(labels.join(","))
            }
        });
        console.log(report);
        return report;
    }
};
