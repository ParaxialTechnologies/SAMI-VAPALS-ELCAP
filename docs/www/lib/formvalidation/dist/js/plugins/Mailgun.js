/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.Mailgun = factory());
}(this, (function () { 'use strict';

  var Plugin = FormValidation.Plugin;

  var Alias = FormValidation.plugins.Alias;

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

  var Mailgun = function (_Plugin) {
      inherits(Mailgun, _Plugin);

      function Mailgun(opts) {
          classCallCheck(this, Mailgun);

          var _this = possibleConstructorReturn(this, (Mailgun.__proto__ || Object.getPrototypeOf(Mailgun)).call(this, opts));

          _this.opts = Object.assign({}, { suggestion: false }, opts);
          _this.messageDisplayedHandler = _this.onMessageDisplayed.bind(_this);
          return _this;
      }

      createClass(Mailgun, [{
          key: 'install',
          value: function install() {
              if (this.opts.suggestion) {
                  this.core.on('plugins.message.displayed', this.messageDisplayedHandler);
              }
              var aliasOpts = {
                  mailgun: 'remote'
              };
              this.core.registerPlugin('___mailgunAlias', new Alias(aliasOpts)).addField(this.opts.field, {
                  validators: {
                      mailgun: {
                          crossDomain: true,
                          data: {
                              api_key: this.opts.apiKey
                          },
                          headers: {
                              'Content-Type': 'application/json'
                          },
                          message: this.opts.message,
                          name: 'address',
                          url: 'https://api.mailgun.net/v3/address/validate',
                          validKey: 'is_valid'
                      }
                  }
              });
          }
      }, {
          key: 'uninstall',
          value: function uninstall() {
              if (this.opts.suggestion) {
                  this.core.off('plugins.message.displayed', this.messageDisplayedHandler);
              }
              this.core.removeField(this.opts.field);
          }
      }, {
          key: 'onMessageDisplayed',
          value: function onMessageDisplayed(e) {
              if (e.field === this.opts.field && 'mailgun' === e.validator && e.meta && e.meta.did_you_mean) {
                  e.messageElement.innerHTML = 'Did you mean ' + e.meta.did_you_mean + '?';
              }
          }
      }]);
      return Mailgun;
  }(Plugin);

  return Mailgun;

})));
