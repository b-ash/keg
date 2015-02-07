###
Steps:
      - don't require selection when clicking drink
      - don't require selection when clicking claim
###

View = require('coffee/views/view')
SelectDrinkerDialog = require('coffee/views/select_drinker_dialog')

$ = jQuery

class RegisterRemoteView extends View

  className: 'register-form'
  template: require('html/register_remote')

  events:
    'submit form': 'registerDevice'

  initialize: ->
    @options.deferredDrinkers.then (@drinkers) =>

  getRenderData: =>
    interactive: @options.admin or app.remote

  postRender: ->
    @hideError()

  registerDevice: (e) ->
    e.preventDefault()
    @hideError()

    remoteCode = @$('#remote-code').val()

    unless remoteCode
      return @showError('You need to enter a code.')

    $.ajax
      type: 'POST'
      url: '/api/interactive'
      contentType: 'application/json'
      dataType: 'json'
      data: JSON.stringify {remote: remoteCode}
      success: ({remote}) =>
        if remote
          @remoteCode = remoteCode
          @promptToChooseDrinker()
        else
          @showError('That code wasn\'t correct.')
      error: =>
        @showError('There was an issue verifying your code.')

  promptToChooseDrinker: ->
    new SelectDrinkerDialog({
      collection: @drinkers
      successCallback: @registerRemote
    }).render()

  registerRemote: (drinkerId) =>
    remote =
      remoteCode: @remoteCode
      drinker: @drinkers.get(drinkerId).toJSON()

    try
      app.setRemote(remote)
    catch e
      @showError('Couldn\'t save drinker info.')

  showError: (msg) ->
    @$('#error').text(msg).show()

  hideError: ->
    @$('#error').hide()


module.exports = RegisterRemoteView
