require("card")

Player = {}
Player.__index = Player


-- Deck constructor for create a new deck object
function Player:new(deck)
  local player = {}
  setmetatable(player, Player)
  
  player.hand = {}
  player.mana = 1
  player.deck = deck
  player.locations = {}
  player.piles = {}
  player.score = 0
  
  
  return player
end

function Player:takeTurn(board)
  print("Opp taking turn")
  
  local hand = self.hand.cards
  if #hand == 0 then
    print("AI has no cards to play.")
    return
  end

  -- Pick a random card
  local cardIndex = love.math.random(1, #hand)
  local card = hand[cardIndex]

  -- Pick a random pile to play to (0-based or 1-based depending on your setup)
  local locationIndex = love.math.random(1, #board.opp.locations)
  local targetPile = board.opp.locations[locationIndex]

  -- Place card in the pile
  self.hand:removeCard(card)
  targetPile:addCard(card)
  card.currentPile = targetPile
  card.pileLocation = locationIndex

  print("AI played " .. card.name .. " to location " .. locationIndex)
  
end

