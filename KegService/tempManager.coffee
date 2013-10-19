class TempManager

  constructor: (@tempDao, @socket) ->

  list: (callback) =>
    @tempDao.list(callback)

  create: (degrees, callback) =>
    @tempDao.create(degrees, callback)
    @socket.broadcast
      action: 'temp'
      temp: degrees

  current: (callback) =>
    @tempDao.current(callback)

module.exports = TempManager
