_ = require('underscore')

class KegManager

  constructor: (@kegDao, @pourDao, @tempDao) ->

  list: (callback) =>
    @kegDao.list(callback)

  create: (keg, callback) =>
    @kegDao.create(keg, callback)

  get: (kegId, callback) =>
    @kegDao.get(kegId, callback)

  current: (callback) =>
    @kegDao.current (keg) =>
      @tempDao.current (temp) =>
        keg.temp = temp.degrees

        @pourDao.list keg.id, (pours) ->
          keg.consumed = 0
          for pour in pours
            keg.consumed += pour.volume
          keg.consumed = keg.consumed
          keg.lastPour = _.last(pours).start

          callback(keg)


module.exports = KegManager
