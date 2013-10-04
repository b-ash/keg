View = require('coffee/views/view')


class IndexView extends View

  className: 'row jumbotron'
  template: require('html/index')

  initialize: =>
    @model.on 'sync', @updateCounts

  getRenderData: =>
    @model.toJSON()

  afterRender: =>
    @interval = setInterval(@updateEllipsis(1), 500)

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
