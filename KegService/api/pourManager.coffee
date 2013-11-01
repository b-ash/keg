_ = require('underscore')

class PourManager

  constructor: (@pourDao, @socket) ->

  create: (volume, callback) ->
    @pourDao.create(volume, callback)
    @socket.broadcast {action: 'pour-end'}

  update: (id, params, callback) ->
    @pourDao.update(id, params, callback)

  pour: (volume) ->
    @socket.broadcast
      action: 'pour'
      amount: volume

  get: (id, callback) ->
    @pourDao.get id, callback

  list: (callback, options) ->
    @pourDao.list callback, options

  listMissed: (callback, options) ->
    @pourDao.listMissed callback, options

  listByDrinkers: (callback) ->
    @pourDao.listByDrinkers callback

  getByDrinker: (drinkerId, callback) ->
    @pourDao.getByDrinker drinkerId, callback

  daily: (callback) ->
    @pourDao.daily(callback)

  weekly: (callback) ->
    @pourDao.weekly(callback)

  setDrinkerForLastPour: (drinkerId, callback) ->
    @pourDao.setDrinkerForLastPour drinkerId, (result) ->
      callback {success: result.affectedRows is 1}

module.exports = PourManager
