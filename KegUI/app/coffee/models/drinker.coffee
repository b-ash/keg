Globals = require('coffee/lib/globals')
$ = jQuery

class Drinker extends Backbone.Model

  urlRoot: ->
    "/api/drinkers"

  # Set this user as the current drinker
  requestDrink: (options) ->
    @_request 'request-drink', options

  # Release this user as the current drinker
  endDrink: (options) ->
    @_request 'end-drink', options

  # Sets this drinker on the last pour
  poured: (options) ->
    @_request 'poured', options

  endAndSetLastPour: (options) ->
    $.when(@endDrink(), @poured())

  _request: (path, options) ->
    url = "#{@url()}/#{path}"
    ajaxOpts = {type: 'POST', url}

    $.ajax _.extend(ajaxOpts, options)


module.exports = Drinker
