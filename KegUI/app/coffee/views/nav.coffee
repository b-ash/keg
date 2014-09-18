View = require('coffee/views/view')
$ = jQuery

class Nav extends View

  el: '#sidenav'
  template: require('html/nav')

  initialize: ({@interactive}) ->

  setActiveItem: (@item) ->

  getRenderData: ->
    {@item, @interactive}


module.exports = Nav
