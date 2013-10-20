Highcharts.setOptions {global: useUTC: false}


class TempChart extends Backbone.View

  el: '#temp_chart'
  title: 'Fridge temperature'
  subtitle: '(click and drag to zoom)'

  getChartOptions: ->
    chart:
      global:
        useUTC: false
      backgroundColor: '#121212'
      zoomType: 'x'
      resetZoomButton:
        position:
          x: 0
          y: -40
    title:
      text: @title
      style:
        color: '#FFF'
        fontWeight: 'bold'
    subtitle:
      text: @subtitle
      style:
        color: '#999'
    credits:
      enabled: false
    xAxis:
      type: 'datetime'
      dateTimeLabelFormats:
        millisecond: '%I:%M%p'
        second: '%I:%M%p'
        minute: '%I:%M%p'
        hour: '%I:%M%p'
        day: '%a %m/%d'
    yAxis: [{
      min: 0
      showFirstLabel: false
      title:
        text: 'Degrees (F)'
        style:
          color: '#999'
    }]
    legend:
      enabled: false
    tooltip:
      crosshairs: true
    series: [{
      name: 'Degrees'
      data: @collection.toJSON()
    }]
    plotOptions:
      series:
        animation: false
        states:
          hover:
            lineWidth: 2
        marker:
          enabled: false
        turboThreshold: 1

  chart: ->
    unless @collection.length
      return

    @$el.highcharts @getChartOptions()


module.exports = TempChart
