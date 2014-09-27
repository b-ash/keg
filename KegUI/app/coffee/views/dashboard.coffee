DashboardStats = require('coffee/collections/dashboard_stats')
Widget = require('coffee/views/dashboard_widget')
View = require('coffee/views/view')

class DashboardView extends View

  className: 'dashboard-content'

  template: require('html/dashboard')

  initialize: ->
    @stats = new DashboardStats

  getWidgets: ->
    [
      (new Widget
        stat: @stats.get('ragingDrinkers')
        title: 'True Partiers'
        unit: 'beers'
      ).render()

      (new Widget
        stat: @stats.get('avgKickTimeDays')
        unit: 'Days'
        title: 'Avg Keg Life'
      ).render()

      (new Widget
        stat: @stats.get('recentKegs')
        title: 'Kegs Crushed'
      ).render()

      (new Widget
        stat: @stats.get('barTabs')
        title: 'Bar Tabs'
        prefix: '$'
      ).render()

      (new Widget
        stat: @stats.get('unclaimedPours')
        title: 'Unclaimed Pours'
      ).render()

      (new Widget
        stat: @stats.get('currentKegLeaders')
        title: 'Current Keg Leaders'
        unit: 'beers'
      ).render()
    ]

  postRender: ->
    @stats.fetch().done(@startStats)

  startStats: =>
    widgets = @getWidgets()
    current = 0
    widget1 = null
    widget2 = null

    slideOne = (widget, position, side, op1, op2) =>
      animation = {}
      animation["margin-#{side}"] = "#{op2}=900"

      # Slide out and remove
      widget?.$el.animate(animation, 'slow', null, ((shown) -> -> shown.$el.remove())(widget))

      widget = widgets[current % widgets.length]
      widget.$el
        .css("margin-#{side}", position)
        .css(side, 0)

      @$('.slider').append(widget.el)

      # Slide in
      animation["margin-#{side}"] = "#{op1}=900"
      widget.$el.animate(animation, 'slow')

      current++
      return widget

    slide = =>
      widget1 = slideOne(widget1, '-350px', 'right', '+', '+')
      widget2 = slideOne(widget2, '-350px', 'left', '+', '+')

    slide()
    setInterval(slide, 10000)

module.exports = DashboardView
