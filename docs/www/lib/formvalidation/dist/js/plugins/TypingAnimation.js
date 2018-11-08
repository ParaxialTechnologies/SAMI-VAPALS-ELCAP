/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.TypingAnimation = factory());
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

  var TypingAnimation = function (_Plugin) {
      inherits(TypingAnimation, _Plugin);

      function TypingAnimation(opts) {
          classCallCheck(this, TypingAnimation);

          var _this = possibleConstructorReturn(this, (TypingAnimation.__proto__ || Object.getPrototypeOf(TypingAnimation)).call(this, opts));

          _this.opts = Object.assign({}, {
              autoPlay: true
          }, opts);
          return _this;
      }

      createClass(TypingAnimation, [{
          key: 'install',
          value: function install() {
              this.fields = Object.keys(this.core.getFields());
              if (this.opts.autoPlay) {
                  this.play();
              }
          }
      }, {
          key: 'play',
          value: function play() {
              return this.animate(0);
          }
      }, {
          key: 'animate',
          value: function animate(fieldIndex) {
              var _this2 = this;

              if (fieldIndex >= this.fields.length) {
                  return Promise.resolve(fieldIndex);
              }
              var field = this.fields[fieldIndex];
              var ele = this.core.getElements(field)[0];
              var inputType = ele.getAttribute('type');
              var samples = this.opts.data[field];
              if ('checkbox' === inputType || 'radio' === inputType) {
                  ele.checked = true;
                  ele.setAttribute('checked', 'true');
                  return this.core.revalidateField(field).then(function (status) {
                      return _this2.animate(fieldIndex + 1);
                  });
              } else if (!samples) {
                  return this.animate(fieldIndex + 1);
              } else {
                  return new Promise(function (resolve) {
                      return new Typed(ele, {
                          attr: 'value',
                          autoInsertCss: true,
                          bindInputFocusEvents: true,
                          onComplete: function onComplete() {
                              resolve(fieldIndex + 1);
                          },
                          onStringTyped: function onStringTyped(arrayPos, self) {
                              ele.value = samples[arrayPos];
                              _this2.core.revalidateField(field);
                          },
                          strings: samples,
                          typeSpeed: 100
                      });
                  }).then(function (nextFieldIndex) {
                      return _this2.animate(nextFieldIndex);
                  });
              }
          }
      }]);
      return TypingAnimation;
  }(Plugin);

  return TypingAnimation;

})));
