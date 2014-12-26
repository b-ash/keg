mysql = require('mysql')

pool = mysql.createPool
  host: process.env.KEGUMS_HOST or 'localhost'
  user: process.env.KEGUMS_USER or 'root'
  password: process.env.KEGUMS_PASS or ''
  database: 'Kegums'
  connectionLimit: 10

executeQuery = (query, params=[], callback, singleResult=false) ->
  pool.getConnection (err, connection) ->
    if err
      console.log 'Error aquiring connection from pool'
      throw err

    console.log query
    connection.query query, params, (err, results) ->
      connection.release()

      if err
        console.log "Error running query `#{query}`"
        throw err

      if singleResult
        results = results[0]

      callback? results


module.exports = executeQuery
