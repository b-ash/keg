class KegDao

  constructor: (@runner) ->

  list: (callback) =>
    @runner('SELECT kegs.id, name, url FROM kegs LEFT JOIN banners ON banners.id = bannerId', [], callback)

  create: (keg) =>
    @runner('INSERT INTO kegs SET ?', [keg])

  get: (id, callback) =>
    @runner('SELECT kegs.id, name, volume, tapped, kicked, url FROM kegs LEFT JOIN banners ON banners.id = bannerId WHERE kegs.id = ?', [id], callback, true)

  current: (callback) =>
    @runner('SELECT kegs.id, name, volume, tapped, kicked, url FROM kegs LEFT JOIN banners ON banners.id = bannerId WHERE kegs.id = (SELECT MAX(id) FROM kegs)', [], callback, true)

module.exports = KegDao
