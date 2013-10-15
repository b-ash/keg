SockJS = require('sockjs')

PourDao = require('./pourDao')
pourDao = new PourDao


class PourManager

  clients: {}

  constructor: (app) ->
    @server = SockJS.createServer()
    @server.installHandlers app, {prefix: "/io"}
    @server.on 'connection', (conn) =>
      console.log 'Receiving socket connection'
      @clients[conn.id] = conn

      setTimeout =>
        @_broadcast {ounces: 400}
      , 2000

      conn.on 'close', =>
        console.log 'Closing socket connection'
        delete @clients[conn.id]

  _broadcast: (data) =>
    for id, client of @clients when @clients.hasOwnProperty(id)
      client.write JSON.stringify(data)

  create: (volume) ->
    pourDao.create(volume)
    @_broadcast JSON.stringify({ounces: volume})

  list: (kegId, callback) ->
    pourDao.list(kegId, callback)

  get: (pourId, callback) ->
    pourDao.get(pourId, callback)

module.exports = PourManager
