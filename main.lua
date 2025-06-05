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
  
  gameState = GAME_STATE.TITLE

end

function love.update(dt)
  if gameState == GAME_STATE.PLAYING then
    grabber:update()
    board:update(grabber)
    gameManager:update()
  end
  
  for i = 1, 3 do
    gameManager.board.player.locations[i]:update(dt)
    gameManager.board.opp.locations[i]:update(dt)
  end

  if gameManager.phase == GAME_PHASE.REVEAL then
    local allDone = true
    for i = 1, 3 do
      if gameManager.board.player.locations[i]:isFlipping() or gameManager.board.opp.locations[i]:isFlipping() then
        allDone = false
        break
      end
    end
  end

end


function love.draw()
  if gameState == GAME_STATE.TITLE then
    drawTitleScreen()
  elseif gameState == GAME_STATE.PLAYING then
    board:draw(grabber)
    gameManager:draw()
  elseif gameState == GAME_STATE.ENDING then
    drawGameOverScreen()
  end
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

function love.keypressed(key)
  if gameState == GAME_STATE.TITLE and key == "return" then
    gameState = GAME_STATE.PLAYING
  elseif gameState == GAME_STATE.ENDING and key == "r" then
    gameState = GAME_STATE.TITLE
    deck1 = Deck:new()
    deck2 = Deck:new()
    deck1:shuffle()
    deck2:shuffle()
    board = Board:new(deck1, deck2)
    gameManager = GameManager:new(board, grabber)
  end
end

function drawTitleScreen()
  local titleFont = love.graphics.newFont(48)
  love.graphics.setFont(titleFont)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Myth Madness", 0, 150, love.graphics.getWidth(), "center")

  local subFont = love.graphics.newFont(24)
  love.graphics.setFont(subFont)
  love.graphics.printf("Press Enter to Start", 0, 300, love.graphics.getWidth(), "center")
  
  love.graphics.setFont(love.graphics.newFont(12))
end

function drawGameOverScreen()
  local font = love.graphics.newFont(36)
  love.graphics.setFont(font)
  love.graphics.printf("Game Over! ".. gameManager.winner .. " wins!", 0, 200, love.graphics.getWidth(), "center")
  love.graphics.printf("Press R to Restart", 0, 250, love.graphics.getWidth(), "center")
  love.graphics.printf("Credits", 0, 350, love.graphics.getWidth(), "center")
  love.graphics.printf("Assets: Generated with AI", 0, 400, love.graphics.getWidth(), "center")
  love.graphics.printf("Gameplay Programming: Jaren Kawai", 0, 450, love.graphics.getWidth(), "center")
end