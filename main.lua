require("deck")
require("board")
require("grabber")
require("gamemanager")

function love.load()
  love.window.setTitle("Myth Madness")
  love.window.setMode(1200, 800)
  
  deck1 = Deck:new()
  deck1:shuffle()
  deck2 = Deck:new()
  deck2:shuffle()
  
  board = Board:new(deck1, deck2)
    
  grabber = GrabberClass:new()
  
  gameManager = GameManager:new(board, grabber)

end

function love.update(dt)
  grabber:update()
  board:update(grabber)
  gameManager:update()
end


function love.draw()
  board:draw(grabber)
  gameManager:draw()

end

function love.mousepressed(x, y, button)
  if button == 1 then
    board:mousepressed(x, y, button, gameManager, grabber)
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
