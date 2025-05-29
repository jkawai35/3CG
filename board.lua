require("card")
require("pile")
require("player")
require("vector")

Board = {}
Board.__index = Board

PILE_LOCATIONS = {
  LEFT = 0,
  CENTER = 1,
  RIGHT = 2,
  HAND = 3,
  DECK = 4,
  DISCARD = 5
}

PLAYER_ENUM = {
  PLAYER = 0,
  OPP = 1
}

function Board:new(deck1, deck2)
  local board = {}
  setmetatable(board, Board)
  
  
  board.player = Player:new(deck1)
  board.opp = Player:new(deck2)
  
  board.allPiles = {}
  
  board.submitButton = {
  position = Vector(love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 20),
  width = 200,
  height = 50,
  text = "Submit Play",
  visible = true
  }

  board.addManaP = false
  board.addManaO = false


  local cardWidth, spacing = 80, 10
  local locationWidth = (cardWidth + spacing) * 4 - spacing
  local cardHeight = 115
  local handCardCount = 7
  local handWidth = (cardWidth + spacing) * handCardCount - spacing
  local topY = 200
  local bottomY = love.graphics.getHeight() - 200 - cardHeight
  local horizontalStart = (love.graphics.getWidth() - ((locationWidth + spacing) * 3 - spacing)) / 2

  -- Draw opponenet pile locations
  for i = 0, 2 do
    local x = horizontalStart + i * (locationWidth + spacing)
    local pile = Pile:new(x, topY, PILE_LOCATIONS[i + 1], self)
    table.insert(board.opp.locations, pile)
    table.insert(board.opp.piles, pile)
  end

  -- Draw player pile locations
  for i = 0, 2 do
    local x = horizontalStart + i * (locationWidth + spacing)
    local pile = Pile:new(x, bottomY, PILE_LOCATIONS[i + 1], self)
    table.insert(board.player.locations, pile)
    table.insert(board.player.piles, pile)
  end
  
  -- Draw opponenet hand
  local oppHandX = (love.graphics.getWidth() - handWidth) / 2
  local oppHandY = topY - cardHeight - 40
  board.opp.hand = Pile:new(oppHandX, oppHandY, PILE_LOCATIONS.HAND, self)
  table.insert(board.opp.piles, board.opp.hand)

  -- Draw player hand
  local yourHandX = (love.graphics.getWidth() - handWidth) / 2
  local yourHandY = bottomY + cardHeight + 40
  board.player.hand = Pile:new(yourHandX, yourHandY, PILE_LOCATIONS.HAND, self)
  table.insert(board.player.piles, board.player.hand)
  
  -- Draw opponent discard
  local oppDiscardX = oppHandX - cardWidth - 30
  local oppDiscardY = oppHandY
  board.opp.discard = Pile:new(oppDiscardX, oppDiscardY, PILE_LOCATIONS.DISCARD, self)
  table.insert(board.opp.piles, board.opp.discard)

  -- Draw player discard
  local yourDiscardX = yourHandX - cardWidth - 30
  local yourDiscardY = yourHandY
  board.player.discard = Pile:new(yourDiscardX, yourDiscardY, PILE_LOCATIONS.DISCARD, self)
  table.insert(board.player.piles, board.player.discard)

  
  -- Deal 3 cards to your hand
  for i = 1, 3 do
    board:deal(board.player, PLAYER_ENUM.PLAYER)
    board:deal(board.opp, PLAYER_ENUM.OPP)
  end
  
  return board
end


function Board:update(grabber)
  for _, pile in ipairs(self.player.piles) do
    for _, card in ipairs(pile.cards) do
      card:checkForMouseOver(grabber)
    end
  end
end


function Board:draw()
  local cardWidth, cardHeight = 80, 115
  local spacing = 10
  local handCardCount = 7
  local handWidth = (cardWidth + spacing) * handCardCount - spacing
  local handHeight = cardHeight
  local locationWidth = (cardWidth + spacing) * 4 - spacing
  local locationHeight = cardHeight
  local topMargin = 200
  local bottomMargin = love.graphics.getHeight() - locationHeight - 200
  local horizontalStart = (love.graphics.getWidth() - ((locationWidth + spacing) * 3 - spacing)) / 2

  -- Draw opponent pile outlines
  for _, pile in ipairs(board.opp.locations) do
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("line", pile.position.x, pile.position.y, pile.width, pile.height)
    pile:draw()
  end

  -- Draw player pile outlines
  for _, pile in ipairs(board.player.locations) do
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle("line", pile.position.x, pile.position.y, pile.width, pile.height)
    pile:draw()
  end

  -- Opponent hand outline
  local oppHandY = topMargin - handHeight - 40
  local handX = (love.graphics.getWidth() - handWidth) / 2
  love.graphics.setColor(0.8, 0.2, 0.2, 1)
  love.graphics.rectangle("line", handX, oppHandY, handWidth, handHeight)

  -- Player hand outline
  local yourHandY = bottomMargin + locationHeight + 40
  love.graphics.setColor(0.2, 0.2, 0.8, 1)
  love.graphics.rectangle("line", handX, yourHandY, handWidth, handHeight)

  -- Reset color
  love.graphics.setColor(1, 1, 1, 1)
  
  if self.submitButton.visible then
    love.graphics.setColor(0.2, 0.6, 1)
    love.graphics.rectangle("fill", self.submitButton.position.x, self.submitButton.position.y, self.submitButton.width, self.submitButton.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.submitButton.text, self.submitButton.position.x, self.submitButton.position.y + 15, self.submitButton.width, "center")
  end
  
  self:drawPlayerStats()
  board:drawDeck()


  -- Draw all player piles (cards)
  for _, pile in ipairs(board.player.piles) do
    pile:draw()
  end
  
  -- Draw all opponenet piles (cards)
  for _, pile in ipairs(board.opp.piles) do
    pile:draw()
  end
  
  -- Draw dragged object
  if grabber.heldObject then
    grabber.heldObject:draw(grabber.heldObject.position.x, grabber.heldObject.position.y)
  end
end

function Board:mousepressed(x, y, button, gameManager, grabber)  
  local b = self.submitButton
  
  -- Check if button is clicked and then call game manager
  if b.visible and button == 1 and x > b.position.x and x < b.position.x + b.width and y > b.position.y and y < b.position.y + b.height then
    gameManager:submitPlay()
    return
  end

  -- Otherwise forward to grabber logic
  grabber:mousepressed(x, y, self)
end

function Board:deal(player, name)
  local card = table.remove(player.deck.cards)
    
  -- Check if card can be dealt first
  if card and #player.hand.cards <= 6 then
    player.hand:addCard(card)
    card.pileLocation = PILE_LOCATIONS.HAND
    
    if name == PLAYER_ENUM.OPP then
      card.faceUp = false
    end
  end
  
end

function Board:drawPlayerStats()
  love.graphics.setColor(1, 1, 1)

  local x = 20
  local y = love.graphics.getHeight() - 100
  local lineHeight = 24

  if self.addManaP then
    love.graphics.print("Player Mana: " .. tostring(self.player.mana + 1), x, y)
    self.addManaP = false
  else
    love.graphics.print("Player Mana: " .. tostring(self.player.mana), x, y)
  end

  if self.addManaO then
    love.graphics.print("Opponent Mana: " .. tostring(self.opp.mana + 1), x, y + lineHeight)
    self.addManaO = false
  else
    love.graphics.print("Opponent Mana: " .. tostring(self.opp.mana), x, y + lineHeight)
  end

  -- Scores
  local playerScore = self.player.score
  local oppScore = self.opp.score
  love.graphics.print("Player Score: " .. tostring(playerScore), x, y + 2 * lineHeight)
  love.graphics.print("Opponent Score: " .. tostring(oppScore), x, y + 3 * lineHeight)
end

function Board:drawDeck()
  local deck = self.player.deck
  local deck2 = self.opp.deck

  if #deck.cards > 0 then
    local cardBackImage = deck.cards[1].backImage
    local x, y = 1000, 650
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(cardBackImage, x, y)
  end
  
    if #deck2.cards > 0 then
    local cardBackImage = deck.cards[1].backImage
    local x, y = 1000, 50
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(cardBackImage, x, y)
  end
end

