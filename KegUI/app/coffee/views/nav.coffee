View = require('coffee/views/view')
$ = jQuery

class Nav extends View

  className: 'container'
  template: require('html/nav')
  events:
    'click a': 'routeEvent'

  updateActive: (route) ->
    @$('.active').removeClass('active')
    @$("[data-route='#{route}']").addClass('active')

  getRenderData: ->
    @options.activeItem

  routeEvent: (event) =>
    $target = $(event.currentTarget)
    @$('li.active').removeClass('active')

    if $target.hasClass('navbar-brand')
      $target = @$('.home')

    $target.parent().addClass('active')

    super


module.exports = Nav
