require("card")

Deck = {}
Deck.__index = Deck

io.stdout:setvbuf("no")


-- Deck constructor for create a new deck object
function Deck:new()
  local deck = {}
  setmetatable(deck, Deck)
  deck.cards = {}
  
  deck:addCard(WoodenCowPrototype:new())
  deck:addCard(PegasusPrototype:new())
  deck:addCard(MinotaurPrototype:new())
  deck:addCard(TitanPrototype:new())
  deck:addCard(ZeusPrototype:new())
  deck:addCard(AresPrototype:new())
  deck:addCard(ArtemisPrototype:new())
  deck:addCard(HeraPrototype:new())
  
  return deck
end

-- Shuffling the deck
function Deck:shuffle()
  for i = #self.cards, 2, -1 do
    local j = love.math.random(1, i)
    self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
  end
end

-- Adding cards to deck
function Deck:addCard(card)
  table.insert(self.cards, card)
end

