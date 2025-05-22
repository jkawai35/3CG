require("player")

GameManager = {}
GameManager.__index = GameManager

io.stdout:setvbuf("no")


GAME_PHASE = {
  STAGING = "STAGING",
  REVEAL = "REVEAL",
  RESOLUTION = "RESOLUTION"
}

function GameManager:new(board)
  local gm = setmetatable({}, GameManager)
  gm.board = board
  gm.phase = GAME_PHASE.STAGING -- other phases: "REVEAL", "RESOLUTION"
  return gm
end

function GameManager:submitPlay()
  self.board.opp:takeTurn(self.board)
  
  self.phase = GAME_PHASE.REVEAL
  
  local playerAddScore = 0
  local oppAddScore = 0

  for i = 1, 3 do
    local yourPower = self.board.player.locations[i]:reveal(self.board)
    local oppPower = self.board.opp.locations[i]:reveal(self.board)
    
    if yourPower > oppPower then
      playerAddScore = playerAddScore + yourPower - oppPower
    elseif oppPower > yourPower then
      oppAddScore = oppAddScore + oppPower - yourPower
    else
      if math.random() < 0.5 then
        playerAddScore = playerAddScore + yourPower - oppPower
      else
        oppAddScore = oppAddScore + oppPower - yourPower
      end
    end
  end
  
  self.board.player.score = self.board.player.score + playerAddScore
  self.board.opp.score = self.board.opp.score + oppAddScore
  
  self.board:deal(self.board.player)
  self.board:deal(self.board.opp)
    
end


