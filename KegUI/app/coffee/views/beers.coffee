View = require('coffee/views/view')
BeerChartView = require('coffee/views/beer_chart')


class BeersView extends View

  className: 'container'
  template: require('html/beers')

  postRender: =>
    @options.deferredDaily.then (dailyCollection) =>
      @dailyView = new BeerChartView
        collection: dailyCollection
        el: '.daily-chart'
        type: 'daily'
      @dailyView.chart()

    @options.deferredWeekly.then (weeklyCollection) =>
      @weeklyView = new BeerChartView
        collection: weeklyCollection
        el: '.weekly-chart'
        type: 'weekly'
      @weeklyView.chart()


module.exports = BeersView
