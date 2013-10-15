mysql = require('mysql')

class BannerDao

  getConnection: ->
    @connection = mysql.createConnection({
      host: 'localhost'
      user: 'root'
      password: ''
      database: 'Kegums'
    })

  list: (callback) =>
    connection = @getConnection()
    connection.query('SELECT id, url FROM banners', (err, rows, fields) ->
      throw err if err
      callback(rows)
    )
    connection.end()

  create: (url, volume) =>
    connection = @getConnection()
    connection.query('INSERT INTO banners SET ?', { url: url}, (err, result) ->
      throw err if err
    )
    connection.end()

  get: (id, callback) =>
    connection = @getConnection()
    connection.query('SELECT id, url FROM banners WHERE id = ?', [pourId], (err, result) ->
      throw err if err
      callback(result)
    )
    connection.end()

module.exports = BannerDao
