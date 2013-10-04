View = require('coffee/views/view')
TickerView = require('coffee/views/ticker')


class IndexView extends View

  className: 'row jumbotron'
  template: require('html/index')

  initialize: =>
    @model.on 'sync', @updateCounts

  getRenderData: =>
    @model.toJSON()

  afterRender: =>
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

  updateCounts: =>
    @$('#total_pours').val 'Not many'
    @$('#pours_left').val 'A bunch'

  onClose: =>
    clearTimeout @timeout


module.exports = IndexView
