/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.Transformer = factory());
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

  var Transformer = function (_Plugin) {
      inherits(Transformer, _Plugin);

      function Transformer(opts) {
          classCallCheck(this, Transformer);

          var _this = possibleConstructorReturn(this, (Transformer.__proto__ || Object.getPrototypeOf(Transformer)).call(this, opts));

          _this.valueFilter = _this.getElementValue.bind(_this);
          return _this;
      }

      createClass(Transformer, [{
          key: 'install',
          value: function install() {
              this.core.registerFilter('field-value', this.valueFilter);
          }
      }, {
          key: 'uninstall',
          value: function uninstall() {
              this.core.deregisterFilter('field-value', this.valueFilter);
          }
      }, {
          key: 'getElementValue',
          value: function getElementValue(defaultValue, field, element, validator) {
              if (this.opts[field] && this.opts[field][validator] && 'function' === typeof this.opts[field][validator]) {
                  return this.opts[field][validator].apply(this, [field, element, validator]);
              }
              return defaultValue;
          }
      }]);
      return Transformer;
  }(Plugin);

  return Transformer;

})));
