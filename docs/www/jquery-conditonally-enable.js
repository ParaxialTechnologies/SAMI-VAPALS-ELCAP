/**
 * The jQuery plugin namespace.
 * @external "jQuery.fn"
 * @see {@link http://learn.jquery.com/plugins/|jQuery Plugins}
 */

/**
 * A jQuery plugin to conditionally enable and disable fields based on the source's value. Supports field value restoration.
 * @link https://github.com/OSEHRA/VA-PALS
 * @author Domenic DiNatale <domenic.dinatale@paraxialtech.com>
 * @license [Apache-2.0]{@link https://www.apache.org/licenses/LICENSE-2.0.html}
 * @copyright 2018 [VA-PALS]{@link http://va-pals.org/}
 * @param {string|function} [options.sourceValues="y"] - a comma separated list of values that must match to trigger enabling fields, or a function that returns a true/false value for if the actual value is considered a match
 * @param {string|function|object} [options.enable=null] - jQuery selector of fields to enable when source value is equal to one of the <code>sourceValues</code>
 * @param {string|function|object} [options.disable=null] - jQuery selector of fields to disable when source value is NOT equal the <code>sourceValues</code>
 * @param {string} [options.additionalDisabledClasses=visible-md-block visible-lg-block]- additional classes to append to each field in fields when it is disabled
 * @todo add github link, author, copyright, license information
 * @class conditionallyEnable
 * @memberof jQuery.fn
 */
(function ($) {

    $.fn.conditionallyEnable = function (options) {

        var settings = $.extend({
            sourceValues: "y", // value $this.val() must match to enabled fields.
            enable: null, // fields to enable when value matches sourceValues
            disable: null, // fields to disable when value does not match sourceValues
            additionalDisabledClasses: "visible-md-block visible-lg-block" //hide at all screen widths, except when MD or larger
        }, options);

        var enabledAttributeName = "data-conditionally-enabled";

        function enableContainer($container) {
            if ($container != null && typeof $container !== 'undefined') {
                $container.find("input, select, textarea")
                    .addBack('input, select, textarea') //include container object if it's actually an input.
                    .prop("disabled", function (i, currentlyDisabled) {
                        if (true === currentlyDisabled) { //if value has changed
                            if ($(this).is(":checkbox")) {
                                $(this).prop("checked", $(this).data("previous-value") === "checked");
                            }
                            else { //other types of controls
                                $(this).val($(this).data("previous-value")); //restore old value
                            }
                            $(this).trigger("change");
                        }
                        return false;
                    });

                // make labels appear disabled.
                $container.find("label")
                    .addBack("label") //add the $field itself if is a label.
                    .toggleClass("text-muted", false);

                //when the value matches, always display the container, otherwise hide it on screens smaller than md.
                if (settings.additionalDisabledClasses) {
                    $container.toggleClass(settings.additionalDisabledClasses, false);
                }
            }
        }

        function disableContainer($container) {
            if ($container != null && typeof $container !== 'undefined') {
                // Include hidden fields as they may be used to aggregate other validators.
                // Also include the container object itself if it's actually an input.
                var $fields = $container.find("input, select, textarea, input[type=hidden]").addBack('input, select, textarea');

                //reset form validations for the fields we're about to disable
                var fv = $container.closest("form.validated").data('formValidation');
                if (fv) {
                    $.each($fields, function (i, t) {
                        fv.resetField($(t));
                    });
                }

                $fields.prop("disabled", function (i, currentlyDisabled) {
                    if (false === currentlyDisabled) { //if value has changed
                        if ($(this).is(":checkbox")) {
                            //save the old value
                            $(this).data("previous-value", $(this).is(":checked") ? "checked" : "");
                            $(this).prop("checked", false);

                        }
                        else { //other types of controls
                            $(this).data("previous-value", $(this).val()); //save the old value
                            $(this).val("");
                        }
                        $(this).trigger("change");
                    }
                    return true;
                });

                // make labels appear disabled.
                $container.find("label")
                    .addBack("label") //add the $field itself if is a label.
                    .toggleClass("text-muted", true);

                //when the value matches, always display the container, otherwise hide it on screens smaller than md.
                if (settings.additionalDisabledClasses) {
                    $container.toggleClass(settings.additionalDisabledClasses, true);
                }
            }
        }

        var disableFields = settings.disable;

        var matchCallback = (typeof settings.sourceValues === 'function') ? settings.sourceValues : function (actualValue) {
            var sourceValuesArray = $.map(settings.sourceValues.split(","), $.trim);
            return $.inArray(actualValue, sourceValuesArray) > -1;
        };

        var enableFieldsCallback = (typeof settings.enable === 'function') ? settings.enable : function (actualValue, matches) {
            return (typeof settings.enable === 'string') ? $(settings.enable) : settings.enable
        };

        var disableFieldsCallback = (typeof settings.disable === 'function') ? settings.disable : function (actualValue, matches) {
            return (typeof settings.disable === 'string') ? $(settings.disable) : settings.disable
        };


        this.on('change', function () {
            var $el = $(this);
            var actualValue = $el.is(":checkbox") ? ($el.is(":checked") ? $el.val() : "") : $el.val();

            var matches = matchCallback(actualValue);

            //toggle input fields within the container.
            var $enableContainer = enableFieldsCallback(actualValue, matches);
            var $disableContainer = disableFieldsCallback(actualValue, matches);
            var enableSize = $enableContainer == null ? 0 : $enableContainer.length
            var disableSize = $disableContainer == null ? 0 : $disableContainer.length

            // console.log("conditionallyEnable(): change event triggered on field. id=" + $el.prop("id") + ", name=" + $el.prop("name") + ", matches=" + matches + ", enable=" + enableSize + ", disable=" + disableSize);

            if (matches) {
                enableContainer($enableContainer);
                disableContainer($disableContainer);
            }
            else {
                disableContainer($enableContainer);
                enableContainer($disableContainer);
            }

            // With enable/disable functions done on the container, now trigger the change event on any field within
            // the $container that is bound to another instance of this plugin. This is necessary because the
            // enabled/disable functions called above will enabled/disable all fields in it's context including those
            // that are controlled by a child element within this container.
            $.each([$enableContainer, $disableContainer], function (i, $container){
                if ($container){
                    $container.find("["+enabledAttributeName+"]").trigger("change");
                }
            });

            //finally reset any validations on now-disabled fields
            if ($enableContainer != null && typeof $enableContainer !== 'undefined') {
                var fv = $enableContainer.closest("form.validated").data('formValidation');
                if (fv) {
                    var disabledFields = $enableContainer.find("input:disabled, select:disabled, textarea:disabled");
                    $.each(disabledFields, function (i, t) {
                        // console.log("resetting field " + $(t).attr('name'))
                        fv.resetField($(t));
                    });
                }
            }
        });

        if (this.first().is(":radio")) {
            //trigger the change event on the first checked or non-matching radio button
            $.merge(
                this.filter(":checked"),
                this.filter(":not(':checked')")
            ).first().trigger("change");
        }
        else {
            this.trigger("change");
        }

        $(this).attr(enabledAttributeName, 'true');
        return this;
    };
}(jQuery));



