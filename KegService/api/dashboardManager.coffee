Q = require('q')
_ = require('underscore')


class DashboardManager

  constructor: (@drinkerDao, @kegDao, @pourDao) ->

  getStats: (callback) ->
    ragingDrinks = Q.defer()
    @drinkerDao.getRagingDrinks _.bind(ragingDrinks.resolve, ragingDrinks)

    kickTime = Q.defer()
    @kegDao.getAverageTimeToKick _.bind(kickTime.resolve, kickTime)

    recent = Q.defer()
    @kegDao.recent _.bind(recent.resolve, recent)

    tabs = Q.defer()
    @drinkerDao.getBarTabs _.bind(tabs.resolve, tabs)

    lonely = Q.defer()
    @pourDao.getLonelyCount _.bind(lonely.resolve, lonely)

    Q.all([
      ragingDrinks.promise
      kickTime.promise
      recent.promise
      tabs.promise
      lonely.promise
    ]).spread (rd, kt, r, t, l) ->
      callback
        ragingDrinkers: rd
        avgKickTimeDays: kt.time
        recentKegs: r
        barTabs: t
        unclaimedPours: l.count

module.exports = DashboardManager
