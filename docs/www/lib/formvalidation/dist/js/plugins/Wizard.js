/**
 * FormValidation (https://formvalidation.io), v1.3.0
 * The best validation library for JavaScript
 * (c) 2013 - 2018 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
    typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
    typeof define === 'function' && define.amd ? define(factory) :
    (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.Wizard = factory());
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

    var classSet = FormValidation.utils.classSet;

    var Excluded = FormValidation.plugins.Excluded;

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

    var toConsumableArray = function (arr) {
      if (Array.isArray(arr)) {
        for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i];

        return arr2;
      } else {
        return Array.from(arr);
      }
    };

    var Wizard = function (_Plugin) {
        inherits(Wizard, _Plugin);

        function Wizard(opts) {
            classCallCheck(this, Wizard);

            var _this = possibleConstructorReturn(this, (Wizard.__proto__ || Object.getPrototypeOf(Wizard)).call(this, opts));

            _this.currentStep = 0;
            _this.numSteps = 0;
            _this.opts = Object.assign({}, {
                activeStepClass: 'fv-plugins-wizard--active',
                onStepActive: function onStepActive() {},
                onStepInvalid: function onStepInvalid() {},
                onStepValid: function onStepValid() {},
                onValid: function onValid() {},
                stepClass: 'fv-plugins-wizard--step'
            }, opts);
            _this.prevStepHandler = _this.onClickPrev.bind(_this);
            _this.nextStepHandler = _this.onClickNext.bind(_this);
            return _this;
        }

        createClass(Wizard, [{
            key: 'install',
            value: function install() {
                var _this2 = this;

                this.core.registerPlugin(Wizard.EXCLUDED_PLUGIN, new Excluded());
                var form = this.core.getFormElement();
                this.steps = [].concat(toConsumableArray(form.querySelectorAll(this.opts.stepSelector)));
                this.numSteps = this.steps.length;
                this.steps.forEach(function (s) {
                    classSet(s, defineProperty({}, _this2.opts.stepClass, true));
                });
                classSet(this.steps[0], defineProperty({}, this.opts.activeStepClass, true));
                this.prevButton = form.querySelector(this.opts.prevButton);
                this.nextButton = form.querySelector(this.opts.nextButton);
                this.prevButton.addEventListener('click', this.prevStepHandler);
                this.nextButton.addEventListener('click', this.nextStepHandler);
            }
        }, {
            key: 'uninstall',
            value: function uninstall() {
                this.core.deregisterPlugin(Wizard.EXCLUDED_PLUGIN);
                this.prevButton.removeEventListener('click', this.prevStepHandler);
                this.nextButton.removeEventListener('click', this.nextStepHandler);
            }
        }, {
            key: 'onClickPrev',
            value: function onClickPrev() {
                if (this.currentStep >= 1) {
                    classSet(this.steps[this.currentStep], defineProperty({}, this.opts.activeStepClass, false));
                    this.currentStep--;
                    classSet(this.steps[this.currentStep], defineProperty({}, this.opts.activeStepClass, true));
                    this.onStepActive();
                }
            }
        }, {
            key: 'onClickNext',
            value: function onClickNext() {
                var _this3 = this;

                this.core.validate().then(function (status) {
                    if (status === Status$1.Valid) {
                        var nextStep = _this3.currentStep + 1;
                        if (nextStep >= _this3.numSteps) {
                            _this3.currentStep = _this3.numSteps - 1;
                        } else {
                            classSet(_this3.steps[_this3.currentStep], defineProperty({}, _this3.opts.activeStepClass, false));
                            _this3.currentStep = nextStep;
                            classSet(_this3.steps[_this3.currentStep], defineProperty({}, _this3.opts.activeStepClass, true));
                        }
                        _this3.onStepActive();
                        _this3.onStepValid();
                        if (nextStep === _this3.numSteps) {
                            _this3.onValid();
                        }
                    } else if (status === Status$1.Invalid) {
                        _this3.onStepInvalid();
                    }
                });
            }
        }, {
            key: 'onStepActive',
            value: function onStepActive() {
                var e = {
                    numSteps: this.numSteps,
                    step: this.currentStep
                };
                this.core.emit('plugins.wizard.step.active', e);
                this.opts.onStepActive(e);
            }
        }, {
            key: 'onStepValid',
            value: function onStepValid() {
                var e = {
                    numSteps: this.numSteps,
                    step: this.currentStep
                };
                this.core.emit('plugins.wizard.step.valid', e);
                this.opts.onStepValid(e);
            }
        }, {
            key: 'onStepInvalid',
            value: function onStepInvalid() {
                var e = {
                    numSteps: this.numSteps,
                    step: this.currentStep
                };
                this.core.emit('plugins.wizard.step.invalid', e);
                this.opts.onStepInvalid(e);
            }
        }, {
            key: 'onValid',
            value: function onValid() {
                var e = {
                    numSteps: this.numSteps
                };
                this.core.emit('plugins.wizard.valid', e);
                this.opts.onValid(e);
            }
        }]);
        return Wizard;
    }(Plugin);

    Wizard.EXCLUDED_PLUGIN = '___wizardExcluded';

    return Wizard;

})));
