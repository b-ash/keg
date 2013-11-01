Banners = require('coffee/collections/banners')
View = require('coffee/views/view')


class AdminView extends View

  className: 'row jumbotron'
  template: require('html/admin')
  events:
    'submit #create_form': 'create'
    'submit #edit_form': 'edit'
    'click h3[data-toggle]': 'toggle'

  initialize: ->
    @banners = new Banners
    @promise = @banners.fetch()

  deferredRender: (cb) ->
    if @promise.state() is 'pending'
      @promise.then cb
    else
      cb()

  getRenderData: ->
    banners: @banners.toJSON()
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


module.exports = AdminView
