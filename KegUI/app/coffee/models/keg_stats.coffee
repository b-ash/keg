Globals = require('coffee/lib/globals')


class KegStats extends Backbone.Model

  url: ->
    "#{Globals.apiOverride}/api/kegs"

  fetch: (options={}) ->
    options.url = "#{@url()}/current"
    super(options)

  parse: (json) ->
    if json.kicked?
      json.poursLeft = 0
    else
      json.poursLeft = Math.round((json.volume - json.consumed) / Globals.beerSize)

    json.consumed = Math.round(json.consumed / Globals.beerSize)

    if json.lastPour?
      json.lastPour = moment(json.lastPour).format('MM/DD/YY')
    else
      json.lastPour = 'never'

    json.tapped = moment(json.tapped).format('MM/DD/YY')
    json.temp = json.temp?.toFixed(1)
    json

module.exports = KegStats
