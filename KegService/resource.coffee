express = require('express')
_ = require('underscore')
moment = require('moment')
server = express()
server.use(express.bodyParser())

app = require('http').createServer(server)

KegDao = require('./kegDao')
kegDao = new KegDao

PourDao = require('./pourDao')
pourDao = new PourDao

KegManager = require('./kegManager')
kegManager = new KegManager(kegDao, pourDao)

PourManager = require('./pourManager')
pourManager = new PourManager(app)

BannerDao = require('./bannerDao')
bannerDao = new BannerDao

TempDao = require('./tempDao')
tempDao = new TempDao

TempManager = require('./tempManager')
tempManager = new TempManager(tempDao)

base = "/api";

server.get(base + '/kegs', (request, response) ->
  kegManager.list((kegs) ->
    response.json(kegs)
  )
)

server.post(base + '/kegs', (request, response) ->
  kegManager.create(request.body)
  response.send(201)
)

server.get(base + '/current', (request, response) ->
  kegManager.current((keg) ->
    response.json(keg)
  )
)

server.get(base + '/kegs/:kegId', (request, response) ->
  kegManager.get(request.params.kegId, (keg) ->
    response.json(keg)
  )
)

server.post(base + '/pours', (request, response) ->
  pourManager.pour(request.body.volume)
  response.send(204)
)

server.post(base + '/pour-end', (request, response) ->
  pourManager.create(request.body.volume)
  response.send(201)
)

server.get(base + '/kegs/:kegId/pours', (request, response) ->
  pourManager.list(request.params.kegId, (pours) ->
    response.json(pours)
  )
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

server.get(base + '/kegs/:kegId/pours/:pourId', (request, response) ->
  pourManager.get(request.params.pourId, (pour) ->
    response.json(pour)
  )
)

server.get(base + '/banners', (request, response) ->
  bannerDao.list((banners) ->
    response.json(banners)
  )
)

server.post(base + '/banners', (request, response) ->
  bannerDao.create(request.body.url)
  response.send(201)
)

server.get(base + '/temps', (request, response) ->
  tempManager.list((temps) ->
    response.json(temps)
  )
)

server.post(base + '/temps', (request, response) ->
  tempManager.create(request.body.degrees)
  response.send(204)
)

app.listen(8000)
console.log 'Server listening on port 8000'
