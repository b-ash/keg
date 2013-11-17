Globals = require('coffee/lib/globals')


class KegStats extends Backbone.Model

  urlRoot: ->
    "#{Globals.apiOverride}/api/kegs"

  fetch: (options={}) ->
    options.url = "#{@urlRoot()}/current"
    super(options)

  kick: (options={}) ->
    options.url = "#{@url()}/kick"
    @save {kicked: moment().format(Globals.apiTimeFormat)}, options

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

    json.tapped = moment(json.tapped).format(Globals.apiTimeFormat)
    json.kicked = moment(json.kicked)?.format(Globals.apiTimeFormat)
    json.temp = json.temp?.toFixed(1)
    json

module.exports = KegStats
