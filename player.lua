require("card")

Player = {}
Player.__index = Deck


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
