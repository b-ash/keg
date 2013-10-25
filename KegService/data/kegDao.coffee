Dao = require('./dao')

class KegDao extends Dao
  table: 'keg'
  fields: ['id', 'name', 'volume', 'tapped', 'kicked', 'bannerId']

  list: (callback) =>
    @runner('SELECT kegs.id, name, url FROM kegs LEFT JOIN banners ON banners.id = bannerId', [], callback)

  get: (id, callback) =>
    @runner('SELECT kegs.id, name, volume, tapped, kicked, url FROM kegs LEFT JOIN banners ON banners.id = bannerId WHERE kegs.id = ?', [id], callback, true)

  current: (callback) =>
    @runner('SELECT kegs.id, name, volume, tapped, kicked, url FROM kegs LEFT JOIN banners ON banners.id = bannerId WHERE kegs.id = (SELECT MAX(id) FROM kegs)', [], callback, true)

module.exports = KegDao
