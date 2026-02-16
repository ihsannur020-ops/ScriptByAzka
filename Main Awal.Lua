-- Script Auto Loader (Silent Mode untuk Delta Executor)
-- Tidak menghasilkan output ke console

local gameScripts = {
    [119987266683883] = "https://raw.githubusercontent.com/ihsannur020-ops/SpeedControl-Azka/refs/heads/main/SurviveLAVAforBrainrots"
    -- Tambahkan ID dan URL lain di sini
}

local currentGameId = game.PlaceId
local scriptUrl = gameScripts[currentGameId]

if scriptUrl then
    local success, content = pcall(game.HttpGet, game, scriptUrl)
    if success and content then
        local loadSuccess, func = pcall(loadstring, content)
        if loadSuccess and func then
            pcall(func)
        end
    end
end
