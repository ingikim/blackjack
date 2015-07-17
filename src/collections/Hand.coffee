class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())
    if @minScore() > 21
      if @isDealer
        alert 'Dealer bust'
      else
        alert 'Player bust'
        @trigger 'gameover'

  stand: ->
    @trigger 'stand'

  dealerTurn: ->
    @at(0).flip()
    score = @bestScore()
    while score < 17
      @hit()
      score = @bestScore()

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1 and card.get('revealed') is true
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]

  bestScore: ->
    if @scores()[1] > 21 then @scores()[0] else @scores()[1]

