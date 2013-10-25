Dao = require('./dao')

class DrinkerDao extends Dao
  table: 'drinkers'
  fields: ['id', 'name']

  requestDrink: (drinkerId, callback) =>
    @runner('UPDATE drinking set drinkerId = ? WHERE drinkerId IS NULL', [drinkerId], callback)

  endDrink: (drinkerId, callback) =>
    @runner('UPDATE drinking set drinkerId = NULL WHERE drinkerId = ?', [drinkerId], callback)


module.exports = DrinkerDao
