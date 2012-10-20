// Generated by IcedCoffeeScript 1.3.3f
var $, Controller, Dust, iced, _, __iced_k, __iced_k_noop,
  __slice = [].slice;

iced = {
  Deferrals: (function() {

    function _Class(_arg) {
      this.continuation = _arg;
      this.count = 1;
      this.ret = null;
    }

    _Class.prototype._fulfill = function() {
      if (!--this.count) return this.continuation(this.ret);
    };

    _Class.prototype.defer = function(defer_params) {
      var _this = this;
      ++this.count;
      return function() {
        var inner_params, _ref;
        inner_params = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (defer_params != null) {
          if ((_ref = defer_params.assign_fn) != null) {
            _ref.apply(null, inner_params);
          }
        }
        return _this._fulfill();
      };
    };

    return _Class;

  })(),
  findDeferral: function() {
    return null;
  }
};
__iced_k = __iced_k_noop = function() {};

Dust = require('dustjs');

$ = require('jquery');

_ = require('underscore');

Controller = (function() {

  function Controller(node) {
    this.node = node;
    if (this.tagName != null) {
      this.el = $("<" + tagName + "></" + tagName + ">");
    } else {
      this.el = $('<div></div>');
    }
    if (this.className != null) this.el.addClass(this.className);
    if (this.id != null) this.el.attr('id', this.id);
  }

  Controller.prototype.bindings = {};

  Controller.prototype.events = {};

  Controller.prototype.render = function(cb, node) {
    var err, ev, event, handler, html, selector, ___iced_passed_deferral, __iced_deferrals, __iced_k,
      _this = this;
    __iced_k = __iced_k_noop;
    ___iced_passed_deferral = iced.findDeferral(arguments);
    if (node == null) node = this.node;
    (function(__iced_k) {
      if (_this.template != null) {
        if (node.raw != null) node = node.raw;
        (function(__iced_k) {
          __iced_deferrals = new iced.Deferrals(__iced_k, {
            parent: ___iced_passed_deferral,
            filename: "src/index.iced",
            funcname: "Controller.render"
          });
          Dust.render(_this.template, (typeof node.toJSON === "function" ? node.toJSON() : void 0) || node, __iced_deferrals.defer({
            assign_fn: (function() {
              return function() {
                err = arguments[0];
                return html = arguments[1];
              };
            })(),
            lineno: 25
          }));
          __iced_deferrals._fulfill();
        })(__iced_k);
      } else {
        return __iced_k();
      }
    })(function() {
      var _ref, _ref1;
      _this.el.html(html);
      _ref = _this.events;
      for (event in _ref) {
        handler = _ref[event];
        _ref1 = event.split(' '), ev = _ref1[0], selector = 2 <= _ref1.length ? __slice.call(_ref1, 1) : [];
        selector = selector.join(' ');
        _this.el.undelegate(selector, event);
        _this.el.delegate(selector, event, _(_this[handler]).bind(_this));
      }
      if (cb != null) return cb.call(_this);
    });
  };

  return Controller;

})();

module.exports = Controller;
