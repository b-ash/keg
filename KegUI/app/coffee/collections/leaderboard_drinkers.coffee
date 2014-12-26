Globals = require('coffee/lib/globals')
Pour = require('coffee/models/pour')

class LeaderboardDrinkers extends Backbone.Collection

  model: Pour

  url: ->
    "/api/leaderboard"

  parse: (json) ->
    for drinker, i in json
      drinker.place = i+1
    json


module.exports = LeaderboardDrinkers
