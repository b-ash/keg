View = require('coffee/views/view')


class Nav extends View

  className: 'container'
  template: require('html/nav')
  events:
    'click a': 'routeEvent'


module.exports = Nav
