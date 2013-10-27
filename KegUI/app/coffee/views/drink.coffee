View = require('coffee/views/view')
$ = jQuery

class DrinkView extends View
  className: 'row jumbotron'
  template: require('html/drink')
  events:
    'click tr': 'selectDrinker'

  selectDrinker: (event) =>
    id = $(event.currentTarget).attr('id')
    drinker = @collection.get(id)
    drinker
      .requestDrink()
      .then(->
        window.app.drinker = drinker

        vex.open
          content: "<h2>Drink up #{drinker.get('name')}</h2>"

        setTimeout vex.close, 1500
      ).fail((xhr) ->
        if xhr.status is 400
          msg = 'Hold up, someone else is drinking.'
        else
          msg = 'Something went wrong...'

        vex.open
          content: "<h3>#{msg}</h3>"

        setTimeout vex.close, 1500
      )

  getRenderData: ->
    drinkers: @collection?.toJSON() ? []

  postRender: ->
    @options.deferredDrinkers.done (@collection) =>
      @render()


module.exports = DrinkView
