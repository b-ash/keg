View = require('coffee/views/view')
TickerView = require('coffee/views/ticker')
BrandBannerTemplate = require('html/brand_banner')
ChartView = require('coffee/views/chart')
PoursSummary = require("coffee/collections/pours_summary")


class IndexView extends View

  className: 'row jumbotron'
  template: require('html/index')

  initialize: =>
    @model.on 'change:keg', @updateKegName
    @model.on 'change:bannerImage', @updateBanner

  getRenderData: =>
    @model.toJSON()

  afterRender: =>
    if @model.get('keg')?
      @updateKegName()

    if @model.get('bannerImage')?
      @updateBanner()

    els =
      lastPour: @$('#last_pour')
      totalPours: @$('#total_pours')
      poursLeft: @$('#pours_left')

    for key in ['lastPour', 'totalPours', 'poursLeft']
      ticker = new TickerView
        model: @model
        length: 8
        field: key

      els[key].append ticker.render().el

    dailyCollection = new PoursSummary()
    dailyCollection.period = 'daily'
    dailyCollection.fetch
      success: =>
        dailyView = new ChartView
          collection: dailyCollection
          el: '.daily-chart'
        dailyView.chart()

    weeklyCollection = new PoursSummary()
    weeklyCollection.period = 'weekly'
    weeklyCollection.fetch
      success: =>
        weeklyView = new ChartView
          collection: weeklyCollection
          el: '.weekly-chart'
        weeklyView.chart()

  updateEllipsis: (count) =>
    =>
      ellipsis = ('.' for i in [0...(count % 3) + 1]).join('')
      count++

      @$('.ellipsis').text ellipsis

  updateKegName: =>
    @$('#keg_wrap p').text @model.get('keg')

  updateBanner: =>
    @$('#brand_banner_wrap')
      .html(BrandBannerTemplate {bannerImage: @model.get('bannerImage')})
      .find('img')
      .fadeIn()

  onClose: =>
    clearTimeout @timeout


module.exports = IndexView
