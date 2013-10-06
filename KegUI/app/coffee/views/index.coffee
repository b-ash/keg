View = require('coffee/views/view')
TickerView = require('coffee/views/ticker')
BrandBannerTemplate = require('html/brand_banner')


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
