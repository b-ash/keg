Globals = require('coffee/lib/globals')
Drinker = require('coffee/models/drinker')

class Drinkers extends Backbone.Collection

  model: Drinker

  url: ->
    "#{Globals.apiOverride}/api/drinkers"


module.exports = Drinkers
