/*
 Backbone Handlebars

 Author: Radoslav Stankov
 Project site: https://github.com/RStankov/backbone-handlebars
 Licensed under the MIT License.
*/


(function() {
  var BH, _compile, _remove;

  BH = {
    VERSION: '1.0.0',
    postponed: {},
    rendered: {},
    postponeRender: function(name, options, parentView) {
      var cid, view, viewClass, _base, _ref;
      viewClass = _.inject((name || '').split('.'), (function(memo, fragment) {
        return memo[fragment] || false;
      }), window);
      if (!viewClass) {
        throw "Invalid view name - " + name;
      }
      view = new viewClass(options.hash);
      if (options.fn !== null) {
        view.template = options.fn;
      }
      cid = (parentView || options.data.view).cid;
      if ((_ref = (_base = this.postponed)[cid]) === null) {
        _base[cid] = [];
      }
      this.postponed[cid].push(view);
      return '<div id="_' + view.cid + '"></div>';
    },
    renderPostponed: function(parentView) {
      var cid;
      cid = parentView.cid;
      this.rendered[cid] = _.map(this.postponed[parentView.cid], function(view) {
        view.render();
        parentView.$("#_" + view.cid).replaceWith(view.el);
        return view;
      });
      return delete this.postponed[cid];
    },
    clearRendered: function(parentView) {
      var cid;
      cid = parentView.cid;
      if (this.rendered[cid]) {
        _.invoke(this.rendered[cid], 'remove');
        return delete this.rendered[cid];
      }
    }
  };

  Handlebars.registerHelper('view', function(name, options) {
    return new Handlebars.SafeString(BH.postponeRender(name, options, this._parentView));
  });

  Handlebars.registerHelper('views', function(name, models, options) {
    var callback, markers,
      _this = this;
    callback = function(model) {
      options.hash.model = model;
      return BH.postponeRender(name, options, _this._parentView);
    };
    markers = 'map' in models ? models.map(callback) : _.map(callback);
    return new Handlebars.SafeString(markers.join(''));
  });

  _compile = Handlebars.compile;

  Handlebars.compile = function(template, options) {
    if (options === null) {
      options = {};
    }
    options.data = true;
    return _compile.call(this, template, options);
  };

  Backbone.View.prototype.renderTemplate = function(context) {
    if (context === null) {
      context = {};
    }
    BH.clearRendered(this);
    context = _.clone(context);
    context._parentView = this;
    this.$el.html(this.template(context, {
      data: {
        view: this
      }
    }));
    BH.renderPostponed(this);
    return this;
  };

  Backbone.View.prototype.renderedSubViews = function() {
    return BH.rendered[this.cid];
  };

  _remove = Backbone.View.prototype.remove;

  Backbone.View.prototype.remove = function() {
    BH.clearRendered(this);
    return _remove.apply(this, arguments);
  };

  Backbone.View.prototype.render = function() {
    if (this.template) {
      this.renderTemplate(typeof this.templateData === 'function' ? this.templateData() : this.templateData);
    }
    return this;
  };

  Backbone.View.prototype.templateData = function() {
    return {};
  };

  Backbone.Handlebars = BH;

}).call(this);