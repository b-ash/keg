PourDialog = require('coffee/views/pour_dialog')


class SocketListener

  url: '/io'

  constructor: (@model) ->
    @pourDialog = new PourDialog()

  listen: =>
    @sock = new SockJS(@url)

    @sock.onopen = @onOpen
    @sock.onmessage = @onMessage
    @sock.onclose = @onClose
    @

  showDialog: =>
    @pourDialog.close()
    @pourDialog.render()
    @

  onOpen: ->
    console.log 'Socket is open.'

  onMessage: (e) =>
    message = JSON.parse(e.data)

    if @pourDialog.$el.is(':hidden') and message.action in ['pour', 'pour-end']
      @showDialog()

    if message.action is 'pour-end'
      @pourComplete()
    else if message.action is 'pour'
      @pourDialog.updatePour message.amount
    else if message.action is 'temp'
      @model.set('temp', message.temp)
    else
      console.error 'Bad message from socket:', message.action

  onClose: (e) =>
    console.error 'Socket was closed.', e.reason

  pourComplete: =>
    @pourDialog.showPourComplete()

    setTimeout =>
      @pourDialog.close()
      @model.fetch()
    , 2000


module.exports = SocketListener
