/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function ($) {
  'use strict';

  $ = $ && $.hasOwnProperty('default') ? $['default'] : $;

  var formValidation = FormValidation.formValidation;

  var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) {
    return typeof obj;
  } : function (obj) {
    return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
  };

  var version = $.fn.jquery.split(' ')[0].split('.');
  if (+version[0] < 2 && +version[1] < 9 || +version[0] === 1 && +version[1] === 9 && +version[2] < 1) {
      throw new Error('The J plugin requires jQuery version 1.9.1 or higher');
  }
  $.fn['formValidation'] = function (options) {
      var params = arguments;
      return this.each(function () {
          var $this = $(this);
          var data = $this.data('formValidation');
          var opts = 'object' === (typeof options === 'undefined' ? 'undefined' : _typeof(options)) && options;
          if (!data) {
              data = formValidation(this, opts);
              $this.data('formValidation', data).data('FormValidation', data);
          }
          if ('string' === typeof options) {
              data[options].apply(data, Array.prototype.slice.call(params, 1));
          }
      });
  };

}(jQuery));
