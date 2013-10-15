KegDao = require('./kegDao')
kegDao = new KegDao


class KegManager

  constructor: (kegDao, pourDao) ->
    @kegDao = kegDao
    @pourDao = pourDao

  list: (callback) =>
    @kegDao.list(callback)

  create: (keg) =>
    @kegDao.create(keg)

  get: (kegId, callback) =>
    @kegDao.get(kegId, callback)

  current: (callback) =>
    @kegDao.current((keg) =>
      @pourDao.list(keg.id, (pours) =>
        keg.consumed = 0
        for pour in pours
          keg.consumed += pour.volume
        callback(keg)
      )
    )

module.exports = KegManager
