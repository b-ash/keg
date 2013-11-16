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

  listByDrinkers: (callback) =>
    @runner('SELECT kegId, sum(volume) AS volume, count(*) as pours, drinkerId, name as drinkerName FROM pours LEFT JOIN drinkers ON drinkers.id = drinkerId WHERE drinkerId IS NOT NULL AND kegId = (SELECT max(id) FROM kegs) GROUP BY drinkerId ORDER BY volume DESC', [], callback)

  listMissed: (callback) =>
    @list callback,
      whereRaw: 'drinkerId IS NULL AND kegId = (SELECT max(id) FROM kegs)'
      orderBy: 'id DESC'

  getByDrinker: (drinkerId, callback) =>
    @runner('SELECT kegId, sum(volume) AS volume, count(*) as pours, drinkerId FROM pours WHERE drinkerId = ?', [drinkerId], callback, true)


module.exports = PourDao
