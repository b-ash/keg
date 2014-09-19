Dao = require('./dao')

class KegDao extends Dao
  table: 'kegs'
  fields: ['id', 'name', 'volume', 'tapped', 'kicked', 'price']

  update: (id, params, callback) =>
    @runner("UPDATE kegs SET ? WHERE id = #{id}", params, callback)

  list: (callback) =>
    @runner('SELECT id, name FROM kegs', [], callback)

  get: (id, callback) =>
    @runner('SELECT id, name, volume, tapped, kicked, price FROM kegs WHERE id = ?', [id], callback, true)

  current: (callback) =>
    @runner('SELECT id, name, volume, tapped, kicked, price FROM kegs WHERE id = (SELECT MAX(id) FROM kegs)', [], callback, true)

  recent: (callback) =>
    @runner('SELECT id, name FROM kegs WHERE kicked IS NOT NULL ORDER BY kicked ASC LIMIT 3', [], callback, true)

  getAverageTimeToKick: (callback) =>
    @runner('SELECT AVG(TIME_TO_SEC(TIMEDIFF(kicked, tapped))) avgKickSeconds FROM kegs WHERE kicked IS NOT NULL', [], callback)

module.exports = KegDao
