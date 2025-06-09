require("card")

Player = {}
Player.__index = Player


-- Deck constructor for creating a new deck object
function Player:new(deck)
  local player = {}
  setmetatable(player, Player)
  
  player.hand = {}
  player.mana = 1
  player.deck = deck
  player.locations = {}
  player.piles = {}
  player.discard = {}
  player.score = 0
  player.apollo = false
  
  
  return player
end

function Player:takeTurn(board)
  local tries = 0
  
  local hand = self.hand.cards
  if #hand == 0 then
    return
  end

  -- Pick a random card
  ::tryAgain::

  if tries >= 4 then
    return
  end
  
  local cardIndex = love.math.random(1, #hand)
  local card = hand[cardIndex]
  
  -- Pick a random pile to play to (0-based or 1-based depending on your setup)
  local locationIndex = love.math.random(1, #board.opp.locations)
  local targetPile = board.opp.locations[locationIndex]
  
  tries = tries + 1

  -- Place card in the pile
  if (targetPile:length() < 4 and card.cost <= self.mana) then
    self.hand:removeCard(card)
    targetPile:addCard(card)
    card.currentPile = targetPile
    card.pileLocation = locationIndex
    self.mana = self.mana - card.cost
    card.faceUp = false
    table.insert(board.flippingPile, card)
    
    if (card.name == CARD_NAMES.APOLLO) then
      self.apollo = true
    end
  else
    goto tryAgain
  end
  
end

