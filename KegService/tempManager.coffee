TempDao = require('./tempDao')
tempDao = new TempDao

class TempManager

  constructor: (tempDao) ->
    @tempDao = tempDao

  list: (callback) =>
    @tempDao.list(callback)

  create: (degrees) =>
    @tempDao.create(degrees)

module.exports = TempManager
