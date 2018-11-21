/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.StartEndDate = factory());
}(this, (function () { 'use strict';

  var Plugin = FormValidation.Plugin;

  var classCallCheck = function (instance, Constructor) {
    if (!(instance instanceof Constructor)) {
      throw new TypeError("Cannot call a class as a function");
    }
  };

  var createClass = function () {
    function defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }

    return function (Constructor, protoProps, staticProps) {
      if (protoProps) defineProperties(Constructor.prototype, protoProps);
      if (staticProps) defineProperties(Constructor, staticProps);
      return Constructor;
    };
  }();

  var inherits = function (subClass, superClass) {
    if (typeof superClass !== "function" && superClass !== null) {
      throw new TypeError("Super expression must either be null or a function, not " + typeof superClass);
    }

    subClass.prototype = Object.create(superClass && superClass.prototype, {
      constructor: {
        value: subClass,
        enumerable: false,
        writable: true,
        configurable: true
      }
    });
    if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass;
  };

  var possibleConstructorReturn = function (self, call) {
    if (!self) {
      throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
    }

    return call && (typeof call === "object" || typeof call === "function") ? call : self;
  };

  var StartEndDate = function (_Plugin) {
      inherits(StartEndDate, _Plugin);

      function StartEndDate(opts) {
          classCallCheck(this, StartEndDate);

          var _this = possibleConstructorReturn(this, (StartEndDate.__proto__ || Object.getPrototypeOf(StartEndDate)).call(this, opts));

          _this.fieldValidHandler = _this.onFieldValid.bind(_this);
          _this.fieldInvalidHandler = _this.onFieldInvalid.bind(_this);
          return _this;
      }

      createClass(StartEndDate, [{
          key: 'install',
          value: function install() {
              var _this2 = this;

              var fieldOptions = this.core.getFields();
              this.startDateFieldOptions = fieldOptions[this.opts.startDate.field];
              this.endDateFieldOptions = fieldOptions[this.opts.endDate.field];
              var form = this.core.getFormElement();
              this.core.on('core.field.valid', this.fieldValidHandler).on('core.field.invalid', this.fieldInvalidHandler).addField(this.opts.startDate.field, {
                  validators: {
                      date: {
                          format: this.opts.format,
                          max: function max() {
                              var endDateField = form.querySelector('[name="' + _this2.opts.endDate.field + '"]');
                              return endDateField.value;
                          },
                          message: this.opts.startDate.message
                      }
                  }
              }).addField(this.opts.endDate.field, {
                  validators: {
                      date: {
                          format: this.opts.format,
                          message: this.opts.endDate.message,
                          min: function min() {
                              var startDateField = form.querySelector('[name="' + _this2.opts.startDate.field + '"]');
                              return startDateField.value;
                          }
                      }
                  }
              });
          }
      }, {
          key: 'uninstall',
          value: function uninstall() {
              this.core.removeField(this.opts.startDate.field);
              if (this.startDateFieldOptions) {
                  this.core.addField(this.opts.startDate.field, this.startDateFieldOptions);
              }
              this.core.removeField(this.opts.endDate.field);
              if (this.endDateFieldOptions) {
                  this.core.addField(this.opts.endDate.field, this.endDateFieldOptions);
              }
              this.core.off('core.field.valid', this.fieldValidHandler).off('core.field.invalid', this.fieldInvalidHandler);
          }
      }, {
          key: 'onFieldInvalid',
          value: function onFieldInvalid(field) {
              switch (field) {
                  case this.opts.startDate.field:
                      this.startDateValid = false;
                      break;
                  case this.opts.endDate.field:
                      this.endDateValid = false;
                      break;
                  default:
                      break;
              }
          }
      }, {
          key: 'onFieldValid',
          value: function onFieldValid(field) {
              switch (field) {
                  case this.opts.startDate.field:
                      this.startDateValid = true;
                      if (this.endDateValid === false) {
                          this.core.revalidateField(this.opts.endDate.field);
                      }
                      break;
                  case this.opts.endDate.field:
                      this.endDateValid = true;
                      if (this.startDateValid === false) {
                          this.core.revalidateField(this.opts.startDate.field);
                      }
                      break;
                  default:
                      break;
              }
          }
      }]);
      return StartEndDate;
  }(Plugin);

  return StartEndDate;

})));
