View = require('coffee/views/view')


class CreateDrinkerDialog extends View
  template: require('html/create_drinker_dialog')
  events:
    'click button': 'createDrinker'
    'keyup #name': 'checkSubmit'

  render: =>
    super
    vex.open {content: @$el}
    @

  checkSubmit: (event) =>
    if event.keyCode is 13
      @createDrinker()

  createDrinker: =>
    name = @$('#name').val()
    @collection.create {name},
      success: =>
        @options.successCallback()
        @close()
      error: =>
        @$el.html '<h3>Something went wrong...</h3>'
        setTimeout @close, 1500

  close: =>
    vex.close()


module.exports = CreateDrinkerDialog
