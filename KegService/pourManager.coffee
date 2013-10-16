SockJS = require('sockjs')

PourDao = require('./pourDao')
pourDao = new PourDao


class PourManager

  clients: {}

  constructor: (app) ->
    @server = SockJS.createServer {sockjs_url: "http://cdn.sockjs.org/sockjs-0.3.min.js"}
    @server.installHandlers app, {prefix: "/io"}
    @server.on 'connection', (conn) =>
      console.log 'Receiving socket connection'
      @clients[conn.id] = conn

      conn.on 'close', =>
        console.log 'Closing socket connection'
        delete @clients[conn.id]

  _broadcast: (data) =>
    for id, client of @clients when @clients.hasOwnProperty(id)
      client.write JSON.stringify(data)

  create: (volume) ->
    pourDao.create(volume)
    @_broadcast {action: 'done'}

  pour: (volume) ->
    @_broadcast
      action: 'pouring'
      amount: volume

  list: (kegId, callback) ->
    pourDao.list(kegId, callback)

  get: (pourId, callback) ->
    pourDao.get(pourId, callback)

  daily: (callback) ->
    pourDao.daily(callback)

  weekly: (callback) ->
    pourDao.weekly(callback)

module.exports = PourManager
