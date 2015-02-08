View = require('coffee/views/view')


class UnregisterRemoteView extends View

  template: require('html/unregister_remote')
  events:
    'click #unregister': 'unregister'

  unregister: ->
    app.removeRemote()


module.exports = UnregisterRemoteView
