View = require('coffee/views/view')
BeerChartView = require('coffee/views/beer_chart')


class BeersView extends View

  className: 'row jumbotron'
  template: require('html/beers')

  postRender: =>
    @options.deferredDaily.then (dailyCollection) =>
      @dailyView = new BeerChartView
        collection: dailyCollection
        el: '.daily-chart'
      @dailyView.chart()

    @options.deferredWeekly.then (weeklyCollection) =>
      @weeklyView = new BeerChartView
        collection: weeklyCollection
        el: '.weekly-chart'
      @weeklyView.chart()


module.exports = BeersView
