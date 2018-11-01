/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
    typeof define === 'function' && define.amd ? define(factory) :
    (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.Recaptcha = factory());
}(this, (function () { 'use strict';

    var Plugin = FormValidation.Plugin;

    var Status;
    (function (Status) {
        Status["Ignored"] = "Ignored";
        Status["Invalid"] = "Invalid";
        Status["NotValidated"] = "NotValidated";
        Status["Valid"] = "Valid";
        Status["Validating"] = "Validating";
    })(Status || (Status = {}));
    var Status$1 = Status;

    var fetch = FormValidation.utils.fetch;

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

    var defineProperty = function (obj, key, value) {
      if (key in obj) {
        Object.defineProperty(obj, key, {
          value: value,
          enumerable: true,
          configurable: true,
          writable: true
        });
      } else {
        obj[key] = value;
      }

      return obj;
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

    var Recaptcha = function (_Plugin) {
        inherits(Recaptcha, _Plugin);

        function Recaptcha(opts) {
            classCallCheck(this, Recaptcha);

            var _this = possibleConstructorReturn(this, (Recaptcha.__proto__ || Object.getPrototypeOf(Recaptcha)).call(this, opts));

            _this.widgetIds = new Map();
            _this.captchaStatus = Status$1.NotValidated;
            _this.opts = Object.assign({}, Recaptcha.DEFAULT_OPTIONS, opts);
            _this.fieldResetHandler = _this.onResetField.bind(_this);
            _this.preValidateFilter = _this.preValidate.bind(_this);
            return _this;
        }

        createClass(Recaptcha, [{
            key: 'install',
            value: function install() {
                var _this2 = this;

                this.core.on('core.field.reset', this.fieldResetHandler).registerFilter('validate-pre', this.preValidateFilter);
                var loadPrevCaptcha = typeof window[Recaptcha.LOADED_CALLBACK] === 'undefined' ? function () {} : window[Recaptcha.LOADED_CALLBACK];
                window[Recaptcha.LOADED_CALLBACK] = function () {
                    loadPrevCaptcha();
                    var captchaOptions = {
                        'badge': _this2.opts.badge,
                        'callback': function callback() {
                            if (_this2.opts.backendVerificationUrl === '') {
                                _this2.captchaStatus = Status$1.Valid;
                                _this2.core.updateFieldStatus(Recaptcha.CAPTCHA_FIELD, Status$1.Valid);
                            }
                        },
                        'error-callback': function errorCallback() {
                            _this2.captchaStatus = Status$1.Invalid;
                            _this2.core.updateFieldStatus(Recaptcha.CAPTCHA_FIELD, Status$1.Invalid);
                        },
                        'expired-callback': function expiredCallback() {
                            _this2.captchaStatus = Status$1.NotValidated;
                            _this2.core.updateFieldStatus(Recaptcha.CAPTCHA_FIELD, Status$1.NotValidated);
                        },
                        'sitekey': _this2.opts.siteKey,
                        'size': _this2.opts.size
                    };
                    var widgetId = window['grecaptcha'].render(_this2.opts.element, captchaOptions);
                    _this2.widgetIds.set(_this2.opts.element, widgetId);
                    _this2.core.addField(Recaptcha.CAPTCHA_FIELD, {
                        validators: {
                            promise: {
                                message: _this2.opts.message,
                                promise: function promise(input) {
                                    if (input.value === '') {
                                        _this2.captchaStatus = Status$1.Invalid;
                                        return Promise.resolve({
                                            valid: false
                                        });
                                    } else if (_this2.opts.backendVerificationUrl === '') {
                                        _this2.captchaStatus = Status$1.Valid;
                                        return Promise.resolve({
                                            valid: true
                                        });
                                    } else if (_this2.captchaStatus === Status$1.Valid) {
                                        return Promise.resolve({
                                            valid: true
                                        });
                                    } else {
                                        return fetch(_this2.opts.backendVerificationUrl, {
                                            method: 'POST',
                                            params: defineProperty({}, Recaptcha.CAPTCHA_FIELD, input.value)
                                        }).then(function (response) {
                                            var isValid = '' + response['success'] === 'true';
                                            _this2.captchaStatus = isValid ? Status$1.Valid : Status$1.Invalid;
                                            return Promise.resolve({
                                                meta: response,
                                                valid: isValid
                                            });
                                        }).catch(function (reason) {
                                            _this2.captchaStatus = Status$1.NotValidated;
                                            return Promise.reject({
                                                valid: false
                                            });
                                        });
                                    }
                                }
                            }
                        }
                    });
                };
                var src = this.getScript();
                if (!document.body.querySelector('script[src="' + src + '"]')) {
                    var script = document.createElement('script');
                    script.type = 'text/javascript';
                    script.async = true;
                    script.defer = true;
                    script.src = src;
                    document.body.appendChild(script);
                }
            }
        }, {
            key: 'uninstall',
            value: function uninstall() {
                if (this.timer) {
                    clearTimeout(this.timer);
                }
                this.core.off('core.field.reset', this.fieldResetHandler).deregisterFilter('validate-pre', this.preValidateFilter);
                this.widgetIds.clear();
                var src = this.getScript();
                var scripts = [].slice.call(document.body.querySelectorAll('script[src="' + src + '"]'));
                scripts.forEach(function (s) {
                    return s.parentNode.removeChild(s);
                });
                this.core.removeField(Recaptcha.CAPTCHA_FIELD);
            }
        }, {
            key: 'getScript',
            value: function getScript() {
                var lang = this.opts.language ? '&hl=' + this.opts.language : '';
                return 'https://www.google.com/recaptcha/api.js?onload=' + Recaptcha.LOADED_CALLBACK + '&render=explicit' + lang;
            }
        }, {
            key: 'preValidate',
            value: function preValidate() {
                var _this3 = this;

                if (this.opts.size === 'invisible' && this.widgetIds.has(this.opts.element)) {
                    var widgetId = this.widgetIds.get(this.opts.element);
                    return this.captchaStatus === Status$1.Valid ? Promise.resolve() : new Promise(function (resolve, reject) {
                        window['grecaptcha'].execute(widgetId).then(function () {
                            if (_this3.timer) {
                                clearTimeout(_this3.timer);
                            }
                            _this3.timer = window.setTimeout(resolve, 1 * 1000);
                        });
                    });
                } else {
                    return Promise.resolve();
                }
            }
        }, {
            key: 'onResetField',
            value: function onResetField(e) {
                if (e.field === Recaptcha.CAPTCHA_FIELD && this.widgetIds.has(this.opts.element)) {
                    var widgetId = this.widgetIds.get(this.opts.element);
                    window['grecaptcha'].reset(widgetId);
                }
            }
        }]);
        return Recaptcha;
    }(Plugin);

    Recaptcha.CAPTCHA_FIELD = 'g-recaptcha-response';
    Recaptcha.DEFAULT_OPTIONS = {
        backendVerificationUrl: '',
        badge: 'bottomright',
        size: 'normal',
        theme: 'light'
    };
    Recaptcha.LOADED_CALLBACK = '___reCaptchaLoaded___';

    return Recaptcha;

})));
