mysql = require('mysql')

class PourDao

  getConnection: ->
    @connection = mysql.createConnection({
      host: 'localhost'
      user: 'root'
      password: ''
      database: 'Kegums'
    })

  list: (kegId, callback) =>
    connection = @getConnection()
    connection.query('SELECT id, volume, start, end FROM pours WHERE kegId = ?', [kegId], (err, rows, fields) ->
      throw err if err
      callback(rows)
    )
    connection.end()

  create: (volume) =>
    connection = @getConnection()
    connection.query('INSERT INTO pours SET kegId = (SELECT max(id) FROM kegs), volume = ?', [volume], (err, result) ->
      throw err if err
    )
    connection.end()

  get: (pourId, callback) =>
    connection = @getConnection()
    connection.query('SELECT id, kegId, volume, start, end FROM pours WHERE id = ?', [pourId], (err, pour) ->
      throw err if err
      callback(pour)
    )
    connection.end()

module.exports = PourDao
