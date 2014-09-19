DashboardStats = require('coffee/collections/dashboard_stats')
Widget = require('coffee/views/dashboard_widget')
View = require('coffee/views/view')

class DashboardView extends View

  template: require('html/dashboard')

  initialize: ->
    @stats = new DashboardStats

  afterRender: ->
    if @stats.has('ragingDrinkers')
      @$el.append (new Widget
        el: '#raging_drinkers'
        stat: @stats.get('ragingDrinkers')
        title: 'True Partiers'
      ).render().el

    if @stats.has('avgKickTimeDays')
      @$el.append (new Widget
        el: '#kick_time'
        stat: @stats.get('avgKickTimeDays')
        unit: 'Days'
        title: 'Avg Keg Life'
      ).render().el

    if @stats.has('recentKegs')
      @$el.append (new Widget
        el: '#recent_kegs'
        stat: @stats.get('recentKegs')
        title: 'Kegs Crushed'
      ).render().el

    if @stats.has('barTabs')
      @$el.append (new Widget
        el: '#bar_tabs'
        stat: @stats.get('barTabs')
        title: 'Bar Tabs'
      ).render().el

    if @stats.has('unclaimedPours')
      @$el.append (new Widget
        el: '#unclaimed_pours'
        stat: @stats.get('unclaimedPours')
        title: 'Unclaimed Pours'
      ).render().el

  postRender: ->
    @stats.fetch().done(@render)

module.exports = DashboardView
