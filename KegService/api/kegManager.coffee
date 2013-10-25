_ = require('underscore')

class KegManager

  constructor: (@kegDao, @pourDao, @tempDao) ->

  create: (keg, callback) =>
    @kegDao.create(keg, callback)

  get: (kegId, callback) =>
    @kegDao.get(kegId, callback)

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
