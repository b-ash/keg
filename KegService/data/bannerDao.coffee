class BannerDao

  constructor: (@runner) ->

  list: (callback) =>
    @runner('SELECT id, url FROM banners', [], callback)

  create: (url) =>
    @runner('INSERT INTO banners SET ?', {url: url})

  get: (id, callback) =>
    @runner('SELECT id, url FROM banners WHERE id = ?', [pourId], callback, true)

module.exports = BannerDao
