Dao = require('./dao')

class DrinkerDao extends Dao
  table: 'drinkers'
  fields: ['id', 'name']

  create: (obj, callback) =>
    createdCallback = =>
      @runner("SELECT id, name FROM #{@table} ORDER BY id DESC LIMIT 1", [], callback, true)

    super(obj, createdCallback)

  getDrinking: (callback) =>
    @runner("SELECT drinkerId as id, name FROM drinking LEFT JOIN drinkers ON drinkerId = drinkers.id WHERE drinkerId IS NOT NULL", [], callback, true)

  requestDrink: (drinkerId, callback) =>
    @runner('UPDATE drinking set drinkerId = ? WHERE drinkerId IS NULL', [drinkerId], callback)

  endDrink: (drinkerId, callback) =>
    @runner('UPDATE drinking set drinkerId = NULL WHERE drinkerId = ?', [drinkerId], callback)

  removeDrinker: (drinkerId, callback) =>
    @runner("DELETE FROM #{@table} WHERE id = ?", [drinkerId], callback)


module.exports = DrinkerDao
