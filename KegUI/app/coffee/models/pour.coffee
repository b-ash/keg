Globals = require('coffee/lib/globals')

class Pour extends Backbone.Model

  urlRoot: ->
    "/api/pours"

  parse: (json) ->
    json.timeDisplay = moment(json.start).format('MM/DD/YY hh:mm:ss a')
    json


module.exports = Pour
