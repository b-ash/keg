Globals = require('coffee/lib/globals')

class Banners extends Backbone.Collection
  url: ->
    "#{Globals.apiOverride}/api/banners"


module.exports = Banners
