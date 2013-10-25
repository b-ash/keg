Dao = require('./dao')

class BannerDao extends Dao
  table: 'banners'
  fields: ['id', 'url']


module.exports = BannerDao
