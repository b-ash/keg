Globals = require('coffee/lib/globals')
Drinker = require('coffee/models/drinker')

class Drinkers extends Backbone.Collection

  model: Drinker

  url: ->
    "/api/drinkers"

  parse: (json) ->
    _.sortBy json, (drinker) ->
      drinker.name


module.exports = Drinkers
