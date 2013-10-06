Nav = require('coffee/views/nav')
IndexView = require('coffee/views/index')
EditView = require('coffee/views/edit')
Simulation = require('coffee/lib/simulation')

$ = jQuery

class Router extends Backbone.Router

  routes:
    'edit': 'edit'
    'simulate': 'simulate'
    '*query': 'index'

  initialize: (options={}) =>
    @model = options.model
    super

  index: =>
    @changeView IndexView

  edit: =>
    @changeView EditView

  simulate: =>
    @index()
    Simulation.start()

  setupNav: =>
    unless @nav?
      @nav = new Nav
      $('.navbar').html @nav.render().el

  changeView: (Claxx) =>
    @view = new Claxx {@model}
    @setupNav()

    if @view is @currentView
      return

    @currentView?.close()
    @currentView = @view

    $('.content').html @view.render().el


module.exports = Router
