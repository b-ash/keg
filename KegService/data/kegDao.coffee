Dao = require('./dao')

class KegDao extends Dao
  table: 'kegs'
  fields: ['id', 'name', 'volume', 'tapped', 'kicked', 'bannerId']

  update: (id, params, callback) =>
    @runner("UPDATE kegs SET ? WHERE id = #{id}", params, callback)

  list: (callback) =>
    @runner('SELECT kegs.id, name, url FROM kegs LEFT JOIN banners ON banners.id = bannerId', [], callback)

  get: (id, callback) =>
    @runner('SELECT kegs.id, name, volume, tapped, kicked, url FROM kegs LEFT JOIN banners ON banners.id = bannerId WHERE kegs.id = ?', [id], callback, true)

  current: (callback) =>
    @runner('SELECT kegs.id, name, volume, tapped, kicked, url FROM kegs LEFT JOIN banners ON banners.id = bannerId WHERE kegs.id = (SELECT MAX(id) FROM kegs)', [], callback, true)

module.exports = KegDao
