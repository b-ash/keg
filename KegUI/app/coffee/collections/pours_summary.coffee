Globals = require('coffee/lib/globals')


class PoursSummary extends Backbone.Collection

  constructor: (@period) ->
    super

  url: ->
    "#{Globals.apiOverride}/api/pours/#{@period}"

module.exports = PoursSummary
