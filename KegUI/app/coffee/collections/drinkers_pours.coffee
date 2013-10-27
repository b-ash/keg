Globals = require('coffee/lib/globals')
DrinkerPour = require('coffee/models/drinker_pour')

class DrinkersPours extends Backbone.Collection

  model: DrinkerPour

  url: ->
    "#{Globals.apiOverride}/api/drinkers/pours"

  parse: (json) ->
    for drinker, i in json
      drinker.place = i+1
    json


module.exports = DrinkersPours
