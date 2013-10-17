PourDao = require('./pourDao')
pourDao = new PourDao


class PourManager

  constructor: (@socket) ->

  create: (volume) ->
    pourDao.create(volume)
    @socket.broadcast {action: 'pour-end'}

  pour: (volume) ->
    @socket.broadcast
      action: 'pour'
      amount: volume

  list: (kegId, callback) ->
    pourDao.list(kegId, callback)

  get: (pourId, callback) ->
    pourDao.get(pourId, callback)

  daily: (callback) ->
    pourDao.daily(callback)

  weekly: (callback) ->
    pourDao.weekly(callback)

module.exports = PourManager
