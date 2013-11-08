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
shouldLimitApiCalls = /(mobile|iphone)/gi.test(navigator.userAgent) and not /(nexus 7)/gi.test(navigator.userAgent)


getURLParameter = (name='bad') ->
  return (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[null,null])[1]


class Application

  deferredObj: (obj) =>
    promise = new $.Deferred
    fetch = ->
      obj.fetch().then ->
        promise.resolve obj

    {promise, fetch, obj}

  deferredObjForDrinkers: (obj) =>
    deferred = @deferredObj(obj)
    deferred.fetch = =>
      obj.fetch().then =>
        @setGlobalDrinker().then ->
          deferred.promise.resolve obj
    deferred

  initHelpers: ->
    Handlebars.registerHelper 'getActiveClass', (active, claxx) ->
      if active is claxx
        return 'active'
    Handlebars.registerHelper 'isNexus7', (options) ->
      if /(nexus 7)/gi.test(navigator.userAgent)
        options.fn()
      else
        options.inverse()
    Handlebars.registerHelper 'unlessLimitedMobile', (ctx, options) ->
      if shouldLimitApiCalls
        options.inverse ctx
      else
        options.fn ctx
    Handlebars.registerHelper 'getBeers', (ounces) ->
      (ounces / Globals.beerSize).toFixed(3)
    Handlebars.registerHelper 'getFixedNumber', (ounces) ->
      try
        ounces.toFixed(3)
      catch e
        ounces

  setGlobalDrinker: =>
    $.getJSON '/api/drinking', (json) =>
      if json?
        @drinker = @drinkers.obj.get(json.id)

  start: =>
    interactiveParam = getURLParameter('interactive')

    _start = (interactive=false) =>
      @initHelpers()

      @model = @deferredObj(new KegStats)
      @temps = @deferredObj(new Temps)
      @drinkers = @deferredObjForDrinkers(new Drinkers)

      unless shouldLimitApiCalls
        @dailyPours = @deferredObj(new PoursSummary 'daily')
        @weeklyPours = @deferredObj(new PoursSummary 'weekly')

      @socket = new SocketListener(@model.obj).listen()
      @router = new Router
        interactive: interactive
        model: @model.obj
        deferredTemps: @temps.promise
        deferredDrinkers: @drinkers.promise
        deferredDaily: @dailyPours?.promise
        deferredWeekly: @weeklyPours?.promise

      Backbone.history.start()

      @model.fetch()
      @temps.fetch()
      @drinkers.fetch()
      @dailyPours?.fetch()
      @weeklyPours?.fetch()

    if interactiveParam?.length
      $.ajax
        type: 'POST'
        url: '/api/interactive'
        dataType: 'json'
        contentType: 'application/json'
        data: JSON.stringify {key: interactiveParam}
        success: (resp) ->
          _start(resp.interactive)
        error: (resp) ->
          _start()
    else
      _start()


$ ->
  window.app = new Application
  window.app.start()
