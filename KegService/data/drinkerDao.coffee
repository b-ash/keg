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

  getBarTabs: (callback) =>
    @runner("""
      SELECT d.name, SUM(k.price / k.volume * p.volume) dollars
      FROM pours p
      JOIN drinkers d ON p.drinkerId = d.id
      JOIN kegs k ON p.kegId = k.id
      WHERE p.drinkerId IS NOT NULL
      GROUP BY p.drinkerId
      ORDER BY dollars DESC
    """, [], callback)

  ###
  Most ounces in a 4 hour span
  ###
  getRagingDrinks: (callback) ->
    @runner("""
      SELECT d.name, MAX(volume) ounces
      FROM (
        SELECT a.drinkerId, a.id, a.start, SUM(b.volume) volume
        FROM pours a
        JOIN pours b ON a.drinkerId = b.drinkerId AND TIMESTAMPDIFF(MINUTE, b.start, a.start) BETWEEN 0 AND 240
        GROUP BY 1,2,3
      ) c
      JOIN drinkers d
        ON drinkerId = d.id
      GROUP BY d.name
      ORDER BY ounces DESC
      LIMIT 5;
    """, [], callback)


module.exports = DrinkerDao
