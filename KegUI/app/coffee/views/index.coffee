View = require('coffee/views/view')
TickerView = require('coffee/views/ticker')
BrandBannerTemplate = require('html/brand_banner')
BeerChartView = require('coffee/views/beer_chart')
TempChartView = require('coffee/views/temp_chart')
PoursSummary = require('coffee/collections/pours_summary')
Temps = require('coffee/collections/temps')


class IndexView extends View

  className: 'row jumbotron'
  template: require('html/index')

  initialize: =>
    @model.on 'change:name', @updateKegName
    @model.on 'change:url', @updateBanner

  getRenderData: =>
    @model.toJSON()

  afterRender: =>
    if @model.get('name')?
      @updateKegName()

    if @model.get('url')?
      @updateBanner()

    els =
      lastPour: @$('#last_pour')
      consumed: @$('#total_pours')
      poursLeft: @$('#pours_left')
      temp: @$('#temp')

    for key in ['lastPour', 'consumed', 'poursLeft', 'temp']
      ticker = new TickerView
        model: @model
        length: 8
        field: key

      els[key].append ticker.render().el

    dailyCollection = new PoursSummary('daily')
    dailyCollection.fetch
      success: ->
        dailyView = new BeerChartView
          collection: dailyCollection
          el: '.daily-chart'
        dailyView.chart()

    weeklyCollection = new PoursSummary('weekly')
    weeklyCollection.fetch
      success: ->
        weeklyView = new BeerChartView
          collection: weeklyCollection
          el: '.weekly-chart'
        weeklyView.chart()

    temps = new Temps
    temps.fetch
      success: ->
        tempsView = new TempChartView
          collection: temps
        tempsView.chart()

  updateEllipsis: (count) =>
    =>
      ellipsis = ('.' for i in [0...(count % 3) + 1]).join('')
      count++

      @$('.ellipsis').text ellipsis

  updateKegName: =>
    @$('#keg_wrap p').text @model.get('name')

  updateBanner: =>
    @$('#brand_banner_wrap')
      .html(BrandBannerTemplate {bannerImage: @model.get('url')})
      .find('img')
      .fadeIn()

  onClose: =>
    clearTimeout @timeout


module.exports = IndexView
