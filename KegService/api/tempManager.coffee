class TempManager

  constructor: (@tempDao, @socket) ->

  list: (options, callback) =>
    @tempDao.list(options, callback)

  create: (degrees, callback) =>
    @tempDao.create(degrees, callback)
    @socket.broadcast
      action: 'temp'
      temp: degrees

  current: (callback) =>
    @tempDao.current(callback)

module.exports = TempManager
