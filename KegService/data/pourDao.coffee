Dao = require('./dao')
_ = require('underscore')

fields = ['id', 'kegId', 'volume', 'start', 'drinkerId']

class PourDao extends Dao
  table: 'pours'
  fields: fields
  updateFields: _.without(fields, 'start')

  create: (volume, callback) =>
    @runner('INSERT INTO pours SET kegId = (SELECT max(id) FROM kegs), volume = ?', [volume], callback)

  daily: (callback) =>
    @runner('SELECT start, sum(volume) as volume FROM pours GROUP BY DAY(start) ORDER BY start DESC LIMIT 7', [], callback)

  weekly: (callback) =>
    @runner('SELECT start, sum(volume) as volume FROM pours GROUP BY WEEK(start) ORDER BY start DESC LIMIT 7', [], callback)

  setDrinkerForLastPour: (drinkerId, callback) =>
    @runner('UPDATE pours SET drinkerId = ? WHERE drinkerId IS NULL ORDER BY id DESC LIMIT 1', [drinkerId], callback)

  listByKegByDrinker: (callback) =>
    @runner("""
      SELECT SUM(p.volume) AS volume, p.drinkerId AS drinkerId, d.name AS drinkerName, k.id AS kegId
      FROM pours p, kegs k, drinkers d
      WHERE p.drinkerId = d.id
        AND p.drinkerid IS NOT NULL
        AND p.kegId = k.id
        AND k.id > (SELECT MAX(id) FROM kegs ORDER BY id DESC) - 3
      GROUP BY drinkerId, k.id
    """, [], callback)

  listMissed: (callback) =>
    @list callback,
      whereRaw: 'drinkerId IS NULL AND kegId = (SELECT max(id) FROM kegs) AND start > NOW() - INTERVAL 2 DAY'
      orderBy: 'id DESC'

  getByDrinker: (drinkerId, callback) =>
    @runner('SELECT kegId, sum(volume) AS volume, count(*) as pours, drinkerId FROM pours WHERE drinkerId = ?', [drinkerId], callback, true)

  removeDrinker: (drinkerId, callback) =>
    @runner('UPDATE pours SET drinkerId = NULL WHERE drinkerId = ?', [drinkerId], callback)

  getLonelyCount: (callback) =>
    @runner('SELECT count(*) count FROM pours WHERE drinkerId IS NULL', [], callback, true)

module.exports = PourDao
