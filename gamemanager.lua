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

GAME_STATE = {
  TITLE = "Title",
  PLAYING = "Playing",
  ENDING = "Ending"
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
  local playerAddScore = 0
  local oppAddScore = 0

  if self.phase == GAME_PHASE.STAGING then
    -- Opponenet plays card on board
    self.board.opp:takeTurn(self.board)
    self.phase = GAME_PHASE.REVEAL
  elseif self.phase == GAME_PHASE.REVEAL then
    
    -- Incrementally flip cards
    self.board:startFlipping(0.3)
    
    self.phase = GAME_PHASE.RESOLUTION
  else
    -- Add card powers by location and determine winner
    for i = 1, 3 do
      self.board.player.locations[i]:reveal(self.board)
      self.board.opp.locations[i]:reveal(self.board)
    end
    
    for j = 1, 3 do
      local yourPower = self.board.player.locations[j]:power(self.board)
      local oppPower = self.board.opp.locations[j]:power(self.board)
      
      local playerHasCards = self.board.player.locations[j]:length() > 0
      local oppHasCards = self.board.opp.locations[j]:length() > 0
      
      self.locationPowers.player[j] = yourPower
      self.locationPowers.opp[j] = oppPower

      -- Determine winner here and add points to score
      if yourPower > oppPower and playerHasCards and oppHasCards then
        playerAddScore = playerAddScore + (yourPower - oppPower)
        oppAddScore = 0
        
        while #self.board.opp.locations[j].cards > 0 do
          local card = table.remove(self.board.opp.locations[j].cards)
          card.pileLocation = PILE_LOCATIONS.DISCARD
          table.insert(self.board.opp.discard.cards, card)
        end
      elseif oppPower > yourPower and playerHasCards and oppHasCards then
        oppAddScore = oppAddScore + (oppPower - yourPower)
        playerAddScore = 0
        
        while #self.board.player.locations[j].cards > 0 do
          local card = table.remove(self.board.player.locations[j].cards)
          card.pileLocation = PILE_LOCATIONS.DISCARD
          table.insert(self.board.player.discard.cards, card)
        end
      else
        -- Tie breaker mechanic
        local flip = math.random()
        if flip < 0.5 and oppHasCards  and playerHasCards then
          playerAddScore = playerAddScore + yourPower
          oppAddScore = 0
          
          while #self.board.opp.locations[j].cards > 0 do
            local card = table.remove(self.board.opp.locations[j].cards)
            card.pileLocation = PILE_LOCATIONS.DISCARD
            table.insert(self.board.opp.discard.cards, card)
          end
        elseif flip >= 0.5 and playerHasCards and oppHasCards then
          oppAddScore = oppAddScore + oppPower
          playerAddScore = 0
          
          while #self.board.player.locations[j].cards > 0 do
            local card = table.remove(self.board.player.locations[j].cards)
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
      
      -- Check if a player has won the game
      if self.board.player.score >= 30 or self.board.opp.score >= 30 then
        gameState = GAME_STATE.ENDING
        if self.board.player.score > self.board.opp.score then
          self.winner = PLAYER_NAME.PLAYER
        else
          self.winner = PLAYER_NAME.OPP
        end
      end
    end
      
    -- Deal out card upon new turn
    self.board:deal(self.board.player, PLAYER_NAME.PLAYER)
    self.board:deal(self.board.opp, PLAYER_NAME.OPP)
    
    -- Check if apollo ability applies
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
    
    self.phase = GAME_PHASE.STAGING
  end
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
  love.graphics.setColor(0, 0, 0, 0.8)
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
