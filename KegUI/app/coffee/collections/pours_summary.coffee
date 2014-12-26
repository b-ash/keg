Globals = require('coffee/lib/globals')


class PoursSummary extends Backbone.Collection

  constructor: (@period) ->
    super

  url: ->
    "/api/pours/#{@period}"

module.exports = PoursSummary
