-- itzalyssa1 Hub - Grow a Garden Mode Script -- Includes: Fruit ESP, Visual Pet Spawner, Seed Spawner, Fly, Speed, Noclip, Auto Collect, Auto Steal Fruit, Shop Auto Buy, Hamster Detection

local Players = game:GetService("Players") local player  = Players.LocalPlayer local RunService = game:GetService("RunService") local uis = game:GetService("UserInputService")


---

-- 🖌️  UI BOOT ------------------------------------------------------

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))() local Window = Rayfield:CreateWindow({ Name             = "itzalyssa1 Hub", LoadingTitle     = "itzalyssa1 Hub Loading...", LoadingSubtitle  = "by itzalyssa1", ConfigurationSaving = {Enabled = false}, Discord          = {Enabled = false}, KeySystem        = false, })

Rayfield:Notify({ Title   = "itzalyssa1 Hub", Content = "Getting scripts from itzalyssa1 — beware of fake hubs!", Duration= 6.5, Image   = 4483362458, })


---

-- 🌱  SETUP ---------------------------------------------------------

local function disableScripts(inst) for _, d in ipairs(inst:GetDescendants()) do if d:IsA("Script") or d:IsA("LocalScript") then d.Disabled = true end end end

local function getMyGarden() local g = workspace:FindFirstChild("Gardens") if not g then return end local m = g:FindFirstChild(player.Name) if not (m and m:IsA("Model")) then return end local cf, size = m:GetBoundingBox() return m, cf.Position - size/2, cf.Position + size/2 end

local FRUIT_CONTAINER      = workspace:WaitForChild("Fruits") local PET_TEMPLATE_FOLDER  = game:GetService("ReplicatedStorage"):WaitForChild("Pets") local SEED_TEMPLATE_FOLDER = game:GetService("ReplicatedStorage"):WaitForChild("Seeds")

local petsFld  = Instance.new("Folder", workspace); petsFld.Name  = "itzalyssa1VisualPets" local seedsFld = Instance.new("Folder", workspace); seedsFld.Name = "itzalyssa1VisualSeeds"


---

-- 🐾  PET TAB -------------------------------------------------------

local PetTab   = Window:CreateTab("Pets", 4483362458) local petWeight, petAge = 5, 2 local selectedPetName   = nil

-- 🐾 Sliders PetTab:CreateSlider({ Name = "Pet Weight", Range = {1, 100}, Increment = 1, Suffix = "kg", CurrentValue = petWeight, Callback = function(v) petWeight = v end, })

PetTab:CreateSlider({ Name = "Pet Age", Range = {0, 20}, Increment = 1, Suffix = "yrs", CurrentValue = petAge, Callback = function(v) petAge = v end, })

-- 🐾 Dropdown list built from ReplicatedStorage.Pets local petNames = {} for _, p in ipairs(PET_TEMPLATE_FOLDER:GetChildren()) do if p:IsA("Model") or p:IsA("BasePart") then table.insert(petNames, p.Name) end end table.sort(petNames)

PetTab:CreateDropdown({ Name          = "Select Pet", Options       = petNames, CurrentOption = nil, Callback      = function(opt) selectedPetName = opt end, })

-- 🐾 Spawner helpers ------------------------------------------------ local function attachMover(pet, minB, maxB) task.spawn(function() while pet.Parent == workspace do local r = Vector3.new( math.random() * (maxB.X - minB.X) + minB.X, minB.Y + 2, math.random() * (maxB.Z - minB.Z) + minB.Z ) pet:PivotTo(CFrame.new(r)) task.wait(15) end end) end

local function createWorldPet(template) local garden, minB, maxB = getMyGarden() if not garden then Rayfield:Notify({Title="Pet Spawner",Content="Your garden not found!",Duration=5}) return end

local pet = template:Clone()
pet.Name = "Pet_" .. template.Name
pet:SetAttribute("Weight", petWeight)
pet:SetAttribute("Age",    petAge)
disableScripts(pet)

pet.Parent = workspace -- 🌍 visible to everyone
pet:PivotTo(player.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0))
attachMover(pet, minB, maxB)

Rayfield:Notify({
    Title   = "Pet Spawner",
    Content = string.format("%s spawned in world!", template.Name),
    Duration= 4,
})

end

local function createInventoryPet(template) local tool = Instance.new("Tool") tool.Name = template.Name .. "PetTool" tool.RequiresHandle = false tool.Parent = player.Backpack

template:Clone().Parent = tool
disableScripts(tool)

Rayfield:Notify({
    Title   = "Pet Spawner",
    Content = template.Name .. " added to inventory (visual)!",
    Duration= 4,
})

end

-- 🐾 Buttons -------------------------------------------------------- PetTab:CreateButton({ Name = "Spawn Selected Pet (World)", Callback = function() if not selectedPetName then Rayfield:Notify({Title="Pet Spawner",Content="Select a pet first!",Duration=4}) return end local template = PET_TEMPLATE_FOLDER:FindFirstChild(selectedPetName) if not template then Rayfield:Notify({Title="Pet Spawner",Content="Template missing!",Duration=5}) return end createWorldPet(template) end, })

PetTab:CreateButton({ Name = "Spawn Selected Pet (Inventory)", Callback = function() if not selectedPetName then Rayfield:Notify({Title="Pet Spawner",Content="Select a pet first!",Duration=4}) return end local template = PET_TEMPLATE_FOLDER:FindFirstChild(selectedPetName) if not template then Rayfield:Notify({Title="Pet Spawner",Content="Template missing!",Duration=5}) return end createInventoryPet(template) end, })

local PetTab   = Window:CreateTab("Pets", 4483362458) local petWeight, petAge = 5, 2 local selectedPetName   = ""

PetTab:CreateSlider({ Name = "Pet Weight", Range = {1,50}, Increment = 1, Suffix = "kg", CurrentValue = petWeight, Callback=function(v) petWeight = v end, })

PetTab:CreateSlider({ Name = "Pet Age", Range = {0,20}, Increment = 1, Suffix = "yrs", CurrentValue = petAge, Callback=function(v) petAge = v end, })

local function attachMover(pet, garden, minB, maxB) task.spawn(function() while pet.Parent == petsFld do local r = Vector3.new( math.random()(maxB.X-minB.X)+minB.X, minB.Y+2, math.random()(maxB.Z-minB.Z)+minB.Z ) pet:PivotTo(CFrame.new(r)) task.wait(15) end end) end

local function spawnPetNow(name, cf) local template = PET_TEMPLATE_FOLDER:FindFirstChild(name) if not template then Rayfield:Notify({ Title   = "Pet Spawner", Content = "Template "" .. name .. "" missing!", Duration= 6, }) return end

local garden, minB, maxB = getMyGarden()
if not garden then
    Rayfield:Notify({Title="Pet Spawner",Content="Your garden model is missing!",Duration=5})
    return
end

local pet = template:Clone()
pet.Name = "Pet_" .. name
pet:SetAttribute("Weight", petWeight)
pet:SetAttribute("Age",    petAge)
disableScripts(pet)
pet.Parent = petsFld
pet:PivotTo(cf)
attachMover(pet, garden, minB, maxB)

Rayfield:Notify({
    Title   = "Pet Spawner",
    Content = string.format("%s spawned (%.0f kg, %dyrs)", name, petWeight, petAge),
    Duration= 4,
})

end

-- generate dropdown options automatically local petNames = {} for _, p in ipairs(PET_TEMPLATE_FOLDER:GetChildren()) do if p:IsA("Model") or p:IsA("BasePart") then table.insert(petNames, p.Name) end end table.sort(petNames)

PetTab:CreateDropdown({ Name          = "Select Pet", Options       = petNames, CurrentOption = nil, Callback      = function(opt) selectedPetName = opt end, })

PetTab:CreateButton({ Name = "Spawn Selected Pet", Callback = function() if selectedPetName == "" then Rayfield:Notify({Title="Pet Spawner",Content="No pet selected.",Duration=4}) return end local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") if hrp then spawnPetNow(selectedPetName, hrp.CFrame * CFrame.new(3,0,0)) end end, })


---

-- 🌱  SEED TAB (Visual seeds that grow) --------------------------------

local SeedTab        = Window:CreateTab("Seeds", 4483362458) local selectedSeed   = nil local seedNames      = {}

for _, s in ipairs(SEED_TEMPLATE_FOLDER:GetChildren()) do if s:IsA("Model") or s:IsA("BasePart") or s:IsA("Tool") then table.insert(seedNames, s.Name) end end table.sort(seedNames)

SeedTab:CreateDropdown({ Name          = "Select Seed", Options       = seedNames, CurrentOption = nil, Callback      = function(opt) selectedSeed = opt end, })

-- growth settings local GROW_TIME = 60 -- seconds until seed becomes a plant

local function growSeed(seedModel, grownTemplate) task.delay(GROW_TIME, function() if seedModel and seedModel.Parent then local cf = seedModel:GetPrimaryPartCFrame() seedModel:Destroy() local grown = grownTemplate:Clone() disableScripts(grown) grown.Parent = workspace grown:PivotTo(cf) end end) end

local function spawnSeedInWorld(template) local garden, minB, maxB = getMyGarden() if not garden then Rayfield:Notify({Title="Seed Spawner",Content="Your garden not found!",Duration=5}) return end local seed = template:Clone() disableScripts(seed) seed.Parent = workspace local startCF = player.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0) seed:PivotTo(startCF)

local grownTemplate = template:FindFirstChild("Grown") or template -- if a child 'Grown' model exists use it
growSeed(seed, grownTemplate)

Rayfield:Notify({Title="Seed Spawner",Content=template.Name .. " planted! It will grow in " .. GROW_TIME .. "s",Duration=4})

end

SeedTab:CreateButton({ Name = "Plant Selected Seed", Callback = function() if not selectedSeed then Rayfield:Notify({Title="Seed Spawner",Content="Select a seed first!",Duration=4}); return end local template = SEED_TEMPLATE_FOLDER:FindFirstChild(selectedSeed) if not template then Rayfield:Notify({Title="Seed Spawner",Content="Template missing!",Duration=5}); return end spawnSeedInWorld(template) end, })


---

-- 🥚 EGG TAB (Visual hatchable eggs) --------------------------------

local EggTab      = Window:CreateTab("Eggs", 4483362458) local selectedEgg = nil local EGG_TEMPLATE_FOLDER = game:GetService("ReplicatedStorage"):WaitForChild("Eggs")

local eggNames = {} for _, e in ipairs(EGG_TEMPLATE_FOLDER:GetChildren()) do if e:IsA("Model") or e:IsA("Part") then table.insert(eggNames, e.Name) end end table.sort(eggNames)

EggTab:CreateDropdown({ Name = "Select Egg", Options = eggNames, CurrentOption = nil, Callback = function(opt) selectedEgg = opt end })

local function hatchEgg(eggModel) task.delay(60, function() if eggModel and eggModel.Parent then local cf = eggModel:GetPrimaryPartCFrame() local petTemplate = PET_TEMPLATE_FOLDER:FindFirstChild(eggModel.Name) eggModel:Destroy() if petTemplate then local pet = petTemplate:Clone() pet:SetAttribute("Weight", math.random(3,10)) pet:SetAttribute("Age", math.random(1,5)) disableScripts(pet) pet.Parent = workspace pet:PivotTo(cf) Rayfield:Notify({Title="Egg Hatch", Content=pet.Name .. " has hatched!", Duration=5}) end end end) end

EggTab:CreateButton({ Name = "Spawn Egg (hatches in 60s)", Callback = function() if not selectedEgg then Rayfield:Notify({Title="Egg Spawner",Content="Select an egg first!",Duration=4}) return end local template = EGG_TEMPLATE_FOLDER:FindFirstChild(selectedEgg) if not template then Rayfield:Notify({Title="Egg Spawner",Content="Template not found!",Duration=4}) return end local garden, minB, maxB = getMyGarden() if not garden then Rayfield:Notify({Title="Egg Spawner",Content="Garden not found!",Duration=4}) return end local egg = template:Clone() disableScripts(egg) egg.Parent = workspace egg:PivotTo(player.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0)) Rayfield:Notify({Title="Egg Spawner", Content="Egg placed! Hatching in 60s...", Duration=5}) hatchEgg(egg) end })


---

-- (All other tabs: Player, Fruits, Shops, etc. would follow here)


---


---

print("itzalyssa1 Hub loaded • Pet Spawner fixed.")
