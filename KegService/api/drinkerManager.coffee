class DrinkerManager

  constructor: (@drinkerDao, @socket) ->

  get: (id, callback) =>
    @drinkerDao.get(id, callback)

  list: (callback) =>
    @drinkerDao.list(callback)

  create: (name, callback) =>
    @drinkerDao.create({name}, callback)

  getDrinking: (callback) =>
    @drinkerDao.getDrinking (result) ->
      callback(result or {})

  requestDrink: (drinkerId, callback) =>
    @drinkerDao.requestDrink drinkerId, (result) ->
      callback {success: result.affectedRows is 1}

  endDrink: (drinkerId, callback) =>
    @drinkerDao.endDrink drinkerId, callback

module.exports = DrinkerManager
