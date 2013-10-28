Globals = require('coffee/lib/globals')
Router = require('coffee/lib/router')
SocketListener = require('coffee/lib/socket_listener')

KegStats = require('coffee/models/keg_stats')
Temps = require('coffee/collections/temps')
Drinkers = require('coffee/collections/drinkers')
Drinker = require('coffee/models/drinker')
PoursSummary = require('coffee/collections/pours_summary')

$ = jQuery

vex.defaultOptions.className = 'vex-theme-wireframe'
shouldLimitApiCalls = 'mobile' in navigator.userAgent and 'nexus 7' not in navigator.userAgent

class Application

  deferredObj: (obj) =>
    promise = new $.Deferred
    fetch = ->
      obj.fetch().then ->
        promise.resolve obj

    {promise, fetch, obj}

  initHelpers: ->
    Handlebars.registerHelper 'getActiveClass', (active, claxx) ->
      if active is claxx
        return 'active'
    Handlebars.registerHelper 'shouldShowBeerGraphs', (options) ->
      if shouldLimitApiCalls
        options.inverse()
      else
        options.fn()
    Handlebars.registerHelper 'getBeers', (ounces) ->
      (ounces / Globals.beerSize).toFixed(3)
    Handlebars.registerHelper 'getDrinkerName', (defaultName) ->
      window.app.drinker?.get('name') ? defaultName

  setGlobalDrinker: =>
    $.getJSON '/api/drinking', (json) =>
      if json?
        @drinker = @drinkers.obj.get(json.id)

  start: =>
    @initHelpers()

    @model = @deferredObj(new KegStats)
    @temps = @deferredObj(new Temps)
    @drinkers = @deferredObj(new Drinkers)

    unless shouldLimitApiCalls
      @dailyPours = @deferredObj(new PoursSummary 'daily')
      @weeklyPours = @deferredObj(new PoursSummary 'weekly')

    @socket = new SocketListener(@model.obj).listen()
    @router = new Router
      model: @model.obj
      deferredTemps: @temps.promise
      deferredDrinkers: @drinkers.promise
      deferredDaily: @dailyPours?.promise
      deferredWeekly: @weeklyPours?.promise

    Backbone.history.start()

    @model.fetch()
    @temps.fetch()
    @drinkers.fetch().then(@setGlobalDrinker)
    @dailyPours?.fetch()
    @weeklyPours?.fetch()

$ ->
  window.app = new Application
  window.app.start()
