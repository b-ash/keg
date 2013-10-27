Globals = require('coffee/lib/globals')


class KegStats extends Backbone.Model

  url: ->
    "#{Globals.apiOverride}/api/kegs/current"

  parse: (json) ->
    if json.kicked?
      json.poursLeft = 'kicked'
    else
      json.poursLeft = ((json.volume - json.consumed) / Globals.beerSize).toFixed(3)

    json.consumed = (json.consumed / Globals.beerSize).toFixed(3)
    json.lastPour = moment(json.lastPour).format('MM/DD/YY')
    json.temp = json.temp.toFixed(3)
    json

module.exports = KegStats
