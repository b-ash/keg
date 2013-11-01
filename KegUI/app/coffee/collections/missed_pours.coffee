Globals = require('coffee/lib/globals')
Pour = require('coffee/models/pour')

class MissedPours extends Backbone.Collection
  model: Pour

  url: ->
    "#{Globals.apiOverride}/api/pours/missed"


module.exports = MissedPours
