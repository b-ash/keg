View = require('coffee/views/view')
LeaderboardDrinkers = require('coffee/collections/leaderboard_drinkers')

class LeaderboardView extends View
  className: 'table-view'
  template: require('html/leaderboard')

  initialize: ->
    @collection = new LeaderboardDrinkers

  getRenderData: ->
    drinkers: @collection.toJSON()

  afterRender: ->
    @$('.leaders span:first-child').html """<img src="/static/images/crown.png" />"""

  postRender: ->
    @collection.fetch().done(@render)


module.exports = LeaderboardView
