repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local eggToPets = {
    ["Common Egg"]     = {"Dog", "Golden Lab", "Bunny"},
    ["Uncommon Egg"]   = {"Black Bunny", "Cat", "Chicken", "Deer"},
    ["Rare Egg"]       = {"Monkey", "Orange Tabby", "Pig", "Rooster", "Spotted Deer"},
    ["Legendary Egg"]  = {"Cow", "Silver Monkey", "Sea Otter", "Turtle", "Polar Bear"},
    ["Mythical Egg"]   = {"Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant", "Red Fox"},
    ["Bug Egg"]        = {"Snail", "Giant Ant", "Caterpillar", "Praying Mantis", "Dragonfly"},
    ["Bee Egg"]        = {"Bee", "Honey Bee", "Bear Bee", "Petal Bee", "Queen Bee"},
    ["Paradise Egg"]   = {"Ostrich", "Peacock", "Capybara", "Scarlet Macaw", "Mimic Octopus"},
    ["Oasis Egg"]      = {"Meerkat", "Sand Snake", "Axolotl", "Hyacinth Macaw"},
}

local espList = {}
local function clearESP()
    for _, gui in ipairs(espList) do
        if gui and gui.Parent then gui:Destroy() end
    end
    espList = {}
end

local function createESP(part, petName)
    if not part:FindFirstChild("EggESP") then
        local gui = Instance.new("BillboardGui")
        gui.Name = "EggESP"
        gui.Size = UDim2.new(0, 100, 0, 40)
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        gui.AlwaysOnTop = true
        gui.Adornee = part
        gui.Parent = part

        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = petName
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0.5
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true

        table.insert(espList, gui)
    end
end

local function getRandomPet(eggName, forceRare, blockRare)
    local pool = eggToPets[eggName]
    if not pool then return "Unknown" end
    if forceRare then return pool[#pool] end
    if blockRare then
        return pool[math.random(1, #pool - 1)]
    end
    return pool[math.random(1, #pool)]
end

local function randomizeEggs(forceRare, blockRare)
    clearESP()
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and eggToPets[model.Name] then
            local part = model:FindFirstChildWhichIsA("BasePart")
            if part then
                local pet = getRandomPet(model.Name, forceRare, blockRare)
                createESP(part, pet)
            end
        end
    end
end

-- 🌈 RGB Animated Loading Screen (30s)
local loadingGui = Instance.new("ScreenGui", PlayerGui)
loadingGui.Name = "XenoLoading"
loadingGui.IgnoreGuiInset = true

local box = Instance.new("Frame", loadingGui)
box.Size = UDim2.new(0, 260, 0, 100)
box.Position = UDim2.new(0.5, -130, 0.5, -50)
box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", box)
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Text = "XenoLoading"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextScaled = true

local status = Instance.new("TextLabel", box)
status.Size = UDim2.new(1, 0, 0.3, 0)
status.Position = UDim2.new(0, 0, 0.4, 0)
status.Text = "Loading"
status.Font = Enum.Font.GothamBold
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.BackgroundTransparency = 1
status.TextScaled = true

local bar = Instance.new("Frame", box)
bar.Size = UDim2.new(0, 0, 0, 8)
bar.Position = UDim2.new(0, 10, 1, -15)
bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)

-- Animate bar and RGB for 30 seconds
spawn(function()
    local r, g, b = 255, 0, 0
    for i = 1, 90 do
        local t = i / 90
        bar.Size = UDim2.new(t * 0.92, 0, 0, 8)
        status.Text = "Loading" .. string.rep(".", i % 4)
        box.BackgroundColor3 = Color3.fromRGB(r, g, b)
        r, g, b = (r + 30) % 256, (g + 60) % 256, (b + 90) % 256
        wait(30 / 90)
    end
    loadingGui:Destroy()
end)

wait(30.2)

-- 🌟 Main GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "KuniHubGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 160)
frame.Position = UDim2.new(0.02, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.Text = "Pet Predictor by Xeno"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 38)
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true

local randomBtn = Instance.new("TextButton", frame)
randomBtn.Size = UDim2.new(0.9, 0, 0, 30)
randomBtn.Position = UDim2.new(0.05, 0, 0, 65)
randomBtn.Text = "Randomize Pet"
randomBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
randomBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
randomBtn.Font = Enum.Font.GothamBold
randomBtn.TextScaled = true
Instance.new("UICorner", randomBtn).CornerRadius = UDim.new(0, 8)

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(0.9, 0, 0, 30)
autoBtn.Position = UDim2.new(0.05, 0, 0, 105)
autoBtn.Text = "Auto Roll Get Rare"
autoBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
autoBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextScaled = true
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, 8)

-- 🛡 Anti-Spam
local canClick = true

randomBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    statusLabel.Text = "Randomizing..."
    randomizeEggs()
    wait(2)
    statusLabel.Text = ""
    canClick = true
end)

autoBtn.MouseButton1Click:Connect(function()
    if not canClick then return end
    canClick = false
    statusLabel.Text = "Rolling for rare pet..."
    local start = tick()
    while tick() - start < 39 do
        randomizeEggs(false, true) -- block rare
        wait(2)
    end
    -- force rare at 40s
    randomizeEggs(true, false)
    local rare = "Rare Pet"
    for _, gui in pairs(espList) do
        local label = gui:FindFirstChildOfClass("TextLabel")
        if label then rare = label.Text break end
    end
    statusLabel.Text = "✅ Found: " .. rare
    wait(3)
    statusLabel.Text = ""
    canClick = true
end)
