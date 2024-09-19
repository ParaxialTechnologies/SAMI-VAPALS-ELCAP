/**
 * The jQuery plugin namespace.
 * @external "jQuery.fn"
 * @see {@link http://learn.jquery.com/plugins/|jQuery Plugins}
 */

/**
 * A jQuery plugin to conditionally show and hide containers based on the source's value.
 * @link https://github.com/VA-PALS-ELCAP/SAMI-VAPALS-ELCAP
 * @author Domenic DiNatale <domenic.dinatale@paraxialtech.com>
 * @license [Apache-2.0]{@link https://www.apache.org/licenses/LICENSE-2.0.html}
 * @copyright 2018 [VAPALS-ELCAP]{@link http://va-pals.org/}
 * @param {string|function} [options.sourceValues="y"] - a comma separated list of values that must match to trigger enabling fields, or a function that returns a true/false value for if the actual value is considered a match
 * @param {string|function|object} [options.enable=null] - jQuery selector of fields to enable when source value is equal to one of the <code>sourceValues</code>
 * @param {string|function|object} [options.disable=null] - jQuery selector of fields to disable when source value is NOT equal the <code>sourceValues</code>

 * @todo add github link, author, copyright, license information
 * @class conditionallyDisplay
 * @memberof jQuery.fn
 */
(function ($) {

    $.fn.conditionallyDisplay = function (options) {

        var settings = $.extend({
            sourceValues: "y", // value $this.val() must match to enabled fields.
            enable: null, // fields to enable when value matches sourceValues
            disable: null // fields to disable when value does not match sourceValues
        }, options);

        // console.log("conditionallyDisplay (settings: " + JSON.stringify(settings) + ")")

        var disableFields = settings.disable;

        var matchCallback = (typeof settings.sourceValues === 'function') ? settings.sourceValues : function (actualValue) {
            var sourceValuesArray = $.map(settings.sourceValues.split(","), $.trim);
            if ($.isArray(actualValue)) {
                // return sourceValuesArray.some(v => actualValue.includes(v)); //won't work in IE11
                return sourceValuesArray.some(function (v) {
                    return actualValue.includes(v);
                });
            }
            return $.inArray(actualValue, sourceValuesArray) > -1;
        };

        var enableFieldsCallback = (typeof settings.enable === 'function') ? settings.enable : function (actualValue, matches) {
            return (typeof settings.enable === 'string') ? $(settings.enable) : settings.enable
        };

        var disableFieldsCallback = (typeof settings.disable === 'function') ? settings.disable : function (actualValue, matches) {
            return (typeof settings.disable === 'string') ? $(settings.disable) : settings.disable
        };


        this.on('change.conditionally-display, keyup.conditionally-display', function () {
            var $el = $(this);
            var actualValue = $el.is(":checkbox, :radio") ? ($el.is(":checked") ? $el.val() : "") : $el.val();

            var matches = matchCallback(actualValue);

            //toggle input fields within the container.
            var $enableContainer = enableFieldsCallback(actualValue, matches);
            var $disableContainer = disableFieldsCallback(actualValue, matches);

            // console.log("conditionallyDisplay(): change event triggered on field. id=" + $el.prop("id") + ", name=" + $el.prop("name") + ", matches=" + matches + ", enable=" + enableSize + ", disable=" + disableSize);

            if (matches) {
                if ($enableContainer != null) {
                    $enableContainer.show();
                }
                if ($disableContainer !== null) {
                    $disableContainer.hide();
                }
            } else {
                if ($enableContainer != null) {
                    $enableContainer.hide();
                }
                if ($disableContainer !== null) {
                    $disableContainer.show();
                }
            }

            //finally reset any validations on all input fields - we don't want
            // any errors or markings to be coming out of fields that are not visible
            $.each([$enableContainer, $disableContainer], function (i, $container) {
                if ($container != null && typeof $container !== 'undefined') {
                    var fv = $container.closest("form.validated").data('formValidation');
                    if (fv) {
                        var inputFields = $container.find("input, select, textarea")
                            .addBack('input, select, textarea'); //include container object if it's actually an input
                        $.each(inputFields, function (i, t) {
                            const $field = $(t);
                            const fieldName = $field.attr("name");
                            const isValidatedField = fv.fields[fieldName] != null;
                            const isVisible = $field.is(":visible");

                            if (isValidatedField) {
                                fv.resetField(fieldName);
                                if (isVisible) {
                                    fv.enableValidator(fieldName);
                                } else {
                                    fv.disableValidator(fieldName);
                                }
                            }
                        });
                    }
                }
            });


        });

        if (this.first().is(":radio")) {
            //trigger the change event on the first checked or non-matching radio button
            $.merge(
                this.filter(":checked"),
                this.filter(":not(':checked')")
            ).first().trigger("change");
        } else {
            this.trigger("change");
        }

        return this;
    };
}(jQuery));



