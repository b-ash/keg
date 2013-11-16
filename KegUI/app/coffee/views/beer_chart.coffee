BEERS_IN_KEG = 55

class BeerChartView extends Backbone.View

  className: 'beer-chart'
  el: '.daily-row'

  chart: ->
    @svg = d3.select(@el)
      .append('svg')
      .attr('width', @$el.width())
      .attr('height', @$el.height())

    @svgWidth = @$el.width() * 0.9
    @svgHeight = @$el.height() * 0.9

    @main = @svg.append('g')

    @createGraph()

  getRandomBeerType: ->
    number = ~~(Math.random() * 4) + 1
    "/static/images/beer#{number}.png"

  createText: (group, count, column) ->
    group.append('text')
      .attr('x', column * @beerWidth)
      .attr('y', @svgHeight)
      .attr('dy', 20)
      .attr('text-anchor', 'middle')
      .text(count)

  createBeerImage: (group, row, column) ->
    x = column * @beerWidth
    y = @svgHeight - row * @beerHeight - @beerHeight
    g = group.append('g').attr('transform', 'translate(' + x + ',' + y + ')')
    g.append('image')
      .attr('xlink:href', '/static/images/beer.png')
      .attr('width', @beerWidth)
      .attr('height', @beerHeight)

  createKegImage: (group, row, column) ->
    x = column * @beerWidth
    y = @svgHeight - row * @beerHeight - @beerHeight * 2
    g = group.append('g').attr('transform', 'translate(' + x + ',' + y + ')')
    g.append('image')
      .attr('xlink:href', "/static/images/keg.png")
      .attr('width', @beerWidth * 2)
      .attr('height', @beerHeight * 2)

  createGraph: ->
    @main.empty()

    data = @collection.toJSON()

    if not data
      return

    _.map(data, (point) ->
      point.volume = Math.ceil(point.volume / 12)  # 12oz per beer
    )

    max = d3.max(data, (point) ->
      point.volume % BEERS_IN_KEG
    )

    beersWide = Math.ceil(Math.min(Math.ceil(max), 6))

    if beersWide % 2 is 1
      beersWide++

    beersTall = d3.max(data, (point) ->
      Math.ceil((point.volume % BEERS_IN_KEG) / beersWide)
    )

    @beerHeight = Math.min(@svgHeight / beersTall, @svgWidth / ((beersWide + 2) * data.length) * 1.8, 149)
    @beerWidth = @beerHeight / 149 * 91

    @svgHeight = (beersTall + 3) * @beerHeight + 50
    @svg.attr('height', @svgHeight * 1.2)

    for group in [0 .. data.length]
      g = @main.append('g')
      point = data[group]
      if point
        count = point.volume
        row = 0
        rows = 1
        column = group * (beersWide + 2)
        if count > 0
          while count > 0
            if count >= BEERS_IN_KEG
              rows = 2
              @createKegImage(g, row, column)

              column += 2
              count -= BEERS_IN_KEG

            else
              @createBeerImage(g, row, column)
              count -= 1

              if count >= 1 and rows is 2
                @createBeerImage(g, row + 1, column)
                count -= 1

              column += 1

            if column >= group * (beersWide + 2) + beersWide
              column = group * (beersWide + 2)
              row += rows
              rows = 1

        if @options.type is 'weekly'
          date = moment().isoWeek(point.start).format('MMM D')
        else
          date = moment().dayOfYear(point.start).format('MMM D')

        @createText(g, date, group * (beersWide + 2) + beersWide / 2)

module.exports = BeerChartView
