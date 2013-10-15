class PoursSummary extends Backbone.Collection

  url: ->
    "/api/pours/#{@period}"

module.exports = PoursSummary
