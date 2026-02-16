local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/ihsannur020-ops/SpeedControl-Azka/refs/heads/main/List%20ID%20Game.Lua"))()

local URL = Games[game.PlaceId]

if URL then
  loadstring(game:HttpGet(URL))()
end
