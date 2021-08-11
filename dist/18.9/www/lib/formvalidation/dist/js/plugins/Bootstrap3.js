/**
 * FormValidation (https://formvalidation.io), v1.4.0 (678705b)
 * The best validation library for JavaScript
 * (c) 2013 - 2019 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global = global || self, (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.Bootstrap3 = factory()));
}(this, function () { 'use strict';

  function _classCallCheck(instance, Constructor) {
    if (!(instance instanceof Constructor)) {
      throw new TypeError("Cannot call a class as a function");
    }
  }

  function _defineProperties(target, props) {
    for (var i = 0; i < props.length; i++) {
      var descriptor = props[i];
      descriptor.enumerable = descriptor.enumerable || false;
      descriptor.configurable = true;
      if ("value" in descriptor) descriptor.writable = true;
      Object.defineProperty(target, descriptor.key, descriptor);
    }
  }

  function _createClass(Constructor, protoProps, staticProps) {
    if (protoProps) _defineProperties(Constructor.prototype, protoProps);
    if (staticProps) _defineProperties(Constructor, staticProps);
    return Constructor;
  }

  function _inherits(subClass, superClass) {
    if (typeof superClass !== "function" && superClass !== null) {
      throw new TypeError("Super expression must either be null or a function");
    }

    subClass.prototype = Object.create(superClass && superClass.prototype, {
      constructor: {
        value: subClass,
        writable: true,
        configurable: true
      }
    });
    if (superClass) _setPrototypeOf(subClass, superClass);
  }

  function _getPrototypeOf(o) {
    _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) {
      return o.__proto__ || Object.getPrototypeOf(o);
    };
    return _getPrototypeOf(o);
  }

  function _setPrototypeOf(o, p) {
    _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) {
      o.__proto__ = p;
      return o;
    };

    return _setPrototypeOf(o, p);
  }

  function _assertThisInitialized(self) {
    if (self === void 0) {
      throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
    }

    return self;
  }

  function _possibleConstructorReturn(self, call) {
    if (call && (typeof call === "object" || typeof call === "function")) {
      return call;
    }

    return _assertThisInitialized(self);
  }

  var classSet = FormValidation.utils.classSet;

  var hasClass = FormValidation.utils.hasClass;

  var Framework = FormValidation.plugins.Framework;

  var Bootstrap3 =
  /*#__PURE__*/
  function (_Framework) {
    _inherits(Bootstrap3, _Framework);

    function Bootstrap3(opts) {
      _classCallCheck(this, Bootstrap3);

      return _possibleConstructorReturn(this, _getPrototypeOf(Bootstrap3).call(this, Object.assign({}, {
        formClass: 'fv-plugins-bootstrap3',
        messageClass: 'help-block',
        rowClasses: 'has-feedback',
        rowInvalidClass: 'has-error',
        rowPattern: /^(.*)(col|offset)-(xs|sm|md|lg)-[0-9]+(.*)$/,
        rowSelector: '.form-group',
        rowValidClass: 'has-success'
      }, opts)));
    }

    _createClass(Bootstrap3, [{
      key: "onIconPlaced",
      value: function onIconPlaced(e) {
        classSet(e.iconElement, {
          'form-control-feedback': true
        });
        var parent = e.element.parentElement;

        if (hasClass(parent, 'input-group')) {
          parent.parentElement.insertBefore(e.iconElement, parent.nextSibling);
        }

        var type = e.element.getAttribute('type');

        if ('checkbox' === type || 'radio' === type) {
          var grandParent = parent.parentElement;

          if (hasClass(parent, type)) {
            parent.parentElement.insertBefore(e.iconElement, parent.nextSibling);
          } else if (hasClass(parent.parentElement, type)) {
            grandParent.parentElement.insertBefore(e.iconElement, grandParent.nextSibling);
          }
        }
      }
    }]);

    return Bootstrap3;
  }(Framework);

  return Bootstrap3;

}));
