require("card")
require("pile")

Board = {}
Board.__index = Board

function Board:new(deck1, deck2)
  local board = {}
  setmetatable(board, Board)
  
  board.yourDeck = deck1
  board.oppDeck = deck2
  
  board.yourHand = {}
  board.oppHand = {}

  board.yourLocations = {}
  board.oppLocations = {}
  board.allPiles = {}

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
    local pile = Pile:new(x, topY)
    table.insert(board.oppLocations, pile)
    table.insert(board.allPiles, pile)
  end

  -- Create your piles
  for i = 0, 2 do
    local x = horizontalStart + i * (locationWidth + spacing)
    local pile = Pile:new(x, bottomY)
    table.insert(board.yourLocations, pile)
    table.insert(board.allPiles, pile)
  end
  
  local oppHandX = (love.graphics.getWidth() - handWidth) / 2
  local oppHandY = topY - cardHeight - 40
  board.oppHand = Pile:new(oppHandX, oppHandY)
  table.insert(board.allPiles, board.oppHand)

  -- 🟦 Add your hand pile
  local yourHandX = (love.graphics.getWidth() - handWidth) / 2
  local yourHandY = bottomY + cardHeight + 40
  board.yourHand = Pile:new(yourHandX, yourHandY)
  table.insert(board.allPiles, board.yourHand)
  
  -- Deal 3 cards to your hand
  for i = 1, 3 do
    local card = table.remove(board.yourDeck.cards)
    
    if card then
      board.yourHand:addCard(card)
    end

  end


  return board
end


function Board:update(grabber)
  for _, pile in ipairs(self.allPiles) do
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
  for _, pile in ipairs(self.oppLocations) do
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("line", pile.position.x, pile.position.y, pile.width, pile.height)
    pile:draw()
  end

  -- Draw player pile outlines
  for _, pile in ipairs(self.yourLocations) do
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

  -- Draw all piles
  for _, pile in ipairs(board.allPiles) do
    pile:draw()
  end
  
  if grabber.heldObject then
    grabber.heldObject:draw(grabber.heldObject.position.x, grabber.heldObject.position.y)
  end
end

