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
shouldLimitApiCalls = /(mobile|iphone)/gi.test(navigator.userAgent) and not /(nexus 7|iPad)/gi.test(navigator.userAgent)


getURLParameter = (name='bad') ->
  (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[null,null])[1]

getStoredRemote = ->
  try
    item = localStorage.getItem(Globals.localStorageRemoteKey)
    if item
      JSON.parse(item)
  catch e


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

  setGlobalDrinker: =>
    $.get "/api/drinking", (json) =>
      if json?.id
        @drinker = @drinkers.obj.get(json.id)

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

  initRemote: ->
    @remote = getStoredRemote()

  setRemote: (remote) ->
    localStorage.setItem Globals.localStorageRemoteKey, JSON.stringify(remote)
    @remote = remote
    @router.nav.render()
    @router.navigate '#/', {trigger: true}

  removeRemote: ->
    localStorage.removeItem Globals.localStorageRemoteKey
    delete @remote
    @router.nav.render()
    @router.navigate '#/', {trigger: true}

  start: =>
    adminParam = getURLParameter('admin')
    remoteParam = getStoredRemote()?.remoteCode

    if adminParam or remoteParam
      $.ajax
        type: 'POST'
        url: "/api/interactive"
        dataType: 'json'
        contentType: 'application/json'
        data: JSON.stringify {
          admin: adminParam
          remote: remoteParam
        }
        success: @_start
        error: @_start
    else
      @_start()

  _start: ({admin, remote}={}) =>
    @initHelpers()
    @initRemote() if remote

    @model = @deferredObj(new KegStats)
    @drinkers = @deferredObjForDrinkers(new Drinkers)

    unless shouldLimitApiCalls
      @dailyPours = @deferredObj(new PoursSummary 'daily')
      @weeklyPours = @deferredObj(new PoursSummary 'weekly')
      @temps = @deferredObj(new Temps)


    @socket = new SocketListener(@model.obj).listen()
    @router = new Router
      admin: admin
      model: @model.obj
      deferredDrinkers: @drinkers.promise
      deferredTemps: @temps?.promise
      deferredDaily: @dailyPours?.promise
      deferredWeekly: @weeklyPours?.promise

    Backbone.history.start()

    @model.fetch()
    @drinkers.fetch()
    @temps?.fetch()
    @dailyPours?.fetch()
    @weeklyPours?.fetch()


$ ->
  window.app = new Application
  window.app.start()
