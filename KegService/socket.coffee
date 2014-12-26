SockJS = require('sockjs')

class Socket
  clients: {}

  constructor: (app) ->
    if process.env.KEGUMS_ENV is 'local'
      return

    @server = SockJS.createServer {sockjs_url: "http://cdn.sockjs.org/sockjs-0.3.min.js"}
    @server.installHandlers app, {prefix: "/io"}
    @server.on 'connection', (conn) =>
      console.log 'Receiving socket connection'
      @clients[conn.id] = conn

      conn.on 'close', =>
        console.log 'Closing socket connection'
        delete @clients[conn.id]

  broadcast: (data) =>
    for id, client of @clients when @clients.hasOwnProperty(id)
      client.write JSON.stringify(data)


module.exports = Socket
