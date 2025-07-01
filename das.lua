-- 🐝 Grow a Garden - Nero Pet & Seed Spawner (2025)
-- Spawns advanced pets like Queen Bee and any seed instantly.
 
local rs = game:GetService("ReplicatedStorage")
 
-- 🔧 Change to the pet or seed name you want to spawn
local spawnName = "Raccoon" -- or "SunflowerSeed", "BatPet", etc.
 
local function neroSpawn(name)
    if name:lower():find("seed") then
        rs:FireServer("SpawnSeed", name)
    else
        rs:FireServer("SpawnPet", name)
    end
end
 
neroSpawn(spawnName)
print("✅ xspr Spawner: Successfully spawned", spawnName)
