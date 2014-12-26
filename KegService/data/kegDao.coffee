Dao = require('./dao')

class KegDao extends Dao
  table: 'kegs'
  fields: ['id', 'name', 'volume', 'tapped', 'kicked', 'price']
  selectSQL: 'SELECT id, name, volume, tapped, kicked, price FROM kegs'

  update: (id, params, callback) =>
    @runner("UPDATE kegs SET ? WHERE id = #{id}", params, callback)

  list: (callback) =>
    @runner(@selectSQL, [], callback)

  get: (id, callback) =>
    @runner("#{@selectSQL} WHERE id = ?", [id], callback, true)

  current: (callback) =>
    @runner("#{@selectSQL} WHERE id = (SELECT MAX(id) FROM kegs)", [], callback, true)

  recent: (callback) =>
    @runner('SELECT name FROM kegs WHERE kicked IS NOT NULL ORDER BY kicked ASC', [], callback)

  getAverageTimeToKick: (callback) =>
    @runner('SELECT ROUND(AVG(TIME_TO_SEC(TIMEDIFF(kicked, tapped))) / 60 / 60 / 24, 2) time FROM kegs WHERE kicked IS NOT NULL', [], callback, true)

module.exports = KegDao
