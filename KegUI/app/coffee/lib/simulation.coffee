class Simulation

  running: false
  timeout: 3000
  pourMessages: [0.6, 0.9, 1.4, 1.8, 2.1, 2.7, 3.2, 3.8, 4.4, 5.0, 5.2, 5.8, 6.4, 6.8, 7.3, 7.9, 8.4, 8.8, 9.3, 9.9, 10.5, 11, 11.8, 12.4, 'done']

  start: =>
    return if @running

    @running = true

    setTimeout ->
      window.app.model.set
        lastPour: '10/2/12'
        totalPours: 15.2
        poursLeft: 35.8
        keg: 'Shock Top Pumpkin Wheat'
        bannerImage: 'shocktop_pumpkin.png'
    , @timeout

    @timeout += 1000

    simulate = (amt) =>
      if amt is 'done'
        msg = {action: 'done'}
        wait = 1500
        last = true
      else
        msg = {action: 'pouring', amount: amt}
        wait = 150
        last = false

      @timeout += wait

      setTimeout =>
        window.app.socket.onMessage {data: JSON.stringify msg}
        @running = not last
      , @timeout

    simulate(amount) for amount in @pourMessages


module.exports = new Simulation
