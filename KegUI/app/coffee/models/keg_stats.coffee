class KegStats extends Backbone.Model

  url: ->
    '/api/kegs/current'

  parse: (json) ->
    json.poursLeft = ((json.volume - json.consumed) / 16).toFixed(3)
    json.lastPour = moment(json.lastPour).format('MM/DD/YY')
    json

module.exports = KegStats
