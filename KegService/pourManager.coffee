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

  create: (request, response) ->
    pourDao.create(request.body.volume)
    @_broadcast JSON.stringify({ounces: request.body.volume})

    response.send(201)

  list: (request, response) ->
    pourDao.list(request.params.kegId, (pours) ->
      response.json(pours)
    )

  get: (request, response) ->
    pourDao.get(request.params.pourId, (pour) ->
      response.json(pour)
    )


module.exports = PourManager
