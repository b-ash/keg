BEERS_IN_KEG = 41

class BeerChartView extends Backbone.View

  className: 'chart'
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
    # group.append('text')
    #   .attr('x', column * @beerWidth)
    #   .attr('y', @svgHeight)
    #   .attr('text-anchor', 'middle')
    #   .text(count)

  createBeerImage: (group, row, column) ->
    x = column * @beerWidth
    y = @svgHeight - row * @beerHeight - @beerHeight
    g = group.append('g').attr('transform', 'translate(' + x + ',' + y + ')')
    g.append('image')
      .attr('xlink:href', @getRandomBeerType())
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

    data = _.pluck(@collection.toJSON(), 'volume')

    if not data
      return

    max = d3.max(data, (n) ->
      n % BEERS_IN_KEG
    )

    beersWide = Math.ceil(Math.min(Math.ceil(max), 6))

    if beersWide % 2 is 1
      beersWide++

    max = Math.ceil(max / beersWide)

    @beerHeight = Math.min(@svgHeight / max / 2, @svgWidth / ((beersWide + 2) * data.length * 23) * 60, 60)
    @beerWidth = @beerHeight / 60 * 25

    for group in [0 .. data.length]
      g = @main.append('g')
      count = data[group] / 16  # 16oz per beer
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

      @createText(g, data[group], group * (beersWide + 2) + beersWide / 2)

module.exports = BeerChartView
