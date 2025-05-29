require("vector")
require("board")
require("player")
require("card")

GrabberClass = {}
io.stdout:setvbuf("no")

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  grabber.dragOffsetX = 0
  grabber.dragOffsetY = 0
  
  grabber.grabPos = nil
  
  grabber.heldObject = nil
  
  return grabber
end

function GrabberClass:update()
  -- Update current mouse position
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
end

function GrabberClass:mousepressed(x, y, board)
  self.grabPos = Vector(x, y)

  for _, pile in ipairs(board.player.piles) do
    for _, card in ipairs(pile.cards) do
      if card.state == CARD_STATE.MOUSE_OVER and card.canMove then
        self.heldObject = card
        card.prevPosition = Vector(card.position.x, card.position.y)
        card.prevPile = card.currentPile
        self.dragOffsetX = x - card.position.x
        self.dragOffsetY = y - card.position.y
        card.state = CARD_STATE.GRABBED
        
        pile:removeCard(card)
        card.currentPile = nil

        break
      end
    end
  end

end

function GrabberClass:mousemoved(x, y)
  if self.heldObject then
    self.heldObject.position.x = x - self.dragOffsetX
    self.heldObject.position.y = y - self.dragOffsetY
  end
end

function GrabberClass:mousereleased(x, y, board)
  if not self.heldObject then return end

  local snapped = false
  
  -- Check for legal placement including mana cost and location capacity
  for i, pile in ipairs(board.player.piles) do
    if pile:contains(x, y) and pile:length() < 4 and board.player.mana >= self.heldObject.cost  and pile ~= board.player.hand then
      if pile:addCard(self.heldObject) then
        snapped = true
        self.heldObject.pileLocation = i
        self.heldObject.faceUp = false
        board.player.mana = board.player.mana - self.heldObject.cost
        
        -- Check if apollo ability needs to be accounted for
        if self.heldObject.name == CARD_NAMES.APOLLO then
          board.player.apollo = true
        end 
        break
      end
    end
  end

  -- Return to last position if not logally placed
  if not snapped and self.heldObject.prevPosition then
    self.heldObject.position = Vector(self.heldObject.prevPosition.x, self.heldObject.prevPosition.y)
    
    if self.heldObject.prevPile then
      self.heldObject.prevPile:addCard(self.heldObject)
    end
  end

  -- Reset held card state
  self.heldObject.state = CARD_STATE.IDLE
  self.heldObject = nil
  self.grabPos = nil
end

