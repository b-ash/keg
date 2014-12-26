Globals = require('coffee/lib/globals')

class DashboardStats extends Backbone.Model

  url: ->
    "/api/dashboard"

  parse: (json) ->
    for key, val of json
      if _.isArray(val)
        json[key] = val.slice(0, 8)
    json

module.exports = DashboardStats
