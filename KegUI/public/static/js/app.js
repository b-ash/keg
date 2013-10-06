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
      this.socket = new SocketListener();
      this.router = new Router({
        model: this.model
      });
      return Backbone.history.start();
    };

    return Application;

  })();

  $(function() {
    window.app = new Application;
    return window.app.start();
  });
  
});
window.require.register("coffee/lib/router", function(exports, require, module) {
  var $, EditView, IndexView, Nav, Router, Simulation,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Nav = require('coffee/views/nav');

  IndexView = require('coffee/views/index');

  EditView = require('coffee/views/edit');

  Simulation = require('coffee/lib/simulation');

  $ = jQuery;

  Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      this.changeView = __bind(this.changeView, this);

      this.setupNav = __bind(this.setupNav, this);

      this.simulate = __bind(this.simulate, this);

      this.edit = __bind(this.edit, this);

      this.index = __bind(this.index, this);

      this.initialize = __bind(this.initialize, this);
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      'edit': 'edit',
      'simulate': 'simulate',
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

    Router.prototype.simulate = function() {
      this.index();
      return Simulation.start();
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
        _ref.close();
      }
      this.currentView = this.view;
      return $('.content').html(this.view.render().el);
    };

    return Router;

  })(Backbone.Router);

  module.exports = Router;
  
});
window.require.register("coffee/lib/simulation", function(exports, require, module) {
  var Simulation,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Simulation = (function() {

    function Simulation() {
      this.start = __bind(this.start, this);

    }

    Simulation.prototype.running = false;

    Simulation.prototype.timeout = 3000;

    Simulation.prototype.pourMessages = [0.6, 0.9, 1.4, 1.8, 2.1, 2.7, 3.2, 3.8, 4.4, 5.0, 5.2, 5.8, 6.4, 6.8, 7.3, 7.9, 8.4, 8.8, 9.3, 9.9, 10.5, 11, 11.8, 12.4, 'done'];

    Simulation.prototype.start = function() {
      var amount, simulate, _i, _len, _ref, _results,
        _this = this;
      if (this.running) {
        return;
      }
      this.running = true;
      setTimeout(function() {
        return window.app.model.set({
          lastPour: '10/2/12',
          totalPours: 15.2,
          poursLeft: 35.8,
          keg: 'Shock Top Pumpkin Wheat',
          bannerImage: 'shocktop_pumpkin.png'
        });
      }, this.timeout);
      this.timeout += 1000;
      simulate = function(amt) {
        var last, msg, wait;
        if (amt === 'done') {
          msg = {
            action: 'done'
          };
          wait = 1500;
          last = true;
        } else {
          msg = {
            action: 'pouring',
            amount: amt
          };
          wait = 150;
          last = false;
        }
        _this.timeout += wait;
        return setTimeout(function() {
          window.app.socket.onMessage({
            data: JSON.stringify(msg)
          });
          return _this.running = !last;
        }, _this.timeout);
      };
      _ref = this.pourMessages;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        amount = _ref[_i];
        _results.push(simulate(amount));
      }
      return _results;
    };

    return Simulation;

  })();

  module.exports = new Simulation;
  
});
window.require.register("coffee/lib/socket_listener", function(exports, require, module) {
  var PourDialog, SocketListener,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  PourDialog = require('coffee/views/pour_dialog');

  SocketListener = (function() {

    function SocketListener() {
      this.pourComplete = __bind(this.pourComplete, this);

      this.onClose = __bind(this.onClose, this);

      this.onMessage = __bind(this.onMessage, this);

      this.showDialog = __bind(this.showDialog, this);

      this.listen = __bind(this.listen, this);

    }

    SocketListener.prototype.url = '/socket';

    SocketListener.prototype.listen = function() {
      this.sock = new SockJS(this.url);
      this.sock.onopen = this.onOpen;
      this.sock.onmessage = this.onMessage;
      this.sock.onclose = this.onClose;
      return this;
    };

    SocketListener.prototype.showDialog = function() {
      var _ref;
      if ((_ref = this.pourDialog) != null) {
        _ref.close();
      }
      this.pourDialog = new PourDialog().render();
      return this;
    };

    SocketListener.prototype.onOpen = function() {
      return console.log('Socket is open.');
    };

    SocketListener.prototype.onMessage = function(e) {
      var message;
      if (this.pourDialog == null) {
        this.showDialog();
      }
      message = JSON.parse(e.data);
      if (message.action === 'done') {
        return this.pourComplete();
      } else if (message.action === 'pouring') {
        return this.pourDialog.updatePour(message.amount);
      } else {
        return console.error('Bad message from socket:', message.action);
      }
    };

    SocketListener.prototype.onClose = function(e) {
      return console.error('Socket was closed.', e.reason);
    };

    SocketListener.prototype.pourComplete = function() {
      var _this = this;
      this.pourDialog.showPourComplete();
      return setTimeout(function() {
        return _this.pourDialog.close();
      }, 2000);
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

    KegStats.prototype.urlRoot = '/';

    return KegStats;

  })(Backbone.Model);

  module.exports = KegStats;
  
});
window.require.register("coffee/views/edit", function(exports, require, module) {
  var EditView, View,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('coffee/views/view');

  EditView = (function(_super) {

    __extends(EditView, _super);

    function EditView() {
      this.edit = __bind(this.edit, this);
      return EditView.__super__.constructor.apply(this, arguments);
    }

    EditView.prototype.className = 'row jumbotron';

    EditView.prototype.template = require('html/edit');

    EditView.prototype.events = {
      'submit form': 'edit'
    };

    EditView.prototype.edit = function(event) {
      var $input, data, input, inputs, val, _i, _len;
      event.preventDefault();
      inputs = this.$('form input');
      data = {};
      for (_i = 0, _len = inputs.length; _i < _len; _i++) {
        input = inputs[_i];
        $input = $(input);
        val = $input.val();
        if (val.length) {
          data[$input.attr('name')] = val;
        }
      }
      this.model.save(data);
      return app.router.navigate('#/simulate', {
        trigger: true
      });
    };

    return EditView;

  })(View);

  module.exports = EditView;
  
});
window.require.register("coffee/views/index", function(exports, require, module) {
  var BrandBannerTemplate, IndexView, TickerView, View,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('coffee/views/view');

  TickerView = require('coffee/views/ticker');

  BrandBannerTemplate = require('html/brand_banner');

  IndexView = (function(_super) {

    __extends(IndexView, _super);

    function IndexView() {
      this.onClose = __bind(this.onClose, this);

      this.updateBanner = __bind(this.updateBanner, this);

      this.updateKegName = __bind(this.updateKegName, this);

      this.updateEllipsis = __bind(this.updateEllipsis, this);

      this.afterRender = __bind(this.afterRender, this);

      this.getRenderData = __bind(this.getRenderData, this);

      this.initialize = __bind(this.initialize, this);
      return IndexView.__super__.constructor.apply(this, arguments);
    }

    IndexView.prototype.className = 'row jumbotron';

    IndexView.prototype.template = require('html/index');

    IndexView.prototype.initialize = function() {
      this.model.on('change:keg', this.updateKegName);
      return this.model.on('change:bannerImage', this.updateBanner);
    };

    IndexView.prototype.getRenderData = function() {
      return this.model.toJSON();
    };

    IndexView.prototype.afterRender = function() {
      var els, key, ticker, _i, _len, _ref, _results;
      if (this.model.get('keg') != null) {
        this.updateKegName();
      }
      if (this.model.get('bannerImage') != null) {
        this.updateBanner();
      }
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

    IndexView.prototype.updateKegName = function() {
      return this.$('#keg_wrap p').text(this.model.get('keg'));
    };

    IndexView.prototype.updateBanner = function() {
      return this.$('#brand_banner_wrap').html(BrandBannerTemplate({
        bannerImage: this.model.get('bannerImage')
      })).find('img').fadeIn();
    };

    IndexView.prototype.onClose = function() {
      return clearTimeout(this.timeout);
    };

    return IndexView;

  })(View);

  module.exports = IndexView;
  
});
window.require.register("coffee/views/nav", function(exports, require, module) {
  var $, Nav, View,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('coffee/views/view');

  $ = jQuery;

  Nav = (function(_super) {

    __extends(Nav, _super);

    function Nav() {
      this.routeEvent = __bind(this.routeEvent, this);
      return Nav.__super__.constructor.apply(this, arguments);
    }

    Nav.prototype.className = 'container';

    Nav.prototype.template = require('html/nav');

    Nav.prototype.events = {
      'click a': 'routeEvent'
    };

    Nav.prototype.routeEvent = function(event) {
      this.$('li.active').removeClass('active');
      $(event.currentTarget).parent().addClass('active');
      return Nav.__super__.routeEvent.apply(this, arguments);
    };

    return Nav;

  })(View);

  module.exports = Nav;
  
});
window.require.register("coffee/views/pour_dialog", function(exports, require, module) {
  var PourDialog, View,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  View = require('coffee/views/view');

  PourDialog = (function(_super) {

    __extends(PourDialog, _super);

    function PourDialog() {
      this.close = __bind(this.close, this);

      this._showMessage = __bind(this._showMessage, this);

      this.showPourError = __bind(this.showPourError, this);

      this.showPourComplete = __bind(this.showPourComplete, this);

      this.updatePour = __bind(this.updatePour, this);

      this.render = __bind(this.render, this);
      return PourDialog.__super__.constructor.apply(this, arguments);
    }

    PourDialog.prototype.template = require('html/pour_dialog');

    PourDialog.prototype.successTemplate = require('html/pour_success');

    PourDialog.prototype.errorTemplate = require('html/pour_error');

    PourDialog.prototype.render = function() {
      PourDialog.__super__.render.apply(this, arguments);
      vex.open({
        content: this.$el
      });
      return this;
    };

    PourDialog.prototype.updatePour = function(oz) {
      return this.$('#amount').text(oz);
    };

    PourDialog.prototype.showPourComplete = function() {
      return this._showMessage(this.successTemplate);
    };

    PourDialog.prototype.showPourError = function() {
      return this._showMessage(this.errorTemplate);
    };

    PourDialog.prototype._showMessage = function(template) {
      return this.$el.html(template());
    };

    PourDialog.prototype.close = function() {
      return vex.close();
    };

    return PourDialog;

  })(View);

  module.exports = PourDialog;
  
});
window.require.register("coffee/views/ticker", function(exports, require, module) {
  var TickerView,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  TickerView = (function(_super) {

    __extends(TickerView, _super);

    function TickerView() {
      this.clear = __bind(this.clear, this);

      this.getLettersForField = __bind(this.getLettersForField, this);

      this.setTickerFields = __bind(this.setTickerFields, this);

      this.startTickers = __bind(this.startTickers, this);

      this.afterRender = __bind(this.afterRender, this);

      this.render = __bind(this.render, this);

      this.getRenderData = __bind(this.getRenderData, this);

      this.initialize = __bind(this.initialize, this);
      return TickerView.__super__.constructor.apply(this, arguments);
    }

    TickerView.prototype.className = 'ticker';

    TickerView.prototype.template = require('html/ticker');

    TickerView.prototype.ticking = false;

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
      if (this.model.get(this.options.field) == null) {
        return this.startTickers();
      }
    };

    TickerView.prototype.startTickers = function() {
      var alphabet, alphabetLength, letterElements, timeout,
        _this = this;
      letterElements = this.$('span');
      alphabet = this.alph.split('');
      alphabetLength = alphabet.length;
      timeout = 0;
      letterElements.each(function(i, el) {
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
              return _this.clear(tid);
            } else if (l === 'EMPTY') {
              $el.html('&nbsp;');
              return _this.clear(tid);
            } else {
              $el.text(currentL);
              return index = index === alphabet.length - 1 ? 0 : index + 1;
            }
          }, _this.speed);
        }, timeout);
        return timeout += 50;
      });
      return this.ticking = true;
    };

    TickerView.prototype.setTickerFields = function() {
      var fieldLetters, i, letter, letterElements, _i, _len;
      fieldLetters = this.getLettersForField();
      letterElements = this.$('span');
      for (i = _i = 0, _len = fieldLetters.length; _i < _len; i = ++_i) {
        letter = fieldLetters[i];
        if (letter === '&nbsp;') {
          letter = 'EMPTY';
        }
        $(letterElements.get(i)).attr('letter', letter.toUpperCase());
      }
      if (!this.ticking) {
        return this.startTickers();
      }
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

    TickerView.prototype.clear = function(tid) {
      clearInterval(tid);
      return this.ticking = false;
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
window.require.register("html/brand_banner", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var buffer = "", stack1, foundHelper, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;


    buffer += "<div>\n  <img id=\"brand_banner\" src=\"/static/images/";
    foundHelper = helpers.bannerImage;
    stack1 = foundHelper || depth0.bannerImage;
    if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
    else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "bannerImage", { hash: {} }); }
    buffer += escapeExpression(stack1) + "\" />\n</div>\n";
    return buffer;});
});
window.require.register("html/edit", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var foundHelper, self=this;


    return "<h2>Edit</h2>\n\n<div>\n  <form role=\"form\">\n    <div class=\"form-group\">\n      <label>Keg</label>\n      <input id=\"keg\" type=\"text\" name=\"keg\" class=\"form-control\" placeholder=\"Keg name\" />\n\n      <label>Banner image</label>\n      <input id=\"banner_image\" type=\"text\" name=\"bannerImage\" class=\"form-control\" placeholder=\"Banner image filename\" />\n\n      <label>Last pour</label>\n      <input id=\"last_pour\" type=\"text\" name=\"lastPour\" class=\"form-control\" placeholder=\"Last pour time\" />\n\n      <label>Total pours</label>\n      <input id=\"total_pours\" type=\"text\" name=\"totalPours\" class=\"form-control\" placeholder=\"Total number of pours of this keg\" />\n\n      <label>Pours left</label>\n      <input id=\"pours_left\" type=\"text\" name=\"poursLeft\" class=\"form-control\" placeholder=\"Pours left in this keg\" />\n    </div>\n\n    <div class=\"form-group\">\n      <button type=\"submit\" class=\"btn btn-primary\">Change</a>\n    </div>\n  </form>\n</div>";});
});
window.require.register("html/index", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var foundHelper, self=this;


    return "<!-- Two grid -->\n<div class=\"row\">\n  <div id=\"keg_wrap\" class=\"col-xs-6 col-sm-6 col-lg-6\">\n    <h3>Current keg</h3>\n    <p>Looking in the fridge...</p>\n  </div>\n\n  <div id=\"brand_banner_wrap\" class=\"col-xs-6 col-sm-6 col-lg-6 brand-banner\">\n    <p>Finding banner...</p>\n  </div>\n</div>\n\n<!-- Three grid -->\n<div class=\"row\">\n  <div class=\"col-xs-6 col-sm-4 col-lg-4\">\n    <h3>Last pour</h3>\n    <div id=\"last_pour\"></div>\n  </div>\n\n  <div class=\"col-xs-6 col-sm-4 col-lg-4\">\n    <h3>Total pours</h3>\n    <div id=\"total_pours\"></div>\n  </div>\n\n  <div class=\"col-xs-6 col-sm-4 col-lg-4\">\n    <h3>Pours until empty</h3>\n    <div id=\"pours_left\"></div>\n  </div>\n</div>\n";});
});
window.require.register("html/nav", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var foundHelper, self=this;


    return "<div class=\"navbar-header\">\n  <button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\".navbar-collapse\">\n    <span class=\"icon-bar\"></span>\n    <span class=\"icon-bar\"></span>\n    <span class=\"icon-bar\"></span>\n  </button>\n  <a class=\"navbar-brand\" href=\"#\">Kegums</a>\n</div>\n<ul class=\"nav navbar-nav\">\n  <li class=\"active\">\n    <a href=\"#\">Home</a>\n  </li>\n\n  <li>\n    <a href=\"#/simulate\">Simulate</a>\n  </li>\n</ul>\n";});
});
window.require.register("html/pour_dialog", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var foundHelper, self=this;


    return "<h4>Now pouring:</h4>\n\n<p>\n  <span id=\"amount\">0.0</span>\n  oz\n</p>\n";});
});
window.require.register("html/pour_error", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var foundHelper, self=this;


    return "<h2>Go tell Bash the socket was closed.</h2>\n";});
});
window.require.register("html/pour_success", function(exports, require, module) {
  module.exports = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
    helpers = helpers || Handlebars.helpers;
    var foundHelper, self=this;


    return "<h2>Enjoy your beer, brah.</h2>\n";});
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
