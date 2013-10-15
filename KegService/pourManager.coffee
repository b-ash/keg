SockJS = require('sockjs')

PourDao = require('./pourDao')
pourDao = new PourDao


class PourManager

  clients: {}

  constructor: (app) ->
    @server = SockJS.createServer()
    @server.installHandlers app, {prefix: "/io"}
    @server.on 'connection', (conn) =>
        @clients[conn.id] = conn

        conn.on 'close', =>
            delete @clients[conn.id]

  _broadcast: (data) ->
    for id, client of clients when clients.hasOwnProperty(id)
      client.write JSON.stringify(data)

  create: (volume) ->
    pourDao.create(volume)
    @_broadcast JSON.stringify({ounces: volume})

  list: (kegId, callback) ->
    pourDao.list(kegId, callback)

  get: (pourId, callback) ->
    pourDao.get(pourId, callback)

module.exports = PourManager
