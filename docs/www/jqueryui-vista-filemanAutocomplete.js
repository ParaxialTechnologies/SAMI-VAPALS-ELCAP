/*
Autocomplete & find one record
Extend the
jQuery Autocomplete Widget ~ https://api.jqueryui.com/autocomplete/
*/
$.widget('vista.filemanAutocomplete', $.ui.autocomplete, {
    _create: function () {
        let input = this.element;
        let vistaData = {};
        input.data('vista', vistaData);

        // When focus returns to this input
        input.focus(function () {
            input.filemanAutocomplete('search');
        });

        this._super();
    }, // End ~ _create()
    _renderItem: function (ul, item) {
        let status = item['vapals'] || 0;
                    
        let html   = '';
        if (status == 1) {
            html   = html + '<li class="enrolled">';
        }
        else {
            html   = html + '<li>';
        }
        html       = html + '<span>' + item['name'] + '</span>';
        html       = html + '<br>';
        html       = html + '<span class="indent">';
        html       = html + 'Last 5: ';
        html       = html + item['last5']
        html       = html + '</span>';
        html       = html + '<br>';
        html       = html + '<span class="indent">';
        html       = html + 'DOB: ';
        html       = html + item['dob']
        html       = html + '</span>';
        html       = html + '<br>';
        html       = html + '<span class="indent">';
        html       = html + 'Gender: ';
        html       = html + item['gender']
        html       = html + '</span>';
        if (status == 1) {
            html   = html + '<br>';
            html   = html + '<span class="indent">';
            html   = html + 'Enrolled in VA-PALS';
            html   = html + '</span>';
        }
        html       = html + '</li>';
        
        return $(html).appendTo(ul);
    }, // End ~ _renderItem()
    _destroy: function () {
        let input = this.element;
        input.val('');

        this._super();
    }, // End ~ _destroy()
    options: {
        minLength: 0,
        delay: 200,
        classes: {
            'ui-autocomplete': 'fm-autocomplete-menu'
        },
        source: function (request, response) {
            let input = this.element;

            let query = $(input).val();
            if (query == '') {
                return false;
            }

            let ajaxRequest = $.ajax({
                url: "/ptlookup/" + query,
                dataType: "json"
            });

            ajaxRequest.done(function (msg) {
                input.data('vista').patients = msg.result;

                response(msg.result);
            });

            ajaxRequest.fail(function (jqXHR, textStatus) {
                input.filemanAutocomplete('close');
            });
        }, // End ~ source
        // Events
        //
        // On blur, if value has changed
        change: function (event, ui) {
            let input = $(this);

            // Only take action if a record has been selected
            if (input.data('vista').patient) {
                // Delete the saved record if the input is empty
                if (input.val() == '') {
                    delete input.data('vista').patient;
                    input.val('');
                }
                // Treat other changes like accidents and restore the input value
                else {
                    let selectedPtName = input.data('vista').patient.name;

                    if (input.val() != selectedPtName) {
                        input.val(selectedPtName);
                    }
                }
            }
        }, // End ~ change
        select: function (event, ui) {
            // Attach record data to the element & show display field
            $(this).data('vista').patient = ui.item;
            $(this).val(ui.item['name']);

            return false;
        }
    }
});
