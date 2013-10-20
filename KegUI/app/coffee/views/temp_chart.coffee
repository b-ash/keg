class TempChart extends Backbone.View

  el: '#temp_chart'

  getChartOptions: ->
    chart:
      backgroundColor: '#121212'
    title:
      text: 'Fridge temperature'
      style:
        color: '#FFF'
        fontWeight: 'bold'
    subtitle:
      text: 'Sensor mounted at top corner'
      style:
        color: '#999'
    credits:
      enabled: false
    xAxis:
      type: 'datetime'
    yAxis: [{
      min: 0
      title:
        text: null
    }]
    legend:
      enabled: false
    tooltip:
      crosshairs: true
    series: [{
      name: 'Degrees'
      data: @collection.toJSON()
    }]

  chart: ->
    unless @collection.length
      return

    @$el.highcharts @getChartOptions()


module.exports = TempChart
