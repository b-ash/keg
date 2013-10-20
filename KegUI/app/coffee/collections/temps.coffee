Temp = require('coffee/models/temp')
Globals = require('coffee/lib/globals')


class Temps extends Backbone.Collection

  apiTimeFormat: 'YYYY/MM/DD HH:mm:ss'
  model: Temp

  url: ->
    end = moment.utc().format(@apiTimeFormat)
    start = moment.utc().subtract(7, 'days').format(@apiTimeFormat)

    "#{Globals.apiOverride}/api/temps?start=#{start}&end=#{end}"


module.exports = Temps
