Dao = require('./dao')

class DrinkerDao extends Dao
  table: 'drinkers'
  fields: ['id', 'name']

  create: (obj, callback) =>
    createdCallback = =>
      @runner("SELECT id, name FROM #{@table} ORDER BY id DESC LIMIT 1", [], callback, true)

    super(obj, createdCallback)


  requestDrink: (drinkerId, callback) =>
    @runner('UPDATE drinking set drinkerId = ? WHERE drinkerId IS NULL', [drinkerId], callback)

  endDrink: (drinkerId, callback) =>
    @runner('UPDATE drinking set drinkerId = NULL WHERE drinkerId = ?', [drinkerId], callback)


module.exports = DrinkerDao
