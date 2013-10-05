(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, localRequire(name), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var require = function(name) {
    var path = expand(name, '.');

    if (has(cache, path)) return cache[path];
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex];
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '"');
  };

  var define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.brunch = true;
})();

window.require.register("coffee/lib/application", function(exports, require, module) {
  var $, Application, KegStats, Router, SocketListener,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Router = require('coffee/lib/router');

  KegStats = require('coffee/models/keg_stats');

  SocketListener = require('coffee/lib/socket_listener');

  $ = jQuery;

  vex.defaultOptions.className = 'vex-theme-wireframe';

  Application = (function() {

    function Application() {
      this.start = __bind(this.start, this);

    }

    Application.prototype.start = function() {
      this.model = new KegStats;
      this.socket = new SocketListener().listen();
      this.router = new Router({
        model: this.model
      });
      return Backbone.history.start();
    };

    return Application;

  })();

  $(function() {
    window.app = new Application;
    window.app.start();
    return setTimeout(function() {
      return window.app.model.set({
        lastPour: '10/2/12',
        totalPours: 15.2,
        poursLeft: 35.8
      });
    }, 3000);
  });
  
});
window.require.register("coffee/lib/router", function(exports, require, module) {
  var $, EditView, IndexView, Nav, Router,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Nav = require('coffee/views/nav');

  IndexView = require('coffee/views/index');

  EditView = require('coffee/views/edit');

  $ = jQuery;

  Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      this.changeView = __bind(this.changeView, this);

      this.setupNav = __bind(this.setupNav, this);

      this.edit = __bind(this.edit, this);

      this.index = __bind(this.index, this);

      this.initialize = __bind(this.initialize, this);
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      'edit': 'edit',
      '*query': 'index'
    };

    Router.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      this.model = options.model;
      return Router.__super__.initialize.apply(this, arguments);
    };

    Router.prototype.index = function() {
      return this.changeView(IndexView);
    };

    Router.prototype.edit = function() {
      return this.changeView(EditView);
    };

    Router.prototype.setupNav = function() {
      if (this.nav == null) {
        this.nav = new Nav;
        return $('.navbar').html(this.nav.render().el);
      }
    };

    Router.prototype.changeView = function(Claxx) {
      var _ref;
      this.view = new Claxx({
        model: this.model
      });
      this.setupNav();
      if (this.view === this.currentView) {
        return;
      }
      if ((_ref = this.currentView) != null) {
        _ref.remove();
      }
      this.currentView = this.view;
      return $('.content').html(this.view.render().el);
    };

    return Router;

  })(Backbone.Router);

  module.exports = Router;
  
});
window.require.register("coffee/lib/socket_listener", function(exports, require, module) {
  var SocketListener,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SocketListener = (function() {

    function SocketListener() {
      this.listen = __bind(this.listen, this);

      this.initialize = __bind(this.initialize, this);

    }

    SocketListener.prototype.initialize = function() {};

    SocketListener.prototype.listen = function() {
      return this;
    };

    return SocketListener;

  })();

  module.exports = SocketListener;
  
});
window.require.register("coffee/models/keg_stats", function(exports, require, module) {
  var KegStats,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  KegStats = (function(_super) {

    __extends(KegStats, _super);

    function KegStats() {
      return KegStats.__super__.constructor.apply(this, arguments);
    }

    KegStats.prototype.defaults = {
      keg: 'Shock Top Pumpkin Wheat'
    };

    return KegStats;

  })(Backbone.Model);

  module.exports = KegStats;
  
});
window.require.register("coffee/views/edit", function(exports, require, module) {
  var EditView, View,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('coffee/views/view');

  EditView = (function(_super) {

    __extends(EditView, _super);

    function EditView() {
      return EditView.__super__.constructor.apply(this, arguments);
    }

    EditView.prototype.className = 'row jumbotron';

    EditView.prototype.template = require('html/edit');

    return EditView;

  })(View);

  module.exports = EditView;
  
});
window.require.register("coffee/views/index", function(exports, require, module) {
  var IndexView, TickerView, View,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('coffee/views/view');

  TickerView = require('coffee/views/ticker');

  IndexView = (function(_super) {

    __extends(IndexView, _super);

    function IndexView() {
      this.onClose = __bind(this.onClose, this);

      this.updateCounts = __bind(this.updateCounts, this);

      this.updateEllipsis = __bind(this.updateEllipsis, this);

      this.afterRender = __bind(this.afterRender, this);

      this.getRenderData = __bind(this.getRenderData, this);

      this.initialize = __bind(this.initialize, this);
      return IndexView.__super__.constructor.apply(this, arguments);
    }

    IndexView.prototype.className = 'row jumbotron';

    IndexView.prototype.template = require('html/index');

    IndexView.prototype.initialize = function() {
      return this.model.on('sync', this.updateCounts);
    };

    IndexView.prototype.getRenderData = function() {
      return this.model.toJSON();
    };

    IndexView.prototype.afterRender = function() {
      var els, key, ticker, _i, _len, _ref, _results;
      els = {
        lastPour: this.$('#last_pour'),
        totalPours: this.$('#total_pours'),
        poursLeft: this.$('#pours_left')
      };
      _ref = ['lastPour', 'totalPours', 'poursLeft'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        key = _ref[_i];
        ticker = new TickerView({
          model: this.model,
          length: 8,
          field: key
        });
        _results.push(els[key].append(ticker.render().el));
      }
      return _results;
    };

    IndexView.prototype.updateEllipsis = function(count) {
      var _this = this;
      return function() {
        var ellipsis, i;
        ellipsis = ((function() {
          var _i, _ref, _results;
          _results = [];
          for (i = _i = 0, _ref = (count % 3) + 1; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
            _results.push('.');
          }
          return _results;
        })()).join('');
        count++;
        return _this.$('.ellipsis').text(ellipsis);
      };
    };

    IndexView.prototype.updateCounts = function() {
      this.$('#total_pours').val('Not many');
      return this.$('#pours_left').val('A bunch');
    };

    IndexView.prototype.onClose = function() {
      return clearTimeout(this.timeout);
    };

    return IndexView;

  })(View);

  module.exports = IndexView;
  
});
window.require.register("coffee/views/nav", function(exports, require, module) {
  var Nav, View,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('coffee/views/view');

  Nav = (function(_super) {

    __extends(Nav, _super);

    function Nav() {
      return Nav.__super__.constructor.apply(this, arguments);
    }

    Nav.prototype.className = 'container';

    Nav.prototype.template = require('html/nav');

    Nav.prototype.events = {
      'click a': 'routeEvent'
    };

    return Nav;

  })(View);

  module.exports = Nav;
  
});
window.require.register("coffee/views/ticker", function(exports, require, module) {
  var TickerView,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  TickerView = (function(_super) {

    __extends(TickerView, _super);

    function TickerView() {
      this.getLettersForField = __bind(this.getLettersForField, this);

      this.setTickerFields = __bind(this.setTickerFields, this);

      this.afterRender = __bind(this.afterRender, this);

      this.render = __bind(this.render, this);

      this.getRenderData = __bind(this.getRenderData, this);

      this.initialize = __bind(this.initialize, this);
      return TickerView.__super__.constructor.apply(this, arguments);
    }

    TickerView.prototype.className = 'ticker';

    TickerView.prototype.template = require('html/ticker');

    TickerView.prototype.speed = 30;

    TickerView.prototype.alph = 'ABCDEFGHIJKLMNOPQRSTUVXYZ01234567890/.';

    TickerView.prototype.initialize = function(options) {
      if (options == null) {
        options = {};
      }
      if (!((this.model != null) && (options.field != null) && (options.length != null))) {
        throw Error('Tickers need a model, a field to listen to, and a desired length');
      }
      return this.model.on("change:" + options.field, this.setTickerFields);
    };

    TickerView.prototype.getRenderData = function() {
      return {
        fieldLetters: this.getLettersForField()
      };
    };

    TickerView.prototype.render = function() {
      this.$el.html(this.template(this.getRenderData()));
      this.afterRender();
      return this;
    };

    TickerView.prototype.afterRender = function() {
      var alphabet, alphabetLength, letterElements, timeout,
        _this = this;
      letterElements = this.$('span');
      alphabet = this.alph.split('');
      alphabetLength = alphabet.length;
      timeout = 0;
      return letterElements.each(function(i, el) {
        var $el, index;
        $el = $(el);
        index = Math.floor(Math.random() * alphabetLength);
        setTimeout(function() {
          var tid;
          return tid = setInterval(function() {
            var currentL, l;
            l = $el.attr('letter');
            currentL = alphabet[index];
            if (l === currentL) {
              $el.text(l);
              return clearInterval(tid);
            } else if (l === 'empty') {
              $el.html('&nbsp;');
              return clearInterval(tid);
            } else {
              $el.text(currentL);
              return index = index === alphabet.length - 1 ? 0 : index + 1;
            }
          }, _this.speed);
        }, timeout);
        return timeout += 50;
      });
    };

    TickerView.prototype.setTickerFields = function() {
      var fieldLetters, i, letter, letterElements, _i, _len, _results;
      fieldLetters = this.getLettersForField();
      letterElements = this.$('span');
      _results = [];
      for (i = _i = 0, _len = fieldLetters.length; _i < _len; i = ++_i) {
        letter = fieldLetters[i];
        if (letter === '&nbsp;') {
          letter = 'empty';
        }
        _results.push($(letterElements.get(i)).attr('letter', letter));
      }
      return _results;
    };

    TickerView.prototype.getLettersForField = function(placeholder) {
      var fieldLetters, fillLetters, i, val;
      if (placeholder == null) {
        placeholder = '&nbsp;';
      }
      val = this.model.get(this.options.field);
      if (val == null) {
        return (function() {
          var _i, _ref, _results;
          _results = [];
          for (i = _i = 0, _ref = this.options.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
            _results.push(placeholder);
          }
          return _results;
        }).call(this);
      }
      fieldLetters = ('' + val).split('');
      if (fieldLetters.length < this.options.length) {
        fillLetters = (function() {
          var _i, _ref, _results;
          _results = [];
          for (i = _i = 0, _ref = this.options.length - fieldLetters.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
            _results.push(placeholder);
          }
          return _results;
        }).call(this);
        fillLetters.push.apply(fillLetters, fieldLetters);
        fieldLetters = fillLetters;
      }
      return fieldLetters;
    };

    return TickerView;

  })(Backbone.View);

  module.exports = TickerView;
  
});
window.require.register("coffee/views/view", function(exports, require, module) {
  var View,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = (function(_super) {

    __extends(View, _super);

    function View() {
      this.close = __bind(this.close, this);

      this.routeLink = __bind(this.routeLink, this);

      this.routeEvent = __bind(this.routeEvent, this);

      this.render = __bind(this.render, this);
      return View.__super__.constructor.apply(this, arguments);
    }

    View.prototype.getRenderData = function() {};

    View.prototype.render = function() {
      this.$el.html(this.template(this.getRenderData()));
      this.afterRender();
      return this;
    };

    View.prototype.afterRender = function() {};

    View.prototype.routeEvent = function(event) {
      var $link, url;
      $link = $(event.target);
      url = $link.attr('href');
      if ($link.attr('target') === '_blank' || typeof url === 'undefined' || url.substr(0, 4) === 'http' || url === '' || url === 'javascript:void(0)') {
        return true;
      }
      event.preventDefault();
      if ($link.hasClass('dont-route')) {
        return true;
      } else {
        return this.routeLink(url);
      }
    };

    View.prototype.routeLink = function(url) {
      app.router.navigate(url, {
        trigger: true
      });
      return this.trigger('routed');
    };

    View.prototype.close = function() {
      this.remove();
      return typeof this.onClose === "function" ? this.onClose() : void 0;
    };

    return View;

  })(Backbone.View);

  module.exports = View;
  
});
window.require.register("html/edit", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var foundHelper, self=this;


    return "<div>Edit (rumor has it auoooooooo wooooooo)</div>";});
});
window.require.register("html/index", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var buffer = "", stack1, foundHelper, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


    buffer += "<!-- Two grid -->\n<div class=\"row\">\n  <div class=\"col-xs-6 col-sm-6 col-lg-6\">\n    <h3>Current keg</h3>\n    <p>";
    foundHelper = helpers.keg;
    stack1 = foundHelper || depth0.keg;
    if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
    else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "keg", { hash: {} }); }
    buffer += escapeExpression(stack1) + "</p>\n  </div>\n\n  <div class=\"col-xs-6 col-sm-6 col-lg-6\">\n    <img src=\"/static/images/current_keg.png\" />\n  </div>\n</div>\n\n<!-- Three grid -->\n<div class=\"row\">\n  <div class=\"col-xs-6 col-sm-4 col-lg-4\">\n    <h3>Last pour</h3>\n    <div id=\"last_pour\"></div>\n  </div>\n\n  <div class=\"col-xs-6 col-sm-4 col-lg-4\">\n    <h3>Total pours</h3>\n    <div id=\"total_pours\"></div>\n  </div>\n\n  <div class=\"col-xs-6 col-sm-4 col-lg-4\">\n    <h3>Pours until empty</h3>\n    <div id=\"pours_left\"></div>\n  </div>\n</div>\n";
    return buffer;});
});
window.require.register("html/nav", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var foundHelper, self=this;


    return "<div class=\"navbar-header\">\n  <button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\".navbar-collapse\">\n    <span class=\"icon-bar\"></span>\n    <span class=\"icon-bar\"></span>\n    <span class=\"icon-bar\"></span>\n  </button>\n  <a class=\"navbar-brand\" href=\"#\">Kegums</a>\n</div>\n<ul class=\"nav navbar-nav\">\n  <li class=\"active\"><a href=\"#\">Home</a></li>\n</ul>\n";});
});
window.require.register("html/ticker", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

  function program1(depth0,data) {
    
    var buffer = "", stack1;
    buffer += "\n<span letter=\"";
    stack1 = depth0;
    if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
    else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "this", { hash: {} }); }
    buffer += escapeExpression(stack1) + "\">";
    stack1 = depth0;
    if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
    else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "this", { hash: {} }); }
    buffer += escapeExpression(stack1) + "</span>\n";
    return buffer;}

    foundHelper = helpers.fieldLetters;
    stack1 = foundHelper || depth0.fieldLetters;
    stack2 = helpers.each;
    tmp1 = self.program(1, program1, data);
    tmp1.hash = {};
    tmp1.fn = tmp1;
    tmp1.inverse = self.noop;
    stack1 = stack2.call(depth0, stack1, tmp1);
    if(stack1 || stack1 === 0) { return stack1; }
    else { return ''; }});
});
