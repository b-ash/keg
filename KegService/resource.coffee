express = require('express')
server = express()
server.use(express.bodyParser())

KegDao = require('./kegDao')
kegDao = new KegDao

PourManager = require('./pourManager')
pourManager = new PourManager(server)

BannerDao = require('./bannerDao')
bannerDao = new BannerDao

server.get('/', (request, response) ->
  kegDao.list((kegs)->
    response.json(kegs)
  )
)

server.post('/', (request, response) ->
  kegDao.create(request.body)
  response.send(201)
)

server.get('/current', (request, response) ->
  kegDao.current((keg) ->
    response.json(keg)
  )
)

server.get('/:kegId', (request, response) ->
  kegDao.get(request.params.kegId, (keg) ->
    response.json(keg)
  )
)

server.post('/pour', (request, response) ->
  pourManager.create(request.body.volume)
  response.send(201)
)

server.get('/:kegId/pours', (request, response) ->
  pourManager.list(request.params.kegId, (pours) ->
    response.json(pours)
  )
)

server.get('/:kegId/pours/:pourId', (request, response) ->
  pourManager.get(request.params.pourId, (pour) ->
    response.josn(pour)
  )
)

server.get('/banners', (request, response) ->
  bannerDao.list((banners) ->
    response.json(banners)
  )
)

server.post('/banners', (request, response) ->
  bannerDao.create(request.body.url)
  response.send(201)
)

server.listen(8888)
