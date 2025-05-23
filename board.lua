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
  DECK = 4
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



  local cardWidth, spacing = 80, 10
  local locationWidth = (cardWidth + spacing) * 4 - spacing
  local cardHeight = 115
  local handCardCount = 7
  local handWidth = (cardWidth + spacing) * handCardCount - spacing
  local topY = 200
  local bottomY = love.graphics.getHeight() - 200 - cardHeight
  local horizontalStart = (love.graphics.getWidth() - ((locationWidth + spacing) * 3 - spacing)) / 2

  -- Create opponent piles
  for i = 0, 2 do
    local x = horizontalStart + i * (locationWidth + spacing)
    local pile = Pile:new(x, topY, PILE_LOCATIONS[i + 1], self)
    table.insert(board.opp.locations, pile)
    table.insert(board.opp.piles, pile)
  end

  -- Create your piles
  for i = 0, 2 do
    local x = horizontalStart + i * (locationWidth + spacing)
    local pile = Pile:new(x, bottomY, PILE_LOCATIONS[i + 1], self)
    table.insert(board.player.locations, pile)
    table.insert(board.player.piles, pile)
  end
  
  local oppHandX = (love.graphics.getWidth() - handWidth) / 2
  local oppHandY = topY - cardHeight - 40
  board.opp.hand = Pile:new(oppHandX, oppHandY, PILE_LOCATIONS.HAND, self)
  table.insert(board.opp.piles, board.opp.hand)

  -- 🟦 Add your hand pile
  local yourHandX = (love.graphics.getWidth() - handWidth) / 2
  local yourHandY = bottomY + cardHeight + 40
  board.player.hand = Pile:new(yourHandX, yourHandY, PILE_LOCATIONS.HAND, self)
  table.insert(board.player.piles, board.player.hand)
  
  -- Deal 3 cards to your hand
  for i = 1, 3 do
    board:deal(board.player)
    board:deal(board.opp)
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
    love.graphics.rectangle("fill", self.submitButton.position.x, self.submitButton.position.y,
                                     self.submitButton.width, self.submitButton.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(self.submitButton.text,
                         self.submitButton.position.x,
                         self.submitButton.position.y + 15,
                         self.submitButton.width,
                         "center")
  end

  -- Draw all piles
  for _, pile in ipairs(board.player.piles) do
    pile:draw()
  end
  
  for _, pile in ipairs(board.opp.piles) do
    pile:draw()
  end
  
  if grabber.heldObject then
    grabber.heldObject:draw(grabber.heldObject.position.x, grabber.heldObject.position.y)
  end
end

function Board:mousepressed(x, y, button, gameManager, grabber)
  -- First check if the submit button was clicked
  
  local b = self.submitButton
  if b.visible and button == 1 and x > b.position.x and x < b.position.x + b.width and y > b.position.y and y < b.position.y + b.height then
    gameManager:submitPlay()
    return
  end

  -- Otherwise forward to grabber logic
  grabber:mousepressed(x, y, self)
end

function Board:deal(player)
  local card = table.remove(player.deck.cards)
    
  if card and #player.hand.cards <= 6 then
    player.hand:addCard(card)
    card.pileLocation = PILE_LOCATIONS.HAND
    card.faceUp = true
  end
end
