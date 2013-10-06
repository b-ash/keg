View = require('coffee/views/view')
$ = jQuery

class Nav extends View

  className: 'container'
  template: require('html/nav')
  events:
    'click a': 'routeEvent'

  routeEvent: (event) =>
    @$('li.active').removeClass('active')
    $(event.currentTarget).parent().addClass('active')

    super


module.exports = Nav
