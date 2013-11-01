View = require('coffee/views/view')


class SelectDrinkerDialog extends View
  template: require('html/select_drinker_dialog')
  events:
    'click tr': 'selectDrinker'

  render: =>
    super
    vex.open {content: @$el}
    @

  getRenderData: ->
    {drinkers: @collection.toJSON()}

  selectDrinker: (event) =>
    id = +$(event.currentTarget).attr('id')
    @options.successCallback(id)
    @close()

  close: =>
    vex.close()


module.exports = SelectDrinkerDialog
