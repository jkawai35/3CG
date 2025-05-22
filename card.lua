require("vector")

CardPrototype = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

-- Constructor for basic card prototype
-- TODO: Add text parameter
function CardPrototype:new(name, text, pow, cost, front, ability)
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
  card.hasAbility = ability
  
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
  self.power = self.power + amount
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
WoodenCowPrototype = {} 

function WoodenCowPrototype:new()
  local card = CardPrototype:new(
    "Wooden Cow",
    "It's a cow made of wood",
    1,
    1,
    love.graphics.newImage("assets/WoodenCow.png")
  )
    
  return card
end

PegasusPrototype = {}

function PegasusPrototype:new()
  local card = CardPrototype:new(
    "Pegasus",
    "Faster than you think",
    3,
    5,
    love.graphics.newImage("assets/Pegasus.png"),
    false
  )
  
  return card
end

MinotaurPrototype = {}

function MinotaurPrototype:new()
  local card = CardPrototype:new(
    "Minataur",
    "Don't mess with a minotaur",
    5,
    9,
    love.graphics.newImage("assets/Minotaur.png"),
    false
  )
  
  return card
end



TitanPrototype = {}

function TitanPrototype:new()
  local card = CardPrototype:new(
    "Titan",
    "A fierce warrior indeed",
    6,
    12,
    love.graphics.newImage("assets/Titan.png"),
    false
  )
  
  return card
end

ZeusPrototype = {}

function ZeusPrototype:new()
  local card = CardPrototype:new(
    "Zeus",
    "When revealed: Lower the power of each card in your opponenet's hand by 1",
    12,
    25,
    love.graphics.newImage("assets/Zeus.png"),
    true
  )
  
  function card:ability(board)
    board.opp.hand:changePilePower(-1)
  end
    
  return card
end

AresPrototype = {}

function AresPrototype:new()
  local card = CardPrototype:new(
    "Ares",
    "When Revealed: Gain +2 power for each enemy card here",
    9,
    14,
    love.graphics.newImage("assets/Ares.png"),
    true
  )
  
  function card:ability(board)
    local pile = board.oppLocations[self.pileLocation]
    self.power = self.power + (2 * pile:length())
  end
    
  return card
end

ArtemisPrototype = {}

function ArtemisPrototype:new()
  local card = CardPrototype:new(
    "Artemis",
    "When Revealed: Gain +5 power if there is exactly one enemy card here",
    8,
    12,
    love.graphics.newImage("assets/Artemis.png"),
    true
  )

  function card:ability(board)
    if board.oppLocations[self.pileLocation]:length() == 1 then
      self.power = self.power + 5
    end
  end
    
  return card
end

HeraPrototype = {}

function HeraPrototype:new()
  local card = CardPrototype:new(
    "Hera",
    "When Revealed: Give cards in your hand +1 power",
    9,
    16,
    love.graphics.newImage("assets/Hera.png"),
    true
  )

  function card:ability(board)
    board.yourHand:changePilePower(1)
  end
    
  return card
end

DemeterPrototype = {}

function DemeterPrototype:new()
  local card = CardPrototype:new(
    "Demeter",
    "When Revealed: Both players draw a card",
    5,
    14,
    love.graphics.newImage("assets/Demeter.png"),
    true
  )
  
  function card:ability(board)
    print("here")
    board:deal(board.player)
    board:deal(board.opp)
  end
    
  return card
end

HadesPrototype = {}

function HadesPrototype:new()
  local card = CardPrototype:new(
    "Hades",
    "When Revealed: Gain +2 power for each card in your discard pile",
    9,
    12,
    love.graphics.newImage("assets/Hades.png"),
    true
  )
  
  function card:ability(board)
    board.yourHand:changePilePower(1)
  end
    
  return card
end

HerculesPrototype = {}

function HerculesPrototype:new()
  local card = CardPrototype:new(
    "Hercules",
    "When Revealed: Doubles its power if its the strongest card here",
    10,
    12,
    love.graphics.newImage("assets/Hercules.png"),
    true
  )
  
  function card:ability(board)
    board.yourHand:changePilePower(1)
  end
    
  return card
end

DionysusPrototype = {}

function DionysusPrototype:new()
  local card = CardPrototype:new(
    "Dionysus",
    "When Revealed: Gain +2 power for each of your other cards here.",
    8,
    14,
    love.graphics.newImage("assets/Dionysus.png"),
    true
  )

  function card:ability(board)
    board.yourHand:changePilePower(1)
  end
    
  return card
end

ApolloPrototype = {}

function ApolloPrototype:new()
  local card = CardPrototype:new(
    "Apollo",
    "When Revealed: Gain +1 mana next turn",
    7,
    14,
    love.graphics.newImage("assets/Apollo.png"),
    true
  )

  function card:ability(board)
    board.yourHand:changePilePower(1)
  end
    
  return card
end


HephaestusPrototype = {}

function HephaestusPrototype:new()
  local card = CardPrototype:new(
    "Hephaestus",
    "When Revealed: Lower the cost of 2 cards in your hand by 1",
    5,
    12,
    love.graphics.newImage("assets/Hephaestus.png"),
    true
  )
  
  function card:ability(board)
    board.yourHand:changePilePower(1)
  end
    
  return card
end

