class View extends Backbone.View

  getRenderData: ->

  render: =>
    @$el.html @template @getRenderData()
    @afterRender()
    @

  afterRender: ->

  routeEvent: (event) =>
    $link = $ event.target
    url = $link.attr('href')

    if $link.attr('target') is '_blank' or
       typeof url is 'undefined' or
       url.substr(0, 4) is 'http' or
       url is '' or
       url is 'javascript:void(0)'
      return true

    event.preventDefault()

    if $link.hasClass('dont-route')
      return true
    else
      @routeLink url

  routeLink: (url) =>
    app.router.navigate url, {trigger: true}
    @trigger('routed')

  close: =>
    @remove()
    @onClose?()



module.exports = View
