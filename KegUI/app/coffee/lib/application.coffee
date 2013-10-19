Router = require('coffee/lib/router')
KegStats = require('coffee/models/keg_stats')
SocketListener = require('coffee/lib/socket_listener')

$ = jQuery

vex.defaultOptions.className = 'vex-theme-wireframe'

class Application

  start: =>
    @model = new KegStats
    @socket = new SocketListener(@model).listen()
    @router = new Router {@model}

    Backbone.history.start()

    @model.fetch()

$ ->
  window.app = new Application
  window.app.start()
