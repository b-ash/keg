Dao = require('./dao')

class PourDao extends Dao
  table: 'pours'
  fields: ['id', 'kegId', 'volume', 'start', 'drinkerId']

  create: (volume, callback) =>
    console.log "Inserting pour with volume #{volume}"
    @runner('INSERT INTO pours SET kegId = (SELECT max(id) FROM kegs), volume = ?', [volume], callback)

  daily: (callback) =>
    @runner('SELECT start, sum(volume) as volume FROM pours GROUP BY DAY(start) ORDER BY start DESC LIMIT 7', [], callback)

  weekly: (callback) =>
    @runner('SELECT start, sum(volume) as volume FROM pours GROUP BY WEEK(start) ORDER BY start DESC LIMIT 7', [], callback)

  setDrinkerForLastPour: (drinkerId, callback) =>
    @runner('UPDATE pours SET drinkerId = ? where drinkerId IS NULL ORDER BY id DESC LIMIT 1', [drinkerId], callback)

  listByDrinkers: (callback) =>
    @runner('SELECT kegId, sum(volume) AS volume, drinkerId, name as drinkerName FROM pours LEFT JOIN drinkers ON drinkers.id = drinkerId GROUP BY drinkerId ORDER BY volume DESC', [], callback)

  getByDrinker: (drinkerId, callback) =>
    @runner('SELECT kegId, sum(volume) AS volume, drinkerId FROM pours where drinkerId = ?', [drinkerId], callback, true)


module.exports = PourDao
