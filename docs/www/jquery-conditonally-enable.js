/*
 * jQuery Conditionally Enable Plugin
 *
 * Enable and disable fields based on if the source's value is equivalent to a a particular value or values.
 * Supports field value restoration.
 *
 * @todo add github link, author, copyright, license information
 *
 * Options:
 * {string|function} sourceValues - values to assert against the actual. When the source field value equals one of these,
 * the fields will become enabled. This argument can also be a callback function that determines disablement. function(actualValue)
 * A return of "true" means they should be enabled.
 * {string|object} enableFields - fields to toggle when source value is equal to one of the sourceValues (delimited by ",")
 * {string|object} disableFields - fields to toggle when source value is NOT equal the sourceValues (delimited by ",")
 * {string} [additionalDisabledClasses=visible-md-block visible-lg-block]- additional classes to append to each field in fields when it is disabled
 */
(function ($) {

    $.fn.conditionallyEnable = function (options) {

        var settings = $.extend({
            sourceValues: "y", // value $this.val() must match to enabled fields.
            enable: null, // fields to enable when value matches sourceValues
            disable: null, // fields to disable when value does not match sourceValues
            additionalDisabledClasses: "visible-md-block visible-lg-block" //hide at all screen widths, except when MD or larger
        }, options);


        function enableContainer($container, disablementClasses) {
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
                if (disablementClasses) {
                    $container.toggleClass(disablementClasses, false);
                }
            }
        }

        function disableContainer($container, disablementClasses) {
            if ($container != null && typeof $container !== 'undefined') {
                //include container object if it's actually an input.
                var $fields = $container.find("input, select, textarea").addBack('input, select, textarea');

                //reset form validations for the fields we're about to disable
                var fv = $("form.validated").data('formValidation');
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
                if (disablementClasses) {
                    $container.toggleClass(disablementClasses, true);
                }
            }
        }

        var enableFields = settings.enable, disableFields = settings.disable;

        var enableCallback = (typeof settings.sourceValues === 'function') ? settings.sourceValues : function (actualValue) {
            var sourceValuesArray = $.map(settings.sourceValues.split(","), $.trim);
            return $.inArray(actualValue, sourceValuesArray) > -1;
        };

        this.on('change', function () {
            var $el = $(this);
            var actualValue = $el.is(":checkbox") ? ($el.is(":checked") ? $el.val() : "") : $el.val();

            var enabled = enableCallback(actualValue);

            console.log("conditionallyEnable::change() triggered. id=" + $el.prop("id") + ", enabled=" + enabled);

            //toggle input fields within the container.
            var $enableContainer = (typeof enableFields === 'string') ? $(enableFields) : enableFields;
            var $disableContainer = (typeof disableFields === 'string') ? $(disableFields) : disableFields;
            if (enabled) {
                enableContainer($enableContainer, settings.additionalDisabledClasses);
                disableContainer($disableContainer, settings.additionalDisabledClasses);
            }
            else {
                disableContainer($enableContainer, settings.additionalDisabledClasses);
                enableContainer($disableContainer, settings.additionalDisabledClasses);
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

        return this;
    };
}(jQuery));



