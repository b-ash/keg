class Nav

  constructor: ->
    @start()

  start: ->
    $(document).delegate '.nav li a', 'click', (event) ->
      event.preventDefault()

      $target = $(event.currentTarget)
      name = $target.attr('href')

      $.scrollTo """a[name="#{name.slice(1)}"]""",
        duration: 500
        onAfter: ->
          window.location.hash = name


module.exports = Nav
