View = require('coffee/views/view')

class DashboardWidgetView extends View

  className: 'dash-widget'

  template: require('html/dashboard_widget')

  initialize: ({@stat, @title, @unit, @prefix}) ->
    if @unit or @prefix and _.isArray(@stat)
      for item in @stat
        item.unit = @unit
        item.prefix = @prefix

  getRenderData: ->
    {@stat, @title, @unit, @prefix, isList: _.isArray(@stat)}

module.exports = DashboardWidgetView
