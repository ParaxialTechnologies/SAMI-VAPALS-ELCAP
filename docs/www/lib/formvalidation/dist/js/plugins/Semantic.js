/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.Semantic = factory());
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

  var get = function get(object, property, receiver) {
    if (object === null) object = Function.prototype;
    var desc = Object.getOwnPropertyDescriptor(object, property);

    if (desc === undefined) {
      var parent = Object.getPrototypeOf(object);

      if (parent === null) {
        return undefined;
      } else {
        return get(parent, property, receiver);
      }
    } else if ("value" in desc) {
      return desc.value;
    } else {
      var getter = desc.get;

      if (getter === undefined) {
        return undefined;
      }

      return getter.call(receiver);
    }
  };

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

  var Semantic = function (_Framework) {
      inherits(Semantic, _Framework);

      function Semantic(opts) {
          classCallCheck(this, Semantic);

          var _this = possibleConstructorReturn(this, (Semantic.__proto__ || Object.getPrototypeOf(Semantic)).call(this, Object.assign({}, {
              formClass: 'fv-plugins-semantic',
              messageClass: 'ui pointing red label',
              rowInvalidClass: 'error',
              rowPattern: /^.*(field|column).*$/,
              rowSelector: '.fields',
              rowValidClass: 'fv-has-success'
          }, opts)));

          _this.messagePlacedHandler = _this.onMessagePlaced.bind(_this);
          return _this;
      }

      createClass(Semantic, [{
          key: 'install',
          value: function install() {
              get(Semantic.prototype.__proto__ || Object.getPrototypeOf(Semantic.prototype), 'install', this).call(this);
              this.core.on('plugins.message.placed', this.messagePlacedHandler);
          }
      }, {
          key: 'uninstall',
          value: function uninstall() {
              get(Semantic.prototype.__proto__ || Object.getPrototypeOf(Semantic.prototype), 'uninstall', this).call(this);
              this.core.off('plugins.message.placed', this.messagePlacedHandler);
          }
      }, {
          key: 'onIconPlaced',
          value: function onIconPlaced(e) {
              var type = e.element.getAttribute('type');
              if ('checkbox' === type || 'radio' === type) {
                  var parent = e.element.parentElement;
                  classSet(e.iconElement, {
                      'fv-plugins-icon-check': true
                  });
                  parent.parentElement.insertBefore(e.iconElement, parent.nextSibling);
              }
          }
      }, {
          key: 'onMessagePlaced',
          value: function onMessagePlaced(e) {
              var type = e.element.getAttribute('type');
              var numElements = e.elements.length;
              if (('checkbox' === type || 'radio' === type) && numElements > 1) {
                  var last = e.elements[numElements - 1];
                  var parent = last.parentElement;
                  if (hasClass(parent, type) && hasClass(parent, 'ui')) {
                      parent.parentElement.insertBefore(e.messageElement, parent.nextSibling);
                  }
              }
          }
      }]);
      return Semantic;
  }(Framework);

  return Semantic;

})));
