Dao = require('./dao')

class TempDao extends Dao
  table: 'temperature'
  fields: ['id', 'degrees', 'timestamp']

  list: (callback, options={}) =>
    sql = 'SELECT id, degrees, timestamp FROM temperature'
    args = []

    if options.start and options.end
      sql += ' WHERE timestamp BETWEEN ? and ?'
      args.push options.start
      args.push options.end

    @runner(sql, args, callback)

  current: (callback) =>
    @runner('SELECT id, degrees, timestamp FROM temperature WHERE id = (SELECT MAX(id) FROM temperature)', [], callback, true)

module.exports = TempDao
