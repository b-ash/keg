class Temp extends Backbone.Model

  parse: (json) ->
    json.x = moment(json.timestamp).toDate()
    json.y = json.degrees

    json

  toJSON: ->
    [@get('x'), @get('y')]


module.exports = Temp
