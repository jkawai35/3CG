require("card")

Pile = {}
Pile.__index = Pile  -- If you meant to use Pile here, fix this line to: Pile.__index = Pile

function Pile:new(x, y, location, board)
  local pile = {}
  setmetatable(pile, Pile)

  pile.cards = {}
  pile.position = Vector(x or 0, y or 0)
  pile.width = (80 + 10) * 4 - 10 -- assuming 4 cards max with 10px spacing
  pile.height = 115
  pile.location = location
  pile.board = board

  return pile
end

function Pile:draw()
  love.graphics.setColor(1, 1, 1, 1)
  for i, card in ipairs(self.cards) do
    -- stack cards horizontally with spacing
    local offsetX = (90) * (i - 1)
    card:draw(self.position.x + offsetX, self.position.y)
  end
end

function Pile:length()
  return #self.cards
end

function Pile:reveal(board)
  local totalPower = 0
  for _, card in ipairs(self.cards) do
    totalPower = totalPower + card.power
    
    if card.ability then
      card:ability(board)
    end
    
    card.canMove = false
  end
  return totalPower
end

-- NEW: check if a point is within the pile bounds
function Pile:contains(x, y)
  return (
    x >= self.position.x and
    x <= self.position.x + self.width and
    y >= self.position.y and
    y <= self.position.y + self.height
  )
end

function Pile:addCard(card)
  -- Remove from previous pile if any
  if card.currentPile and card.currentPile ~= self then
    card.currentPile:removeCard(card)
  end

  -- Add to this pile
  table.insert(self.cards, card)
  card.position = Vector(self:getCardPosition(#self.cards))
  card.currentPile = self -- 🔹 Set this as the current pile
  card.prevPile = self

  return true
end

function Pile:removeCard(card)
  for i, c in ipairs(self.cards) do
    if c == card then
      table.remove(self.cards, i)
      break
    end
  end

  -- Recalculate positions for remaining cards
  for i, c in ipairs(self.cards) do
    local x, y = self:getCardPosition(i)
    c.position.x = x
    c.position.y = y
  end
end


function Pile:getCardPosition(index)
  local spacing = 90
  return self.position.x + (index - 1) * spacing, self.position.y
end

function Pile:changePilePower(amount)
  for _, card in self.cards do
    card:changePower(amount)
  end
end

function Pile:checkDuplicates(table, value)
  for _, card in ipairs(self.cards) do
    if card and card.name == value then
      return true
    end
    
    return false
  end
end

function Pile:pickRandom(cards)
  local picked = {}
  local index = love.math.random(1, #self.cards)

  for i = 1, cards do
    while self:checkDuplicates(picked, self.cards[index].name) do
      index = love.math.random(1, #self.cards)
    end
    
    table.insert(picked, self.cards[index])
  end
  
  return picked
end
