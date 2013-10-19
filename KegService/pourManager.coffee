class PourManager

  constructor: (@pourDao, @socket) ->

  create: (volume, callback) ->
    @pourDao.create(volume, callback)
    @socket.broadcast {action: 'pour-end'}

  pour: (volume) ->
    @socket.broadcast
      action: 'pour'
      amount: volume

  list: (kegId, callback) ->
    @pourDao.list(kegId, callback)

  get: (pourId, callback) ->
    @pourDao.get(pourId, callback)

  daily: (callback) ->
    @pourDao.daily(callback)

  weekly: (callback) ->
    @pourDao.weekly(callback)

module.exports = PourManager
