Router = require('coffee/lib/router')
KegStats = require('coffee/models/keg_stats')

$ = jQuery

class Application

  start: =>
    @model = new KegStats
    @router = new Router {@model}

    Backbone.history.start()

$ ->
  window.app = new Application
  window.app.start()
