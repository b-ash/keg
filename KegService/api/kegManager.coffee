_ = require('underscore')

class KegManager

  constructor: (@kegDao, @pourDao, @tempDao) ->

  create: (keg, callback) =>
    keg.kicked = keg.kicked or null
    @kegDao.create(keg, callback)

  get: (kegId, callback) =>
    @kegDao.get(kegId, callback)

  update: (kegId, params, callback) =>
    @kegDao.update(kegId, params, callback)

  list: (callback) =>
    @kegDao.list(callback)

  current: (callback) =>
    @kegDao.current (keg) =>
      @tempDao.current (temp) =>
        keg.temp = temp?.degrees

        @pourDao.list (pours) ->
          keg.lastPour = _.last(pours)?.start
          keg.consumed = 0

          for pour in pours
            keg.consumed += pour.volume

          callback(keg)
        , {
          where:
            kegId: keg.id
        }


module.exports = KegManager
