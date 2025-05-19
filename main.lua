require("deck")
require("board")
require("grabber")

function love.load()
  love.window.setTitle("3CG")
  love.window.setMode(1200, 800)
  
  deck1 = Deck:new()
  deck1:shuffle()
  deck2 = Deck:new()
  deck2:shuffle()
  
  board = Board:new(deck1, deck2)
  
  grabber = GrabberClass:new()

end

function love.update(dt)
  grabber:update()
  board:update(grabber)
end


function love.draw()
  board:draw(grabber)

end

function love.mousepressed(x, y, button)
  if button == 1 then
    grabber:mousepressed(x, y, board)
  end
end

function love.mousemoved(x, y, dx, dy)
  grabber:mousemoved(x, y)
end


function love.mousereleased(x, y, button)
  if button == 1 then
    grabber:mousereleased(x, y, board)
  end
end


function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
  end
end
  
