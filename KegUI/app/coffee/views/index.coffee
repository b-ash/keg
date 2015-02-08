View = require('coffee/views/view')
TickerView = require('coffee/views/ticker')


class IndexView extends View
  template: require('html/index')

  initialize: =>
    @model.on 'change', @updateStats

  getRenderData: =>
    app.remote or {}

  afterRender: =>
    if @model.get('name')?
      @updateStats()

    opts =
      lastPour:
        el: @$('#last_pour')
        length: 8
      tapped:
        el: @$('#tapped')
        length: 8
        translateVal: (tapped) ->
          moment(tapped).format('MM/DD/YY')
      temp:
        el: @$('#temp')
        length: 4

    for key in ['lastPour', 'tapped', 'temp']
      ticker = new TickerView
        model: @model
        length: opts[key].length
        field: key
        translateVal: opts[key].translateVal

      opts[key].el.append ticker.render().el

  updateStats: =>
    @$('#keg_name').text @model.get('name')
    @$('#total_pours').text @model.get('consumed')
    @$('#pours_left').text @model.get('poursLeft')


module.exports = IndexView
