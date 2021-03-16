/**
 * FormValidation (https://formvalidation.io), v1.4.0 (678705b)
 * The best validation library for JavaScript
 * (c) 2013 - 2019 Nguyen Huu Phuoc <me@phuoc.ng>
 */

(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
  typeof define === 'function' && define.amd ? define(factory) :
  (global = global || self, (global.FormValidation = global.FormValidation || {}, global.FormValidation.plugins = global.FormValidation.plugins || {}, global.FormValidation.plugins.Wizard = factory()));
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

  function _defineProperty(obj, key, value) {
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

  function _toConsumableArray(arr) {
    return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread();
  }

  function _arrayWithoutHoles(arr) {
    if (Array.isArray(arr)) {
      for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) arr2[i] = arr[i];

      return arr2;
    }
  }

  function _iterableToArray(iter) {
    if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter);
  }

  function _nonIterableSpread() {
    throw new TypeError("Invalid attempt to spread non-iterable instance");
  }

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

  var Wizard =
  /*#__PURE__*/
  function (_Plugin) {
    _inherits(Wizard, _Plugin);

    function Wizard(opts) {
      var _this;

      _classCallCheck(this, Wizard);

      _this = _possibleConstructorReturn(this, _getPrototypeOf(Wizard).call(this, opts));
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
      _this.prevStepHandler = _this.onClickPrev.bind(_assertThisInitialized(_this));
      _this.nextStepHandler = _this.onClickNext.bind(_assertThisInitialized(_this));
      return _this;
    }

    _createClass(Wizard, [{
      key: "install",
      value: function install() {
        var _this2 = this;

        this.core.registerPlugin(Wizard.EXCLUDED_PLUGIN, new Excluded());
        var form = this.core.getFormElement();
        this.steps = _toConsumableArray(form.querySelectorAll(this.opts.stepSelector));
        this.numSteps = this.steps.length;
        this.steps.forEach(function (s) {
          classSet(s, _defineProperty({}, _this2.opts.stepClass, true));
        });
        classSet(this.steps[0], _defineProperty({}, this.opts.activeStepClass, true));
        this.prevButton = form.querySelector(this.opts.prevButton);
        this.nextButton = form.querySelector(this.opts.nextButton);
        this.prevButton.addEventListener('click', this.prevStepHandler);
        this.nextButton.addEventListener('click', this.nextStepHandler);
      }
    }, {
      key: "uninstall",
      value: function uninstall() {
        this.core.deregisterPlugin(Wizard.EXCLUDED_PLUGIN);
        this.prevButton.removeEventListener('click', this.prevStepHandler);
        this.nextButton.removeEventListener('click', this.nextStepHandler);
      }
    }, {
      key: "onClickPrev",
      value: function onClickPrev() {
        if (this.currentStep >= 1) {
          classSet(this.steps[this.currentStep], _defineProperty({}, this.opts.activeStepClass, false));
          this.currentStep--;
          classSet(this.steps[this.currentStep], _defineProperty({}, this.opts.activeStepClass, true));
          this.onStepActive();
        }
      }
    }, {
      key: "onClickNext",
      value: function onClickNext() {
        var _this3 = this;

        this.core.validate().then(function (status) {
          if (status === Status$1.Valid) {
            var nextStep = _this3.currentStep + 1;

            if (nextStep >= _this3.numSteps) {
              _this3.currentStep = _this3.numSteps - 1;
            } else {
              classSet(_this3.steps[_this3.currentStep], _defineProperty({}, _this3.opts.activeStepClass, false));
              _this3.currentStep = nextStep;
              classSet(_this3.steps[_this3.currentStep], _defineProperty({}, _this3.opts.activeStepClass, true));
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
      key: "onStepActive",
      value: function onStepActive() {
        var e = {
          numSteps: this.numSteps,
          step: this.currentStep
        };
        this.core.emit('plugins.wizard.step.active', e);
        this.opts.onStepActive(e);
      }
    }, {
      key: "onStepValid",
      value: function onStepValid() {
        var e = {
          numSteps: this.numSteps,
          step: this.currentStep
        };
        this.core.emit('plugins.wizard.step.valid', e);
        this.opts.onStepValid(e);
      }
    }, {
      key: "onStepInvalid",
      value: function onStepInvalid() {
        var e = {
          numSteps: this.numSteps,
          step: this.currentStep
        };
        this.core.emit('plugins.wizard.step.invalid', e);
        this.opts.onStepInvalid(e);
      }
    }, {
      key: "onValid",
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

}));
