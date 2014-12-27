Temp = require('coffee/models/temp')
Globals = require('coffee/lib/globals')


class Temps extends Backbone.Collection
  model: Temp

  url: ->
    end = moment.utc().format(Globals.apiTimeFormat)
    start = moment.utc().subtract(1, 'days').format(Globals.apiTimeFormat)

    "/api/temps?start=#{start}&end=#{end}"

  parse: (temps) ->
    last = {}
    _.filter temps, (temp) ->
      outlier = Math.abs(last.degrees - temp.degrees) > 20
      last = temp
      !outlier


module.exports = Temps
