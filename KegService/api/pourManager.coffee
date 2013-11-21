_ = require('underscore')

class PourManager

  constructor: (@pourDao, @kegDao, @socket) ->

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

  leaderboard: (callback) ->
    @pourDao.listByKegByDrinker (pours) =>
      @kegDao.current (currentKeg) =>
        sumOfKegIds = _.reduce [1...currentKeg.id + 1], (memo, id) ->
          (memo + id)
        , 0

        drinkers = {}
        for drinkerByKeg in pours
          drinkers[drinkerByKeg.drinkerId] ?=
            name: drinkerByKeg.drinkerName
            weightedPours: 0

          drinkers[drinkerByKeg.drinkerId].weightedPours += (drinkerByKeg.volume * drinkerByKeg.kegId)

        response = for id, drinker of drinkers
          volume: (drinker.weightedPours / sumOfKegIds)
          drinkerName: drinker.name

        response = _.sortBy response, (drinker) ->
          drinker.volume * -1

        callback response

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
