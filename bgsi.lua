local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local RemoteEvent = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
local RemoteFunction = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteFunction")
local RemoteModule = require(ReplicatedStorage.Shared.Framework.Network.Remote)
local LocalData = require(ReplicatedStorage.Client.Framework.Services.LocalData)

local Pets = require(ReplicatedStorage.Shared.Data.Pets)

-- ======================================
--   CONFIG & FILE SYSTEM UTILITIES
-- ======================================
local FILE_NAME = "Hub_Config.json"

local function getDefaults()
    return {
        WEBHOOK_URL = "",
        DISCORD_PING_ID = "",
        TOGGLE_KEY = "RightShift",
        FPS_CAP = "60",
        SELECTED_EGG = "4x Luck Egg"
    }
end

local Config = getDefaults()

local function saveConfig()
    local ok, encoded = pcall(function() return HttpService:JSONEncode(Config) end)
    if ok and writefile then
        pcall(function() writefile(FILE_NAME, encoded) end)
    end
end

local function loadConfig()
    if readfile and isfile and isfile(FILE_NAME) then
        local ok, content = pcall(function() return readfile(FILE_NAME) end)
        if ok and content then
            local ok2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
            if ok2 and type(decoded) == "table" then
                for k, v in pairs(decoded) do Config[k] = v end
                return
            end
        end
    end
end
loadConfig()

-- ======================================
--   STATE MANAGEMENT & HARDCODED EGGS
-- ======================================
local HATCH_AMOUNT = 12
local WALKSPEED = 75

local EGGS = {
    ["Common Egg"]         = Vector3.new(-59.7594, 13.7468, -4.9295),
    ["Inferno Egg"]        = Vector3.new(61.6161, -38.2405, -36.4416),
    ["Classic Egg"]        = Vector3.new(-89.3765, 13.9007, 30.5915),
    ["Vine Egg"]           = Vector3.new(-60.7224, 13.9614, 11.0473),
    ["Lava Egg"]           = Vector3.new(-68.9796, 14.1626, 19.3721),
    ["Icy Egg"]            = Vector3.new(-54.2339, 13.7070, 0.9815),
    ["Iceshard Egg"]       = Vector3.new(-119.0674, 11.4101, 13.9992),
    ["Spotted Egg"]        = Vector3.new(-91.7780, 12.9166, 12.3185),
    ["Atlantis Egg"]       = Vector3.new(-78.4374, 14.7693, 25.9414),
    ["Mining Egg"]         = Vector3.new(-121.7517, 11.0727, -68.1152),
    ["Neon Egg"]           = Vector3.new(-81.3096, 10.9481, -60.4263),
    ["Cyber Egg"]          = Vector3.new(-92.2678, 10.9795, -66.6913),
    ["Spikey Egg"]         = Vector3.new(-128.6110, 10.8857, 9.7908),
    ["Magma Egg"]          = Vector3.new(-137.1953, 11.1698, 3.5342),
    ["Crystal Egg"]        = Vector3.new(-144.1717, 10.9745, -4.9899),
    ["Rainbow Egg"]        = Vector3.new(-140.0540, 10.9538, -56.0581),
    ["Void Egg"]           = Vector3.new(-150.2729, 11.1749, -26.0208),
    ["Showman Egg"]        = Vector3.new(-131.7554, 12.0426, -63.2838),
    ["Hell Egg"]           = Vector3.new(-149.3270, 11.1268, -36.8873),
    ["Nightmare Egg"]      = Vector3.new(-146.0093, 10.9916, -46.9943),
    ["Lunar Egg"]          = Vector3.new(-148.4841, 11.1363, -15.2603),
    ["Dice Egg"]           = Vector3.new(9832.3232, 27.8746, 172.1069),
    ["Secret Egg"]         = Vector3.new(-19438.9062, 8.6763, 18838.1113),
    ["4x Luck Egg"]        = Vector3.new(2342, 3161, 999),
    ["Flame Egg"]          = Vector3.new(764, 7611, -3464),
    ["Frozen Egg"]         = Vector3.new(686, 7611, -3466),
}

local eggButtons = {}

local running = false
local teleporting = false
local eSpamming = false
local autoEnchanting = false
local autoPermanentShrine = false
local autoTimedShrines = false
local uiVisible = true
local scriptActive = true

local eggsHatched = 0
local selectedEgg = Config.SELECTED_EGG
local startTime = os.time()

local hatchThread, teleportThread, eSpamThread, enchantThread, permShrineThread, timedShrineThread
local loopThreads = {}
local webhookQueue = {}
local webhookProcessing = false
local savedBubblePos = nil
local connections = {}

-- UI declaration forward references
local eggScroll, eggLayout, questScroll, questLayout

-- Generates the UI elements from the hardcoded positions list
local function populateEggUI()
    if not eggScroll then return end
    
    -- Clear out old listings to prevent overlap
    for _, btn in pairs(eggButtons) do btn:Destroy() end
    table.clear(eggButtons)

    -- Sort eggs alphabetically for a cleaner interface
    local sortedEggNames = {}
    for eggName, _ in pairs(EGGS) do
        table.insert(sortedEggNames, eggName)
    end
    table.sort(sortedEggNames)

    for _, eggName in ipairs(sortedEggNames) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -6, 0, 26)
        b.BackgroundColor3 = (selectedEgg == eggName) and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(34, 34, 40)
        b.TextColor3 = Color3.fromRGB(230, 230, 240)
        b.Text = "   " .. eggName
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 11
        b.BorderSizePixel = 0
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = eggScroll
        eggButtons[eggName] = b
        
        b.MouseButton1Click:Connect(function()
            for _, btn in pairs(eggButtons) do btn.BackgroundColor3 = Color3.fromRGB(34, 34, 40) end
            selectedEgg = eggName
            Config.SELECTED_EGG = eggName
            saveConfig()
            b.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        end)
    end
    eggScroll.CanvasSize = UDim2.new(0, 0, 0, eggLayout.AbsoluteContentSize.Y + 5)
end

-- ======================================
--   HTTP & UTILITY METHODS
-- ======================================
local function safeRequest(options)
    local reqFunc = request or http_request or (syn and syn.request)
    return reqFunc and reqFunc(options) or nil
end

local function formatCommas(n)
    n = tonumber(n) or 0
    local s = tostring(math.floor(n))
    while true do
        local new, k = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        s = new
        if k == 0 then break end
    end
    return s
end

local function safeNum(v) return v and formatCommas(v) or "0" end
local function getRoot() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
local function getHumanoid() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") end
local function setWalkSpeed(speed) local hum = getHumanoid() if hum then hum.WalkSpeed = speed end end
local function teleportTo(pos) local root = getRoot() if root and pos then root.CFrame = CFrame.new(pos) end end

local function cleanPetSlug(petName)
    local base = string.lower(petName)
    return base:gsub("%s+", "-")
end

local function getThumbnail(petName)
    return petName and "https://cdn.bgsi.gg/items/" .. cleanPetSlug(petName) .. ".png" or nil
end

local function getChanceText(petName)
    if not petName then return "1 in 1" end
    local url = "https://api.bgsi.gg/api/items/" .. cleanPetSlug(petName)
    local ok, response = pcall(function() return safeRequest({ Url = url, Method = "GET" }) end)
    if ok and response and response.StatusCode == 200 then
        local rawData = HttpService:JSONDecode(response.Body)
        if rawData and rawData.pet and rawData.pet.chance then
            local percentChance = tonumber(rawData.pet.chance)
            if percentChance and percentChance > 0 then
                return "1 in " .. formatCommas(math.floor((1 / (percentChance / 100)) + 0.5))
            end
        end
    end
    return "1 in 1"
end

local function getExists(petName)
    local ok, result = pcall(function() return RemoteFunction:InvokeServer("GetExisting", petName) end)
    return ok and result and (tonumber(result) or result) or "0"
end

-- ======================================
--   DISCORD WEBHOOK PIPELINE
-- ======================================
local function processWebhookQueue()
    if webhookProcessing then return end
    webhookProcessing = true
    task.spawn(function()
        while #webhookQueue > 0 and scriptActive do
            local payload = table.remove(webhookQueue, 1)
            pcall(function()
                safeRequest({
                    Url = Config.WEBHOOK_URL,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode(payload)
                })
            end)
            task.wait(1)
        end
        webhookProcessing = false
    end)
end

local function buildAndQueueEmbed(rawPetName, petData, extras)
    if not Config.WEBHOOK_URL or Config.WEBHOOK_URL == "" then return end
    
    local variantPrefix = ""
    if extras.Shiny and extras.Mythic then variantPrefix = "Shiny Mythic "
    elseif extras.Shiny then variantPrefix = "Shiny "
    elseif extras.Mythic then variantPrefix = "Mythic "
    end
    if extras.XL then variantPrefix = variantPrefix .. "XL " end

    local fullPetName = variantPrefix .. rawPetName
    local chanceText = getChanceText(fullPetName)
    local exists = getExists(fullPetName)

    local bubbles = petData.Stats and petData.Stats.Bubbles
    local coins = petData.Stats and petData.Stats.Coins
    local gems = petData.Stats and petData.Stats.Gems
    local tag = petData.Tag or "Unknown Event"

    local titleString = "<a:dog:1361821088954454259> " .. fullPetName .. " " .. chanceText .. " Hatched!"
    local valueString = table.concat({
        "<:bust_in_silhouette:1364067337069662259> Username: ||" .. LocalPlayer.Name .. "||",
        "<:egg:1377264232915013673> Rarity: **" .. tostring(petData.Rarity) .. "**",
        "<:information_source:1411581375995318362> **" .. tostring(tag) .. "**",
        "<:purple_circle:1363755750828019774> Bubbles: **x" .. safeNum(bubbles) .. "**",
        "<:coin:1364066009677303818> Coins: **x" .. safeNum(coins) .. "**",
        "<:gem:1363755998401269854> Gems: **x" .. safeNum(gems) .. "**",
        "",
        " > **<:star2:1510913945123291176> " .. safeNum(exists) .. " Exists**",
        "**Server Id**:",
        "```" .. tostring(game.JobId) .. "```"
    }, "\n")

    local mentionContent = Config.DISCORD_PING_ID ~= "" and "<@" .. Config.DISCORD_PING_ID .. ">" or ""

    local payload = {
        content = mentionContent,
        embeds = {{
            title = titleString,
            color = 16711680,
            timestamp = DateTime.now():ToIsoDate(),
            fields = {{ name = "", value = valueString, inline = false }}
        }}
    }

    local thumb = getThumbnail(fullPetName)
    if thumb then payload.embeds[1].thumbnail = { url = thumb } end

    table.insert(webhookQueue, payload)
    processWebhookQueue()
end

-- ======================================
--   UNBRANDED MODERN INTERFACE
-- ======================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CleanHubUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 560, 0, 390)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 9)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
sidebar.BorderSizePixel = 0
sidebar.Parent = frame
local sbCorner = Instance.new("UICorner", sidebar)
sbCorner.CornerRadius = UDim.new(0, 9)

local sbPatch = Instance.new("Frame")
sbPatch.Size = UDim2.new(0, 15, 1, 0)
sbPatch.Position = UDim2.new(1, -15, 0, 0)
sbPatch.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
sbPatch.BorderSizePixel = 0
sbPatch.Parent = sidebar

local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(1, 0, 0, 50)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "" 
logoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextSize = 13
logoLabel.Parent = sidebar

local navList = Instance.new("Frame")
navList.Size = UDim2.new(1, 0, 1, -60)
navList.Position = UDim2.new(0, 0, 0, 50)
navList.BackgroundTransparency = 1
navList.Parent = sidebar

local navLayout = Instance.new("UIListLayout")
navLayout.Padding = UDim.new(0, 4)
navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
navLayout.Parent = navList

local function createSideNavButton(name, iconText)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 125, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    btn.TextColor3 = Color3.fromRGB(155, 155, 165)
    btn.Text = "  " .. iconText .. "  " .. name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Parent = navList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    return btn
end

local mainTabBtn    = createSideNavButton("Main", "🏠")
local eggTabBtn     = createSideNavButton("Eggs", "🥚")
local enchantTabBtn = createSideNavButton("Enchant", "🔮")
local questsTabBtn  = createSideNavButton("Quests", "📜")
local shrineTabBtn  = createSideNavButton("Shrines", "⛩️")
local settingsTabBtn= createSideNavButton("Settings", "⚙️")

local contentPane = Instance.new("Frame")
contentPane.Size = UDim2.new(1, -155, 1, -20)
contentPane.Position = UDim2.new(0, 147, 0, 10)
contentPane.BackgroundTransparency = 1
contentPane.Parent = frame

local function createViewPage()
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 4
    p.Visible = false
    p.Parent = contentPane
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = p
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    return p
end

local mainPage     = createViewPage()
local eggPage      = createViewPage()
local enchantPage  = createViewPage()
local questsPage   = createViewPage()
local shrinePage   = createViewPage()
local settingsPage = createViewPage()

local function switchTab(activePage, activeBtn)
    mainPage.Visible, eggPage.Visible, enchantPage.Visible, questsPage.Visible, shrinePage.Visible, settingsPage.Visible = false, false, false, false, false, false
    
    local buttons = {mainTabBtn, eggTabBtn, enchantTabBtn, questsTabBtn, shrineTabBtn, settingsTabBtn}
    for _, btn in ipairs(buttons) do
        btn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        btn.TextColor3 = Color3.fromRGB(155, 155, 165)
    end
    
    activePage.Visible = true
    activeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
    activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end

mainTabBtn.MouseButton1Click:Connect(function() switchTab(mainPage, mainTabBtn) end)
eggTabBtn.MouseButton1Click:Connect(function() switchTab(eggPage, eggTabBtn) end)
enchantTabBtn.MouseButton1Click:Connect(function() switchTab(enchantPage, enchantTabBtn) end)
questsTabBtn.MouseButton1Click:Connect(function() switchTab(questsPage, questsTabBtn) end)
shrineTabBtn.MouseButton1Click:Connect(function() switchTab(shrinePage, shrineTabBtn) end)
settingsTabBtn.MouseButton1Click:Connect(function() switchTab(settingsPage, settingsTabBtn) end)

-- ======================================
--   COMPACT CONTENT CARD SUB-PANELS
-- ======================================
local function createSectionCard(titleText, parent, height)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, height or 110)
    card.BackgroundColor3 = Color3.fromRGB(27, 27, 30)
    card.BorderSizePixel = 0
    card.Parent = parent
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -12, 0, 24)
    titleLbl.Position = UDim2.new(0, 8, 0, 2)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = titleText
    titleLbl.TextColor3 = Color3.fromRGB(140, 140, 150)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 10
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = card
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 1, -28)
    container.Position = UDim2.new(0, 8, 0, 24)
    container.BackgroundTransparency = 1
    container.Parent = card
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = container
    
    return container
end

local function createFormRowInput(labelStr, placeholder, default, parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 120, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelStr
    lbl.TextColor3 = Color3.fromRGB(175, 175, 185)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -125, 1, 0)
    box.Position = UDim2.new(0, 125, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderText = placeholder
    box.Text = default
    box.Font = Enum.Font.Gotham
    box.TextSize = 11
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Parent = row
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    
    return box
end

local function createToggleBtn(text, color, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

-- ======================================
--   MAIN PAGE PANEL
-- ======================================
local statsCard = createSectionCard("MONITOR STATISTICS", mainPage, 65)
local counterLabel = Instance.new("TextLabel")
counterLabel.Size = UDim2.new(1, 0, 0, 14)
counterLabel.BackgroundTransparency = 1
counterLabel.Text = "Eggs Hatched: 0"
counterLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
counterLabel.Font = Enum.Font.GothamMedium
counterLabel.TextSize = 12
counterLabel.TextXAlignment = Enum.TextXAlignment.Left
counterLabel.Parent = statsCard

local rateLabel = Instance.new("TextLabel")
rateLabel.Size = UDim2.new(1, 0, 0, 14)
rateLabel.BackgroundTransparency = 1
rateLabel.Text = "Hatch Rate: 0 / m"
rateLabel.TextColor3 = Color3.fromRGB(130, 170, 230)
rateLabel.Font = Enum.Font.GothamMedium
rateLabel.TextSize = 11
rateLabel.TextXAlignment = Enum.TextXAlignment.Left
rateLabel.Parent = statsCard

local loopCard = createSectionCard("AUTOMATION CONTROLS", mainPage, 135)
local hatchBtn     = createToggleBtn("Auto Hatch Core: OFF", Color3.fromRGB(38, 38, 44), loopCard)
local teleportBtn  = createToggleBtn("Teleport Loop: OFF", Color3.fromRGB(38, 38, 44), loopCard)
local eSpamBtn     = createToggleBtn("Key E Spam: OFF", Color3.fromRGB(38, 38, 44), loopCard)

local extraCard = createSectionCard("SQUAD POSITIONING", mainPage, 65)
local savePosBtn   = createToggleBtn("Save Position Anchor", Color3.fromRGB(80, 70, 105), extraCard)

-- ======================================
--   EGGS SELECTION PAGE
-- ======================================
local selectionCard = createSectionCard("HARDCODED CHOSEN EGGS", eggPage, 330)

eggScroll = Instance.new("ScrollingFrame")
eggScroll.Size = UDim2.new(1, 0, 1, -4)
eggScroll.BackgroundTransparency = 1
eggScroll.ScrollBarThickness = 3
eggScroll.BorderSizePixel = 0
eggScroll.Parent = selectionCard

eggLayout = Instance.new("UIListLayout")
eggLayout.Padding = UDim.new(0, 3)
eggLayout.Parent = eggScroll

-- Build list instantly from positions table
populateEggUI()

-- ======================================
--   ENCHANT CONFIGURATIONS PAGE
-- ======================================
local enchantCard = createSectionCard("ENCHANT CONFIGURATIONS", enchantPage, 90)
local enchantBtn = createToggleBtn("Auto Enchant Squad: OFF", Color3.fromRGB(38, 38, 44), enchantCard)

-- ======================================
--   QUEST MANAGEMENT PAGE
-- ======================================
local questsCard = createSectionCard("ACTIVE TRACKED QUESTS", questsPage, 330)

questScroll = Instance.new("ScrollingFrame")
questScroll.Size = UDim2.new(1, 0, 1, -4)
questScroll.BackgroundTransparency = 1
questScroll.ScrollBarThickness = 3
questScroll.BorderSizePixel = 0
questScroll.Parent = questsCard

questLayout = Instance.new("UIListLayout")
questLayout.Padding = UDim.new(0, 5)
questLayout.Parent = questScroll

local function updateQuestDisplay()
    if not scriptActive or not questScroll then return end
    questScroll:ClearAllChildren()
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = questScroll

    local data = LocalData:Get()
    if data and data.Quests then
        for qName, qData in pairs(data.Quests) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -6, 0, 36)
            row.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
            row.BorderSizePixel = 0
            row.Parent = questScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -12, 1, 0)
            lbl.Position = UDim2.new(0, 6, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = row

            local currentVal = qData.Amount or 0
            local targetVal = qData.Target or 1
            lbl.Text = tostring(qName) .. ": " .. formatCommas(currentVal) .. " / " .. formatCommas(targetVal)
        end
    end
    questScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 5)
end

-- ======================================
--   SHRINES CONFIG PAGE
-- ======================================
local permCard = createSectionCard("PERMANENT SHRINE BUFFS", shrinePage, 160)
local permItemInput = createFormRowInput("Donation Type:", "Lucky / Potion", "Lucky", permCard)
local permTierInput = createFormRowInput("Rarity Tier:", "Item Tier", "6", permCard)
local permAmtInput  = createFormRowInput("Sacrifice Qty:", "Quantity", "400", permCard)
local permEggInput  = createFormRowInput("Buff Target Egg:", "Egg Name", "Common Egg", permCard)
local togglePermShrineBtn = createToggleBtn("Permanent Shrine: OFF", Color3.fromRGB(38, 38, 44), permCard)

local timedCard = createSectionCard("TIMED SHRINE BUFFS", shrinePage, 185)
local timedTypeInput = createFormRowInput("Bubble Gift Type:", "Potion / Pet", "Potion", timedCard)
local timedNameInput = createFormRowInput("Bubble Item Id:", "Item Name", "Lucky", timedCard)
local timedTierInput = createFormRowInput("Bubble Item Tier:", "Level Tier", "1", timedCard)
local timedAmtInput  = createFormRowInput("Bubble Item Qty:", "Sacrifice Qty", "500", timedCard)
local timedDreamInput = createFormRowInput("Dreamer Dust Qty:", "Dust Qty", "15", timedCard)
local toggleTimedShrineBtn = createToggleBtn("Automate Timed Shrines: OFF", Color3.fromRGB(38, 38, 44), timedCard)

-- ======================================
--   SETTINGS & INTEGRATIONS PAGE
-- ======================================
local urlCard = createSectionCard("INTEGRATION METRICS", settingsPage, 90)
local webUrlInput = createFormRowInput("Webhook URL:", "Discord Link...", Config.WEBHOOK_URL, urlCard)
local pingIdInput = createFormRowInput("Ping User ID:", "Discord Snowflake...", Config.DISCORD_PING_ID, urlCard)

local diagnosticCard = createSectionCard("DIAGNOSTICS", settingsPage, 60)
local testWebBtn = createToggleBtn("Send Integration Test Link", Color3.fromRGB(110, 60, 150), diagnosticCard)

webUrlInput.FocusLost:Connect(function() Config.WEBHOOK_URL = webUrlInput.Text saveConfig() end)
pingIdInput.FocusLost:Connect(function() Config.DISCORD_PING_ID = pingIdInput.Text saveConfig() end)

local envCard = createSectionCard("HARDWARE PERFORMANCE", settingsPage, 60)
local fpsInput = createFormRowInput("Limit Client FPS:", "FPS Target", Config.FPS_CAP, envCard)

local keysCard = createSectionCard("KEYBIND MANAGER", settingsPage, 60)
local bindBtn = createToggleBtn("Current Bind: " .. Config.TOGGLE_KEY, Color3.fromRGB(38, 38, 44), keysCard)

local termCard = createSectionCard("TERMINATION", settingsPage, 60)
local exitBtn = createToggleBtn("End Script Session", Color3.fromRGB(150, 40, 45), termCard)

-- ======================================
--   KEYBIND CONTEXT HANDLERS
-- ======================================
local listeningForBind = false
bindBtn.MouseButton1Click:Connect(function()
    listeningForBind = true
    bindBtn.Text = "Press any key..."
    bindBtn.BackgroundColor3 = Color3.fromRGB(90, 50, 50)
end)

local inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not scriptActive then return end
    if listeningForBind then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            listeningForBind = false
            local keyName = input.KeyCode.Name
            Config.TOGGLE_KEY = keyName
            saveConfig()
            bindBtn.Text = "Current Bind: " .. keyName
            bindBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
        end
    else
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == Config.TOGGLE_KEY then
            uiVisible = not uiVisible
            frame.Visible = uiVisible
        end
    end
end)
table.insert(connections, inputConnection)

local function unloadScript()
    scriptActive = false
    running = false
    teleporting = false
    eSpamming = false
    autoPermanentShrine = false
    autoTimedShrines = false
    autoEnchanting = false
    
    if hatchThread then pcall(function() task.cancel(hatchThread) end) end
    if teleportThread then pcall(function() task.cancel(teleportThread) end) end
    if eSpamThread then pcall(function() task.cancel(eSpamThread) end) end
    if enchantThread then pcall(function() task.cancel(enchantThread) end) end
    if permShrineThread then pcall(function() task.cancel(permShrineThread) end) end
    if timedShrineThread then pcall(function() task.cancel(timedShrineThread) end) end
    for _, t in ipairs(loopThreads) do pcall(function() task.cancel(t) end) end
    for _, c in ipairs(connections) do if c and c.Connected then c:Disconnect() end end
    
    setWalkSpeed(16)
    screenGui:Destroy()
end
exitBtn.MouseButton1Click:Connect(unloadScript)

local function updateHatchDisplays()
    if not scriptActive then return end
    counterLabel.Text = "Eggs Hatched: " .. formatCommas(eggsHatched)
    local elapsed = os.time() - startTime
    rateLabel.Text = (elapsed > 0 and eggsHatched > 0) and ("Hatch Rate: " .. formatCommas((eggsHatched / elapsed) * 60) .. " / m") or "Hatch Rate: 0 / m"
end

local function applyFpsLimit(valStr)
    local num = tonumber(valStr) or 60
    if setfpscap then setfpscap(num) end
end
fpsInput.FocusLost:Connect(function() Config.FPS_CAP = fpsInput.Text saveConfig() applyFpsLimit(Config.FPS_CAP) end)
applyFpsLimit(Config.FPS_CAP)

-- ======================================
--   INTELLIGENT ENCHANT ENGINE HANDLERS
-- ======================================
local TARGET_ENCHANTS = {
    ["ultra-roller"] = true,
    ["secret-hunter"] = true
}
local COOLDOWN_BETWEEN_REROLLS = 0.25

local function findPetById(petId)
    local playerData = LocalData:Get()
    if not (playerData and playerData.Pets) then return nil end
    
    local crystals = playerData.Powerups and playerData.Powerups["Shadow Crystal"] or 0
    if crystals <= 0 then
        return nil, "NoCrystals"
    end

    for _, pet in ipairs(playerData.Pets) do
        if pet and pet.Id == petId then return pet end
    end
    return nil
end

local function enchantPetWithCrystals(petId)    
    while autoEnchanting and scriptActive do
        local currentPet, status = findPetById(petId)
        
        if not currentPet then 
            if status == "NoCrystals" then 
                warn("You do not have enough Shadow Crystals")
                return false
            end
            warn("Lost pet data: " .. petId)
            task.wait(1)
            continue
        end
        
        local enchants = currentPet.Enchants or {}
        
        local slot1 = enchants[1] and enchants[1].Id
        local slot2 = enchants[2] and enchants[2].Id
        
        local hasTarget1 = slot1 and TARGET_ENCHANTS[slot1]
        local hasTarget2 = slot2 and TARGET_ENCHANTS[slot2]
        
        if hasTarget1 and hasTarget2 and slot1 ~= slot2 then
            return true
        end
        
        if hasTarget1 then
            RemoteEvent:FireServer("UseShadowCrystal", petId, 1)
        elseif hasTarget2 then
            RemoteEvent:FireServer("UseShadowCrystal", petId, 2)
        else
            RemoteEvent:FireServer("UseShadowCrystal", petId, nil)
        end
        
        task.wait(COOLDOWN_BETWEEN_REROLLS)
    end
    return false
end

enchantBtn.MouseButton1Click:Connect(function()
    if autoEnchanting then
        autoEnchanting = false
        if enchantThread then task.cancel(enchantThread) enchantThread = nil end
        enchantBtn.Text = "Auto Enchant Squad: OFF"
        enchantBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    else
        autoEnchanting = true
        enchantBtn.Text = "Auto Enchant Squad: ON"
        enchantBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        enchantThread = task.spawn(function()
            if not LocalData:IsReady() then LocalData.DataReady:Wait() end
            
            while autoEnchanting and scriptActive do
                local playerData = LocalData:Get()
                local teamPetIds = nil
                
                local equippedTeamIndex = playerData.TeamEquipped
                if equippedTeamIndex then
                    local equippedTeam = playerData.Teams and playerData.Teams[equippedTeamIndex]
                    if equippedTeam and equippedTeam.Pets and #equippedTeam.Pets > 0 then
                        teamPetIds = equippedTeam.Pets
                    end
                end
                
                if teamPetIds then
                    for i, petId in ipairs(teamPetIds) do
                        if not autoEnchanting or not scriptActive then break end
                        local petData = findPetById(petId)
                        
                        if petData and petData.Shiny then
                            local success = enchantPetWithCrystals(petId)
                            if not success then
                                break
                            end
                        end
                        if i < #teamPetIds then task.wait(0.5) end
                    end
                end
                task.wait(2)
            end
        end)
    end
end)

-- Shrine Executions
local function loopPermanentShrineAction()
    local item = permItemInput.Text
    local tier = tonumber(permTierInput.Text) or 6
    local amt  = tonumber(permAmtInput.Text) or 400
    local egg  = permEggInput.Text

    pcall(function() RemoteModule:InvokeServer("DonateToPermanentShrine", item, tier, amt) end)
    task.wait(1)
    for cycle = 1, 2 do
        if not autoPermanentShrine or not scriptActive then break end
        pcall(function() RemoteEvent:FireServer("ClaimPermanentShrineBuff", egg) end)
        task.wait(1)
    end
end

togglePermShrineBtn.MouseButton1Click:Connect(function()
    if autoPermanentShrine then
        autoPermanentShrine = false
        if permShrineThread then task.cancel(permShrineThread) permShrineThread = nil end
        togglePermShrineBtn.Text = "Permanent Shrine: OFF"
        togglePermShrineBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    else
        autoPermanentShrine = true
        togglePermShrineBtn.Text = "Permanent Shrine: ON"
        togglePermShrineBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        permShrineThread = task.spawn(function()
            while autoPermanentShrine and scriptActive do
                loopPermanentShrineAction()
                task.wait(10)
            end
        end)
    end
end)

local function processTimedShrinesActivation()
    local bShrineData = {
        Level = tonumber(timedTierInput.Text) or 1,
        Type = timedTypeInput.Text,
        Name = timedNameInput.Text,
        Amount = tonumber(timedAmtInput.Text) or 500
    }
    local dAmount = tonumber(timedDreamInput.Text) or 15
    pcall(function() RemoteModule:InvokeServer("DonateToShrine", bShrineData) end)
    task.wait(0.5)
    pcall(function() RemoteModule:InvokeServer("DonateToDreamerShrine", dAmount) end)
end

toggleTimedShrineBtn.MouseButton1Click:Connect(function()
    if autoTimedShrines then
        autoTimedShrines = false
        if timedShrineThread then task.cancel(timedShrineThread) timedShrineThread = nil end
        toggleTimedShrineBtn.Text = "Automate Timed Shrines: OFF"
        toggleTimedShrineBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    else
        autoTimedShrines = true
        toggleTimedShrineBtn.Text = "Automate Timed Shrines: ON"
        toggleTimedShrineBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        timedShrineThread = task.spawn(function()
            processTimedShrinesActivation()
            while autoTimedShrines and scriptActive do
                task.wait(43600)
                if autoTimedShrines and scriptActive then processTimedShrinesActivation() end
            end
        end)
    end
end)

-- ======================================
--   FORCE HIDE HATCH ANIMATION ENGINE
-- ======================================
local function cleanHatchUI(child)
    if child.Name == "HatchEgg" or child.Name == "Hatch" then
        child.Enabled = false
        local mainFrame = child:FindFirstChildOfClass("Frame")
        if mainFrame then mainFrame.Visible = false end
        child:GetPropertyChangedSignal("Enabled"):Connect(function()
            if child.Enabled then child.Enabled = false end
        end)
    end
end

for _, c in ipairs(LocalPlayer.PlayerGui:GetChildren()) do cleanHatchUI(c) end
local uiConnection = LocalPlayer.PlayerGui.ChildAdded:Connect(cleanHatchUI)
table.insert(connections, uiConnection)

local success, HatchingModule = pcall(function() return require(ReplicatedStorage.Client.Effects.HatchEgg) end)
if success and HatchingModule and type(HatchingModule) == "table" and HatchingModule.Play then
    local originalPlay = HatchingModule.Play
    HatchingModule.Play = function(self, data)
        if not scriptActive then return originalPlay(self, data) end
        
        if type(data) == "table" and data.Pets then
            eggsHatched = eggsHatched + #data.Pets
            task.spawn(updateHatchDisplays)
            
            for _, petData in ipairs(data.Pets) do
                if type(petData) == "table" and petData.Pet and petData.Pet.Name then
                    local pet = petData.Pet
                    local ok, petInfo = pcall(function() return Pets[pet.Name] end)
                    if ok and petInfo then
                        local r = petInfo.Rarity
                        if r == "Secret" or r == "Celestial" or r == "Infinity" or r == "Void" then
                            task.spawn(function()
                                buildAndQueueEmbed(pet.Name, petInfo, {Shiny = pet.Shiny, Mythic = pet.Mythic, XL = pet.XL})
                            end)
                        end
                    end
                end
            end
        end
        return 
    end
end

-- Controls Interaction Loops
local function startTeleport()
    if not selectedEgg or not EGGS[selectedEgg] then return end
    teleporting = true
    teleportBtn.Text = "Teleport Loop: ON"
    teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    teleportThread = task.spawn(function()
        while teleporting and scriptActive do 
            if EGGS[selectedEgg] then teleportTo(EGGS[selectedEgg]) end
            task.wait(0.5) 
        end
    end)
end
local function stopTeleport()
    teleporting = false
    if teleportThread then task.cancel(teleportThread) teleportThread = nil end
    teleportBtn.Text = "Teleport Loop: OFF"
    teleportBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
end
teleportBtn.MouseButton1Click:Connect(function() if teleporting then stopTeleport() else startTeleport() end end)

local function startHatch()
    if not selectedEgg or not EGGS[selectedEgg] then return end
    running = true
    hatchBtn.Text = "Auto Hatch Core: ON"
    hatchBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    setWalkSpeed(WALKSPEED)
    hatchThread = task.spawn(function()
        while running and scriptActive do
            if EGGS[selectedEgg] then
                -- Lock positioning
                teleportTo(EGGS[selectedEgg])
                
                -- Fast loop Remote invocation
                RemoteEvent:FireServer("HatchEgg", selectedEgg, HATCH_AMOUNT)
                
                -- Virtual Input Intermittent E+R input emulation sequence
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
            end
            task.spawn(updateHatchDisplays)
            task.wait(0.05)
        end
    end)
end
local function stopHatch()
    running = false
    if hatchThread then task.cancel(hatchThread) hatchThread = nil end
    hatchBtn.Text = "Auto Hatch Core: OFF"
    hatchBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    setWalkSpeed(16)
end
hatchBtn.MouseButton1Click:Connect(function() if running then stopHatch() else startHatch() end end)

eSpamBtn.MouseButton1Click:Connect(function()
    if eSpamming then
        eSpamming = false
        if eSpamThread then task.cancel(eSpamThread) eSpamThread = nil end
        eSpamBtn.Text = "Key E Spam: OFF"
        eSpamBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    else
        eSpamming = true
        eSpamBtn.Text = "Key E Spam: ON"
        eSpamBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        eSpamThread = task.spawn(function()
            while eSpamming and scriptActive do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                task.wait(0.05)
            end
        end)
    end
end)

savePosBtn.MouseButton1Click:Connect(function()
    local root = getRoot()
    if root then
        savedBubblePos = root.Position
        savePosBtn.Text = "Position Anchored! ✅"
        savePosBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(1.5)
        if not scriptActive then return end
        savePosBtn.Text = "Save Position Anchor"
        savePosBtn.BackgroundColor3 = Color3.fromRGB(80, 70, 105)
    end
end)

-- Test Embed Generator
testWebBtn.MouseButton1Click:Connect(function()
    testWebBtn.Text = "Simulating Premium Drop..."
    local petPool = {}
    for name, data in pairs(Pets) do table.insert(petPool, {name = name, data = data}) end
    
    local selectedSample = #petPool > 0 and petPool[math.random(1, #petPool)] or nil
    local petName = selectedSample and selectedSample.name or "Hyperwave Doggy"
    local petData = selectedSample and selectedSample.data or {
        Rarity = "Secret",
        Tag = "600M Event",
        Stats = { Bubbles = 14000, Coins = 7750, Gems = 175 }
    }
    
    local randomShiny = true
    local randomMythic = false
    local randomXL = false

    task.spawn(function()
        buildAndQueueEmbed(petName, petData, {Shiny = randomShiny, Mythic = randomMythic, XL = randomXL})
    end)

    task.wait(1)
    if not scriptActive then return end
    testWebBtn.Text = "Test Broadcast Complete! ✅"
    task.wait(1.5)
    if not scriptActive then return end
    testWebBtn.Text = "Send Integration Test Link"
end)

-- Draggable Interface Core
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
sidebar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
sidebar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging and scriptActive then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Initialization Loops
local loop1 = task.spawn(function() while scriptActive do task.wait(1) updateHatchDisplays() end end)
table.insert(loopThreads, loop1)

local loop2 = task.spawn(function() while scriptActive do task.wait(2.5) updateQuestDisplay() end end)
table.insert(loopThreads, loop2)

switchTab(mainPage, mainTabBtn)
if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
setWalkSpeed(WALKSPEED)
