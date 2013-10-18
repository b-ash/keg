class PourDao

  constructor: (@runner) ->

  list: (kegId, callback) =>
    @runner('SELECT id, volume, start, end FROM pours WHERE kegId = ?', [kegId], callback)

  create: (volume) =>
    @runner('INSERT INTO pours SET kegId = (SELECT max(id) FROM kegs), volume = ?', [volume])

  get: (pourId, callback) =>
    @runner('SELECT id, kegId, volume, start, end FROM pours WHERE id = ?', [pourId], callback, true)

  daily: (callback) =>
    @runner('SELECT start, sum(volume) as volume FROM pours GROUP BY DAY(start) ORDER BY start DESC LIMIT 7', [], callback)

  weekly: (callback) =>
    @runner('SELECT start, sum(volume) as volume FROM pours GROUP BY WEEK(start) ORDER BY start DESC LIMIT 7', [], callback)


module.exports = PourDao
