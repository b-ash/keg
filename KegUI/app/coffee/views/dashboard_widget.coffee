View = require('coffee/views/view')

class DashboardWidgetView extends View

  template: require('html/dashboard_widget')

  initialize: ({@stat, @title, @unit}) ->

  getRenderData: ->
    {@stat, @title, @unit, isList: _.isArray(@stat)}

module.exports = DashboardWidgetView
