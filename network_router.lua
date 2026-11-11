-- Network Hub router: picks the right Luarmor loader for the current game
local BASE = "https://api.luarmor.net/files/v4/loaders/"

local MM2    = BASE .. "0267587747fa39f06a1fb8570832bb49.lua" -- network mm2
local BF     = BASE .. "c38b8ef302e50b6e29c9011e1af7fcf5.lua" -- network blox fruit
local SAE    = BASE .. "d3623cafc81319c77eae46f5d7e6bdce.lua" -- Steal an Egg
local FISCH  = BASE .. "27d36773e022e97f3bf8dc7134754aef.lua" -- fisch
local RIVALS = BASE .. "014a511331504aa515de59a855bace16.lua" -- rivals
local BLADE  = BASE .. "a8ab5f00a1f52711a67e9efd8b5c1182.lua" -- bladeballl
local DOORS  = BASE .. "f55007cbb16be6ffedd4270039aae979.lua" -- doors
local DQ     = BASE .. "63cd877755e9a97c8c1484d5258be095.lua" -- Dungeon quest
local PS99   = BASE .. "5178020fe0c8f7d4b0571dbe91577cef.lua" -- pet sim 99

-- Universe IDs (game.GameId): covers every place inside the game
local byGameId = {
    [66654135]    = MM2,
    [994732206]   = BF,
    [10563114921] = SAE,
    [5750914919]  = FISCH,
    [6035872082]  = RIVALS,
    [4777817887]  = BLADE,
    [2440500124]  = DOORS,
    [848145103]   = DQ,
    [3317771874]  = PS99,
}

-- Place IDs (game.PlaceId): fallback if GameId doesn't match
local byPlaceId = {
    [142823291]       = MM2,
    [2753915549]      = BF,     -- First Sea
    [4442272183]      = BF,     -- Second Sea
    [7449423635]      = BF,     -- Third Sea
    [107778070777162] = SAE,
    [16732694052]     = FISCH,
    [17625359962]     = RIVALS,
    [13772394625]     = BLADE,
    [6516141723]      = DOORS,  -- Lobby
    [6839171747]      = DOORS,  -- Hotel
    [2414851778]      = DQ,
    [8737899170]      = PS99,
}

local gameId = game.GameId
while gameId == 0 and game.PlaceId == 0 do
    task.wait()
    gameId = game.GameId
end

local url = byGameId[gameId] or byPlaceId[game.PlaceId]
if not url then
    return
end

for _ = 1, 3 do
    local ok, source = pcall(game.HttpGet, game, url)
    if ok and type(source) == "string" and source ~= "" then
        local chunk = loadstring(source)
        if chunk then
            chunk()
        end
        return
    end
    task.wait(0.5)
end
