View = require('coffee/views/view')
$ = jQuery

class Nav extends View

  className: 'container'
  template: require('html/nav')
  events:
    'click a': 'routeEvent'

  updateActive: (route) ->
    unless route?.length
      route = 'home'

    @$('.active').removeClass('active')
    @$("[data-route='#{route}']").addClass('active')

  getRenderData: ->
    item: @options.activeItem
    interactive: @options.interactive
    showDashboard: @options.interactive

  routeEvent: (event) =>
    $target = $(event.currentTarget)
    @$('li.active').removeClass('active')

    if $target.hasClass('navbar-brand')
      $target = @$('.home')

    $target.parent().addClass('active')

    if @$('.navbar-collapse').hasClass('in')
      @$('button').click()

    super


module.exports = Nav
