require("vector")

CardPrototype = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

-- Constructor for basic card prototype
function CardPrototype:new(name, pow, cost, front)
  local card = {}
  local metadata = {__index = CardPrototype}
  setmetatable(card, metadata)
   
  card.name = name
  card.power = pow
  card.cost = cost
  card.frontImage = front
  card.faceUp = true
  card.position = Vector(0, 0)
  card.state = CARD_STATE.IDLE
  card.prevPosition = Vector(0, 0)
  card.currentPile = nil
  card.prevPile = nil
  
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
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

-- CARD DEFINITIONS --
-- 70 x 105 --
WoodenCowPrototype = CardPrototype:new(
  "Wooden Cow",
  1,
  1,
  love.graphics.newImage("assets/WoodenCow.png")
)

function WoodenCowPrototype:new()
  return WoodenCowPrototype
end

PegasusPrototype = CardPrototype:new(
  "Pegasus",
  3,
  5,
  love.graphics.newImage("assets/Pegasus.png")
)

function PegasusPrototype:new()
  return PegasusPrototype
end

MinotaurPrototype = CardPrototype:new(
  "Minataur",
  5,
  9,
  love.graphics.newImage("assets/Minotaur.png")
)

function MinotaurPrototype:new()
  return MinotaurPrototype
end

TitanPrototype = CardPrototype:new(
  "Titan",
  6,
  12,
  love.graphics.newImage("assets/Titan.png")
)

function TitanPrototype:new()
  return TitanPrototype
end

ZeusPrototype = CardPrototype:new(
  "Zeus",
  12,
  25,
  love.graphics.newImage("assets/Zeus.png")
)

function ZeusPrototype:new()
  return ZeusPrototype
end

AresPrototype = CardPrototype:new(
  "Ares",
  9,
  14,
  love.graphics.newImage("assets/Ares.png")
)

function AresPrototype:new()
  return AresPrototype
end

ArtemisPrototype = CardPrototype:new(
  "Artemis",
  8,
  12,
  love.graphics.newImage("assets/Artemis.png")
)

function ArtemisPrototype:new()
  return ArtemisPrototype
end

HeraPrototype = CardPrototype:new(
  "Hera",
  9,
  16,
  love.graphics.newImage("assets/Hera.png")
)

function HeraPrototype:new()
  return HeraPrototype
end