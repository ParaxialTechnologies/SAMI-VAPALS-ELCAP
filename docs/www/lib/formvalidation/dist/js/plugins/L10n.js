/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.L10n = factory());
}(this, (function () { 'use strict';

  var Plugin = FormValidation.Plugin;

  var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) {
    return typeof obj;
  } : function (obj) {
    return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj;
  };

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

  var L10n = function (_Plugin) {
      inherits(L10n, _Plugin);

      function L10n(opts) {
          classCallCheck(this, L10n);

          var _this = possibleConstructorReturn(this, (L10n.__proto__ || Object.getPrototypeOf(L10n)).call(this, opts));

          _this.messageFilter = _this.getMessage.bind(_this);
          return _this;
      }

      createClass(L10n, [{
          key: 'install',
          value: function install() {
              this.core.registerFilter('validator-message', this.messageFilter);
          }
      }, {
          key: 'uninstall',
          value: function uninstall() {
              this.core.deregisterFilter('validator-message', this.messageFilter);
          }
      }, {
          key: 'getMessage',
          value: function getMessage(locale, field, validator) {
              if (this.opts[field] && this.opts[field][validator]) {
                  var message = this.opts[field][validator];
                  var messageType = typeof message === 'undefined' ? 'undefined' : _typeof(message);
                  if ('object' === messageType && message[locale]) {
                      return message[locale];
                  } else if ('function' === messageType) {
                      var result = message.apply(this, [field, validator]);
                      return result && result[locale] ? result[locale] : '';
                  }
              }
              return '';
          }
      }]);
      return L10n;
  }(Plugin);

  return L10n;

})));
