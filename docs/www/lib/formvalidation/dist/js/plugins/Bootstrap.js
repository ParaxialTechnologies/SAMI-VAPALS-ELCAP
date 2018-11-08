/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.Bootstrap = factory());
}(this, (function () { 'use strict';

  var classSet = FormValidation.utils.classSet;

  var hasClass = FormValidation.utils.hasClass;

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

  var Bootstrap = function (_Framework) {
      inherits(Bootstrap, _Framework);

      function Bootstrap(opts) {
          classCallCheck(this, Bootstrap);
          return possibleConstructorReturn(this, (Bootstrap.__proto__ || Object.getPrototypeOf(Bootstrap)).call(this, Object.assign({}, {
              eleInvalidClass: 'is-invalid',
              eleValidClass: 'is-valid',
              formClass: 'fv-plugins-bootstrap',
              messageClass: 'fv-help-block',
              rowInvalidClass: 'has-danger',
              rowPattern: /^(.*)(col|offset)(-(sm|md|lg|xl))*-[0-9]+(.*)$/,
              rowSelector: '.form-group',
              rowValidClass: 'has-success'
          }, opts)));
      }

      createClass(Bootstrap, [{
          key: 'onIconPlaced',
          value: function onIconPlaced(e) {
              var parent = e.element.parentElement;
              if (hasClass(parent, 'input-group')) {
                  parent.parentElement.insertBefore(e.iconElement, parent.nextSibling);
              }
              var type = e.element.getAttribute('type');
              if ('checkbox' === type || 'radio' === type) {
                  var grandParent = parent.parentElement;
                  if (hasClass(parent, 'form-check')) {
                      classSet(e.iconElement, {
                          'fv-plugins-icon-check': true
                      });
                      parent.parentElement.insertBefore(e.iconElement, parent.nextSibling);
                  } else if (hasClass(parent.parentElement, 'form-check')) {
                      classSet(e.iconElement, {
                          'fv-plugins-icon-check': true
                      });
                      grandParent.parentElement.insertBefore(e.iconElement, grandParent.nextSibling);
                  }
              }
          }
      }]);
      return Bootstrap;
  }(Framework);

  return Bootstrap;

})));
