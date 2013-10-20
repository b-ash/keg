Temp = require('coffee/models/temp')


class Temps extends Backbone.Collection

  apiTimeFormat: 'YYYY/MM/DD hh:mm:ss'
  model: Temp

  url: ->
    end = moment().format(@apiTimeFormat)
    start = moment().subtract(7, 'days').format(@apiTimeFormat)

    "/api/temps?start=#{start}&end=#{end}"


module.exports = Temps
