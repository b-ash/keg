class TempDao

  constructor: (@runner) ->

  list: (callback) =>
    @runner('SELECT id, degrees, timestamp FROM temperature', [], callback)

  create: (degrees, callback) =>
    @runner('INSERT INTO temperature SET degrees = ?', [degrees], callback)

  current: (callback) =>
    @runner('SELECT id, degrees, timestamp FROM temperature WHERE id = (SELECT MAX(id) FROM temperature)', [], callback, true)

module.exports = TempDao
