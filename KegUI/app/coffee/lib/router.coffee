Nav = require('coffee/views/nav')
IndexView = require('coffee/views/index')
AdminView = require('coffee/views/admin')
FridgeView = require('coffee/views/fridge')
BeersView = require('coffee/views/beers')
DrinkView = require('coffee/views/drink')
ClaimView = require('coffee/views/claim')
LeaderboardView = require('coffee/views/leaderboard')
DashboardView = require('coffee/views/dashboard')
RegisterRemoteView = require('coffee/views/register_remote')
UnregisterRemoteView = require('coffee/views/unregister_remote')

$ = jQuery

class Router extends Backbone.Router

  routes:
    'admin': 'admin'
    'fridge': 'fridge'
    'beers': 'beers'
    'drink': 'drink'
    'claim': 'claim'
    'leaderboard': 'leaderboard'
    'dashboard': 'dashboard'
    'register': 'register'
    'unregister': 'unregister'
    '*query': 'index'

  initialize: (@options) =>
    super

  navigate: (route, options) ->
    @nav?.updateActive(route.slice(2))
    super

  index: =>
    @changeView IndexView, 'home', {model: @options.model}

  admin: =>
    @changeView AdminView, '',
      model: @options.model
      deferredDrinkers: @options.deferredDrinkers

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
    @changeView LeaderboardView, 'leaderboard',
      model: @options.model

  dashboard: =>
    @changeView DashboardView, 'dashboard',
      model: @options.model

  register: =>
    @changeView RegisterRemoteView, 'register',
      admin: @options.admin
      deferredDrinkers: @options.deferredDrinkers

  unregister: =>
    @changeView UnregisterRemoteView, 'unregister'

  setupNav: (navItem) =>
    unless @nav?
      @nav = new Nav
        activeItem: navItem
        admin: @options.admin
      $('.navbar').html @nav.render().el

  changeView: (Claxx, navItem, classOptions) =>
    @view = new Claxx classOptions
    @setupNav navItem

    if @view is @currentView
      return

    @currentView?.close()
    @currentView = @view

    render = =>
      $('#content').html @view.render().el

    if @view.deferredRender?
      @view.deferredRender render
    else
      render()

    @currentView.postRender?()


module.exports = Router
