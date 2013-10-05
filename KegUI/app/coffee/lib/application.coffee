Router = require('coffee/lib/router')
KegStats = require('coffee/models/keg_stats')
SocketListener = require('coffee/lib/socket_listener')
$ = jQuery

vex.defaultOptions.className = 'vex-theme-wireframe'

class Application

  start: =>
    @model = new KegStats
    @socket = new SocketListener().listen()
    @router = new Router {@model}

    Backbone.history.start()

$ ->
  window.app = new Application
  window.app.start()

  # Remove this later, obvi
  setTimeout ->
    window.app.model.set
      lastPour: '10/2/12'
      totalPours: 15.2
      poursLeft: 35.8
  , 3000
