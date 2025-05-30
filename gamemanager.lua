require("player")
require("grabber")
require("board")

GameManager = {}
GameManager.__index = GameManager

io.stdout:setvbuf("no")


GAME_PHASE = {
  STAGING = "STAGING",
  REVEAL = "REVEAL",
  RESOLUTION = "RESOLUTION"
}


function GameManager:update(dt)
  self.hoveredCard = nil

  for _, card in ipairs(self:getAllCardsOnBoard()) do
    if card:checkForMouseOver(self.grabber) then
      self.hoveredCard = card
      break
    end
  end
  
end

function GameManager:new(board, grabber)
  local gm = setmetatable({}, GameManager)
  gm.board = board
  gm.phase = GAME_PHASE.STAGING
  gm.grabber = grabber
  gm.turn = 2
  gm.flipping = true
  gm.gameOver = false
  gm.winner = nil
  
  gm.locationPowers = {
    player = {},
    opp = {}
  }
  return gm
end

function GameManager:draw()
  
  if gameManager.gameOver then
    love.graphics.setColor(1, 1, 1, 1)
    local message = ""
    if gameManager.winner == PLAYER_ENUM.PLAYER then
      message = "You Win!"
    elseif gameManager.winner == PLAYER_ENUM.OPP then
      message = "Opponent Wins!"
    else
      message = "It's a Tie!"
    end
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.printf(message, 0, 300, love.graphics.getWidth(), "center")
    love.graphics.setFont(love.graphics.newFont(12))
  end
  
  if self.hoveredCard then
    local mx, my = love.mouse.getPosition()
    self:drawCardTooltip(self.hoveredCard, mx + 10, my + 10)
  end
  
  for i = 1, 3 do
    local loc = self.board.player.locations[i]
    local oppLoc = self.board.opp.locations[i]

    -- Player score
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
      tostring(self.locationPowers.player[i] or 0),
      loc.position.x,
      loc.position.y + 120
    )

    -- Opponent score
    love.graphics.print(
      tostring(self.locationPowers.opp[i] or 0),
      oppLoc.position.x,
      oppLoc.position.y - 30
    )
  end
end


function GameManager:submitPlay()  
  self.phase = GAME_PHASE.REVEAL
  
  self.board.opp:takeTurn(self.board)
  
  local playerAddScore = 0
  local oppAddScore = 0

  for i = 1, 3 do
    local yourPower = self.board.player.locations[i]:reveal(self.board)
    local oppPower = self.board.opp.locations[i]:reveal(self.board)
    
    local playerHasCards = self.board.player.locations[i]:length() > 0
    local oppHasCards = self.board.opp.locations[i]:length() > 0
    
    self.locationPowers.player[i] = yourPower
    self.locationPowers.opp[i] = oppPower

    if yourPower > oppPower and playerHasCards and oppHasCards then
      playerAddScore = playerAddScore + (yourPower - oppPower)
      oppAddScore = 0
      
      while #self.board.opp.locations[i].cards > 0 do
        local card = table.remove(self.board.opp.locations[i].cards)
        card.pileLocation = PILE_LOCATIONS.DISCARD
        table.insert(self.board.opp.discard.cards, card)
      end
    elseif oppPower > yourPower and playerHasCards and oppHasCards then
      oppAddScore = oppAddScore + (oppPower - yourPower)
      playerAddScore = 0
      
      while #self.board.player.locations[i].cards > 0 do
        local card = table.remove(self.board.player.locations[i].cards)
        card.pileLocation = PILE_LOCATIONS.DISCARD
        table.insert(self.board.player.discard.cards, card)
      end
    else
      local flip = math.random()
      if flip < 0.5 and oppHasCards  and playerHasCards then
        playerAddScore = playerAddScore + yourPower
        oppAddScore = 0
        
        while #self.board.opp.locations[i].cards > 0 do
          local card = table.remove(self.board.opp.locations[i].cards)
          card.pileLocation = PILE_LOCATIONS.DISCARD
          table.insert(self.board.opp.discard.cards, card)
        end
      elseif flip >= 0.5 and playerHasCards and oppHasCards then
        oppAddScore = oppAddScore + oppPower
        playerAddScore = 0
        
        while #self.board.player.locations[i].cards > 0 do
          local card = table.remove(self.board.player.locations[i].cards)
          card.pileLocation = PILE_LOCATIONS.DISCARD
          table.insert(self.board.player.discard.cards, card)
        end
      else
      end
    end
    
    self.board.player.score = self.board.player.score + playerAddScore
    self.board.opp.score = self.board.opp.score + oppAddScore
    playerAddScore = 0
    oppAddScore = 0
    
    if self.board.player.score >= 25 or self.board.opp.score >= 25 then
      self.gameOver = true
      if self.board.player.score > self.board.opp.score then
        self.winner = PLAYER_ENUM.PLAYER
      else
        self.winner = PLAYER_ENUM.OPP
      end
    end
  end
    
  self.board:deal(self.board.player, PLAYER_ENUM.PLAYER)
  self.board:deal(self.board.opp, PLAYER_ENUM.OPP)
  
  if (self.board.player.apollo) then 
    self.board.player.mana = self.turn + 1
    self.board.player.apollo = false
  else
    self.board.player.mana = self.turn
  end
  
  if (self.board.opp.apollo) then
    self.board.opp.mana = self.turn + 1
    self.board.opp.apollo = false
  else
    self.board.opp.mana = self.turn
  end
  
  
  self.turn = self.turn + 1
    
end

function GameManager:getAllCardsOnBoard()
  local allCards = {}

  -- Player cards on board
  for _, pile in ipairs(self.board.player.locations) do
    for _, card in ipairs(pile.cards) do
      table.insert(allCards, card)
    end
  end

  -- Opponent cards on board
  for _, pile in ipairs(self.board.opp.locations) do
    for _, card in ipairs(pile.cards) do
      table.insert(allCards, card)
    end
  end

  -- Add player and opponent hands
  for _, card in ipairs(self.board.player.hand.cards) do
    table.insert(allCards, card)
  end
  for _, card in ipairs(self.board.opp.hand.cards) do
    table.insert(allCards, card)
  end

  return allCards
end

function GameManager:drawCardTooltip(card, x, y)
  local padding = 8
  local width = 200
  local lineHeight = 20
  local height = 5 * lineHeight + padding * 2

  -- Background box
  love.graphics.setColor(0, 0, 0, 0.8) -- semi-transparent black
  love.graphics.rectangle("fill", x, y, width, height, 6, 6)

  -- Border
  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle("line", x, y, width, height, 6, 6)

  -- Card information
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Name: " .. card.name, x + padding, y + padding)
  love.graphics.print("Cost: " .. card.cost, x + padding, y + padding + lineHeight)
  love.graphics.print("Power: " .. card.power, x + padding, y + padding + lineHeight * 2)
  love.graphics.printf(card.text, x + padding, y + padding + lineHeight * 3, width - padding * 2)
end





