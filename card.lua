require("vector")

CardPrototype = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2,
}

CARD_NAMES = {
  COW = "Wooden Cow",
  PEGASUS = "Pegasus",
  MINOTAUR = "Minotaur",
  TITAN = "Titan",
  ZEUS = "Zeus",
  ARES = "Ares",
  ARTEMIS = "Artemis",
  HERA = "Hera",
  DEMETER = "Demeter",
  HADES = "Hades",
  HERCULES = "Hercules",
  DIONYSUS = "Dionysus",
  APOLLO = "Apollo",
  HEPHAESTUS = "Heaphaestus"
}

-- Constructor for basic card prototype
function CardPrototype:new(name, text, cost, pow, front, ability)
  local card = {}
  local metadata = {__index = CardPrototype}
  setmetatable(card, metadata)
   
  card.name = name
  card.text = text
  card.power = pow
  card.cost = cost
  card.frontImage = front
  card.backImage = love.graphics.newImage("assets/Back.png")
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
    love.graphics.draw(self.backImage, x, y)
    return
  end
end

-- Flipping cards
function CardPrototype:flip()
  self.faceUp = not self.faceUp
end

-- Helper for changing card power
function CardPrototype:changePower(amount)
  self.power = self.power + amount
end

-- Check if mouse is over a card
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
  
  return isMouseOver

end


-- CARD DEFINITIONS --
-- 70 x 105 --
WoodenCowPrototype = {} 

function WoodenCowPrototype:new()
  local card = CardPrototype:new(
    CARD_NAMES.COW,
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
    CARD_NAMES.PEGASUS,
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
    CARD_NAMES.MINOTAUR,
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
    CARD_NAMES.TITAN,
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
    CARD_NAMES.ZEUS,
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
    CARD_NAMES.ARES,
    "When Revealed: Gain +2 power for each enemy card here",
    9,
    14,
    love.graphics.newImage("assets/Ares.png"),
    true
  )
  
  function card:ability(board)
    local pile = board.opp.locations[self.pileLocation]
    self.power = self.power + (2 * pile:length())
  end
    
  return card
end

ArtemisPrototype = {}

function ArtemisPrototype:new()
  local card = CardPrototype:new(
    CARD_NAMES.ARTEMIS,
    "When Revealed: Gain +5 power if there is exactly one enemy card here",
    8,
    12,
    love.graphics.newImage("assets/Artemis.png"),
    true
  )

  function card:ability(board)
    if board.opp.locations[self.pileLocation]:length() == 1 then
      self.power = self.power + 5
    end
  end
    
  return card
end

HeraPrototype = {}

function HeraPrototype:new()
  local card = CardPrototype:new(
    CARD_NAMES.HERA,
    "When Revealed: Give cards in your hand +1 power",
    9,
    16,
    love.graphics.newImage("assets/Hera.png"),
    true
  )

  function card:ability(board)
    board.player.hand:changePilePower(1)
  end
    
  return card
end

DemeterPrototype = {}

function DemeterPrototype:new()
  local card = CardPrototype:new(
    CARD_NAMES.DEMETER,
    "When Revealed: Both players draw a card",
    5,
    14,
    love.graphics.newImage("assets/Demeter.png"),
    true
  )
  
  function card:ability(board)
    board:deal(board.player, PLAYER_ENUM.PLAYER)
    board:deal(board.opp, PLAYER_ENUM.OPP)
  end
    
  return card
end

HadesPrototype = {}

function HadesPrototype:new()
  local card = CardPrototype:new(
    CARD_NAMES.HADES,
    "When Revealed: Gain +2 power for each card in your discard pile",
    9,
    12,
    love.graphics.newImage("assets/Hades.png"),
    true
  )
  
  function card:ability(board)
    self.power = self.power + (board.player.discard:length() * 2)
  end
    
  return card
end

HerculesPrototype = {}

function HerculesPrototype:new()
  local card = CardPrototype:new(
    CARD_NAMES.HERCULES,
    "When Revealed: Doubles its power if its the strongest card here",
    10,
    12,
    love.graphics.newImage("assets/Hercules.png"),
    true
  )
  
  function card:ability(board)
    local pile = board.player.locations[self.pileLocation]
    for _, card in ipairs(pile) do
      if card.power > self.power then
        return
      end
    end
    self.power = self.power * 2
  end
    
  return card
end

DionysusPrototype = {}

function DionysusPrototype:new()
  local card = CardPrototype:new(
    CARD_NAMES.DIONYSUS,
    "When Revealed: Gain +2 power for each of your other cards here.",
    8,
    14,
    love.graphics.newImage("assets/Dionysus.png"),
    true
  )

  function card:ability(board)
    self.power = self.power + ((board.player.locations[self.pileLocation]:length() - 1) * 2)
  end
    
  return card
end

ApolloPrototype = {}

function ApolloPrototype:new()
  local card = CardPrototype:new(
    CARD_NAMES.APOLLO,
    "When Revealed: Gain +1 mana next turn",
    7,
    14,
    love.graphics.newImage("assets/Apollo.png"),
    true
  )

  function card:ability(board)
    board.player.mana = board.player.mana + 1
  end
    
  return card
end


HephaestusPrototype = {}

function HephaestusPrototype:new()
  local card = CardPrototype:new(
    CARD_NAMES.HEPHAESTUS,
    "When Revealed: Lower the cost of 2 cards in your hand by 1",
    7,
    14,
    love.graphics.newImage("assets/Hephaestus.png"),
    true
  )
  
  function card:ability(board)
    local cards = board.player.hand:pickRandom(2)
    for _, card in ipairs(cards) do
      card.power = card.power - 1 or 0
    end
  end
    
  return card
end

