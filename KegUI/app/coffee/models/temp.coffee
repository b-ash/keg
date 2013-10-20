class Temp extends Backbone.Model

  parse: (json) ->
    json.y = json.degrees

    date = moment(json.timestamp)
    json.x = Date.UTC(date.year(), date.month(), date.date())

    json


module.exports = Temp
