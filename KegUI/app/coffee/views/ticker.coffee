class TickerView extends Backbone.View

  className: 'ticker'
  template: require('html/ticker')

  speed: 30
  alph: 'ABCDEFGHIJKLMNOPQRSTUVXYZ01234567890/.'

  initialize: (options={}) =>
    unless @model? and options.field? and options.length?
      throw Error('Tickers need a model, a field to listen to, and a desired length')

    @model.on "change:#{options.field}", @setTickerFields

  getRenderData: =>
    {fieldLetters: @getLettersForField()}

  render: =>
    @$el.html @template @getRenderData()
    @afterRender()
    @

  afterRender: =>
    letterElements = @$('span')
    alphabet = @alph.split('')
    alphabetLength = alphabet.length
    timeout = 0

    letterElements.each (i, el) =>
      $el = $(el)
      index = Math.floor(Math.random() * alphabetLength)

      setTimeout =>
        tid = setInterval =>
          l = $el.attr('letter')
          currentL = alphabet[index]

          if l is currentL
            $el.text l
            clearInterval(tid)
          else if l is 'empty'
            $el.html '&nbsp;'
            clearInterval(tid)
          else
            $el.text currentL
            index = if index is alphabet.length - 1 then 0 else (index + 1)

        , @speed
      , timeout

      timeout += 50

  setTickerFields: =>
    fieldLetters = @getLettersForField()
    letterElements = @$('span')

    for letter, i in fieldLetters
      if letter is '&nbsp;'
        letter = 'empty'

      $(letterElements.get(i)).attr('letter', letter)

  getLettersForField: (placeholder='&nbsp;') =>
    val = @model.get(@options.field)

    unless val?
      return (placeholder for i in [0...@options.length])

    fieldLetters = ('' + val).split('')

    if fieldLetters.length < @options.length
      fillLetters = (placeholder for i in [0...@options.length - fieldLetters.length])
      fillLetters.push.apply fillLetters, fieldLetters
      fieldLetters = fillLetters

    return fieldLetters


module.exports = TickerView