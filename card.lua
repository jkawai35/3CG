require("vector")

CardPrototype = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

-- Constructor for basic card prototype
-- TODO: Add text parameter
function CardPrototype:new(name, text, pow, cost, front)
  local card = {}
  local metadata = {__index = CardPrototype}
  setmetatable(card, metadata)
   
  card.name = name
  card.text = text
  card.power = pow
  card.cost = cost
  card.frontImage = front
  card.faceUp = true
  card.position = Vector(0, 0)
  card.state = CARD_STATE.IDLE
  card.prevPosition = Vector(0, 0)
  card.currentPile = nil
  card.prevPile = nil
  card.pileLocation = nil
  card.canMove = true
  
  return card
end

-- Drawing cards
function CardPrototype:draw(x,y)
  if self.faceUp then
    love.graphics.draw(self.frontImage, x, y)
  else
    return
  end
end

-- Flipping cards
function CardPrototype:flip()
  self.faceUp = not self.faceUp
end

function CardPrototype:changePower(amount)
  card.power = card.power + amount
end

function CardPrototype:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end
    
  local mousePos = grabber.currentMousePos

  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + 70 and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + 105
  
  if isMouseOver then
    self.state = CARD_STATE.MOUSE_OVER
  else
    self.state = CARD_STATE.IDLE
  end

end


-- CARD DEFINITIONS --
-- 70 x 105 --
WoodenCowPrototype = CardPrototype:new(
  "Wooden Cow",
  "It's a cow made of wood",
  1,
  1,
  love.graphics.newImage("assets/WoodenCow.png")
)

function WoodenCowPrototype:new()
  return WoodenCowPrototype
end

PegasusPrototype = CardPrototype:new(
  "Pegasus",
  "Faster than you think",
  3,
  5,
  love.graphics.newImage("assets/Pegasus.png")
)

function PegasusPrototype:new()
  return PegasusPrototype
end

MinotaurPrototype = CardPrototype:new(
  "Minataur",
  "Don't mess with a minotaur",
  5,
  9,
  love.graphics.newImage("assets/Minotaur.png")
)

function MinotaurPrototype:new()
  return MinotaurPrototype
end

TitanPrototype = CardPrototype:new(
  "Titan",
  "A fierce warrior indeed",
  6,
  12,
  love.graphics.newImage("assets/Titan.png")
)

function TitanPrototype:new()
  return TitanPrototype
end

ZeusPrototype = CardPrototype:new(
  "Zeus",
  "When revealed: Lower the power of each card in your opponenet's hand by 1",
  12,
  25,
  love.graphics.newImage("assets/Zeus.png")
)

function ZeusPrototype:new()
  function ZeusPrototype:ability(board)
    board.oppHand:changePilePower(-1)
  end
  
  return ZeusPrototype
end

AresPrototype = CardPrototype:new(
  "Ares",
  "When Revealed: Gain +2 power for each enemy card here",
  9,
  14,
  love.graphics.newImage("assets/Ares.png")
)

function AresPrototype:new()
  function AresPrototype:ability(board)
    local pile = board.oppLocations[self.pileLocation]
    self.power = self.power + (2 * pile:length())
  end
  
  return AresPrototype
end

ArtemisPrototype = CardPrototype:new(
  "Artemis",
  "When Revealed: Gain +5 power if there is exactly one enemy card here",
  8,
  12,
  love.graphics.newImage("assets/Artemis.png")
)

function ArtemisPrototype:new()
  function ArtemisPrototype:ability(board)
    if board.oppLocations[self.pileLocation]:length() == 1 then
      self.power = self.power + 5
    end
  end
  
  return ArtemisPrototype
end

HeraPrototype = CardPrototype:new(
  "Hera",
  "When Revealed: Give cards in your hand +1 power",
  9,
  16,
  love.graphics.newImage("assets/Hera.png")
)

function HeraPrototype:new()
  function HeraPrototype:ability(board)
    board.yourHand:changePilePower(1)
  end
  
  return HeraPrototype
end