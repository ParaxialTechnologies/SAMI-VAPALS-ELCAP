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
        let dob = item['dob'] || '';
        if (dob) {
            dob = moment(dob, 'YYYY-MM-DD').format('MM/DD/YYYY');
        }
        let gender = item['gender'] || '';
        if (gender) {
            gender = gender.split('^')[1];
        }

        let html = '';
        if (status == 1) {
            html = html + '<li class="enrolled">';
        } else {
            html = html + '<li>';
        }
        html = html + "<div class='row'>";
        html = html + '<div class="col-sm-12">' + item['name'] + '</div>';
        html = html + '</div>';
        html = html + '<div class="row">';
        html = html + '<div class="col-sm-3">' + 'Last 5: ' + item['last5'] + '</div>';
        html = html + '<div class="col-sm-3">' + 'DOB: ' + dob + '</div>';
        html = html + '<div class="col-sm-3">' + 'Gender: ' + gender + '</div>';

        if (status == 1) {
            const logoSource = $("img.logo-icon").attr('src');
            html = html + '<div class="col-sm-3 text-right" title="Patient is enrolled">';
            html = html + '<img src="' + logoSource + '" class="enrolled-icon" alt="Logo"/>';
            html = html + '</div>';
        } else {
            html = html + '<div class="col-sm-3"></div>'
        }
        html = html + "</div>";
        html = html + '</li>';

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
        dataOptions: {}, // options to include in the ajax request.
        classes: {
            'ui-autocomplete': 'fm-autocomplete-menu'
        },
        source: function (request, response) {
            let input = this.element;
            let query = $(input).val();
            if (query === '') {
                return false;
            }

            let ajaxRequest = null; //NB: keep on separate line so beforeSend function can access it.
            ajaxRequest = $.ajax({
                url: "/ptlookup/" + query,
                data: this.options.dataOptions,
                dataType: "json",
                beforeSend: function () {
                    if (ajaxRequest != null) {
                        ajaxRequest.abort();
                    }
                },
                done: function (msg) {
                    input.data('vista').patients = msg.result;
                    response(msg.result);
                },
                fail: function (jqXHR, textStatus) {
                    input.filemanAutocomplete('close');
                }
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
                if (input.val() === '') {
                    delete input.data('vista').patient;
                    input.val('');
                }
                // Treat other changes like accidents and restore the input value
                else {
                    let selectedPtName = input.data('vista').patient.name;

                    if (input.val() !== selectedPtName) {
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
