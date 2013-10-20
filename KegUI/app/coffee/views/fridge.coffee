View = require('coffee/views/view')
TickerView = require('coffee/views/ticker')
TempChartView = require('coffee/views/temp_chart')


class FridgeView extends View

  className: 'row jumbotron'
  template: require('html/fridge')

  afterRender: =>
    @tickerView = new TickerView
      model: @model
      length: 8
      field: 'temp'

    @$('#temp').append @tickerView.render().el

  postRender: =>
    @options.deferredTemps.done (collection) =>
      @tempsView = new TempChartView {collection}
      @tempsView.chart()


module.exports = FridgeView
