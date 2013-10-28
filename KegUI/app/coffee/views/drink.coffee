View = require('coffee/views/view')
CreateDrinkerDialog = require('coffee/views/create_drinker_dialog')
$ = jQuery

class DrinkView extends View
  className: 'row jumbotron'
  template: require('html/drink')
  events:
    'click tr': 'selectDrinker'
    'click #create button': 'createDrinker'
    'click #cancel button': 'cancelDrinker'

  getRenderData: ->
    drinkers: @collection?.toJSON() ? []
    drinker: window.app.drinker?.toJSON()

  postRender: ->
    @options.deferredDrinkers.done (@collection) =>
      @render()

  selectDrinker: (event) =>
    id = $(event.currentTarget).attr('id')
    drinker = @collection.get(id)
    drinker
      .requestDrink()
      .then(=>
        window.app.drinker = drinker
        @render()
      ).fail((xhr) ->
        if xhr.status is 400
          msg = 'Hold up, someone else is drinking.'
        else
          msg = 'Something went wrong...'

        vex.open
          content: "<h3>#{msg}</h3>"

        setTimeout vex.close, 1500
      )

  cancelDrinker: (event) ->
    window.app.drinker.endDrink()
    window.app.drinker = null
    @render()

  createDrinker: (event) =>
    dialog = new CreateDrinkerDialog
      collection: @collection
      successCallback: @render

    dialog.render()


module.exports = DrinkView
