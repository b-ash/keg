View = require('coffee/views/view')
MissedPours = require('coffee/collections/missed_pours')
SelectDrinkerDialog = require('coffee/views/select_drinker_dialog')
$ = jQuery

class ClaimView extends View
  className: 'spanning-full'
  template: require('html/claim')
  events:
    'click tr': 'selectPour'

  initialize: ->
    @pours = new MissedPours

  getRenderData: ->
    pours: @pours.toJSON()

  postRender: ->
    $.when(@options.deferredDrinkers, @pours.fetch()).then (@drinkers) =>
      @render()

  selectPour: (event) =>
    id = $(event.currentTarget).attr('id')
    pour = @pours.get(id)

    dialog = new SelectDrinkerDialog
      collection: @drinkers
      successCallback: @getDrinkerSelectedCallback pour

    dialog.render()

  getDrinkerSelectedCallback: (pour) ->
    (drinkerId) ->
      pour.save {drinkerId},
        success: ->
          app.router.navigate '#/leaderboard', {trigger: true}
        error: ->
          vex.open {content: "<h3>Something went wrong...</h3>"}
          setTimeout vex.close, 1500



module.exports = ClaimView
