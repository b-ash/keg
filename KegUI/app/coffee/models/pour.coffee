Globals = require('coffee/lib/globals')

class Pour extends Backbone.Model

  urlRoot: ->
    "#{Globals.apiOverride}/api/pours"

  parse: (json) ->
    json.timeDisplay = moment(json.start).format('MM/DD/YY hh:mm:ss a')
    json


module.exports = Pour
