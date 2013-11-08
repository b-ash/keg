View = require('coffee/views/view')
TickerView = require('coffee/views/ticker')


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

  updateStats: =>
    @$('#keg_name').text @model.get('name')
    @$('#total_pours').text @model.get('consumed')
    @$('#pours_left').text @model.get('poursLeft')


module.exports = IndexView
