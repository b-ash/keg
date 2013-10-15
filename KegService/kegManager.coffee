KegDao = require('./kegDao')
kegDao = new KegDao


class KegManager

  list: (callback) ->
    kegDao.list(callback)

  create: (keg) ->
    kegDao.create(keg)

  get: (kegId, callback) ->
    kegDao.get(kegId, callback)

  current: (callback) ->
    kegDao.current(callback)

module.exports = KegManager
