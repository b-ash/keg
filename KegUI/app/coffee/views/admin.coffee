Globals = require('coffee/lib/globals')
View = require('coffee/views/view')
KegSizes = require('html/admin_keg_sizes')

Handlebars.registerPartial 'kegSizes', KegSizes


class AdminView extends View
  template: require('html/admin')
  events:
    'submit #create_form': 'create'
    'submit #edit_form': 'edit'
    'click h3[data-toggle]': 'toggle'
    'click #drinkers tr.clickable': 'removeDrinker'
    'click #kick': 'kickKeg'

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
    @_saveForm @$('#create_form')

  edit: (event) =>
    @_saveForm @$('#edit_form')

  _saveForm: ($parent) =>
    event.preventDefault()
    $inputs = $parent.find('input,select')

    data = {}

    for input in $inputs
      $input = $(input)
      data[$input.attr('name')] = $input.val()

    for dateProp in ['tapped', 'kicked']
      date = data[dateProp]
      if date
        data[dateProp] = moment.utc(date, 'MM/DD/YYYY').format(Globals.apiTimeFormat)

    @model.save data,
      wait: true
      success: ->
        app.router.navigate '#/', {trigger: true}

  toggle: (event) =>
    id = $(event.currentTarget).data('toggle')
    $el = @$("##{id}")

    if $el.is(':hidden')
      $el.show()
      $el.siblings().filter(".toggling").hide()
      @["toggle_#{id}"]?($el)
    else
      $el.hide()

  toggle_edit_form: ($el) ->
    $el.find(':selected').removeAttr('selected')
    $el.find("""option[value="#{@model.get('volume')}"]""").attr('selected', 'selected')

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

  kickKeg: ->
    @model.kick()


module.exports = AdminView
