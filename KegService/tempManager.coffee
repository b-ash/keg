TempDao = require('./tempDao')
tempDao = new TempDao

class TempManager

  constructor: (@tempDao, @socket) ->

  list: (callback) =>
    @tempDao.list(callback)

  create: (degrees) =>
    @tempDao.create(degrees)
    @socket.broadcast
      action: 'temp'
      temp: degrees

  current: (callback) =>
    @tempDao.current(callback)

module.exports = TempManager
