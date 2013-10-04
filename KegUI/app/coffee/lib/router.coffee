Nav = require('coffee/views/nav')
IndexView = require('coffee/views/index')
EditView = require('coffee/views/edit')

$ = jQuery

class Router extends Backbone.Router

  routes:
    'edit': 'edit'
    '*query': 'index'

  initialize: (options={}) =>
    @model = options.model
    super

  index: =>
    @changeView IndexView

  edit: =>
    @changeView EditView

  setupNav: =>
    unless @nav?
      @nav = new Nav
      $('.navbar').html @nav.render().el

  changeView: (Claxx) =>
    @view = new Claxx {@model}
    @setupNav()

    if @view is @currentView
      return

    @currentView?.remove()
    @currentView = @view

    $('.content').html @view.render().el


module.exports = Router
