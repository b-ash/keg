View = require('coffee/views/view')
DrinkersPours = require('coffee/collections/drinkers_pours')

class LeaderboardView extends View
  className: 'spanning-full table-view'
  template: require('html/leaderboard')

  initialize: ->
    @collection = new DrinkersPours

  getRenderData: ->
    drinkers: @collection.toJSON()

  afterRender: ->
    @$('.leaders span:first-child').html """<img src="/static/images/crown.png" />"""

  postRender: ->
    @collection.fetch().done(@render)


module.exports = LeaderboardView
