_ = require('underscore')

class Dao

  constructor: (@runner) ->

  get: (id, callback) =>
    @runner("SELECT #{@fields.join(', ')} FROM #{@table} WHERE id = ?", [id], callback, true)

  list: (callback, options={}) =>
    sql = "SELECT #{@fields.join(', ')} FROM #{@table}"

    if options.whereRaw?
      sql += " WHERE #{options.whereRaw}"
    else if options.where?
      sql += ' WHERE ?'
      params = options.where

    if options.groupBy?
      sql += " GROUP BY #{options.groupBy}"

    if options.orderBy?
      sql += " ORDER BY #{options.orderBy}"

    @runner(sql, params ? {}, callback)

  create: (obj, callback) =>
    @runner("INSERT INTO #{@table} SET ?", _.pick(obj, @fields), callback)

  update: (id, obj, callback) =>
    @runner("UPDATE #{@table} SET ? WHERE id = #{id}", _.pick(obj, @updateFields ? @fields), callback)


module.exports = Dao
