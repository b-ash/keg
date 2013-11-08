View = require('coffee/views/view')
TickerView = require('coffee/views/ticker')
BrandBannerTemplate = require('html/brand_banner')


class IndexView extends View

  className: 'spanning-full'
  template: require('html/index')

  initialize: =>
    @model.on 'change', @updateStats

  getRenderData: =>
    @model.toJSON()

  afterRender: =>
    if @model.get('name')?
      @updateStats()

    opts =
      lastPour:
        el: @$('#last_pour')
        length: 8
      consumed:
        el: @$('#total_pours')
        length: 2
      poursLeft:
        el: @$('#pours_left')
        length: 2
      temp:
        el: @$('#temp')
        length: 4

    for key in ['lastPour', 'temp']
      ticker = new TickerView
        model: @model
        length: opts[key].length
        field: key

      opts[key].el.append ticker.render().el

  updateEllipsis: (count) =>
    =>
      ellipsis = ('.' for i in [0...(count % 3) + 1]).join('')
      count++

      @$('.ellipsis').text ellipsis

  updateStats: =>
    @$('#keg_name').text @model.get('name')
    @$('#brand_banner_wrap')
      .html(BrandBannerTemplate {bannerImage: @model.get('url')})
      .find('img')
      .fadeIn()
    @$('#total_pours').text @model.get('consumed')
    @$('#pours_left').text @model.get('poursLeft')

  onClose: =>
    clearTimeout @timeout


module.exports = IndexView
