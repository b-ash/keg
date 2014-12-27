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
    @stats.fetch().done(@attachChildren)

  attachChildren: =>
    for widget in @getWidgets()
      @$('.slider').append widget.el


module.exports = DashboardView
