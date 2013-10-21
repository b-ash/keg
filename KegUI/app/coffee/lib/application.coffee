Router = require('coffee/lib/router')
SocketListener = require('coffee/lib/socket_listener')

KegStats = require('coffee/models/keg_stats')
Temps = require('coffee/collections/temps')
PoursSummary = require('coffee/collections/pours_summary')

$ = jQuery

vex.defaultOptions.className = 'vex-theme-wireframe'

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

  start: =>
    @initHelpers()

    @model = @deferredObj(new KegStats)
    @temps = @deferredObj(new Temps)
    @dailyPours = @deferredObj(new PoursSummary 'daily')
    @weeklyPours = @deferredObj(new PoursSummary 'weekly')

    @socket = new SocketListener(@model.obj).listen()
    @router = new Router
      model: @model.obj
      deferredTemps: @temps.promise
      deferredDaily: @dailyPours.promise
      deferredWeekly: @weeklyPours.promise

    Backbone.history.start()

    @model.fetch()
    @temps.fetch()
    @dailyPours.fetch()
    @weeklyPours.fetch()

$ ->
  window.app = new Application
  window.app.start()
