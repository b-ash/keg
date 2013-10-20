Nav = require('coffee/views/nav')
IndexView = require('coffee/views/index')
EditView = require('coffee/views/edit')
FridgeView = require('coffee/views/fridge')
BeersView = require('coffee/views/beers')
Simulation = require('coffee/lib/simulation')

$ = jQuery

class Router extends Backbone.Router

  routes:
    'edit': 'edit'
    'fridge': 'fridge'
    'beers': 'beers'
    'simulate': 'simulate'
    '*query': 'index'

  initialize: (options) =>
    @options = options
    super

  index: =>
    @changeView IndexView, 'home', {model: @options.model}

  edit: =>
    @changeView EditView, '', {model: @options.model}

  fridge: =>
    @changeView FridgeView, 'fridge',
      model: @options.model
      deferredTemps: @options.deferredTemps

  beers: =>
    @changeView BeersView, 'beers',
      model: @options.model
      deferredDaily: @options.deferredDaily
      deferredWeekly: @options.deferredWeekly

  simulate: =>
    @index()
    Simulation.start()

  setupNav: (navItem) =>
    unless @nav?
      @nav = new Nav {activeItem: navItem}
      $('.navbar').html @nav.render().el

  changeView: (Claxx, navItem, classOptions) =>
    @view = new Claxx classOptions
    @setupNav navItem

    if @view is @currentView
      return

    @currentView?.close()
    @currentView = @view

    $('.content').html @view.render().el

    @currentView.postRender?()


module.exports = Router
