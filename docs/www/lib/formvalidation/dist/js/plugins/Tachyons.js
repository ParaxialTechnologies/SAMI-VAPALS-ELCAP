/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.Tachyons = factory());
}(this, (function () { 'use strict';

  var classSet = FormValidation.utils.classSet;

  var Framework = FormValidation.plugins.Framework;

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

  var Tachyons = function (_Framework) {
      inherits(Tachyons, _Framework);

      function Tachyons(opts) {
          classCallCheck(this, Tachyons);
          return possibleConstructorReturn(this, (Tachyons.__proto__ || Object.getPrototypeOf(Tachyons)).call(this, Object.assign({}, {
              formClass: 'fv-plugins-tachyons',
              messageClass: 'small',
              rowInvalidClass: 'red',
              rowPattern: /^(.*)fl(.*)$/,
              rowSelector: '.fl',
              rowValidClass: 'green'
          }, opts)));
      }

      createClass(Tachyons, [{
          key: 'onIconPlaced',
          value: function onIconPlaced(e) {
              var type = e.element.getAttribute('type');
              var parent = e.element.parentElement;
              if ('checkbox' === type || 'radio' === type) {
                  parent.parentElement.insertBefore(e.iconElement, parent.nextSibling);
                  classSet(e.iconElement, {
                      'fv-plugins-icon-check': true
                  });
              }
          }
      }]);
      return Tachyons;
  }(Framework);

  return Tachyons;

})));
