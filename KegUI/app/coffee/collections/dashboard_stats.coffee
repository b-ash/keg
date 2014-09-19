Globals = require('coffee/lib/globals')

class DashboardStats extends Backbone.Model

  url: ->
    "#{Globals.apiOverride}/api/dashboard"

module.exports = DashboardStats
