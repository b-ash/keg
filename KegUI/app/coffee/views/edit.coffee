View = require('coffee/views/view')


class EditView extends View

  className: 'row jumbotron'
  template: require('html/edit')
  events:
    'submit form': 'edit'

  edit: (event) =>
    event.preventDefault()

    inputs = @$('form input')

    data = {}

    for input in inputs
      $input = $(input)
      val = $input.val()

      if val.length
        data[$input.attr('name')] = val

    @model.save data
    app.router.navigate '#/simulate', {trigger: true}


module.exports = EditView
