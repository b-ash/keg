mysql = require('mysql')

class TempDao

  getConnection: ->
    @connection = mysql.createConnection({
      host: 'localhost'
      user: 'root'
      password: ''
      database: 'Kegums'
    })

  list: (callback) =>
    connection = @getConnection()
    connection.query('SELECT id, degrees, timestamp FROM temperature', (err, temps) ->
      throw err if err
      callback(temps)
    )
    connection.end()

  create: (degrees) =>
    connection = @getConnection()
    connection.query('INSERT INTO temperature SET degrees = ?', [degrees], (err, result) ->
      throw err if err
    )

    connection.end()

module.exports = TempDao
