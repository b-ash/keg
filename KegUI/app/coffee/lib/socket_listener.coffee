PourDialog = require('coffee/views/pour_dialog')


class SocketListener

  url: '/socket'

  listen: =>
    @sock = new SockJS(@url)

    @sock.onopen = @onOpen
    @sock.onmessage = @onMessage
    @sock.onclose = @onClose
    @

  showDialog: =>
    @pourDialog?.close()
    @pourDialog = new PourDialog().render()
    @

  onOpen: ->
    console.log 'Socket is open.'

  onMessage: (e) =>
    unless @pourDialog?
      @showDialog()

    message = JSON.parse(e.data)

    if message.action is 'done'
      @pourComplete()
    else if message.action is 'pouring'
      @pourDialog.updatePour message.amount
    else
      console.error 'Bad message from socket:', message.action

  onClose: (e) =>
    console.error 'Socket was closed.', e.reason

  pourComplete: =>
    @pourDialog.showPourComplete()

    setTimeout =>
      @pourDialog.close()
    , 2000


module.exports = SocketListener
