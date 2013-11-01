express = require('express')
_ = require('underscore')
moment = require('moment')
dbRunner = require('./mysql_runner')
server = express()
server.use(express.bodyParser())

app = require('http').createServer(server)

Socket = require('./socket')
socket = new Socket(app)

TempDao = require('./data/tempDao')
tempDao = new TempDao(dbRunner)

TempManager = require('./api/tempManager')
tempManager = new TempManager(tempDao, socket)

KegDao = require('./data/kegDao')
kegDao = new KegDao(dbRunner)

PourDao = require('./data/pourDao')
pourDao = new PourDao(dbRunner)

KegManager = require('./api/kegManager')
kegManager = new KegManager(kegDao, pourDao, tempDao)

PourManager = require('./api/pourManager')
pourManager = new PourManager(pourDao, socket)

DrinkerDao = require('./data/drinkerDao')
drinkerDao = new DrinkerDao(dbRunner)

DrinkerManager = require('./api/drinkerManager')
drinkerManager = new DrinkerManager(drinkerDao)

BannerDao = require('./data/bannerDao')
bannerDao = new BannerDao(dbRunner)

base = '/api'

###
Keg routes
###
server.get(base + '/kegs', (request, response) ->
  kegManager.list _.bind(response.json, response)
)

server.post(base + '/kegs', (request, response) ->
  kegManager.create(request.body, ->
    kegManager.current _.bind(response.json, response)
  )
)

server.get(base + '/kegs/current', (request, response) ->
  kegManager.current _.bind(response.json, response)
)

server.get(base + '/kegs/:kegId', (request, response) ->
  kegManager.get request.params.kegId, _.bind(response.json, response)
)

server.put(base + '/kegs/:kegId', (request, response) ->
  kegManager.update request.params.kegId, request.body, ->
    kegManager.current _.bind(response.json, response)
)

###
Pour routes
###
server.get(base + '/pours', (request, response) ->
  pourManager.list _.bind(response.json, response)
)

server.post(base + '/pours', (request, response) ->
  pourManager.pour(request.body.volume)
  response.send(204)
)

server.post(base + '/pour-end', (request, response) ->
  pourManager.create(request.body.volume, ->
    response.send(201)
  )
)

server.get(base + '/pours/missed', (request, response) ->
  pourManager.listMissed _.bind(response.json, response)
)

server.post(base + '/drinkers/:drinkerId/poured', (request, response) ->
  pourManager.setDrinkerForLastPour request.params.drinkerId, (results) ->
    if results.success
      response.send(200)
    else
      response.send(400)
)

server.get(base + '/drinkers/pours', (request, response) ->
  pourManager.listByDrinkers _.bind(response.json, response)
)

server.get(base + '/drinkers/:drinkerId/pours', (request, response) ->
  pourManager.getByDrinker request.params.drinkerId, _.bind(response.json, response)
)

server.get(base + '/kegs/:kegId/pours', (request, response) ->
  pourManager.list _.bind(response.json, response), {
    where:
      kegId: request.params.kegId
  }
)

server.get(base + '/pours/daily', (request, response) ->
  pourManager.daily((pours) ->
    response.json(_.map(pours.reverse(), (obj) ->
      obj.start = moment(obj.start).format('DDD')
      obj
    ))
  )
)

server.get(base + '/pours/weekly', (request, response) ->
  pourManager.weekly((pours) ->
    response.json(_.map(pours.reverse(), (obj) ->
      obj.start = moment(obj.start).format('w')
      obj
    ))
  )
)

###
Banner routes
###
server.get(base + '/banners', (request, response) ->
  bannerDao.list _.bind(response.json, response)
)

server.post(base + '/banners', (request, response) ->
  bannerDao.create(request.body.url, ->
    response.send(201)
  )
)

###
Temp routes
###
server.get(base + '/temps', (request, response) ->
  tempManager.list request.query, _.bind(response.json, response)
)

server.post(base + '/temps', (request, response) ->
  tempManager.create(request.body.degrees, ->
    response.send(204)
  )
)

###
Drinker routes
###
server.get(base + '/drinkers', (request, response) ->
  drinkerManager.list _.bind(response.json, response)
)

server.post(base + '/drinkers', (request, response) ->
  drinkerManager.create request.body.name, _.bind(response.json, response)
)

server.post(base + '/drinkers/:drinkerId/request-drink', (request, response) ->
  drinkerManager.requestDrink request.params.drinkerId, (resp) ->
    if resp.success
      response.send(200)
    else
      response.send(400)
)

server.post(base + '/drinkers/:drinkerId/end-drink', (request, response) ->
  drinkerManager.endDrink request.params.drinkerId, ->
    response.send(200)
)

server.get(base + '/drinking', (request, response) ->
  drinkerManager.getDrinking _.bind(response.json, response)
)

app.listen(8000)
console.log 'Server listening on port 8000'
