Banners = require('coffee/collections/banners')
View = require('coffee/views/view')


class AdminView extends View
  template: require('html/admin')
  events:
    'submit #create_form': 'create'
    'submit #edit_form': 'edit'
    'click h3[data-toggle]': 'toggle'
    'click #drinkers tr.clickable': 'removeDrinker'

  initialize: ->
    @promise = @options.deferredDrinkers

  deferredRender: (cb) ->
    @promise.then (@drinkers) =>
      cb()

  getRenderData: ->
    drinkers: @drinkers.toJSON()
    keg: @model.toJSON()

  afterRender: ->
    @$('.toggling').hide()

  create: (event) =>
    event.preventDefault()
    @model.clear()
    @model.id = null
    @_saveForm @$('#create_form input')

  edit: (event) =>
    @_saveForm @$('#edit_form input')

  _saveForm: ($inputs) =>
    event.preventDefault()

    data = {}

    for input in $inputs
      $input = $(input)
      val = $input.val()

      if val.length
        data[$input.attr('name')] = val

    @model.save data,
      wait: true
      success: ->
        app.router.navigate '#/', {trigger: true}

  toggle: (event) =>
    id = $(event.currentTarget).data('toggle')
    $el = @$("##{id}")

    if $el.is(':hidden')
      $el.show()
    else
      $el.hide()

  removeDrinker: (event) ->
    $target = $(event.currentTarget)
    id = $target.attr('id')

    vex.dialog.confirm
      message: 'You sure? This can\'t be undone.'
      callback: (value) =>
        return unless value

        @drinkers.get(id).destroy
          success: ->
            $target.remove()
          error: ->
            vex.dialog.alert('Didn\'t work.')


module.exports = AdminView
