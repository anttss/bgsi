local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
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
local REJOIN_STATE_FILE = "Hub_Rejoin_State.json"

local function getDefaults()
    return {
        WEBHOOK_URL = "",
        DISCORD_PING_ID = "",
        TOGGLE_KEY = "RightShift",
        FPS_CAP = "60",
        SELECTED_EGG = "Flame Egg",
        HATCH_DELAY = "0.05",
        AUTO_REJOIN = "false"
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

local function boolValue(value)
    if value == true then return true end
    if value == false or value == nil then return false end
    local text = string.lower(tostring(value))
    return text == "true" or text == "1" or text == "yes" or text == "on"
end

local function encodeVector3(pos)
    if typeof(pos) ~= "Vector3" then return nil end
    return { X = pos.X, Y = pos.Y, Z = pos.Z }
end

local function decodeVector3(data)
    if type(data) ~= "table" then return nil end
    local x, y, z = tonumber(data.X), tonumber(data.Y), tonumber(data.Z)
    if not x or not y or not z then return nil end
    return Vector3.new(x, y, z)
end

local function loadRejoinState()
    if not (readfile and isfile and isfile(REJOIN_STATE_FILE)) then return nil end
    local ok, content = pcall(function() return readfile(REJOIN_STATE_FILE) end)
    if not ok or not content or content == "" then return nil end
    local ok2, decoded = pcall(function() return HttpService:JSONDecode(content) end)
    if ok2 and type(decoded) == "table" then return decoded end
    return nil
end

local persistedRejoinState = loadRejoinState()
if persistedRejoinState and type(persistedRejoinState.Config) == "table" and boolValue(persistedRejoinState.AutoRejoinEnabled) then
    for k, v in pairs(persistedRejoinState.Config) do
        Config[k] = v
    end
end

-- ======================================
--   RESTORED HARDCODED LOOKUP METADATA
-- ======================================
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

local HATCH_AMOUNT = 12
local WALKSPEED = 75
local DEFAULT_HATCH_EGG = "4x Luck Egg"
local QUEST_FALLBACK_EGG = "Common Egg"
local HATCH_DELAY = tonumber(Config.HATCH_DELAY) or 0.05
if HATCH_DELAY <= 0 then HATCH_DELAY = 0.05 end

local eggButtons = {}

local running = false
local teleporting = false
local eSpamming = false
local autoEnchanting = false
local autoPermanentShrine = false
local autoTimedShrines = false
local autoSeasonPass = false
local autoPresentRain = false
local autoQuesting = false
local uiVisible = true
local scriptActive = true

local resumeStateActive = persistedRejoinState and boolValue(persistedRejoinState.AutoRejoinEnabled)
local savedSessionElapsed = resumeStateActive and (tonumber(persistedRejoinState.SessionElapsed) or 0) or 0

local eggsHatched = resumeStateActive and (tonumber(persistedRejoinState.EggsHatched) or 0) or 0
local secretPetsHatched = resumeStateActive and (tonumber(persistedRejoinState.SecretPetsHatched) or 0) or 0
local rejoinCount = resumeStateActive and (tonumber(persistedRejoinState.Rejoins) or 0) or 0
if resumeStateActive and persistedRejoinState and persistedRejoinState.Reason == "scheduled_rejoin" then
    rejoinCount = rejoinCount + 1
end
local selectedEgg = Config.SELECTED_EGG
local startTime = os.time() - savedSessionElapsed

local hatchThread, teleportThread, eSpamThread, enchantThread, permShrineThread, timedShrineThread
local seasonPassThread, presentRainThread, autoQuestThread, autoRejoinThread
local loopThreads = {}
local webhookQueue = {}
local webhookProcessing = false
local savedBubblePos = nil
local connections = {}

-- UI declaration forward references
local eggScroll, eggLayout, questScroll, questLayout

-- Generates interface selection rows directly from the hardcoded coordinate lookups
local function buildStaticEggUI()
    if not eggScroll then return end
    
    local sortedNames = {}
    for eggName in pairs(EGGS) do table.insert(sortedNames, eggName) end
    table.sort(sortedNames)

    for _, name in ipairs(sortedNames) do
        if not eggButtons[name] then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -6, 0, 26)
            b.BackgroundColor3 = (selectedEgg == name) and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(34, 34, 40)
            b.TextColor3 = Color3.fromRGB(230, 230, 240)
            b.Text = "   " .. name
            b.Font = Enum.Font.GothamMedium
            b.TextSize = 11
            b.BorderSizePixel = 0
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Parent = eggScroll
            eggButtons[name] = b
            
            b.MouseButton1Click:Connect(function()
                for _, btn in pairs(eggButtons) do btn.BackgroundColor3 = Color3.fromRGB(34, 34, 40) end
                selectedEgg = name
                Config.SELECTED_EGG = name
                saveConfig()
                b.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            end)
        end
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
    
    local reqFunc = request or http_request or (syn and syn.request)
    if not reqFunc then return "1 in 1" end

    local url = "https://api.bgsi.gg/api/items/" .. cleanPetSlug(petName)
    local ok, response = pcall(function() return reqFunc({ Url = url, Method = "GET" }) end)
    
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

local function queueWebhookMessage(message)
    if not Config.WEBHOOK_URL or Config.WEBHOOK_URL == "" then return end
    table.insert(webhookQueue, { content = tostring(message or "") })
    processWebhookQueue()
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
--   RAYFIELD INTERFACE
-- ======================================
local Rayfield
local Window
local screenGui
local frame
local counterLabel
local rateLabel
local sessionTimeLabel
local hatchBtn
local teleportBtn
local eSpamBtn
local savePosBtn
local seasonPassBtn
local presentRainBtn
local enchantBtn
local permItemInput
local permTierInput
local permAmtInput
local permEggInput
local togglePermShrineBtn
local timedTypeInput
local timedNameInput
local timedTierInput
local timedAmtInput
local timedDreamInput
local toggleTimedShrineBtn
local webUrlInput
local pingIdInput
local testWebBtn
local autoQuestBtn
local fpsInput
local bindBtn
local exitBtn
local questParagraph
local selectedEggLabel
local accountsParagraph
local accountRefreshButton
local accountMiniButton
local accountMiniGui
local accountMiniFrame
local accountMiniBody
local accountMiniText
local accountMiniMinimized = false
local autoRejoinToggle

local startAutoRejoin
local stopAutoRejoin
local saveRejoinState

local function makeSignal()
    local signal = { _callbacks = {} }
    function signal:Connect(callback)
        if type(callback) ~= "function" then
            return { Disconnect = function() end }
        end
        table.insert(self._callbacks, callback)
        local disconnected = false
        return {
            Disconnect = function()
                if disconnected then return end
                disconnected = true
                for i, fn in ipairs(signal._callbacks) do
                    if fn == callback then
                        table.remove(signal._callbacks, i)
                        break
                    end
                end
            end
        }
    end
    function signal:Fire(...)
        for _, callback in ipairs(self._callbacks) do
            task.spawn(callback, ...)
        end
    end
    return signal
end

local function protectCall(fn)
    local ok, result = pcall(fn)
    if ok then return result end
    warn(result)
    return nil
end

local function createButtonProxy(tab, name)
    local clicked = makeSignal()
    local proxy = {
        _text = name,
        _element = nil,
        MouseButton1Click = clicked
    }

    proxy._element = protectCall(function()
        return tab:CreateButton({
            Name = name,
            Callback = function()
                clicked:Fire()
            end,
        })
    end)

    return setmetatable(proxy, {
        __index = function(self, key)
            if key == "Text" then
                return rawget(self, "_text")
            end
            return rawget(self, key)
        end,
        __newindex = function(self, key, value)
            if key == "Text" then
                rawset(self, "_text", tostring(value or ""))
                if self._element and self._element.Set then
                    pcall(function() self._element:Set(rawget(self, "_text")) end)
                end
            elseif key == "BackgroundColor3" then
                rawset(self, key, value)
            else
                rawset(self, key, value)
            end
        end
    })
end

local function createInputProxy(tab, name, current, placeholder, flag)
    local focusLost = makeSignal()
    local proxy = {
        _text = tostring(current or ""),
        _element = nil,
        FocusLost = focusLost
    }

    proxy._element = protectCall(function()
        return tab:CreateInput({
            Name = name,
            CurrentValue = proxy._text,
            PlaceholderText = placeholder or "",
            RemoveTextAfterFocusLost = false,
            Flag = flag,
            Callback = function(text)
                proxy._text = tostring(text or "")
                focusLost:Fire()
            end,
        })
    end)

    return setmetatable(proxy, {
        __index = function(self, key)
            if key == "Text" then
                return rawget(self, "_text")
            end
            return rawget(self, key)
        end,
        __newindex = function(self, key, value)
            if key == "Text" then
                rawset(self, "_text", tostring(value or ""))
                if self._element and self._element.Set then
                    pcall(function() self._element:Set(rawget(self, "_text")) end)
                end
            else
                rawset(self, key, value)
            end
        end
    })
end

local function createToggleProxy(tab, name, current, flag, callback)
    local changed = makeSignal()
    local proxy = {
        _value = current == true,
        _element = nil,
        Changed = changed
    }

    proxy._element = protectCall(function()
        return tab:CreateToggle({
            Name = name,
            CurrentValue = proxy._value,
            Flag = flag,
            Callback = function(value)
                proxy._value = value == true
                changed:Fire(proxy._value)
                if callback then
                    callback(proxy._value)
                end
            end,
        })
    end)

    function proxy:Set(value)
        self._value = value == true
        if self._element and self._element.Set then
            pcall(function() self._element:Set(self._value) end)
        else
            changed:Fire(self._value)
            if callback then callback(self._value) end
        end
    end

    return proxy
end

local function createLabelProxy(tab, text)
    local proxy = {
        _text = tostring(text or ""),
        _element = nil
    }

    proxy._element = protectCall(function()
        return tab:CreateLabel(proxy._text)
    end)

    return setmetatable(proxy, {
        __index = function(self, key)
            if key == "Text" then
                return rawget(self, "_text")
            end
            return rawget(self, key)
        end,
        __newindex = function(self, key, value)
            if key == "Text" then
                rawset(self, "_text", tostring(value or ""))
                if self._element and self._element.Set then
                    pcall(function() self._element:Set(rawget(self, "_text")) end)
                end
            else
                rawset(self, key, value)
            end
        end
    })
end

local function rayNotify(title, content, duration)
    if Rayfield and Rayfield.Notify then
        pcall(function()
            Rayfield:Notify({
                Title = title or "Notice",
                Content = content or "",
                Duration = duration or 4,
            })
        end)
    end
end

local function buildEggList()
    local names = {}
    for eggName in pairs(EGGS) do
        table.insert(names, eggName)
    end
    table.sort(names)
    return names
end

local function createFallbackButton(name)
    local clicked = makeSignal()
    local proxy = { _text = name, MouseButton1Click = clicked }
    return setmetatable(proxy, {
        __index = function(self, key)
            if key == "Text" then return rawget(self, "_text") end
            return rawget(self, key)
        end,
        __newindex = function(self, key, value)
            if key == "Text" then rawset(self, "_text", tostring(value or "")) else rawset(self, key, value) end
        end
    })
end

local function createFallbackInput(current)
    local focusLost = makeSignal()
    local proxy = { _text = tostring(current or ""), FocusLost = focusLost }
    return setmetatable(proxy, {
        __index = function(self, key)
            if key == "Text" then return rawget(self, "_text") end
            return rawget(self, key)
        end,
        __newindex = function(self, key, value)
            if key == "Text" then rawset(self, "_text", tostring(value or "")); focusLost:Fire() else rawset(self, key, value) end
        end
    })
end

local function createFallbackLabel(text)
    local proxy = { _text = tostring(text or "") }
    return setmetatable(proxy, {
        __index = function(self, key)
            if key == "Text" then return rawget(self, "_text") end
            return rawget(self, key)
        end,
        __newindex = function(self, key, value)
            if key == "Text" then rawset(self, "_text", tostring(value or "")) else rawset(self, key, value) end
        end
    })
end

local rayfieldOk = pcall(function()
    Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

local function getRayfieldToggleKeybind()
    local keyName = tostring(Config.TOGGLE_KEY or "RightShift")
    local ok, keyCode = pcall(function()
        return Enum.KeyCode[keyName]
    end)

    if ok and typeof(keyCode) == "EnumItem" then
        return keyCode
    end

    Config.TOGGLE_KEY = "RightShift"
    saveConfig()
    return Enum.KeyCode.RightShift
end

local rayfieldWindowOk = false

if rayfieldOk and Rayfield then
    local createdWindow
    rayfieldWindowOk, createdWindow = pcall(function()
        return Rayfield:CreateWindow({
        Name = "@76yx",
        Icon = 0,
        LoadingTitle = "@76yx",
        LoadingSubtitle = "",
        ShowText = "@76yx",
        Theme = {
            TextColor = Color3.fromRGB(235, 235, 235),
            Background = Color3.fromRGB(18, 18, 18),
            Topbar = Color3.fromRGB(28, 28, 28),
            Shadow = Color3.fromRGB(10, 10, 10),
            NotificationBackground = Color3.fromRGB(22, 22, 22),
            NotificationActionsBackground = Color3.fromRGB(42, 42, 42),
            TabBackground = Color3.fromRGB(30, 30, 30),
            TabStroke = Color3.fromRGB(48, 48, 48),
            TabBackgroundSelected = Color3.fromRGB(42, 42, 42),
            TabTextColor = Color3.fromRGB(190, 190, 190),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
            ElementBackground = Color3.fromRGB(27, 27, 27),
            ElementBackgroundHover = Color3.fromRGB(34, 34, 34),
            SecondaryElementBackground = Color3.fromRGB(22, 22, 22),
            ElementStroke = Color3.fromRGB(50, 50, 50),
            SecondaryElementStroke = Color3.fromRGB(42, 42, 42),
            SliderBackground = Color3.fromRGB(70, 110, 170),
            SliderProgress = Color3.fromRGB(80, 130, 200),
            SliderStroke = Color3.fromRGB(90, 145, 220),
            ToggleBackground = Color3.fromRGB(25, 25, 25),
            ToggleEnabled = Color3.fromRGB(55, 150, 95),
            ToggleDisabled = Color3.fromRGB(90, 90, 90),
            ToggleEnabledStroke = Color3.fromRGB(70, 175, 115),
            ToggleDisabledStroke = Color3.fromRGB(110, 110, 110),
            ToggleEnabledOuterStroke = Color3.fromRGB(70, 70, 70),
            ToggleDisabledOuterStroke = Color3.fromRGB(55, 55, 55),
            DropdownSelected = Color3.fromRGB(34, 34, 34),
            DropdownUnselected = Color3.fromRGB(25, 25, 25),
            InputBackground = Color3.fromRGB(24, 24, 24),
            InputStroke = Color3.fromRGB(58, 58, 58),
            PlaceholderColor = Color3.fromRGB(145, 145, 145)
        },
        ToggleUIKeybind = getRayfieldToggleKeybind(),
        DisableRayfieldPrompts = true,
        DisableBuildWarnings = true,
        ConfigurationSaving = {
            Enabled = false,
            FolderName = nil,
            FileName = "UtilityPanel"
        },
        Discord = {
            Enabled = false,
            Invite = "",
            RememberJoins = true
        },
        KeySystem = false
        })
    end)

    if rayfieldWindowOk then
        Window = createdWindow
    else
        warn("Rayfield CreateWindow failed. Falling back to safe proxy controls.", tostring(createdWindow))
    end
end

if rayfieldOk and Rayfield and rayfieldWindowOk and Window then
    local Tabs = {
        Stats = Window:CreateTab("Stats", 0),
        Main = Window:CreateTab("Main", 0),
        Eggs = Window:CreateTab("Eggs", 0),
        Event = Window:CreateTab("Event", 0),
        Enchant = Window:CreateTab("Enchant", 0),
        Quests = Window:CreateTab("Quests", 0),
        Shrines = Window:CreateTab("Shrines", 0),
        Accounts = Window:CreateTab("Accounts", 0),
        Settings = Window:CreateTab("Settings", 0)
    }

    Tabs.Stats:CreateSection("Hatch Monitor")
    counterLabel = createLabelProxy(Tabs.Stats, "Eggs Hatched: 0")
    rateLabel = createLabelProxy(Tabs.Stats, "Hatch Rate: 0 / m")
    sessionTimeLabel = createLabelProxy(Tabs.Stats, "Session Time: 00:00:00")
    rejoinLabel = createLabelProxy(Tabs.Stats, "Rejoins: " .. formatCommas(rejoinCount))
    selectedEggLabel = createLabelProxy(Tabs.Stats, "Selected Egg: " .. tostring(selectedEgg or "None"))

    Tabs.Main:CreateSection("Automation")
    hatchBtn = createButtonProxy(Tabs.Main, "Auto Hatch Core: OFF")
    teleportBtn = createButtonProxy(Tabs.Main, "Teleport Loop: OFF")
    eSpamBtn = createButtonProxy(Tabs.Main, "Key E Spam: OFF")
    Tabs.Main:CreateDivider()
    Tabs.Main:CreateSection("Position")
    savePosBtn = createButtonProxy(Tabs.Main, "Save Position Anchor")

    Tabs.Eggs:CreateSection("Egg Selection")
    local eggNames = buildEggList()
    createLabelProxy(Tabs.Eggs, "Click an egg below to select it.")

    for _, eggName in ipairs(eggNames) do
        local eggButton = createButtonProxy(Tabs.Eggs, eggName)
        eggButtons[eggName] = eggButton
        eggButton.MouseButton1Click:Connect(function()
            selectedEgg = eggName
            Config.SELECTED_EGG = eggName
            saveConfig()
            if selectedEggLabel then
                selectedEggLabel.Text = "Selected Egg: " .. tostring(eggName)
            end
            rayNotify("Egg Selected", eggName, 2)
        end)
    end

    Tabs.Event:CreateSection("Event")
    seasonPassBtn = createButtonProxy(Tabs.Event, "Auto Claim Season Pass: OFF")
    presentRainBtn = createButtonProxy(Tabs.Event, "Collect Present Rain: OFF")

    Tabs.Enchant:CreateSection("Enchant")
    enchantBtn = createButtonProxy(Tabs.Enchant, "Auto Enchant Squad: OFF")

    Tabs.Quests:CreateSection("Challenge Pass")
    autoQuestBtn = createButtonProxy(Tabs.Quests, "Auto Quest: OFF")
    questParagraph = Tabs.Quests:CreateParagraph({
        Title = "Challenge Pass Quests",
        Content = "Open Challenge Pass UI to load quests."
    })

    Tabs.Shrines:CreateSection("Permanent Shrine")
    permItemInput = createInputProxy(Tabs.Shrines, "Donation Type", "Lucky", "Lucky / Potion", "PermanentShrine_Item")
    permTierInput = createInputProxy(Tabs.Shrines, "Rarity Tier", "6", "Item Tier", "PermanentShrine_Tier")
    permAmtInput = createInputProxy(Tabs.Shrines, "Sacrifice Qty", "400", "Quantity", "PermanentShrine_Amount")
    permEggInput = createInputProxy(Tabs.Shrines, "Buff Target Egg", "Common Egg", "Egg Name", "PermanentShrine_Egg")
    togglePermShrineBtn = createButtonProxy(Tabs.Shrines, "Permanent Shrine: OFF")

    Tabs.Shrines:CreateDivider()
    Tabs.Shrines:CreateSection("Timed Shrines")
    timedTypeInput = createInputProxy(Tabs.Shrines, "Bubble Gift Type", "Potion", "Potion / Pet", "TimedShrine_Type")
    timedNameInput = createInputProxy(Tabs.Shrines, "Bubble Item Id", "Lucky", "Item Name", "TimedShrine_Name")
    timedTierInput = createInputProxy(Tabs.Shrines, "Bubble Item Tier", "1", "Level Tier", "TimedShrine_Tier")
    timedAmtInput = createInputProxy(Tabs.Shrines, "Bubble Item Qty", "500", "Sacrifice Qty", "TimedShrine_Amount")
    timedDreamInput = createInputProxy(Tabs.Shrines, "Dreamer Dust Qty", "15", "Dust Qty", "TimedShrine_Dreamer")
    toggleTimedShrineBtn = createButtonProxy(Tabs.Shrines, "Automate Timed Shrines: OFF")

    Tabs.Accounts:CreateSection("Running Accounts")
    accountsParagraph = Tabs.Accounts:CreateParagraph({
        Title = "Accounts",
        Content = "Loading account stats..."
    })
    accountRefreshButton = createButtonProxy(Tabs.Accounts, "Refresh Accounts")
    accountMiniButton = createButtonProxy(Tabs.Accounts, "Open Mini Accounts Window")

    Tabs.Settings:CreateSection("Webhook")
    webUrlInput = createInputProxy(Tabs.Settings, "Webhook URL", Config.WEBHOOK_URL, "Discord Webhook URL", "WebhookURL_Input")
    pingIdInput = createInputProxy(Tabs.Settings, "Ping User ID", Config.DISCORD_PING_ID, "Discord User ID", "PingID_Input")
    testWebBtn = createButtonProxy(Tabs.Settings, "Send Integration Test Link")

    Tabs.Settings:CreateDivider()
    Tabs.Settings:CreateSection("Client")
    fpsInput = createInputProxy(Tabs.Settings, "FPS Cap", Config.FPS_CAP, "FPS Target", "FPSCap_Input")
    bindBtn = createButtonProxy(Tabs.Settings, "Current Bind: " .. Config.TOGGLE_KEY)

    Tabs.Settings:CreateDivider()
    Tabs.Settings:CreateSection("Session")
    autoRejoinToggle = createToggleProxy(Tabs.Settings, "Auto Rejoin", boolValue(Config.AUTO_REJOIN), "AutoRejoin_Toggle", function(value)
        Config.AUTO_REJOIN = value and "true" or "false"
        saveConfig()
        if startAutoRejoin and stopAutoRejoin then
            if value then
                startAutoRejoin()
            else
                stopAutoRejoin(false)
            end
        end
    end)
    exitBtn = createButtonProxy(Tabs.Settings, "End Script Session")
else
    warn("Rayfield failed to load. UI controls were not created.")
    counterLabel = createFallbackLabel("Eggs Hatched: 0")
    rateLabel = createFallbackLabel("Hatch Rate: 0 / m")
    sessionTimeLabel = createFallbackLabel("Session Time: 00:00:00")
    rejoinLabel = createFallbackLabel("Rejoins: " .. formatCommas(rejoinCount))
    hatchBtn = createFallbackButton("Auto Hatch Core: OFF")
    teleportBtn = createFallbackButton("Teleport Loop: OFF")
    eSpamBtn = createFallbackButton("Key E Spam: OFF")
    savePosBtn = createFallbackButton("Save Position Anchor")
    seasonPassBtn = createFallbackButton("Auto Claim Season Pass: OFF")
    presentRainBtn = createFallbackButton("Collect Present Rain: OFF")
    enchantBtn = createFallbackButton("Auto Enchant Squad: OFF")
    permItemInput = createFallbackInput("Lucky")
    permTierInput = createFallbackInput("6")
    permAmtInput = createFallbackInput("400")
    permEggInput = createFallbackInput("Common Egg")
    togglePermShrineBtn = createFallbackButton("Permanent Shrine: OFF")
    timedTypeInput = createFallbackInput("Potion")
    timedNameInput = createFallbackInput("Lucky")
    timedTierInput = createFallbackInput("1")
    timedAmtInput = createFallbackInput("500")
    timedDreamInput = createFallbackInput("15")
    toggleTimedShrineBtn = createFallbackButton("Automate Timed Shrines: OFF")
    webUrlInput = createFallbackInput(Config.WEBHOOK_URL)
    pingIdInput = createFallbackInput(Config.DISCORD_PING_ID)
    testWebBtn = createFallbackButton("Send Integration Test Link")
    autoQuestBtn = createFallbackButton("Auto Quest: OFF")
    fpsInput = createFallbackInput(Config.FPS_CAP)
    bindBtn = createFallbackButton("Current Bind: " .. Config.TOGGLE_KEY)
    autoRejoinToggle = nil
    exitBtn = createFallbackButton("End Script Session")
    selectedEggLabel = createFallbackLabel("Selected Egg: " .. tostring(selectedEgg or "None"))
    accountsParagraph = createFallbackLabel("Accounts: Rayfield unavailable")
    accountRefreshButton = createFallbackButton("Refresh Accounts")
    accountMiniButton = createFallbackButton("Open Mini Accounts Window")
end

screenGui = {
    Destroy = function()
        if Rayfield and Rayfield.Destroy then
            pcall(function() Rayfield:Destroy() end)
        end
    end
}

frame = setmetatable({ _visible = true }, {
    __index = function(self, key)
        if key == "Visible" then
            return rawget(self, "_visible")
        end
        return rawget(self, key)
    end,
    __newindex = function(self, key, value)
        if key == "Visible" then
            rawset(self, "_visible", value and true or false)
            if Rayfield and Rayfield.SetVisibility then
                pcall(function() Rayfield:SetVisibility(rawget(self, "_visible")) end)
            end
        else
            rawset(self, key, value)
        end
    end
})

-- ======================================
--   CHALLENGE PASS QUEST READER
-- ======================================
local function getChallengePassGui()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local sg = pg:FindFirstChild("ScreenGui")
    return sg and sg:FindFirstChild("ChallengePass")
end

local function getQuestLabel(challengeFrame)
    local content = challengeFrame and challengeFrame:FindFirstChild("Content")
    if content then
        local lbl = content:FindFirstChild("Label")
        if lbl then return lbl.Text end
    end
    return nil
end

local function isQuestCompleted(challengeFrame)
    local completed = challengeFrame and challengeFrame:FindFirstChild("Completed")
    return completed and completed.Visible == true
end

local function getQuestFillPct(challengeFrame)
    local ok, fill = pcall(function()
        return challengeFrame.Content.Bar.Fill
    end)
    if ok and fill then
        return math.clamp(tonumber(fill.Size.X.Scale) or 0, 0, 1)
    end
    return 0
end

local function parseQuestText(text)
    if not text then return nil end
    text = tostring(text):gsub(",", "")

    local blowAmount = text:match("^Blow (%d+) Bubbles$")
    if blowAmount then
        return { type = "Blow", amount = tonumber(blowAmount) }
    end

    local playMins = text:match("[Pp]lay.+(%d+).+[Mm]in")
    if playMins then
        return { type = "Playtime", amount = tonumber(playMins) }
    end

    local genericAmount = text:match("^Hatch (%d+) Eggs$")
    if genericAmount then
        return { type = "Hatch", amount = tonumber(genericAmount), egg = QUEST_FALLBACK_EGG }
    end

    local hatchAmount, eggName = text:match("^Hatch (%d+) (.+) Eggs$")
    if hatchAmount and eggName then
        return { type = "Hatch", amount = tonumber(hatchAmount), egg = eggName .. " Egg" }
    end

    return nil
end

local function getActiveChallenges()
    local cpGui = getChallengePassGui()
    if not cpGui then return {} end

    local ok, list = pcall(function()
        return cpGui.Frame.Challenges.List
    end)
    if not ok or not list then return {} end

    local challenges = {}
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("Frame") and tostring(child.Name):find("bubble%-challenge") then
            local labelText = getQuestLabel(child)
            local parsed = parseQuestText(labelText)
            if parsed then
                table.insert(challenges, {
                    frame = child,
                    text = labelText,
                    completed = isQuestCompleted(child),
                    quest = parsed
                })
            end
        end
    end
    return challenges
end

local function allQuestsCompleted(challenges)
    if #challenges == 0 then return false end
    for _, c in ipairs(challenges) do
        if not isQuestCompleted(c.frame) and getQuestFillPct(c.frame) < 1 then
            return false
        end
    end
    return true
end

local function hasIncompleteChallengeQuests()
    local challenges = getActiveChallenges()
    if #challenges == 0 then return false end

    for _, c in ipairs(challenges) do
        if c and c.frame and not isQuestCompleted(c.frame) and getQuestFillPct(c.frame) < 1 then
            return true
        end
    end

    return false
end

local function shouldHoldMainHatchForQuests()
    -- Only let Challenge Pass quest work take priority when Auto Quest is enabled.
    -- This prevents Auto Hatch / Teleport Loop from pulling you back to the selected egg
    -- while the quest worker is trying to finish hatch, bubble, or playtime quests.
    return autoQuesting and hasIncompleteChallengeQuests()
end

local function updateQuestDisplay()
    if not scriptActive or not questParagraph then return end

    local challenges = getActiveChallenges()
    local lines = {}

    if #challenges > 0 then
        for i, c in ipairs(challenges) do
            local pct = math.floor(getQuestFillPct(c.frame) * 100)
            if isQuestCompleted(c.frame) or pct >= 100 then
                table.insert(lines, "✅ " .. tostring(c.text or ("Quest " .. i)))
            else
                table.insert(lines, tostring(c.text or ("Quest " .. i)) .. " (" .. pct .. "%)")
            end
        end
    else
        local data = LocalData:Get()
        if data and data.Quests then
            for qName, qData in pairs(data.Quests) do
                local currentVal = qData.Amount or 0
                local targetVal = qData.Target or 1
                table.insert(lines, tostring(qName) .. ": " .. formatCommas(currentVal) .. " / " .. formatCommas(targetVal))
            end
        end
    end

    if #lines == 0 then
        table.insert(lines, "Open Challenge Pass UI to load quests.")
    end

    pcall(function()
        questParagraph:Set({
            Title = "Challenge Pass Quests",
            Content = table.concat(lines, "\n")
        })
    end)
end

-- ======================================
--   CORE INTERACTION AND SYSTEMS
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
            rayNotify("Keybind Saved", "Reload the script for the Rayfield toggle key to update.", 3)
        end
    else
        -- Rayfield owns UI visibility through ToggleUIKeybind.
        -- Keeping a second manual visibility toggle here can desync the menu and prevent reopening.
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
    autoSeasonPass = false
    autoPresentRain = false
    autoQuesting = false
    if stopAutoRejoin then stopAutoRejoin(false) end
    
    if hatchThread then pcall(function() task.cancel(hatchThread) end) end
    if teleportThread then pcall(function() task.cancel(teleportThread) end) end
    if eSpamThread then pcall(function() task.cancel(eSpamThread) end) end
    if enchantThread then pcall(function() task.cancel(enchantThread) end) end
    if permShrineThread then pcall(function() task.cancel(permShrineThread) end) end
    if timedShrineThread then pcall(function() task.cancel(timedShrineThread) end) end
    if seasonPassThread then pcall(function() task.cancel(seasonPassThread) end) end
    if presentRainThread then pcall(function() task.cancel(presentRainThread) end) end
    if autoQuestThread then pcall(function() task.cancel(autoQuestThread) end) end
    if autoRejoinThread then pcall(function() task.cancel(autoRejoinThread) end) end
    for _, t in ipairs(loopThreads) do pcall(function() task.cancel(t) end) end
    for _, c in ipairs(connections) do if c and c.Connected then c:Disconnect() end end
    
    setWalkSpeed(16)
    screenGui:Destroy()
end
exitBtn.MouseButton1Click:Connect(unloadScript)

local function formatSessionTime(seconds)
    seconds = math.max(0, tonumber(seconds) or 0)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function updateHatchDisplays()
    if not scriptActive then return end
    local elapsed = os.time() - startTime
    counterLabel.Text = "Eggs Hatched: " .. formatCommas(eggsHatched)
    rateLabel.Text = (elapsed > 0 and eggsHatched > 0) and ("Hatch Rate: " .. formatCommas((eggsHatched / elapsed) * 60) .. " / m") or "Hatch Rate: 0 / m"
    if sessionTimeLabel then
        sessionTimeLabel.Text = "Session Time: " .. formatSessionTime(elapsed)
    end
    if rejoinLabel then
        rejoinLabel.Text = "Rejoins: " .. formatCommas(rejoinCount)
    end
end

local function getLeaderstatValue(player, names)
    local leaderstats = player and player:FindFirstChild("leaderstats")
    if not leaderstats then return nil end

    for _, statName in ipairs(names) do
        local stat = leaderstats:FindFirstChild(statName)
        if stat and stat.Value ~= nil then
            return stat.Value
        end
    end

    local lowered = {}
    for _, statName in ipairs(names) do
        lowered[string.lower(statName)] = true
    end

    for _, stat in ipairs(leaderstats:GetChildren()) do
        local key = string.lower(stat.Name)
        if lowered[key] and stat.Value ~= nil then
            return stat.Value
        end
    end

    return nil
end

local function getAccountStatsText()
    local elapsed = math.max(os.time() - startTime, 0)
    local localRate = (elapsed > 0 and eggsHatched > 0) and ((eggsHatched / elapsed) * 60) or 0
    local lines = {}

    for _, player in ipairs(Players:GetPlayers()) do
        local isLocal = player == LocalPlayer
        local hatchTotal = getLeaderstatValue(player, {"Hatches", "Eggs Hatched", "EggsHatched", "Eggs", "Hatch"})
        local secretTotal = getLeaderstatValue(player, {"Secrets", "Secret Pets", "SecretPets", "Secrets Hatched", "SecretHatches"})

        if isLocal then
            hatchTotal = eggsHatched
            secretTotal = secretPetsHatched
        end

        local displayName = player.Name
        if player.DisplayName and player.DisplayName ~= player.Name then
            displayName = player.DisplayName .. " (@" .. player.Name .. ")"
        else
            displayName = "@" .. player.Name
        end

        local sessionText = isLocal and formatSessionTime(elapsed) or "N/A"
        local rateText = isLocal and (formatCommas(localRate) .. " / m") or "N/A"
        local hatchesText = hatchTotal ~= nil and formatCommas(hatchTotal) or "N/A"
        local secretsText = secretTotal ~= nil and formatCommas(secretTotal) or "N/A"

        table.insert(lines, table.concat({
            displayName,
            "Hatches: " .. hatchesText,
            "Rate: " .. rateText,
            "Session: " .. sessionText,
            "Secret Pets: " .. secretsText
        }, "\n"))
    end

    if #lines == 0 then
        return "No accounts detected."
    end

    return table.concat(lines, "\n\n")
end


local function setMiniAccountsMinimized(state)
    accountMiniMinimized = state and true or false
    if not accountMiniFrame then return end
    if accountMiniBody then
        accountMiniBody.Visible = not accountMiniMinimized
    end
    accountMiniFrame.Size = accountMiniMinimized and UDim2.new(0, 250, 0, 34) or UDim2.new(0, 250, 0, 210)
end

local function updateMiniAccountsWindow()
    if accountMiniText then
        accountMiniText.Text = getAccountStatsText()
    end
end

local function ensureMiniAccountsWindow()
    if accountMiniGui and accountMiniGui.Parent then
        accountMiniGui.Enabled = true
        setMiniAccountsMinimized(false)
        updateMiniAccountsWindow()
        return
    end

    accountMiniGui = Instance.new("ScreenGui")
    accountMiniGui.Name = "AccountsMiniWindow"
    accountMiniGui.ResetOnSpawn = false
    accountMiniGui.IgnoreGuiInset = true
    accountMiniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    accountMiniGui.Parent = LocalPlayer.PlayerGui

    accountMiniFrame = Instance.new("Frame")
    accountMiniFrame.Size = UDim2.new(0, 250, 0, 210)
    accountMiniFrame.Position = UDim2.new(1, -270, 0, 110)
    accountMiniFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    accountMiniFrame.BorderSizePixel = 0
    accountMiniFrame.Parent = accountMiniGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = accountMiniFrame

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(48, 48, 48)
    frameStroke.Thickness = 1
    frameStroke.Parent = accountMiniFrame

    local top = Instance.new("Frame")
    top.Name = "Topbar"
    top.Size = UDim2.new(1, 0, 0, 34)
    top.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    top.BorderSizePixel = 0
    top.Parent = accountMiniFrame

    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = top

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -70, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Accounts"
    title.TextColor3 = Color3.fromRGB(235, 235, 235)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    local minimize = Instance.new("TextButton")
    minimize.Size = UDim2.new(0, 26, 0, 22)
    minimize.Position = UDim2.new(1, -58, 0, 6)
    minimize.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    minimize.TextColor3 = Color3.fromRGB(220, 220, 220)
    minimize.Text = "-"
    minimize.Font = Enum.Font.GothamBold
    minimize.TextSize = 14
    minimize.BorderSizePixel = 0
    minimize.Parent = top
    Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 5)

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 26, 0, 22)
    close.Position = UDim2.new(1, -30, 0, 6)
    close.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    close.TextColor3 = Color3.fromRGB(220, 220, 220)
    close.Text = "x"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 12
    close.BorderSizePixel = 0
    close.Parent = top
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 5)

    accountMiniBody = Instance.new("Frame")
    accountMiniBody.Size = UDim2.new(1, -16, 1, -46)
    accountMiniBody.Position = UDim2.new(0, 8, 0, 40)
    accountMiniBody.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    accountMiniBody.BorderSizePixel = 0
    accountMiniBody.Parent = accountMiniFrame
    Instance.new("UICorner", accountMiniBody).CornerRadius = UDim.new(0, 6)

    accountMiniText = Instance.new("TextLabel")
    accountMiniText.Size = UDim2.new(1, -14, 1, -12)
    accountMiniText.Position = UDim2.new(0, 7, 0, 6)
    accountMiniText.BackgroundTransparency = 1
    accountMiniText.TextColor3 = Color3.fromRGB(210, 210, 210)
    accountMiniText.Font = Enum.Font.Gotham
    accountMiniText.TextSize = 10
    accountMiniText.TextXAlignment = Enum.TextXAlignment.Left
    accountMiniText.TextYAlignment = Enum.TextYAlignment.Top
    accountMiniText.TextWrapped = true
    accountMiniText.Parent = accountMiniBody

    minimize.MouseButton1Click:Connect(function()
        setMiniAccountsMinimized(not accountMiniMinimized)
        minimize.Text = accountMiniMinimized and "+" or "-"
    end)

    close.MouseButton1Click:Connect(function()
        if accountMiniGui then
            accountMiniGui.Enabled = false
        end
    end)

    local UIS = UserInputService
    local draggingMini = false
    local dragInputMini = nil
    local dragStartMini = nil
    local startPosMini = nil

    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingMini = true
            dragStartMini = input.Position
            startPosMini = accountMiniFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingMini = false
                end
            end)
        end
    end)

    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInputMini = input
        end
    end)

    local dragConn = UIS.InputChanged:Connect(function(input)
        if input == dragInputMini and draggingMini and accountMiniFrame then
            local delta = input.Position - dragStartMini
            accountMiniFrame.Position = UDim2.new(
                startPosMini.X.Scale,
                startPosMini.X.Offset + delta.X,
                startPosMini.Y.Scale,
                startPosMini.Y.Offset + delta.Y
            )
        end
    end)
    table.insert(connections, dragConn)

    updateMiniAccountsWindow()
end

local function updateAccountsDisplay()
    if not scriptActive then return end

    local content = getAccountStatsText()
    if accountsParagraph.Set then
        pcall(function()
            accountsParagraph:Set({
                Title = "Accounts",
                Content = content
            })
        end)
    elseif accountsParagraph then
        accountsParagraph.Text = content
    end

    updateMiniAccountsWindow()
end

local function getCurrentSessionElapsed()
    return math.max(os.time() - startTime, 0)
end

local function getSavedPosition()
    local root = getRoot()
    return root and root.Position or nil
end

saveRejoinState = function(reason)
    if not writefile then return false end

    local state = {
        Version = 1,
        Reason = reason or "autosave",
        SavedAt = os.time(),
        PlaceId = game.PlaceId,
        JobId = game.JobId,
        AutoRejoinEnabled = boolValue(Config.AUTO_REJOIN),
        SelectedEgg = selectedEgg,
        EggsHatched = eggsHatched,
        SecretPetsHatched = secretPetsHatched,
        Rejoins = rejoinCount,
        SessionElapsed = getCurrentSessionElapsed(),
        Position = encodeVector3(getSavedPosition()),
        SavedBubblePos = encodeVector3(savedBubblePos),
        Config = Config,
        Toggles = {
            AutoHatch = running,
            TeleportLoop = teleporting,
            ESpam = eSpamming,
            AutoEnchant = autoEnchanting,
            PermanentShrine = autoPermanentShrine,
            TimedShrines = autoTimedShrines,
            SeasonPass = autoSeasonPass,
            PresentRain = autoPresentRain,
            AutoQuest = autoQuesting
        }
    }

    local ok, encoded = pcall(function() return HttpService:JSONEncode(state) end)
    if ok and encoded then
        pcall(function() writefile(REJOIN_STATE_FILE, encoded) end)
        return true
    end

    return false
end

stopAutoRejoin = function(clearSavedState)
    if autoRejoinThread then
        pcall(function() task.cancel(autoRejoinThread) end)
        autoRejoinThread = nil
    end

    if clearSavedState and delfile and isfile and isfile(REJOIN_STATE_FILE) then
        pcall(function() delfile(REJOIN_STATE_FILE) end)
    end
end

startAutoRejoin = function()
    stopAutoRejoin(false)

    if not boolValue(Config.AUTO_REJOIN) then return end

    autoRejoinThread = task.spawn(function()
        while scriptActive and boolValue(Config.AUTO_REJOIN) do
            task.wait(900)
            if not scriptActive or not boolValue(Config.AUTO_REJOIN) then break end

            saveRejoinState("scheduled_rejoin")
            task.wait(1)

            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
        end
    end)
end

local function restoreSavedPositionFromState()
    if not resumeStateActive or not persistedRejoinState then return end

    local savedPos = decodeVector3(persistedRejoinState.Position)
    local savedBubble = decodeVector3(persistedRejoinState.SavedBubblePos)
    if savedBubble then savedBubblePos = savedBubble end

    if savedPos then
        task.spawn(function()
            if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
            task.wait(1)
            teleportTo(savedPos)
        end)
    end
end

local function restoreSavedTogglesFromState()
    if not resumeStateActive or not persistedRejoinState then return end
    local toggles = persistedRejoinState.Toggles
    if type(toggles) ~= "table" then return end

    task.spawn(function()
        task.wait(2)

        local isScheduledRejoinResume = persistedRejoinState and persistedRejoinState.Reason == "scheduled_rejoin"
        if isScheduledRejoinResume then
            queueWebhookMessage("Rejoined `" .. tostring(game.JobId) .. "`")
        end

        if toggles.AutoHatch and not running and hatchBtn then
            hatchBtn.MouseButton1Click:Fire()
            task.wait(0.5)
            if isScheduledRejoinResume and running then
                queueWebhookMessage("Hatching has resumed successfully")
            end
        end
        if toggles.TeleportLoop and not teleporting and teleportBtn then teleportBtn.MouseButton1Click:Fire() task.wait(0.2) end
        if toggles.ESpam and not eSpamming and eSpamBtn then eSpamBtn.MouseButton1Click:Fire() task.wait(0.2) end
        if toggles.AutoEnchant and not autoEnchanting and enchantBtn then enchantBtn.MouseButton1Click:Fire() task.wait(0.2) end
        if toggles.PermanentShrine and not autoPermanentShrine and togglePermShrineBtn then togglePermShrineBtn.MouseButton1Click:Fire() task.wait(0.2) end
        if toggles.TimedShrines and not autoTimedShrines and toggleTimedShrineBtn then toggleTimedShrineBtn.MouseButton1Click:Fire() task.wait(0.2) end
        if toggles.SeasonPass and not autoSeasonPass and seasonPassBtn then seasonPassBtn.MouseButton1Click:Fire() task.wait(0.2) end
        if toggles.PresentRain and not autoPresentRain and presentRainBtn then presentRainBtn.MouseButton1Click:Fire() task.wait(0.2) end
        if toggles.AutoQuest and not autoQuesting and autoQuestBtn then autoQuestBtn.MouseButton1Click:Fire() task.wait(0.2) end
    end)
end

local function applyFpsLimit(valStr)
    local num = tonumber(valStr) or 60
    if setfpscap then setfpscap(num) end
end
fpsInput.FocusLost:Connect(function() Config.FPS_CAP = fpsInput.Text saveConfig() applyFpsLimit(Config.FPS_CAP) end)
if accountRefreshButton then
    accountRefreshButton.MouseButton1Click:Connect(function()
        updateAccountsDisplay()
        rayNotify("Accounts", "Account stats refreshed.", 2)
    end)
end

if accountMiniButton then
    accountMiniButton.MouseButton1Click:Connect(function()
        ensureMiniAccountsWindow()
        rayNotify("Accounts", "Mini accounts window opened.", 2)
    end)
end

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

-- ======================================
--   SEASON PASS & PRESENT RAIN LOOPS
-- ======================================
seasonPassBtn.MouseButton1Click:Connect(function()
    if autoSeasonPass then
        autoSeasonPass = false
        if seasonPassThread then task.cancel(seasonPassThread) seasonPassThread = nil end
        seasonPassBtn.Text = "Auto Claim Season Pass: OFF"
        seasonPassBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    else
        autoSeasonPass = true
        seasonPassBtn.Text = "Auto Claim Season Pass: ON"
        seasonPassBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        seasonPassThread = task.spawn(function()
            while autoSeasonPass and scriptActive do
                pcall(function()
                    RemoteEvent:FireServer("ClaimSeason")
                end)
                task.wait(5)
            end
        end)
    end
end)

local function scanAndCollectPresents()
    local targetPool = Workspace:FindFirstChild("Rendered") or Workspace
    for _, obj in ipairs(targetPool:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local nameLower = string.lower(obj.Name)
            if string.find(nameLower, "present") or string.find(nameLower, "gift") or obj:GetAttribute("PresentId") then
                local foundId = obj:GetAttribute("ID") or obj:GetAttribute("PresentId") or obj.Name
                if foundId and #foundId >= 6 and foundId ~= "Present" then 
                    pcall(function()
                        RemoteEvent:FireServer("CollectPresentRain", tostring(foundId))
                    end)
                end
            end
        end
    end
end

presentRainBtn.MouseButton1Click:Connect(function()
    if autoPresentRain then
        autoPresentRain = false
        if presentRainThread then task.cancel(presentRainThread) presentRainThread = nil end
        presentRainBtn.Text = "Collect Present Rain: OFF"
        presentRainBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    else
        autoPresentRain = true
        presentRainBtn.Text = "Collect Present Rain: ON"
        presentRainBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        presentRainThread = task.spawn(function()
            while autoPresentRain and scriptActive do
                scanAndCollectPresents()
                task.wait(1)
            end
        end)
    end
end)

-- Shrines Executions
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

-- Hook structure targets the global metadata located within: ReplicatedStorage.Shared.Data.Pets
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
                        if r == "Secret" then
                            secretPetsHatched = secretPetsHatched + 1
                        end
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
            if not shouldHoldMainHatchForQuests() and EGGS[selectedEgg] then
                teleportTo(EGGS[selectedEgg])
            end
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
            if shouldHoldMainHatchForQuests() then
                -- Auto Quest owns teleporting/hatching until current Challenge Pass quests are complete.
                updateQuestDisplay()
                task.wait(HATCH_DELAY)
            elseif EGGS[selectedEgg] then
                teleportTo(EGGS[selectedEgg])
                -- RESTORED: Concurrent simulated input keypresses for continuous hatching triggers
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                
                RemoteEvent:FireServer("HatchEgg", selectedEgg, HATCH_AMOUNT)
                
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
            end
            task.spawn(updateHatchDisplays)
            task.wait(HATCH_DELAY)
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

-- ======================================
--   CHALLENGE PASS AUTO QUEST
-- ======================================
local function stopAutoQuest()
    autoQuesting = false
    if autoQuestThread then
        pcall(function() task.cancel(autoQuestThread) end)
        autoQuestThread = nil
    end
    if autoQuestBtn then
        autoQuestBtn.Text = "Auto Quest: OFF"
        autoQuestBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44)
    end
    setWalkSpeed(16)
end

local function resolveQuestEgg(eggName)
    if eggName and EGGS[eggName] and eggName ~= "4x Luck Egg" then
        return eggName
    end
    if EGGS[QUEST_FALLBACK_EGG] then
        return QUEST_FALLBACK_EGG
    end
    return "Common Egg"
end

local function doHatchQuest(challenge)
    local q = challenge.quest
    local targetEgg = resolveQuestEgg(q and q.egg)
    local pos = EGGS[targetEgg]

    while autoQuesting and scriptActive do
        if isQuestCompleted(challenge.frame) or getQuestFillPct(challenge.frame) >= 1 then break end
        teleportTo(pos)
        RemoteEvent:FireServer("HatchEgg", targetEgg, HATCH_AMOUNT)
        task.spawn(updateHatchDisplays)
        updateQuestDisplay()
        task.wait(HATCH_DELAY)
    end
end

local function doBlowQuest(challenge)
    if not savedBubblePos then
        rayNotify("Auto Quest", "Save a bubble position first.", 3)
        return
    end

    local wasHatching = running
    if wasHatching then stopHatch() end

    while autoQuesting and scriptActive do
        if isQuestCompleted(challenge.frame) or getQuestFillPct(challenge.frame) >= 1 then break end
        teleportTo(savedBubblePos)
        RemoteEvent:FireServer("BlowBubble")
        RemoteEvent:FireServer("SellBubble")
        updateQuestDisplay()
        task.wait(HATCH_DELAY)
    end

    if wasHatching and autoQuesting and scriptActive then startHatch() end
end

local function doPlaytimeQuest(challenge)
    while autoQuesting and scriptActive do
        if isQuestCompleted(challenge.frame) or getQuestFillPct(challenge.frame) >= 1 then break end
        local targetEgg = resolveQuestEgg(QUEST_FALLBACK_EGG)
        teleportTo(EGGS[targetEgg])
        RemoteEvent:FireServer("HatchEgg", targetEgg, HATCH_AMOUNT)
        task.spawn(updateHatchDisplays)
        updateQuestDisplay()
        task.wait(HATCH_DELAY)
    end
end

local function startAutoQuest()
    local challenges = getActiveChallenges()
    if #challenges == 0 then
        rayNotify("Auto Quest", "Open the Challenge Pass UI first so quests can be read.", 4)
        if autoQuestBtn then autoQuestBtn.Text = "Auto Quest: OFF" end
        return
    end

    autoQuesting = true
    if running then
        rayNotify("Auto Quest", "Auto Hatch will pause its selected-egg loop until quests are complete.", 4)
    end
    if autoQuestBtn then
        autoQuestBtn.Text = "Auto Quest: ON"
        autoQuestBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
    setWalkSpeed(WALKSPEED)

    autoQuestThread = task.spawn(function()
        while autoQuesting and scriptActive do
            local active = getActiveChallenges()

            if #active == 0 then
                updateQuestDisplay()
                task.wait(2)
                continue
            end

            if allQuestsCompleted(active) then
                RemoteEvent:FireServer("ChallengePassClaimAll")
                task.wait(3)
                updateQuestDisplay()
                continue
            end

            for _, challenge in ipairs(active) do
                if not autoQuesting or not scriptActive then break end
                if isQuestCompleted(challenge.frame) or getQuestFillPct(challenge.frame) >= 1 then
                    continue
                end

                local q = challenge.quest
                if q.type == "Hatch" then
                    doHatchQuest(challenge)
                elseif q.type == "Blow" then
                    doBlowQuest(challenge)
                elseif q.type == "Playtime" then
                    doPlaytimeQuest(challenge)
                end

                if autoQuesting and scriptActive then
                    RemoteEvent:FireServer("ChallengePassClaimAll")
                    task.wait(1)
                    updateQuestDisplay()
                end
            end

            task.wait(0.5)
        end
    end)
end

if autoQuestBtn then
    autoQuestBtn.MouseButton1Click:Connect(function()
        if autoQuesting then stopAutoQuest() else startAutoQuest() end
    end)
end

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

-- Rayfield handles dragging and visibility internally.
-- The old custom draggable code depended on custom Frame instances and breaks when using Rayfield or fallback proxy controls.

-- Initialization Loops
local loop1 = task.spawn(function() while scriptActive do task.wait(1) updateHatchDisplays() updateAccountsDisplay() end end)
table.insert(loopThreads, loop1)

local playerAddedConn = Players.PlayerAdded:Connect(function() task.defer(updateAccountsDisplay) end)
table.insert(connections, playerAddedConn)
local playerRemovingConn = Players.PlayerRemoving:Connect(function() task.defer(updateAccountsDisplay) end)
table.insert(connections, playerRemovingConn)

local loop2 = task.spawn(function() while scriptActive do task.wait(2.5) updateQuestDisplay() end end)
table.insert(loopThreads, loop2)

switchTab(mainPage, mainTabBtn)
if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
setWalkSpeed(WALKSPEED)
restoreSavedPositionFromState()
restoreSavedTogglesFromState()
if boolValue(Config.AUTO_REJOIN) then
    startAutoRejoin()
end
