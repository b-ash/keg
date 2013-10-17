mysql = require('mysql')

class KegDao

  getConnection: ->
    @connection = mysql.createConnection({
      host: 'localhost'
      user: 'root'
      password: ''
      database: 'Kegums'
    })

  list: (callback) =>
    connection = @getConnection()
    connection.query('SELECT kegs.id, name, url FROM kegs LEFT JOIN banners ON banners.id = bannerId', (err, rows, fields) ->
      throw err if err
      callback(rows)
    )
    connection.end()

  create: (keg) =>
    connection = @getConnection()
    connection.query('INSERT INTO kegs SET ?', [keg], (err, result) ->
      throw err if err
    )
    connection.end()

  get: (id, callback) =>
    connection = @getConnection()
    connection.query('SELECT kegs.id, name, volume, tapped, kicked, url FROM kegs LEFT JOIN banners ON banners.id = bannerId WHERE kegs.id = ?', [id], (err, keg, fields) ->
      throw err if err
      callback(keg[0])
    )
    connection.end()

  current: (callback) =>
    connection = @getConnection()
    connection.query('SELECT kegs.id, name, volume, tapped, kicked, url FROM kegs LEFT JOIN banners ON banners.id = bannerId WHERE kegs.id = (SELECT MAX(id) FROM kegs)', (err, keg, fields) ->
      throw err if err
      callback(keg[0])
    )
    connection.end()

module.exports = KegDao
