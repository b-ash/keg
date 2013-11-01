Nav = require('coffee/views/nav')
IndexView = require('coffee/views/index')
AdminView = require('coffee/views/admin')
FridgeView = require('coffee/views/fridge')
BeersView = require('coffee/views/beers')
DrinkView = require('coffee/views/drink')
ClaimView = require('coffee/views/claim')
LeaderboardView = require('coffee/views/leaderboard')
Simulation = require('coffee/lib/simulation')

$ = jQuery

class Router extends Backbone.Router

  routes:
    'admin': 'admin'
    'fridge': 'fridge'
    'beers': 'beers'
    'drink': 'drink'
    'claim': 'claim'
    'leaderboard': 'leaderboard'
    'simulate': 'simulate'
    '*query': 'index'

  initialize: (@options) =>
    super

  navigate: (route, options) ->
    @nav?.updateActive(route.slice(2))
    super

  index: =>
    @changeView IndexView, 'home', {model: @options.model}

  admin: =>
    @changeView AdminView, '', {model: @options.model}

  fridge: =>
    @changeView FridgeView, 'fridge',
      model: @options.model
      deferredTemps: @options.deferredTemps

  beers: =>
    @changeView BeersView, 'beers',
      model: @options.model
      deferredDaily: @options.deferredDaily
      deferredWeekly: @options.deferredWeekly

  drink: =>
    @changeView DrinkView, 'drink',
      model: @options.model
      deferredDrinkers: @options.deferredDrinkers

  claim: =>
    @changeView ClaimView, 'claim',
      model: @options.model
      deferredDrinkers: @options.deferredDrinkers

  leaderboard: =>
    @changeView LeaderboardView, 'leaderboard', {model: @options.model}

  simulate: =>
    @index()
    Simulation.start()

  setupNav: (navItem) =>
    unless @nav?
      @nav = new Nav
        activeItem: navItem
        interactive: @options.interactive
      $('.navbar').html @nav.render().el

  changeView: (Claxx, navItem, classOptions) =>
    @view = new Claxx classOptions
    @setupNav navItem

    if @view is @currentView
      return

    @currentView?.close()
    @currentView = @view

    render = =>
      $('.content').html @view.render().el

    if @view.deferredRender?
      @view.deferredRender render
    else
      render()

    @currentView.postRender?()


module.exports = Router
