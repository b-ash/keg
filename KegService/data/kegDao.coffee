Dao = require('./dao')

class KegDao extends Dao
  table: 'kegs'
  fields: ['id', 'name', 'volume', 'tapped', 'kicked']

  update: (id, params, callback) =>
    @runner("UPDATE kegs SET ? WHERE id = #{id}", params, callback)

  list: (callback) =>
    @runner('SELECT id, name FROM kegs', [], callback)

  get: (id, callback) =>
    @runner('SELECT id, name, volume, tapped, kicked FROM kegs WHERE id = ?', [id], callback, true)

  current: (callback) =>
    @runner('SELECT id, name, volume, tapped, kicked FROM kegs WHERE id = (SELECT MAX(id) FROM kegs)', [], callback, true)


module.exports = KegDao
