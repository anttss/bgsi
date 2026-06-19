if type(getgenv) == "function" then
    local globalEnv = getgenv()
            local previousCleanup = rawget(globalEnv, "_1rzHubLitePetViewerCleanup")
            if type(previousCleanup) == "function" then
        pcall(previousCleanup)
        globalEnv._1rzHubLitePetViewerCleanup = nil
    end
    if rawget(globalEnv, "_1rzHubLite_Loaded") and rawget(globalEnv, "_1rzHubLite_LoadComplete") then
        return
    end
    globalEnv._1rzHubLite_Loaded = true
    globalEnv._1rzHubLite_LoadComplete = false
end
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
            local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
            local VirtualInputManager = game:GetService("VirtualInputManager")
local CollectionService = game:GetService("CollectionService")
            local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
            local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
            local activeStates = (getgenv and getgenv()) or {}
task.spawn(function()
    repeat
        task.wait()
    until CoreGui:FindFirstChild("RobloxPromptGui")
    local robloxPromptGui = CoreGui:FindFirstChild("RobloxPromptGui")
            local promptOverlay = robloxPromptGui and robloxPromptGui:FindFirstChild("promptOverlay") or robloxPromptGui and robloxPromptGui:WaitForChild("promptOverlay", 30)
            if not promptOverlay then
        return
    end
    promptOverlay.ChildAdded:Connect(function(promptChild)
        if promptChild.Name == "ErrorPrompt" then
            task.spawn(function()
                while true do
                    pcall(function()
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    end)
                    task.wait(2)
                end
            end)
        end
    end)
end)

local configFile = "1rzHubLiteConfig.json"
            local defaultConfig = {
    autoCollectPresentRain = false,
    selectedWorldChest = "Giant Chest",
    autoClaimWorldChest = false,
    selectedChest = "golden-chest",
    autoChestSummon = false,
    autoChest = false,
    selectedEgg = "",
    selectedEggLocationPriorities = {
    },
    selectedRiftEgg = "",
    autoRiftEgg = false,
    autoRiftEggSpawn = false,
    autoHatch = false,
    noHatchAnim = false,
    autoSpamE = false,
    autoBounty = false,
    spawnRift = false,
    autoLuckEgg = false,
    potionType = "Speed",
    potionLevel = 1,
    potionUseAmount = 10,
    potionAuto = false,
    autoEnchant = false,
    autoPowerOrbEquipped = false,
    equippedTargetEnchant = "secret-hunter",
    equippedTargetEnchant2 = "",
    equippedTargetEnchantLevel = 0,
    equippedEnchantCurrency = "Auto (Secret = Crystals,Normal = Gems)",
    autoPlaytime = false,
    autoEquipBestPets = false,
    autoUpgradeMastery = false,
    autoCollectCoins = false,
    autoBuyShops = false,
    selectedShops = {},
    selectedShopItems = {},
    shopInterval = 1,
    autoBubble = false,
    autoSell = false,
    selectedMysteryBox = "Mystery Box",
    autoOpenMystery = false,
    autoOpenMysteryDelay = 0.2,
    autoGemGenie = false,
    optimisedGemGenie = false,
    gemGenieTargetItem = "Shadow Crystal",
    autoSeason = false,
    autoDailyHourlyChallenge = false,
    autoGlobalIncentive = false,
    autoClaimGlobalIncentive = false,
    DreamerShrineEnabled = false,
    DreamerShrineAmount = 1,
    shrineAuto = false,
    shrineLevel = 1,
    shrinePotion = "Lucky",
    shrineAmount = 10,
    webhookEnabled = false,
    webhookURL = "",
    webhookHidePlayerName = false,
    webhookPingEnabled = false,
    webhookPingUserId = "",
    webhookLowCurrencyEnabled = false,
    webhookLowCoinsBelow = "",
    webhookLowGemsBelow = "",
    webhookLowPearlsBelow = "",
    webhookLowTicketsBelow = "",
    webhookLowCurrencyCooldownMinutes = 30,
    webhookRarities = {
        Secret = true,
        Legendary = false,
        Epic = false,
        Rare = false,
        Unique = false,
        Common = false
    },
    RebirthPetName = "Man Face Lord",
    AdminRebirthPetName = "Man Face Lord",
    RebirthVariants = {
        "Normal"
    },
    RebirthMachineEnabled = false,
    AdminRebirthMachineEnabled = false,

    -- Minigames / fishing copied over from main hub.
    autoMinigames = false,
    autoCircusPetMatch = false,
    autoPetMatch = false,
    autoDanceOff = false,
    autoHyperDarts = false,
    autoIslandRace = false,
    autoIslandRaceFragmentsOnly = false,
    autoFishing = false,
    fastMinigameTransitions = true,
    hideRobotClawHUD = false,
    noRobotClawCamera = false,
    robotClawDebug = false,
    minigameDifficulty = "Easy",

    disableRendering = false,
    renderDistance = 250,
    chunkerRenderDistance = 4,
}
local legacyConfigFile = "1rzHubConfig.json"
            local Config
-- Loads the saved config and falls back safely if the file is missing/broken.
local function loadConfig()
    local scriptStateBB = {
    }
    if isfile and isfile(configFile) then
        local scriptStateIS, scriptStateRR = pcall(function()
            return HttpService:JSONDecode(readfile(configFile))
        end)
        if scriptStateIS and type(scriptStateRR) == "table" then
            for loopSlotCL, scriptStateOE in pairs(defaultConfig) do
                if scriptStateRR[loopSlotCL] ~= nil and typeof(scriptStateRR[loopSlotCL]) == typeof(scriptStateOE) then
                    defaultConfig[loopSlotCL] = scriptStateRR[loopSlotCL]
                    scriptStateBB[loopSlotCL] = true
                end
            end
        end
    end
    if isfile and isfile(legacyConfigFile) then
        local scriptStateZF, scriptStateQX = pcall(function()
            return HttpService:JSONDecode(readfile(legacyConfigFile))
        end)
        if scriptStateZF and type(scriptStateQX) == "table" then
            for loopSlotAL, scriptStateAN in pairs(defaultConfig) do
                if not scriptStateBB[loopSlotAL] and scriptStateQX[loopSlotAL] ~= nil and typeof(scriptStateQX[loopSlotAL]) == typeof(scriptStateAN) then
                    defaultConfig[loopSlotAL] = scriptStateQX[loopSlotAL]
                end
            end
        end
    end
    return defaultConfig
end
-- Saves the current config when a setting changes.
local function saveConfig()
            if not writefile then
        return
    end
    pcall(function()
        writefile(configFile, HttpService:JSONEncode(Config))
    end)
end

-- Helper function to safely require modules
local function safeRequireTable(moduleLoaderFunction)
    local success, module = pcall(moduleLoaderFunction)
    return success and type(module) == "table" and module or nil
end

local function getChunkerModule()
    local ChunkerModule = safeRequireTable(function()
        local shared = ReplicatedStorage:WaitForChild("Shared", 5)
        local utils = shared:WaitForChild("Utils", 5)
        return require(utils:WaitForChild("Chunker", 5))
    end)
    if not ChunkerModule then
        ChunkerModule = safeRequireTable(function()
            return require(ReplicatedStorage.Shared.Utils.Chunker)
        end)
    end
    if not ChunkerModule then
        ChunkerModule = safeRequireTable(function()
            local shared = ReplicatedStorage:WaitForChild("Shared", 5)
            local framework = shared:WaitForChild("Framework", 5)
            local classes = framework:WaitForChild("Classes", 5)
            return require(classes:WaitForChild("Chunker", 5))
        end)
    end
    if not ChunkerModule then
        ChunkerModule = safeRequireTable(function()
            return require(ReplicatedStorage.Shared.Framework.Classes.Chunker)
        end)
    end

    return ChunkerModule
end

-- Function to refresh chunks around the player
local function refreshChunkerAroundPlayer()
    local ChunkerModule = getChunkerModule()

    if not ChunkerModule or type(ChunkerModule.Update) ~= "function" then
        return
    end

    local character = LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local playerPosition = humanoidRootPart and humanoidRootPart.Position

    if not playerPosition then
        return
    end

    for _, entryName in ipairs({
        "Instance",
        "Singleton",
        "Client",
        "Chunker",
        "Active",
    }) do
        local chunkerInstance = rawget(ChunkerModule, entryName)
        if type(chunkerInstance) == "table" and type(chunkerInstance.Update) == "function" then
            pcall(function()
                chunkerInstance:Update(playerPosition)
            end)
        end
    end
end

Config = loadConfig()
Config.chunkerRenderDistance = math.max(1, math.floor(tonumber(Config.chunkerRenderDistance) or 4))
_G.BGSI_CHUNK_RENDER_DISTANCE = Config.chunkerRenderDistance

-- Current clients do not expose Workspace.StreamingTargetRadius. The game
-- controls rendered objects through each Chunker's RenderDistance instead.
local function installChunkerRenderDistanceHook()
    local ChunkerModule = getChunkerModule()
    if not ChunkerModule or type(ChunkerModule.Update) ~= "function" then
        return false
    end

    if rawget(ChunkerModule, "_BGSI_CHUNKER_TRUE_UPDATE") == nil then
        ChunkerModule._BGSI_CHUNKER_TRUE_UPDATE = ChunkerModule.Update
    end

    local originalUpdate = ChunkerModule._BGSI_CHUNKER_TRUE_UPDATE
    ChunkerModule.Update = function(self, playerPosition, ...)
        if Config.disableRendering ~= true and type(self) == "table" then
            self.RenderDistance = math.max(1, math.floor(tonumber(Config.chunkerRenderDistance) or 4))
        end
        local updateResults = table.pack(pcall(originalUpdate, self, playerPosition, ...))
        if updateResults[1] then
            return table.unpack(updateResults, 2, updateResults.n)
        end
    end
    return true
end

task.defer(function()
    for _ = 1, 40 do
        if installChunkerRenderDistanceHook() then
            refreshChunkerAroundPlayer()
            return
        end
        task.wait(0.5)
    end
    warn("[1rzHub Lite] Chunker render-distance hook could not find the Chunker module.")
end)

for loopSlotBI, scriptStateAAX in pairs(defaultConfig) do
    if Config[loopSlotBI] == nil then
        Config[loopSlotBI] = scriptStateAAX
    end
end
local Fluent do
    local fluentFile = "Fluent.lua"
            local fluentSource
    if isfile and isfile(fluentFile) then
        fluentSource = readfile(fluentFile)
    else
        fluentSource = game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")
        if writefile then
            pcall(writefile, fluentFile, fluentSource)
        end
    end
    Fluent = loadstring(fluentSource)()
end
activeStates.FluentLite = Fluent
local profileStore = require(ReplicatedStorage.Client.Framework.Services.LocalData)
            local timeModule = require(ReplicatedStorage.Shared.Framework.Utilities.Math.Time)
local questModule = require(ReplicatedStorage.Shared.Utils.Stats.QuestUtil)
            local enchantModule, enchantData, petRarityData, eggDataModule, riftData, bountyUtil, potionData, giftData, itemUtil
pcall(function()
    enchantModule = require(ReplicatedStorage.Shared.Utils.EnchantUtil)
end)
pcall(function()
    enchantData = require(ReplicatedStorage.Shared.Data.Enchants)
end)
pcall(function()
    petRarityData = require(ReplicatedStorage.Shared.Data.Pets)
end)
pcall(function()
    eggDataModule = require(ReplicatedStorage.Shared.Data.Eggs)
end)
pcall(function()
    riftData = require(ReplicatedStorage.Shared.Data.Rifts)
end)
pcall(function()
    bountyUtil = require(ReplicatedStorage.Shared.Utils.Stats.BountyUtil)
end)
pcall(function()
    potionData = require(ReplicatedStorage.Shared.Data.Potions)
end)
pcall(function()
    giftData = require(ReplicatedStorage.Shared.Data.Powerups)
end)
pcall(function()
    itemUtil = require(ReplicatedStorage.Shared.Utils.Stats.ItemUtil)
end)

-- Safe time helper. Some game builds expose Time.now(), others only need os.time().
local function getCurrentTimestamp()
    if type(timeModule) == "table" and type(timeModule.now) == "function" then
        local ok, result = pcall(timeModule.now)
        if ok and type(result) == "number" then
            return result
        end
    end
    return os.time()
end
local networkRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote")
            local remoteEvent = networkRemote:WaitForChild("RemoteEvent")
local remoteFunction = networkRemote:WaitForChild("RemoteFunction")
            local hatchEffectModule, scriptStateID
pcall(function()
    hatchEffectModule = require(ReplicatedStorage.Client.Effects.HatchEgg)
    scriptStateID = hatchEffectModule and hatchEffectModule.Play or nil
end)
-- Teleport helper: moves the character root to a CFrame safely.
local function teleportToCFrame(targetCFrame)
    if typeof(targetCFrame) ~= "CFrame" or not LocalPlayer then
        return false
    end
    local playerCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local teleportHumanoidRootPart = playerCharacter:FindFirstChild("HumanoidRootPart") or playerCharacter:WaitForChild("HumanoidRootPart", 5)
            if not teleportHumanoidRootPart then
        return false
    end
    teleportHumanoidRootPart.CFrame = targetCFrame
    return true
end
local cachedMaxHatch, cacheHatchTime = nil, 0
local function getMaxHatchAmount()
    if cachedMaxHatch and tick() - cacheHatchTime < 5 then
        return cachedMaxHatch
    end
    local scriptStateVM
    pcall(function()
        if profileStore:IsReady() then
            local scriptStateJE = profileStore:Get()
            scriptStateVM = scriptStateJE and(scriptStateJE.MaxHatch or scriptStateJE.HatchLimit or scriptStateJE.HatchAmount or(scriptStateJE.Upgrades and scriptStateJE.Upgrades.HatchAmount) or(scriptStateJE.Stats and scriptStateJE.Stats.MaxHatch))
        end
    end)
    if type(scriptStateVM) ~= "number" or scriptStateVM < 1 then
        scriptStateVM = 80
    end
    cachedMaxHatch, cacheHatchTime = scriptStateVM, tick()
    return scriptStateVM
end
local fallbackUtilityE
local function safeGetChildren(targetObject)
    return fallbackUtilityE and fallbackUtilityE(targetObject) or {
    }
end
local sharedEnv = activeStates
sharedEnv._1rzHubLiteEggChunkerTracker = sharedEnv._1rzHubLiteEggChunkerTracker or sharedEnv.EggChunkerTracker or {
    Chunkers = {
    },
    Positions = setmetatable({
    },
    {
        __mode = "k"
    }),
    Patched = false,
}
sharedEnv.EggChunkerTracker = sharedEnv._1rzHubLiteEggChunkerTracker
local eggChunkerTracker = sharedEnv._1rzHubLiteEggChunkerTracker
eggChunkerTracker.Chunkers = eggChunkerTracker.Chunkers or {
}
eggChunkerTracker.Positions = eggChunkerTracker.Positions or setmetatable({
}, {
    __mode = "k"
})
local autoPatchEnabled = true
            local defaultTeleportHeight = 5
local infinityEggHeight = 10
            local cachedEggLookup, cachedEggList, cacheTime = nil, nil, 0
local function clearEggScanCache()
    cachedEggLookup, cachedEggList, cacheTime = nil, nil, 0
end
local function findChunkerModule()
    local sharedFolder = ReplicatedStorage:FindFirstChild("Shared")
            local scriptStateAAO = sharedFolder and sharedFolder:FindFirstChild("Framework")
    local scriptStateABJ = scriptStateAAO and scriptStateAAO:FindFirstChild("Classes")
            local chunkerModule = scriptStateABJ and scriptStateABJ:FindFirstChild("Chunker")
            if chunkerModule and chunkerModule:IsA("ModuleScript") then
        return chunkerModule
    end
    local utilsFolder = sharedFolder and sharedFolder:FindFirstChild("Utils")
            local scriptStateZQ = utilsFolder and utilsFolder:FindFirstChild("Chunker")
            if scriptStateZQ and scriptStateZQ:IsA("ModuleScript") then
        return scriptStateZQ
    end
    for loopSlotBF, scriptStateQH in ipairs(ReplicatedStorage:GetDescendants()) do
        if scriptStateQH:IsA("ModuleScript") and scriptStateQH.Name == "Chunker" then
            return scriptStateQH
        end
    end
    return nil
end
local function registerEggChunker(scriptStateFJ)
    if type(scriptStateFJ) ~= "table" then
        return
    end
    for loopSlotS, scriptStateZH in ipairs(eggChunkerTracker.Chunkers) do
        if scriptStateZH == scriptStateFJ then
            return
        end
    end
    table.insert(eggChunkerTracker.Chunkers, scriptStateFJ)
    clearEggScanCache()
end
local function isEggChunkerObject(scriptStateFO)
    return type(scriptStateFO) == "table" and type(rawget(scriptStateFO, "_chunks")) == "table" and type(rawget(scriptStateFO, "_loaded")) == "table" and rawget(scriptStateFO, "_chunkSize") ~= nil and rawget(scriptStateFO, "RenderDistance") ~= nil
end
local function patchEggChunkerModule()
    local scriptStateED = findChunkerModule()
            local scriptStateLO, chunkerInstance = false, nil
    if scriptStateED then
        scriptStateLO, chunkerInstance = pcall(require, scriptStateED)
    end
    if scriptStateLO and type(chunkerInstance) == "table" and not eggChunkerTracker.Patched then
        eggChunkerTracker.Patched = true
        local scriptStateQI = chunkerInstance.new
            if type(scriptStateQI) == "function" then
            chunkerInstance.new = function(...)
                local newChunker = scriptStateQI(...)
                registerEggChunker(newChunker)
                return newChunker
            end
        end
        local scriptStateEU = chunkerInstance.Add
            if type(scriptStateEU) == "function" then
            chunkerInstance.Add = function(self, scriptStateRQ, eggKey, ...)
                registerEggChunker(self)
                if scriptStateRQ ~= nil and eggKey ~= nil then
                    eggChunkerTracker.Positions[eggKey] = scriptStateRQ
                    clearEggScanCache()
                end
                return scriptStateEU(self, scriptStateRQ, eggKey, ...)
            end
        end
    end
    if getgc then
        pcall(function()
            for loopSlotDX, scriptStateWJ in ipairs(getgc(true)) do
                if isEggChunkerObject(scriptStateWJ) then
                    registerEggChunker(scriptStateWJ)
                end
            end
        end)
    end
    return # eggChunkerTracker.Chunkers > 0 or(scriptStateLO and type(chunkerInstance) == "table")
end
local scriptStateTU
local function getEggDataLookup()
    if scriptStateTU then
        return scriptStateTU
    end
    local scriptStateWU = {
    }
    local eggData = eggDataModule
            if type(eggData) ~= "table" or next(eggData) == nil then
        pcall(function()
            eggData = require(ReplicatedStorage.Shared.Data.Eggs)
        end)
    end
    if type(eggData) == "table" then
        for scriptStateACX in pairs(eggData) do
            if type(scriptStateACX) == "string" then
                scriptStateWU[scriptStateACX] = true
            end
        end
    end
    pcall(function()
        local scriptStateER = ReplicatedStorage:FindFirstChild("Assets")
            local eggsFolder = scriptStateER and scriptStateER:FindFirstChild("Eggs")
            if eggsFolder then
            for loopSlotDW, scriptStateAA in ipairs(eggsFolder:GetChildren()) do
                scriptStateWU[scriptStateAA.Name] = true
            end
        end
    end)
    scriptStateTU = scriptStateWU
    return scriptStateWU
end
local function getEggDisplayName(scriptStateII)
    if typeof(scriptStateII) == "Instance" then
        return scriptStateII.Name
    end
    if type(scriptStateII) == "table" then
        return rawget(scriptStateII, "Name") or rawget(scriptStateII, "name") or rawget(scriptStateII, "Egg") or rawget(scriptStateII, "egg")
    end
    if scriptStateII ~= nil then
        return tostring(scriptStateII)
    end
    return nil
end
local function isValidEggInstance(scriptStateZO)
    local scriptStateCF = getEggDisplayName(scriptStateZO)
            if type(scriptStateCF) ~= "string" or scriptStateCF == "" then
        return false
    end
    if riftSet and scriptStateCF == "Egg" then
        return false
    end
    if getEggDataLookup()[scriptStateCF] then
        return true
    end
    if typeof(scriptStateZO) == "Instance" then
        if CollectionService:HasTag(scriptStateZO, "Egg") then
            return true
        end
        return string.find(string.lower(scriptStateZO.Name), "egg", 1, true) ~= nil
    end
    return string.find(string.lower(scriptStateCF), "egg", 1, true) ~= nil
end
local function toVector3(inputValue)
    if typeof(inputValue) == "Vector3" then
        return inputValue
    end
    if typeof(inputValue) == "CFrame" then
        return inputValue.Position
    end
    return nil
end
local function getEggPosition(scriptStateMN)
    local cachedPosition = toVector3(eggChunkerTracker.Positions[scriptStateMN])
            if cachedPosition then
        return cachedPosition
    end
    if typeof(scriptStateMN) ~= "Instance" then
        return nil
    end
    local scriptStateADZ, scriptStateABX = pcall(function()
        if scriptStateMN:IsA("Model") then
            return scriptStateMN:GetPivot().Position
        elseif scriptStateMN:IsA("BasePart") then
            return scriptStateMN.Position
        end
    end)
    if scriptStateADZ and typeof(scriptStateABX) == "Vector3" then
        return scriptStateABX
    end
    return nil
end
local function getChunkWorldBounds(scriptStateDI, scriptStateOT)
    local scriptStateGW = rawget(scriptStateDI, "_chunkSize") or 1
            local scriptStateABB, scriptStateQY, scriptStateHI = scriptStateGW, scriptStateGW, scriptStateGW
    if typeof(scriptStateGW) == "Vector3" then
        scriptStateABB, scriptStateQY, scriptStateHI = scriptStateGW.X, scriptStateGW.Y, scriptStateGW.Z
    end
    return Vector3.new(((scriptStateOT.X or 0) - 0.5) * scriptStateABB,((scriptStateOT.Y or 0) - 0.5) * scriptStateQY,((scriptStateOT.Z or 0) - 0.5) * scriptStateHI)
end
local function scoreEggScanResult(scriptStateVU)
    return(scriptStateVU.exact and 1000 or 0) +(scriptStateVU.loaded and 100 or 0)
end
local function roundToThreeDecimals(scriptStateLJ)
    scriptStateLJ = tonumber(scriptStateLJ) or 0
    return math.floor(scriptStateLJ * 1000 +(scriptStateLJ >= 0 and 0.5 or - 0.5)) / 1000
end
local function makeEggLocationKey(scriptStatePJ, scriptStateCC, scriptStateVG, scriptStateNF)
    local scriptStateABF = scriptStateNF and scriptStateNF.X or 0
            local scriptStateFC = scriptStateNF and scriptStateNF.Y or 0
    local scriptStateZR = scriptStateNF and scriptStateNF.Z or 0
    return table.concat({
        tostring(scriptStatePJ or ""),
        tostring(scriptStateVG or 0),
        tostring(scriptStateABF),
        tostring(scriptStateFC),
        tostring(scriptStateZR),
        tostring(roundToThreeDecimals(scriptStateCC and scriptStateCC.X or 0)),
        tostring(roundToThreeDecimals(scriptStateCC and scriptStateCC.Y or 0)),
        tostring(roundToThreeDecimals(scriptStateCC and scriptStateCC.Z or 0)),
    }, "|")
end
local function sortEggScanResults(scriptStatePZ)
    table.sort(scriptStatePZ, function(scriptStateADX, scriptStateJN)
        local scriptStateOZ, scriptStateAAU = scoreEggScanResult(scriptStateADX), scoreEggScanResult(scriptStateJN)
        if scriptStateOZ ~= scriptStateAAU then
            return scriptStateOZ > scriptStateAAU
        end
        return tostring(scriptStateADX.key or "") < tostring(scriptStateJN.key or "")
    end)
    return scriptStatePZ
end
-- Egg scanner: reads rendered eggs/chunk data so the UI can show real egg locations.
local function scanRenderedEggs(scriptStateMJ)
    if not scriptStateMJ and cachedEggLookup and tick() - cacheTime < 2 then
        return cachedEggLookup, cachedEggList
    end
    patchEggChunkerModule()
    local scanResults, bestResults = {
    }, {
    }
    for loopSlotG, chunker in ipairs(eggChunkerTracker.Chunkers) do
        local chunks = rawget(chunker, "_chunks")
            local loadedChunks = rawget(chunker, "_loaded")
            if type(chunks) == "table" then
            for loopSlotDJ, chunkData in pairs(chunks) do
                if type(chunkData) == "table" then
                    for loopSlotCT, eggInstance in pairs(chunkData) do
                        if isValidEggInstance(eggInstance) then
                            local eggName = getEggDisplayName(eggInstance)
            local exactPosition = getEggPosition(eggInstance)
                            local eggPosition = exactPosition or getChunkWorldBounds(chunker, loopSlotDJ)
            local scanResult = {
                                name = eggName,
                                position = eggPosition,
                                key = makeEggLocationKey(eggName,
                                eggPosition,
                                loopSlotG,
                                loopSlotDJ),
                                exact = exactPosition ~= nil,
                                loaded = loadedChunks and loadedChunks[loopSlotDJ] ~= nil or false,
                                chunker = loopSlotG,
                                chunk = loopSlotDJ,
                            }
                            table.insert(scanResults, scanResult)
                            local scriptStateUB = bestResults[eggName]
            if not scriptStateUB or scoreEggScanResult(scanResult) > scoreEggScanResult(scriptStateUB) then
                                bestResults[eggName] = scanResult
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(scanResults, function(resultA, resultB)
        if resultA.name == resultB.name then
            return scoreEggScanResult(resultA) > scoreEggScanResult(resultB)
        end
        return string.lower(resultA.name) < string.lower(resultB.name)
    end)
    cachedEggLookup, cachedEggList, cacheTime = bestResults, scanResults, tick()
    return bestResults, scanResults
end
fallbackUtilityE = function(scriptStateAB)
    local scriptStateUH = scanRenderedEggs(scriptStateAB == true)
            local loopSlotBB = {
    }
    for scriptStateACQ in pairs(scriptStateUH) do
        table.insert(loopSlotBB, scriptStateACQ)
    end
    table.sort(loopSlotBB, function(loopSlotR, scriptStateKJ)
        return string.lower(loopSlotR) < string.lower(scriptStateKJ)
    end)
    return loopSlotBB
end
local function getEggLocationsByName(eggName, forceRescan)
    if type(eggName) ~= "string" or eggName == "" then
        return{
        }
    end
    local scriptStateSO, scriptStateXE = scanRenderedEggs(forceRescan == true)
    local scriptStateFN = {
    }
    for loopSlotBQ, scriptStateLA in ipairs(scriptStateXE) do
        if scriptStateLA.name == eggName then
            table.insert(scriptStateFN, scriptStateLA)
        end
    end
    return sortEggScanResults(scriptStateFN)
end
local function getEggLocationByKey(loopSlotAV, scriptStatePE, scriptStateES)
    if type(scriptStatePE) ~= "string" or scriptStatePE == "" then
        return nil
    end
    for loopSlotAI, scriptStateAEZ in ipairs(getEggLocationsByName(loopSlotAV, scriptStateES)) do
        if scriptStateAEZ.key == scriptStatePE then
            return scriptStateAEZ
        end
    end
    return nil
end
local function chooseBestEggLocation(scriptStateAAH)
    local scriptStateJB = getEggLocationsByName(scriptStateAAH, false)
            if # scriptStateJB == 0 then
        return nil
    end
    local scriptStateAET = type(Config.selectedEggLocationPriorities) == "table" and Config.selectedEggLocationPriorities or {
    }
    local scriptStateABK = scriptStateAET[scriptStateAAH]
            local scriptStateVE = getEggLocationByKey(scriptStateAAH, scriptStateABK, false)
            if scriptStateVE then
        return scriptStateVE
    end
    return scriptStateJB[1]
end
local function makeEggTeleportPosition(scriptStateNG)
    if type(scriptStateNG) ~= "table" or typeof(scriptStateNG.position) ~= "Vector3" then
        return nil
    end
    local heightOffset =(scriptStateNG.name == "Infinity Egg") and infinityEggHeight or defaultTeleportHeight
    return{
        X = scriptStateNG.position.X,
        Y = scriptStateNG.position.Y + heightOffset,
        Z = scriptStateNG.position.Z
    }
end
local function countScannedEggs()
    local scriptStateYU, scriptStateHF = scanRenderedEggs(true)
    local scriptStateSG = 0
    for scriptStateCT in pairs(scriptStateYU) do
        scriptStateSG = scriptStateSG + 1
    end
    return scriptStateSG, # scriptStateHF
end
local scanNotificationInProgress = false
            local function refreshEggScanNotification(scriptStateNT)
    if scanNotificationInProgress then
        return
    end
    scanNotificationInProgress = true
    local scriptStateMS, scriptStateAEF, scriptStateVI = pcall(countScannedEggs)
    scanNotificationInProgress = false
    if not scriptStateNT then
        if scriptStateMS then
            Fluent:Notify({
                Title = "Egg scan",
                Content = scriptStateAEF > 0 and("Done - found "..scriptStateAEF.." egg(s) from "..scriptStateVI.." chunker location(s).") or "Done - no egg locations found yet.",
                Duration = 6,
            })
        else
            Fluent:Notify({
                Title = "Egg scan",
                Content = "Failed: "..tostring(scriptStateAEF),
                Duration = 5
            })
        end
    end
end
local function getSelectedEggTeleportPosition(scriptStateADY)
    if type(scriptStateADY) ~= "string" or scriptStateADY == "" then
        return nil
    end
    local scriptStateABC = chooseBestEggLocation(scriptStateADY)
            local scriptStateMH = makeEggTeleportPosition(scriptStateABC)
            if scriptStateMH then
        return scriptStateMH
    end
    return nil
end
task.defer(function()
    for loopSlotCG = 1, 20 do
        if patchEggChunkerModule() then
            return
        end
        task.wait(0.5)
    end
end)
local teleportOffsetY = 3
            local function teleportToEggByName(scriptStateABE)
    local scriptStateAEM = getSelectedEggTeleportPosition(scriptStateABE)
            if not scriptStateAEM then
        return false
    end
    return teleportToCFrame(CFrame.new(scriptStateAEM.X, scriptStateAEM.Y + teleportOffsetY, scriptStateAEM.Z))
end
-- Hatch helper: fires the hatch remote with the selected egg and hatch amount.
local function fireHatchEgg(scriptStateQC)
    if type(scriptStateQC) ~= "string" or scriptStateQC == "" then
        return
    end
    pcall(function()
        remoteEvent:FireServer("HatchEgg", scriptStateQC, getMaxHatchAmount())
    end)
end
local function getBountyTaskRequirement(scriptStateVB)
    if not scriptStateVB then
        return 1
    end
    if questModule and type(questModule.GetRequirement) == "function" then
        local scriptStateJK, scriptStateLK = pcall(function()
            return questModule:GetRequirement(scriptStateVB)
        end)
        if scriptStateJK and type(scriptStateLK) == "number" then
            return scriptStateLK
        end
    end
    if type(scriptStateVB) == "table" then
        local scriptStateWW = tonumber(scriptStateVB.Amount or scriptStateVB.amount)
            if scriptStateWW then
            return scriptStateWW
        end
        if type(scriptStateVB.Item) == "table" then
            local scriptStateZJ = tonumber(scriptStateVB.Item.Amount or scriptStateVB.Item.amount)
            if scriptStateZJ then
                return scriptStateZJ
            end
        end
    end
    return 1
end
local function getBountyTaskProgress(scriptStateL, loopSlotC)
    if not scriptStateL or not loopSlotC then
        return 0
    end
    local scriptStatePF = 0
            if questModule then
        pcall(function()
            if type(questModule.GetTaskProgress) == "function" then
                local scriptStateADQ = questModule:GetTaskProgress(scriptStateL, loopSlotC)
            if type(scriptStateADQ) == "number" and scriptStateADQ > scriptStatePF then
                    scriptStatePF = scriptStateADQ
                end
            end
        end)
    end
    if scriptStateL.Progress and type(scriptStateL.Progress) == "table" then
        for loopSlotT, scriptStateLI in ipairs({
            loopSlotC,
            tostring(loopSlotC),
            tonumber(loopSlotC)
        }) do
            local scriptStateJL = scriptStateL.Progress[scriptStateLI]
            if type(scriptStateJL) == "number" and scriptStateJL > scriptStatePF then
                scriptStatePF = scriptStateJL
            end
        end
    end
    local scriptStateNZ = scriptStateL.Tasks and scriptStateL.Tasks[loopSlotC]
            if type(scriptStateNZ) == "table" then
        if scriptStateNZ.Completed == true then
            scriptStatePF = math.max(scriptStatePF, getBountyTaskRequirement(scriptStateNZ))
        end
        for loopSlotBU, scriptStateOD in ipairs({
            "Progress",
            "Current",
            "Count",
            "Value"
        }) do
            local scriptStateIV = scriptStateNZ[scriptStateOD]
            if type(scriptStateIV) == "number" and scriptStateIV > scriptStatePF then
                scriptStatePF = scriptStateIV
            end
        end
    end
    return scriptStatePF
end
local function makeIndexList(scriptStateMG)
    if type(scriptStateMG) ~= "table" then
        return{
        }
    end
    if # scriptStateMG > 0 then
        local scriptStateC = {
        }
        for loopSlotCJ = 1, # scriptStateMG do
            scriptStateC[loopSlotCJ] = loopSlotCJ
        end
        return scriptStateC
    end
    local scriptStateA = {
    }
    for scriptStateADP in pairs(scriptStateMG) do
        local scriptStateNN = tonumber(scriptStateADP)
            if scriptStateNN and scriptStateNN >= 1 then
            table.insert(scriptStateA, scriptStateNN)
        end
    end
    table.sort(scriptStateA)
    return scriptStateA
end
local function normalizeBountyTask(scriptStateXW)
    if type(scriptStateXW) ~= "table" then
        return scriptStateXW
    end
    local scriptStateOU = scriptStateXW.Item
            if type(scriptStateOU) == "table" and type(scriptStateOU.Task) == "table" then
        return scriptStateOU.Task
    end
    if type(scriptStateXW.Task) == "table" then
        return scriptStateXW.Task
    end
    return scriptStateXW
end
local function isCoinOrCollectBountyTask(shopItemEntry)
    shopItemEntry = normalizeBountyTask(shopItemEntry)
    if type(shopItemEntry) ~= "table" then
        return false
    end
    local scriptStateNC = shopItemEntry.Type or shopItemEntry.type
            if type(scriptStateNC) == "string" then
        local scriptStateZA = string.lower(scriptStateNC)
            if scriptStateZA == "collect" or scriptStateZA == "coins" or scriptStateZA == "coin" then
            return true
        end
    end
    local scriptStateAAW = shopItemEntry.Item
            if type(scriptStateAAW) == "table" and(scriptStateAAW.Type == "Currency") then
        return true
    end
    return false
end
local function getBountyCurrencyName(scriptStateADE)
    scriptStateADE = normalizeBountyTask(scriptStateADE)
    if type(scriptStateADE) ~= "table" or type(scriptStateADE.Item) ~= "table" then
        return nil
    end
    if scriptStateADE.Item.Type ~= "Currency" then
        return nil
    end
    local scriptStateN = scriptStateADE.Item.Currency
            if type(scriptStateN) == "string" then
        return string.lower(scriptStateN)
    end
    return nil
end
local function getBountyTaskType(scriptStateADT)
    scriptStateADT = normalizeBountyTask(scriptStateADT)
    if type(scriptStateADT) ~= "table" then
        return""
    end
    return string.lower(tostring(scriptStateADT.Type or scriptStateADT.type or ""))
end
local function isBubbleBountyTask(scriptStateCR)
    local scriptStateOV = getBountyTaskType(scriptStateCR)
    return scriptStateOV == "bubble" or scriptStateOV == "bubbles" or string.find(scriptStateOV, "bubble", 1, true) ~= nil
end
local function isHatchBountyTask(scriptStateRF)
    local scriptStateXZ = getBountyTaskType(scriptStateRF)
            if scriptStateXZ == "hatchegggroup" then
        return false
    end
    return scriptStateXZ == "hatch" or string.find(scriptStateXZ, "hatch", 1, true) ~= nil
end
local function getBountyEggName(scriptStateBO)
    local scriptStateLL = normalizeBountyTask(scriptStateBO) or scriptStateBO
            if type(scriptStateLL) == "table" then
        local scriptStateDG = scriptStateLL.Egg or scriptStateLL.egg or scriptStateLL.EggName
            if type(scriptStateDG) == "string" and scriptStateDG ~= "" then
            return scriptStateDG
        end
        if type(scriptStateLL.Item) == "table" then
            local scriptStateB = scriptStateLL.Item.Name or scriptStateLL.Item.Egg
            if type(scriptStateB) == "string" and scriptStateB ~= "" then
                return scriptStateB
            end
        end
        if scriptStateLL.Rarity then
            if type(scriptStateLL.Rarity) == "string" and string.lower(scriptStateLL.Rarity) == "unique" then
                return"Void Egg"
            end
            return"Infinity Egg"
        end
    end
    return(type(Config.selectedEgg) == "string" and Config.selectedEgg ~= "") and Config.selectedEgg or "Common Egg"
end
local gemShopSlots = nil
            local function getGemShopSlots()
    if type(gemShopSlots) == "table" then
        return gemShopSlots
    end
    local loopSlotI = {
    }
    local scriptStateYM, scriptStateBE = pcall(function()
        return require(ReplicatedStorage.Shared.Data.Shops)
    end)
    if not scriptStateYM or type(scriptStateBE) ~= "table" then
        gemShopSlots = loopSlotI;
        return loopSlotI
    end
    local function addGemShopSlotIfValid(scriptStateXV, scriptStateLW, scriptStateKE)
        if type(scriptStateKE) ~= "table" then
            return
        end
        local scriptStateUG = scriptStateKE.Cost or(type(scriptStateKE.Item) == "table" and scriptStateKE.Item.Cost)
            if type(scriptStateUG) ~= "table" then
            return
        end
        local scriptStateAL = scriptStateUG.Currency
            local scriptStateGA = tonumber(scriptStateUG.Amount)
            if type(scriptStateAL) == "string" and string.lower(scriptStateAL) == "gems" and scriptStateGA and scriptStateGA > 0 then
            table.insert(loopSlotI, {
                shop = scriptStateXV,
                slot = scriptStateLW,
                amount = scriptStateGA
            })
        end
    end
    for loopSlotAF, scriptStateYG in pairs(scriptStateBE) do
        if type(loopSlotAF) == "string" and type(scriptStateYG) == "table" then
            for loopSlotDD, scriptStateUM in ipairs({
                "PermanentItems",
                "RandomItems",
                "Items",
                "Slots"
            }) do
                if type(scriptStateYG[scriptStateUM]) == "table" then
                    for loopSlotCD, scriptStateAAY in pairs(scriptStateYG[scriptStateUM]) do
                        addGemShopSlotIfValid(loopSlotAF, loopSlotCD, scriptStateAAY)
                    end
                end
            end
        end
    end
    table.sort(loopSlotI, function(loopSlotBC, scriptStateCH)
        return loopSlotBC.amount < scriptStateCH.amount
    end)
    gemShopSlots = loopSlotI
    return loopSlotI
end
local function getCurrentCoins()
    local scriptStateRY = 0
    pcall(function()
        if profileStore:IsReady() then
            local scriptStateWE = profileStore:Get() or {
            }
            scriptStateRY = tonumber(scriptStateWE.Coins) or 0
        end
    end)
    return scriptStateRY
end
local function getCurrentGems()
    local scriptStateBN = 0
    pcall(function()
        if profileStore:IsReady() then
            local scriptStateHO = profileStore:Get() or {
            }
            scriptStateBN = tonumber(scriptStateHO.Gems) or 0
            if scriptStateBN <= 0 and type(scriptStateHO.Currencies) == "table" then
                scriptStateBN = tonumber(scriptStateHO.Currencies.Gems) or 0
            end
        end
    end)
    return scriptStateBN
end
local gemReserveThreshold = 4999000000000
            local function hatchEggForDuration(scriptStateTY, scriptStateMI)
    local scriptStateAFN = tick() +(scriptStateMI or 5)
    pcall(function()
        teleportToEggByName(scriptStateTY)
    end)
    local scriptStateAEP = tick()
    while tick() < scriptStateAFN do
        if tick() - scriptStateAEP >= 2 then
            pcall(function()
                teleportToEggByName(scriptStateTY)
            end)
            scriptStateAEP = tick()
        end
        pcall(function()
            remoteEvent:FireServer("HatchEgg", scriptStateTY, getMaxHatchAmount())
        end)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
        task.wait(0.05)
    end
end
local function spendGemsDownToReserve(scriptStateACD, scriptStateEM)
    local scriptStateQN = getGemShopSlots()
            if # scriptStateQN == 0 then
        return 0
    end
    local scriptStateNX = getCurrentGems()
            local scriptStateWP = math.max(0, scriptStateNX - math.max(0, scriptStateACD or 0))
    local scriptStateAX = tick() +(scriptStateEM or 30)
    while tick() < scriptStateAX do
        local scriptStateJR = getCurrentGems()
            if scriptStateJR <= scriptStateWP then
            break
        end
        local scriptStateHQ = false
        for loopSlotBN = # scriptStateQN, 1, - 1 do
            local scriptStateZV = scriptStateQN[loopSlotBN]
            if scriptStateJR >= scriptStateZV.amount then
                pcall(function()
                    remoteEvent:FireServer("BuyShopItem", scriptStateZV.shop, scriptStateZV.slot, false)
                end)
                scriptStateHQ = true
                task.wait(0.5)
                scriptStateJR = getCurrentGems()
                if scriptStateJR <= scriptStateWP then
                    break
                end
            end
        end
        if not scriptStateHQ then
            break
        end
        task.wait(0.05)
    end
    return scriptStateNX - getCurrentGems()
end
local scriptStateAAN = CFrame.new(11, 15973, 45)
            local scriptStateZG = CFrame.new(2286, 3158, 850)
local function teleportToCurrencyArea(scriptStateIG)
    return teleportToCFrame(scriptStateIG == "gems" and scriptStateZG or scriptStateAAN)
end
local function spamClaimGiantChest(scriptStateAAP)
    local scriptStateAEI = tick() +(scriptStateAAP or 5)
    while tick() < scriptStateAEI do
        pcall(function()
            remoteEvent:FireServer("ClaimChest", "Giant Chest", true)
            remoteEvent:FireServer("ClaimChest", "Giant Chest")
        end)
        task.wait(0.05)
    end
end
local scriptStateHD = 200
            local scriptStateCE
local function installPickupRangeHook()
    if not scriptStateCE then
        pcall(function()
            scriptStateCE = require(ReplicatedStorage.Shared.Utils.Stats.StatsUtil)
        end)
    end
    local statsModule = scriptStateCE
            if type(statsModule) ~= "table" or type(statsModule.GetPickupRange) ~= "function" then
        return false
    end
    if rawget(statsModule, "_BGSI_LITE_GetPickupRangeOrig") == nil then
        statsModule._BGSI_LITE_GetPickupRangeOrig = statsModule.GetPickupRange
    end
    statsModule.GetPickupRange = function(self, scriptStateEA)
        local scriptStateAFF = statsModule._BGSI_LITE_GetPickupRangeOrig
            local scriptStateOA = scriptStateAFF(self, scriptStateEA)
            if type(scriptStateOA) ~= "number" or scriptStateOA ~= scriptStateOA then
            return scriptStateOA
        end
        local featureActive = activeStates.BGSI_Lite_GemGenieActive or activeStates.BGSI_Lite_SeasonActive or activeStates.BGSI_Lite_GlobalIncentiveActive
            if Config.autoCollectCoins == true or featureActive then
            return math.max(scriptStateOA, scriptStateHD)
        end
        return scriptStateOA
    end
    return true
end
task.defer(function()
    for loopSlotCP = 1, 40 do
        if installPickupRangeHook() then
            return
        end
        task.wait(0.5)
    end
    warn("[1rzHub Lite] Pickup range hook failed — StatsUtil not found.")
end)
task.spawn(function()
    while task.wait(2) do
        pcall(installPickupRangeHook)
    end
end)
local function useGoldenOrbs(scriptStateKH, scriptStateAAT)
    scriptStateKH = scriptStateKH or 4
    scriptStateAAT = scriptStateAAT or 0.4
    for loopSlotBH = 1, scriptStateKH do
        pcall(function()
            remoteEvent:FireServer("UseGoldenOrb")
        end)
        task.wait(scriptStateAAT)
    end
end
local function runCurrencyOrbPrep(scriptStateEV, scriptStateDJ)
    teleportToCurrencyArea(scriptStateEV)
    task.wait(0.15)
    if scriptStateEV == "gems" then
        local scriptStateHL = getCurrentGems()
            local scriptStateACN = math.max(100000, tonumber(scriptStateDJ) or 0)
            if scriptStateHL > scriptStateACN then
            spendGemsDownToReserve(scriptStateACN, 60)
            teleportToCurrencyArea(scriptStateEV)
            task.wait(0.15)
        end
    else
        local scriptStateZD = getCurrentCoins()
            if scriptStateZD >= gemReserveThreshold then
            hatchEggForDuration("Rainbow Egg", 4)
            teleportToCurrencyArea(scriptStateEV)
            task.wait(0.15)
        end
    end
    task.spawn(useGoldenOrbs, 4, 1)
    spamClaimGiantChest(5)
end
local function runHatchBountyTask(scriptStateWT, scriptStateI, scriptStateDF, scriptStateAAJ)
    local scriptStateUA = 0
    while scriptStateAAJ() do
        local scriptStateVL = scriptStateWT()
            if not scriptStateVL then
            break
        end
        local scriptStateIF = scriptStateVL.Tasks and scriptStateVL.Tasks[scriptStateI]
            local scriptStateVR = scriptStateDF
            if scriptStateIF then
            scriptStateVR = getBountyTaskRequirement(scriptStateIF)
        end
        local scriptStateSP = getBountyTaskProgress(scriptStateVL, scriptStateI)
            if type(scriptStateVR) == "number" and scriptStateSP >= scriptStateVR then
            break
        end
        if scriptStateVL.Completed then
            break
        end
        if type(scriptStateIF) == "table" and scriptStateIF.Completed then
            break
        end
        local scriptStateYV = getBountyEggName(scriptStateIF or {
        })
        if tick() - scriptStateUA >= 1 then
            pcall(function()
                teleportToEggByName(scriptStateYV)
            end)
            scriptStateUA = tick()
        end
        pcall(function()
            remoteEvent:FireServer("HatchEgg", scriptStateYV, getMaxHatchAmount())
        end)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
        task.wait(0)
    end
end
local function runBubbleBountyTask(scriptStateIO, scriptStatePW, scriptStateKN, scriptStateFF)
    teleportToCFrame(CFrame.new(78, 9, - 110))
    task.wait(0.4)
    local teleportStartTime = tick()
    while scriptStateFF() do
        local scriptStateABM = scriptStateIO()
            if not scriptStateABM then
            break
        end
        local selectedPotionCallback = scriptStateABM.Tasks and scriptStateABM.Tasks[scriptStatePW]
            local bountyRequirement = scriptStateKN
            if selectedPotionCallback then
            bountyRequirement = getBountyTaskRequirement(selectedPotionCallback)
        end
        local bountyProgress = getBountyTaskProgress(scriptStateABM, scriptStatePW)
            if type(bountyRequirement) == "number" and bountyProgress >= bountyRequirement then
            break
        end
        if tick() - teleportStartTime >= 2 then
            teleportToCFrame(CFrame.new(78, 9, - 110))
            teleportStartTime = tick()
        end
        pcall(function()
            remoteEvent:FireServer("BlowBubble")
        end)
        task.wait(0.08)
    end
end
local function runCollectCurrencyBountyTask(scriptStateSM, scriptStateOX, scriptStateMZ, scriptStateSS, scriptStateF)
    teleportToCurrencyArea(scriptStateF)
    task.wait(0.2)
    local shopItemLoopCount = 0
            local scriptStateSK = tick()
    while scriptStateSS() do
        local scriptStateBL = scriptStateSM()
            if not scriptStateBL then
            break
        end
        local scriptStateYF = scriptStateBL.Tasks and scriptStateBL.Tasks[scriptStateOX]
            local scriptStateAP = scriptStateMZ
            if scriptStateYF then
            scriptStateAP = getBountyTaskRequirement(scriptStateYF)
        end
        local scriptStateUX = getBountyTaskProgress(scriptStateBL, scriptStateOX)
            if type(scriptStateAP) == "number" and scriptStateUX >= scriptStateAP then
            break
        end
        local scriptStateFP = math.max(0,(scriptStateAP or 0) - scriptStateUX)
            if tick() - scriptStateSK >= 8 then
            teleportToCurrencyArea(scriptStateF)
            scriptStateSK = tick()
        end
        if scriptStateF == "gems" then
            local scriptStatePR = getCurrentGems()
            if scriptStatePR > math.max(100000, scriptStateFP) then
                spendGemsDownToReserve(scriptStateFP, 30)
                teleportToCurrencyArea(scriptStateF)
            end
        else
            if getCurrentCoins() >= gemReserveThreshold then
                hatchEggForDuration("Rainbow Egg", 4)
                teleportToCurrencyArea(scriptStateF)
            end
        end
        pcall(function()
            remoteEvent:FireServer("UseGoldenOrb")
        end)
        if tick() - shopItemLoopCount >= 0.4 then
            pcall(function()
                remoteEvent:FireServer("ClaimChest", "Giant Chest", true)
                remoteEvent:FireServer("ClaimChest", "Giant Chest")
            end)
            shopItemLoopCount = tick()
        end
        task.wait(1.2)
    end
end
activeStates.BGSI_Lite_GemGenieActive = false
activeStates.BGSI_Lite_SeasonActive = false
activeStates.BGSI_Lite_GlobalIncentiveActive = false
activeStates.BGSI_Lite_RiftEggActive = false
local function isPriorityAutomationActive()
    return activeStates.BGSI_Lite_GemGenieActive or activeStates.BGSI_Lite_SeasonActive or activeStates.BGSI_Lite_GlobalIncentiveActive
end
local scriptStateGV, scriptStateSR = false, false
local pauseInProgress = false
            local function pauseNormalAutomation()
    if pauseInProgress then
        return
    end
    pauseInProgress = true
    scriptStateGV = Config.autoHatch
    scriptStateSR = Config.autoBounty
    Config.autoHatch = false
    Config.autoBounty = false
end
local function resumeNormalAutomation()
    if not pauseInProgress then
        return
    end
    pauseInProgress = false
    Config.autoHatch = scriptStateGV or Config.autoHatch
    Config.autoBounty = scriptStateSR or Config.autoBounty
    scriptStateGV, scriptStateSR = false, false
end
local scriptStateOG = Fluent:CreateWindow({
    Title = "LarpLite - BGSI",
    SubTitle = "free",
    TabWidth = 100,
    Size = UDim2.fromOffset(500,
    300),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
}) do
    local scriptStateACM = "https://i.postimg.cc/Y9BqDMrR/images.png"
            local scriptStateQB = "1rzHubMobileUI.png"
    local scriptStateMY = "rbxassetid://7229442422"
            local function isImageFileBytes(scriptStateQE)
        if type(scriptStateQE) ~= "string" or # scriptStateQE < 24 then
            return false
        end
        if string.sub(scriptStateQE, 1, 8) == "\137PNG\r\n\26\n" then
            return true
        end
        if string.sub(scriptStateQE, 1, 2) == "\255\216" then
            return true
        end
        return false
    end
    local function downloadImageBytes(scriptStateRB)
        local scriptStatePD = request or http_request or(syn and syn.request) or(http and http.request)
            if scriptStatePD then
            local scriptStateIQ, scriptStateYB = pcall(function()
                return scriptStatePD({
                    Url = scriptStateRB,
                    Method = "GET",
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0",
                        ["Accept"] = "image/*",
                    },
                })
            end)
            if scriptStateIQ and type(scriptStateYB) == "table" then
                local scriptStateBD = scriptStateYB.Body or scriptStateYB.body
            if type(scriptStateBD) == "string" and isImageFileBytes(scriptStateBD) then
                    return scriptStateBD
                end
            end
        end
        local scriptStateCX, scriptStateHN = pcall(function()
            return game:HttpGet(scriptStateRB)
        end)
        if scriptStateCX and isImageFileBytes(scriptStateHN) then
            return scriptStateHN
        end
        return nil
    end
    local function getCustomAssetLoader()
        local scriptStateAJ = getcustomasset or getsynasset
            if type(scriptStateAJ) == "function" then
            return scriptStateAJ
        end
        if type(syn) == "table" then
            if type(syn.getcustomasset) == "function" then
                return syn.getcustomasset
            end
            if type(syn.getsynasset) == "function" then
                return syn.getsynasset
            end
        end
        return nil
    end
    local function getMobileButtonImage()
        local scriptStateYN = writefile and isfile and readfile
            local scriptStateUD = getCustomAssetLoader()
            if not scriptStateYN then
            return scriptStateACM
        end
        if not isfile(scriptStateQB) then
            local scriptStateTN = downloadImageBytes(scriptStateACM)
            if scriptStateTN then
                pcall(writefile, scriptStateQB, scriptStateTN)
            end
        end
        if scriptStateUD and isfile(scriptStateQB) then
            local scriptStateHP, scriptStateADN = pcall(scriptStateUD, scriptStateQB)
            if scriptStateHP and type(scriptStateADN) == "string" and scriptStateADN ~= "" then
                return scriptStateADN
            end
        end
        return scriptStateMY
    end
    if not getgenv().LoadedMobileUI then
        getgenv().LoadedMobileUI = true
        local scriptStateMA = getMobileButtonImage()
            local scriptStateMV = Instance.new("ScreenGui")
        scriptStateMV.Name = "OpenUI"
        scriptStateMV.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        scriptStateMV.Parent = CoreGui
        local scriptStatePI = Instance.new("ImageButton")
        scriptStatePI.Parent = scriptStateMV
        scriptStatePI.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
        scriptStatePI.BackgroundTransparency = 0.8
        scriptStatePI.Position = UDim2.new(0.9, 0, 0.1, 0)
        scriptStatePI.Size = UDim2.new(0, 50, 0, 50)
        scriptStatePI.Image = scriptStateMA
        scriptStatePI.ImageTransparency = 0
        scriptStatePI.Draggable = true
        scriptStatePI.MouseButton1Click:Connect(function()
            local scriptStateFR = getgenv()._1rzHubToggleFluent
            if type(scriptStateFR) == "function" then
                local scriptStateLC = pcall(scriptStateFR)
            if scriptStateLC then
                    return
                end
            end
            pcall(function()
                scriptStateOG:Minimize()
            end)
        end)
    end
    getgenv()._1rzHubToggleFluent = function()
        scriptStateOG:Minimize()
    end
end
local scriptStateDB = scriptStateOG:AddTab({
    Title = "Main",
    Icon = "home"
})
local eggTab = scriptStateOG:AddTab({
    Title = "Eggs",
    Icon = "egg"
})
local scriptStateCZ = scriptStateOG:AddTab({
    Title = "Event",
    Icon = "flower"
})
local potionTab = scriptStateOG:AddTab({
    Title = "Chests",
    Icon = "package"
})
local scriptStateYT = scriptStateOG:AddTab({
    Title = "Potions",
    Icon = "beaker"
})
local gameTab = scriptStateOG:AddTab({
    Title = "Game",
    Icon = "gamepad"
})
local minigamesTab = scriptStateOG:AddTab({
    Title = "Minigames",
    Icon = "gamepad-2"
})
local scriptStateTJ = scriptStateOG:AddTab({
    Title = "Enchant",
    Icon = "wand-sparkles"
})
local scriptStateUC = scriptStateOG:AddTab({
    Title = "Quests",
    Icon = "scroll"
})
local scriptStateOB = scriptStateOG:AddTab({
    Title = "Shrines",
    Icon = "sparkles"
})
local scriptStateKM = scriptStateOG:AddTab({
    Title = "Webhook",
    Icon = "link"
})
local scriptStateGB = scriptStateOG:AddTab({
    Title = "Rebirth",
    Icon = "repeat"
})
local scriptStateAFW = scriptStateOG:AddTab({
    Title = "Other",
    Icon = "workflow"
})
scriptStateDB:AddParagraph({
    Title = "1rzHub Lite",
    Content = "this is 1rzhub but lite (for the people who like em younger)"
})


--// Minigames port from 1rzMain
-- Keeps this Lite build small, but brings over the useful minigame automation toggles.
do
    local currentReelMinigame = nil
    local minigameDataCache = nil
    local itemUtilCache = nil

    pcall(function()
        local reelMinigameModule = require(ReplicatedStorage.Client.Gui.Frames.Fishing.FishingPlayerRods.RodComponent.States.Local.Reeling.ReelMinigame)
        if type(reelMinigameModule) == "table" and type(reelMinigameModule.new) == "function" and not reelMinigameModule._LiteHooked then
            reelMinigameModule._LiteHooked = true
            local originalReelConstructor = reelMinigameModule.new
            reelMinigameModule.new = function(...)
                local reelObject = originalReelConstructor(...)
                currentReelMinigame = reelObject
                return reelObject
            end
        end
    end)

    local function getMinigameData()
        if minigameDataCache then
            return minigameDataCache
        end
        pcall(function()
            minigameDataCache = require(ReplicatedStorage.Shared.Data.Minigames)
        end)
        return type(minigameDataCache) == "table" and minigameDataCache or {}
    end

    local function getItemUtil()
        if itemUtilCache then
            return itemUtilCache
        end
        pcall(function()
            itemUtilCache = require(ReplicatedStorage.Shared.Utils.Stats.ItemUtil)
        end)
        return type(itemUtilCache) == "table" and itemUtilCache or nil
    end

    local function getLocalData()
        local data
        pcall(function()
            if profileStore and profileStore.IsReady and profileStore:IsReady() then
                data = profileStore:Get()
            end
        end)
        return type(data) == "table" and data or nil
    end

    local function getDifficultyLevel()
        local selectedDifficulty = tostring(Config.minigameDifficulty or "Easy")
        if selectedDifficulty == "Medium" then
            return 2
        elseif selectedDifficulty == "Hard" then
            return 3
        elseif selectedDifficulty == "Insane" then
            return 4
        end
        return 1
    end

    local function canStartMinigame(minigameName)
        local playerData = getLocalData()
        local minigameData = getMinigameData()[minigameName]
        if not playerData or not minigameData then
            return true
        end

        local playerLevel = 1
        if type(playerData.MinigameLevels) == "table" then
            playerLevel = tonumber(playerData.MinigameLevels[minigameName]) or 1
        end
        if playerLevel < getDifficultyLevel() then
            return false
        end

        local itemUtilModule = getItemUtil()
        if itemUtilModule and minigameData.Cost then
            local ok, hasCost = pcall(function()
                return itemUtilModule:GetOwnedAmount(playerData, minigameData.Cost) >= itemUtilModule:GetAmount(minigameData.Cost)
            end)
            if ok and not hasCost then
                return false
            end
        end

        return true
    end

    local function fireMinigameRemote(...)
        local remoteArgs = { ... }
        pcall(function()
            remoteEvent:FireServer(table.unpack(remoteArgs))
        end)
    end

    local function startMinigame(minigameName)
        if not canStartMinigame(minigameName) then
            return false
        end
        fireMinigameRemote("SkipMinigameCooldown", minigameName)
        fireMinigameRemote("StartMinigame", minigameName, Config.minigameDifficulty or "Easy")
        return true
    end

    local function finishMinigame()
        fireMinigameRemote("FinishMinigame")
    end

    local function getMinigameHud(minigameName)
        local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
        local screenGui = playerGui and playerGui:FindFirstChild("ScreenGui")
        local minigameHud = screenGui and screenGui:FindFirstChild("MinigameHUD")
        local minigameFrame = minigameHud and minigameHud:FindFirstChild(minigameName)
        if minigameFrame and minigameHud and minigameHud.Visible and minigameFrame.Visible then
            return minigameFrame, minigameHud
        end
        return nil, minigameHud
    end

    local function findDescendantByText(rootObject, wantedText)
        if not rootObject then
            return nil
        end
        wantedText = tostring(wantedText or ""):lower()
        for _, descendant in ipairs(rootObject:GetDescendants()) do
            if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                if tostring(descendant.Text or ""):lower():find(wantedText, 1, true) then
                    return descendant
                end
            end
        end
        return nil
    end

    local function pressKey(keyCode)
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
            task.wait(0.015)
            VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        end)
    end

    local function clickGuiObject(guiObject)
        if not guiObject or not guiObject:IsA("GuiObject") then
            return
        end
        local position = guiObject.AbsolutePosition + (guiObject.AbsoluteSize / 2)
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(position.X, position.Y, 0, true, game, 1)
            task.wait(0.015)
            VirtualInputManager:SendMouseButtonEvent(position.X, position.Y, 0, false, game, 1)
        end)
    end

    local function installFastTransitionHook(reason)
        if not Config.fastMinigameTransitions or _G._Lite_PlayTransitionHooked then
            return
        end
        local playTransitionModule = ReplicatedStorage.Client
            and ReplicatedStorage.Client.Gui
            and ReplicatedStorage.Client.Gui:FindFirstChild("PlayTransition")
        if not playTransitionModule or not playTransitionModule:IsA("ModuleScript") then
            return
        end
        local ok, playTransition = pcall(require, playTransitionModule)
        if not ok or type(playTransition) ~= "function" then
            return
        end
        local hookApi = hookfunction or hookfunc or replaceclosure
        if type(hookApi) ~= "function" then
            return
        end
        local originalTransition
        local hookOk = pcall(function()
            originalTransition = hookApi(playTransition, function(titleText, callback, ...)
                local loweredTitle = tostring(titleText or ""):lower()
                if Config.autoMinigames and (loweredTitle:find("loading minigame", 1, true) or loweredTitle:find("returning home", 1, true)) then
                    if type(callback) == "function" then
                        task.spawn(function()
                            pcall(callback)
                        end)
                    end
                    return nil
                end
                return originalTransition(titleText, callback, ...)
            end)
        end)
        if hookOk then
            _G._Lite_PlayTransitionHooked = true
        end
    end

    local function setRobotClawHudVisible(isVisible)
        local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then
            return
        end
        pcall(function()
            for _, screenGui in ipairs(playerGui:GetChildren()) do
                if screenGui:IsA("ScreenGui") then
                    local robotClawFrame = screenGui:FindFirstChild("Robot Claw", true)
                    if robotClawFrame and robotClawFrame:IsA("GuiObject") then
                        robotClawFrame.Visible = isVisible
                    end
                    local minigameHud = screenGui:FindFirstChild("MinigameHUD", true)
                    if minigameHud and minigameHud:IsA("GuiObject") and minigameHud:FindFirstChild("Robot Claw", true) then
                        minigameHud.Visible = isVisible
                    end
                    for _, descendant in ipairs(screenGui:GetDescendants()) do
                        if descendant:IsA("BillboardGui") and tostring(descendant.Name):sub(1, 8) == "ClawItem" then
                            descendant.Enabled = isVisible
                        end
                    end
                end
            end
        end)
    end

    local function lockCameraToPlayer()
        if not Config.noRobotClawCamera then
            return
        end
        local camera = workspace.CurrentCamera
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if camera and humanoid then
            pcall(function()
                camera.CameraType = Enum.CameraType.Custom
                camera.CameraSubject = humanoid
            end)
        end
    end

    local function getClawMachine()
        local cachedClawMachine = rawget(_G, "_Lite_ActiveClawMachine")
        if cachedClawMachine and cachedClawMachine.Parent then
            return cachedClawMachine
        end
        local clawMachine = Workspace:FindFirstChild("ClawMachine", true)
        _G._Lite_ActiveClawMachine = clawMachine
        return clawMachine
    end

    local function runRobotClawStep()
        installFastTransitionHook("Robot Claw")
        if Config.hideRobotClawHUD then
            setRobotClawHudVisible(false)
        end
        lockCameraToPlayer()

        local clawMachine = getClawMachine()
        if not clawMachine then
            startMinigame("Robot Claw")
            return
        end

        local grabbedAnyItem = false
        local seenItemGuids = {}
        for _, clawToy in ipairs(CollectionService:GetTagged("ClawToyModel")) do
            if clawToy:IsDescendantOf(clawMachine) and clawToy.Parent then
                local itemGuid = clawToy:GetAttribute("ItemGUID")
                local wasCollected = clawToy:GetAttribute("wasCollected")
                if itemGuid and not wasCollected and not seenItemGuids[itemGuid] then
                    seenItemGuids[itemGuid] = true
                    grabbedAnyItem = true
                    fireMinigameRemote("GrabMinigameItem", itemGuid)
                    task.wait(0.01)
                end
            end
        end

        if grabbedAnyItem then
            finishMinigame()
            _G._Lite_ActiveClawMachine = nil
            task.wait(0.05)
        end
    end

    local function runPetMatchStep()
        local frame = getMinigameHud("Pet Match")
        if frame then
            finishMinigame()
            task.wait(0.08)
        end
        startMinigame("Pet Match")
    end

    local function runDanceOffStep()
        local frame = getMinigameHud("Dance Off")
        if not frame then
            startMinigame("Dance Off")
            return
        end

        local directionsFrame = frame:FindFirstChild("Directions", true)
        if not directionsFrame then
            return
        end

        local keyMap = {
            w = Enum.KeyCode.W,
            a = Enum.KeyCode.A,
            s = Enum.KeyCode.S,
            d = Enum.KeyCode.D,
            up = Enum.KeyCode.W,
            left = Enum.KeyCode.A,
            down = Enum.KeyCode.S,
            right = Enum.KeyCode.D,
        }

        for keyName, keyCode in pairs(keyMap) do
            local directionButton = directionsFrame:FindFirstChild(keyName, true)
            if directionButton and directionButton:IsA("GuiObject") and directionButton.Visible then
                local button = directionButton:FindFirstChild("Button")
                if not button or button.Active == true then
                    pressKey(keyCode)
                    task.wait(0.025)
                end
            end
        end
    end

    local function runHyperDartsStep()
        local frame = getMinigameHud("Hyper Darts")
        if not frame then
            startMinigame("Hyper Darts")
            return
        end

        local clickedTarget = false
        for _, descendant in ipairs(frame:GetDescendants()) do
            local lowerName = tostring(descendant.Name):lower()
            if descendant:IsA("GuiButton") and descendant.Visible and (lowerName:find("target") or lowerName:find("dart") or lowerName:find("balloon")) then
                clickGuiObject(descendant)
                clickedTarget = true
                task.wait(0.01)
            end
        end

        if not clickedTarget then
            for _, descendant in ipairs(frame:GetDescendants()) do
                if descendant:IsA("GuiButton") and descendant.Visible and descendant.Active then
                    clickGuiObject(descendant)
                    task.wait(0.01)
                end
            end
        end
    end

    local islandRacePoints = {
        CFrame.new(-77, 18, -107),
        CFrame.new(-129, 31, -93),
        CFrame.new(-166, 47, -102),
        CFrame.new(-204, 61, -65),
        CFrame.new(-241, 78, -26),
        CFrame.new(-281, 95, 9),
    }

    local function getIslandRacePoints()
        local points = {}
        local renderedFolder = Workspace:FindFirstChild("Rendered")
        if renderedFolder then
            for _, descendant in ipairs(renderedFolder:GetDescendants()) do
                local lowerName = tostring(descendant.Name):lower()
                if (lowerName:find("checkpoint") or lowerName:find("island")) and (descendant:IsA("BasePart") or descendant:IsA("Model")) then
                    local ok, pointCFrame = pcall(function()
                        return descendant:IsA("Model") and descendant:GetPivot() or descendant.CFrame
                    end)
                    if ok and typeof(pointCFrame) == "CFrame" then
                        table.insert(points, pointCFrame + Vector3.new(0, 4, 0))
                    end
                end
            end
        end
        table.sort(points, function(a, b)
            return a.Position.Y < b.Position.Y
        end)
        return #points > 0 and points or islandRacePoints
    end

    local function runIslandRaceStep()
        local frame = getMinigameHud("Island Race")
        if not frame then
            startMinigame("Island Race")
            task.wait(0.2)
        end

        _G.BGSI_IslandRaceReserved = true
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            return
        end

        for _, pointCFrame in ipairs(getIslandRacePoints()) do
            if not Config.autoIslandRace then
                break
            end
            pcall(function()
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.CFrame = pointCFrame
            end)
            task.wait(0.5)
        end
        finishMinigame()
        _G.BGSI_IslandRaceReserved = false
    end

    local function runFishingStep()
        pcall(function()
            remoteEvent:FireServer("EquipRod")
        end)

        local reelObject = currentReelMinigame
        if reelObject and not reelObject._isFinished then
            pcall(function()
                reelObject.Progress = 1
                reelObject._progress = 1
                reelObject._isFinished = true
            end)
            return
        end

        local character = LocalPlayer.Character
        if not character then
            return
        end

        local hasRodEquipped = false
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") and tostring(child.Name):lower():find("rod", 1, true) then
                hasRodEquipped = true
                break
            end
        end

        if hasRodEquipped then
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, true)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, true)
            end)
        end
    end

    minigamesTab:AddSection("Main")
    minigamesTab:AddDropdown("MinigameDifficulty", {
        Title = "Difficulty",
        Values = { "Easy", "Medium", "Hard", "Insane" },
        Default = Config.minigameDifficulty or "Easy",
        Multi = false,
        Callback = function(selectedDifficulty)
            Config.minigameDifficulty = selectedDifficulty
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("AutoRobotClaw", {
        Title = "Auto Robot Claw",
        Default = Config.autoMinigames,
        Callback = function(isEnabled)
            Config.autoMinigames = isEnabled
            if not isEnabled then
                _G._Lite_ActiveClawMachine = nil
                _G.BGSI_IslandRaceReserved = false
                setRobotClawHudVisible(true)
            end
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("AutoPetMatch", {
        Title = "Auto Pet Match",
        Default = Config.autoPetMatch or Config.autoCircusPetMatch,
        Callback = function(isEnabled)
            Config.autoPetMatch = isEnabled
            Config.autoCircusPetMatch = isEnabled
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("AutoDanceOff", {
        Title = "Auto Dance Off",
        Default = Config.autoDanceOff,
        Callback = function(isEnabled)
            Config.autoDanceOff = isEnabled
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("AutoHyperDarts", {
        Title = "Auto Hyper Darts",
        Default = Config.autoHyperDarts,
        Callback = function(isEnabled)
            Config.autoHyperDarts = isEnabled
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("AutoIslandRace", {
        Title = "Auto Island Race",
        Default = Config.autoIslandRace,
        Callback = function(isEnabled)
            Config.autoIslandRace = isEnabled
            if not isEnabled then
                _G.BGSI_IslandRaceReserved = false
            end
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("AutoIslandRaceFragmentsOnly", {
        Title = "Island Race Fragments Only",
        Default = Config.autoIslandRaceFragmentsOnly,
        Callback = function(isEnabled)
            Config.autoIslandRaceFragmentsOnly = isEnabled
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("AutoFishing", {
        Title = "Auto Fishing",
        Default = Config.autoFishing,
        Callback = function(isEnabled)
            Config.autoFishing = isEnabled
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("FastMinigameTransitions", {
        Title = "Fast Minigame Transitions",
        Default = Config.fastMinigameTransitions,
        Callback = function(isEnabled)
            Config.fastMinigameTransitions = isEnabled
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("HideRobotClawHUD", {
        Title = "Hide Robot Claw HUD",
        Default = Config.hideRobotClawHUD,
        Callback = function(isEnabled)
            Config.hideRobotClawHUD = isEnabled
            if not isEnabled then
                setRobotClawHudVisible(true)
            end
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("NoRobotClawCamera", {
        Title = "Keep Camera Normal",
        Default = Config.noRobotClawCamera,
        Callback = function(isEnabled)
            Config.noRobotClawCamera = isEnabled
            saveConfig()
        end,
    })

    minigamesTab:AddToggle("RobotClawDebug", {
        Title = "Robot Claw Debug",
        Default = Config.robotClawDebug,
        Callback = function(isEnabled)
            Config.robotClawDebug = isEnabled
            saveConfig()
        end,
    })

    task.spawn(function()
        while true do
            task.wait(Config.autoMinigames and 0.05 or 0.5)
            if Config.autoMinigames then
                local ok, err = pcall(runRobotClawStep)
                if not ok and Config.robotClawDebug then
                    warn("[1rzLite][RobotClaw]", err)
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait((Config.autoPetMatch or Config.autoCircusPetMatch) and 0.12 or 0.75)
            if Config.autoPetMatch or Config.autoCircusPetMatch then
                pcall(runPetMatchStep)
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(Config.autoDanceOff and 0.05 or 0.75)
            if Config.autoDanceOff then
                pcall(runDanceOffStep)
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(Config.autoHyperDarts and 0.05 or 0.75)
            if Config.autoHyperDarts then
                pcall(runHyperDartsStep)
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(Config.autoIslandRace and 0.25 or 1)
            if Config.autoIslandRace then
                pcall(runIslandRaceStep)
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(Config.autoFishing and 0.1 or 1)
            if Config.autoFishing then
                pcall(runFishingStep)
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(1) -- Refresh every 1 second
            refreshChunkerAroundPlayer()
        end
    end)
end
scriptStateOG:SelectTab(1)
Fluent:Notify({
    Title = "1rzHub Lite",
    Content = "Loading...",
    Duration = 3
}) do
    local function getDebugGui()
        local scriptStateEG = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
            local scriptStateIT = scriptStateEG and scriptStateEG:FindFirstChild("ScreenGui")
        return scriptStateIT and scriptStateIT:FindFirstChild("_debug") or nil
    end
    local function getDebugTagsContainer()
        local scriptStateAG = getDebugGui()
        return scriptStateAG and scriptStateAG:FindFirstChild("Tags") or nil
    end
    local function getOrCreateDebugLabel(debugTagsContainer, labelName, layoutOrder)
        if not debugTagsContainer or typeof(debugTagsContainer) ~= "Instance" then
            return nil
        end
        local scriptStateEK = debugTagsContainer
        local scriptStateRD = tostring(labelName or "BGSI_Lite_Label")
        local scriptStateADJ = tonumber(layoutOrder) or 0
        local scriptStateABL = scriptStateEK:FindFirstChild(scriptStateRD)
            if scriptStateABL then
            return scriptStateABL:FindFirstChild("Label")
        end
        local scriptStateGZ
        for loopSlotCV, scriptStateAFJ in ipairs(scriptStateEK:GetChildren()) do
            if scriptStateAFJ:IsA("Frame") and scriptStateAFJ:FindFirstChild("Label") and not string.find(scriptStateAFJ.Name, "^BGSI_") then
                scriptStateGZ = scriptStateAFJ
                break
            end
        end
        if scriptStateGZ then
            local scriptStateXS = scriptStateGZ:Clone()
            scriptStateXS.Name = scriptStateRD
            scriptStateXS.LayoutOrder = scriptStateADJ
            scriptStateXS.Parent = scriptStateEK
            local scriptStateCM = scriptStateXS:FindFirstChild("Label")
            if scriptStateCM and scriptStateCM:IsA("TextLabel") then
                scriptStateCM.Text = ""
                scriptStateCM.RichText = true
                return scriptStateCM
            end
        end
        local giftSortedList = Instance.new("Frame")
        giftSortedList.Name = scriptStateRD
        giftSortedList.BackgroundTransparency = 1
        giftSortedList.LayoutOrder = scriptStateADJ
        giftSortedList.Size = UDim2.fromOffset(220, 20)
        giftSortedList.Parent = scriptStateEK
        local scriptStateAAQ = Instance.new("TextLabel")
        scriptStateAAQ.Name = "Label"
        scriptStateAAQ.BackgroundTransparency = 1
        scriptStateAAQ.Font = Enum.Font.GothamBold
        scriptStateAAQ.RichText = true
        scriptStateAAQ.Size = UDim2.fromScale(1, 1)
        scriptStateAAQ.Text = ""
        scriptStateAAQ.TextColor3 = Color3.new(1, 1, 1)
        scriptStateAAQ.TextSize = 14
        scriptStateAAQ.TextXAlignment = Enum.TextXAlignment.Left
        scriptStateAAQ.TextYAlignment = Enum.TextYAlignment.Center
        scriptStateAAQ.Parent = giftSortedList
        local scriptStateAM = Instance.new("UIStroke")
        scriptStateAM.Color = Color3.new(0, 0, 0)
        scriptStateAM.Thickness = 1
        scriptStateAM.Parent = scriptStateAAQ
        return scriptStateAAQ
    end
    local function formatNumberWithCommas(scriptStateHB)
        scriptStateHB = tonumber(scriptStateHB)
        if not scriptStateHB then
            return"-"
        end
        local scriptStateXB = tostring(math.floor(scriptStateHB))
        while true do
            local scriptStateUR, scriptStateZI = scriptStateXB:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
            scriptStateXB = scriptStateUR
            if scriptStateZI == 0 then
                break
            end
        end
        return scriptStateXB
    end
    local function formatOneInChance(scriptStateNM)
        scriptStateNM = tonumber(scriptStateNM)
        if not scriptStateNM or scriptStateNM <= 0 then
            return"-"
        end
        local scriptStateJJ = 1 / scriptStateNM
            local scriptStateABY = math.floor(scriptStateJJ + 0.5)
            if math.abs(scriptStateJJ - scriptStateABY) < 1e-06 then
            return formatNumberWithCommas(scriptStateABY)
        end
        return string.format("%.2f", scriptStateJJ)
    end
    local function resizeDebugLabelToText(scriptStatePB)
        if not scriptStatePB or not scriptStatePB.Parent then
            return
        end
        local scriptStateLB = scriptStatePB.Parent
            local scriptStateYJ = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
        local scriptStateAH = scriptStateYJ and scriptStateYJ:FindFirstChild("ScreenGui")
            local scriptStateJP = scriptStateAH and scriptStateAH:FindFirstChild("UIScale")
        local scriptStateDK =(scriptStateJP and scriptStateJP.Scale) or 1
            local scriptStateCY = math.max(130, math.floor((scriptStatePB.TextBounds.X / math.max(scriptStateDK, 0.001)) + 20))
        local scriptStateLX = scriptStateLB.Size.Y.Offset > 0 and scriptStateLB.Size.Y.Offset or 20
        scriptStateLB.Size = UDim2.fromOffset(scriptStateCY, scriptStateLX)
    end
    local function makeDebugLabelClickable(scriptStateJX, scriptStateOW, scriptStatePT)
        local scriptStateFA = scriptStateJX and scriptStateJX.Parent
            if not scriptStateFA or scriptStateFA:FindFirstChild(scriptStateOW) then
            return
        end
        local scriptStateFG = Instance.new("TextButton")
        scriptStateFG.Name = scriptStateOW
        scriptStateFG.AutoButtonColor = false
        scriptStateFG.BackgroundTransparency = 1
        scriptStateFG.Position = UDim2.fromOffset(0, 0)
        scriptStateFG.Size = UDim2.fromScale(1, 1)
        scriptStateFG.Text = ""
        scriptStateFG.ZIndex =(scriptStateJX.ZIndex or 1) + 1
        scriptStateFG.Parent = scriptStateFA
        scriptStateFG.MouseButton1Click:Connect(scriptStatePT)
    end
    local function getPlayerDataSnapshot()
        local scriptStateU
        pcall(function()
            if profileStore and profileStore.IsReady and profileStore:IsReady() then
                scriptStateU = profileStore:Get()
            end
        end)
        return type(scriptStateU) == "table" and scriptStateU or {
        }
    end
    local function findNestedNumericStat(scriptStateBG, scriptStateLV, scriptStateKD)
        if type(scriptStateBG) ~= "table" or type(scriptStateLV) ~= "table" then
            return nil
        end
        scriptStateKD = tonumber(scriptStateKD) or 0
        local scriptStateSZ = {
        }
        for loopSlotDR, scriptStateSW in ipairs(scriptStateLV) do
            scriptStateSZ[string.lower(tostring(scriptStateSW))] = true
        end
        for loopSlotAB, scriptStateAEO in pairs(scriptStateBG) do
            if type(loopSlotAB) == "string" and scriptStateSZ[string.lower(loopSlotAB)] then
                if type(scriptStateAEO) == "number" then
                    return scriptStateAEO
                end
                if type(scriptStateAEO) == "string" and tonumber(scriptStateAEO) then
                    return tonumber(scriptStateAEO)
                end
            end
        end
        if scriptStateKD <= 0 then
            return nil
        end
        for loopSlotDS, scriptStateEO in pairs(scriptStateBG) do
            if type(scriptStateEO) == "table" then
                local scriptStateJH = findNestedNumericStat(scriptStateEO, scriptStateLV, scriptStateKD - 1)
            if type(scriptStateJH) == "number" then
                    return scriptStateJH
                end
            end
        end
        return nil
    end
    local function getNestedStatValue(scriptStateSI, scriptStateDM)
        local scriptStateMR = findNestedNumericStat(scriptStateSI, scriptStateDM, 6)
        return type(scriptStateMR) == "number" and scriptStateMR or 0
    end
    local scriptStateEX = {
        Common = 0.0002,
        Unique = 0.00028571428571428574,
        Rare = 0.0013333333333333333,
        Epic = 0.004,
        Legendary = 0.05,
        Secret = 0.2,
    }
    local rebirthRarityList = {
        "Legendary",
        "Epic",
        "Rare",
        "Unique",
        "Common"
    }
    local scriptStateEP = 0.04
            local scriptStateAFL = {
        "",
        "Shiny ",
        "Mythic ",
        "Shiny Mythic ",
        "Mythic Shiny ",
        "XL ",
        "XL Shiny ",
        "XL Mythic ",
        "XL Shiny Mythic ",
        "XL Mythic Shiny ",
    }
    local scriptStateM = {
        Common = 1,
        Unique = 2,
        Rare = 3,
        Epic = 4,
        Legendary = 5,
        Mythic = 6,
        Secret = 7,
        Infinity = 8,
    }
    local function getXLChanceForRarity(scriptStateAAF, scriptStateJO)
        local scriptStateLG = scriptStateEX[scriptStateAAF]
            if type(scriptStateLG) ~= "number" then
            return nil, 0
        end
        local scriptStateBA = getNestedStatValue(scriptStateJO, {
            "XLChance",
            "xl_chance",
            "xlpetchance",
            "xleggchance"
        })
        return(scriptStateLG / 100) * math.max(0, 1 + scriptStateBA), scriptStateBA
    end
    local function getSuperLegendaryChance(scriptStateY)
        local scriptStateQO = getNestedStatValue(scriptStateY, {
            "SuperChance",
            "SuperLegendaryChance",
            "super_legendary_chance"
        })
        return(scriptStateEP / 100) * math.max(0, 1 + scriptStateQO), scriptStateQO
    end
    local function countDiscoveredPetVariants(scriptStateMT, scriptStateABP)
        if type(scriptStateMT) ~= "table" or type(scriptStateABP) ~= "string" then
            return 0
        end
        local scriptStateNS = 0
        for loopSlotAO, scriptStateFT in ipairs(scriptStateAFL) do
            local scriptStateAAC = scriptStateMT[scriptStateFT..scriptStateABP]
            if type(scriptStateAAC) == "number" then
                scriptStateNS = scriptStateNS + math.max(0, math.floor(scriptStateAAC))
            elseif scriptStateAAC == true then
                scriptStateNS = scriptStateNS + 1
            end
        end
        return scriptStateNS
    end
    local function getPetsForSelectedEgg(scriptStateTA)
        local scriptStateSV = {
        }
        if type(scriptStateTA) ~= "string" or scriptStateTA == "" or type(petRarityData) ~= "table" then
            return scriptStateSV
        end
        for loopSlotCR, scriptStateEB in pairs(petRarityData) do
            if type(loopSlotCR) == "string" and type(scriptStateEB) == "table" and scriptStateEB.Egg == scriptStateTA then
                table.insert(scriptStateSV, {
                    name = loopSlotCR,
                    chance = tonumber(scriptStateEB.Chance) or 0,
                    rank = scriptStateM[scriptStateEB.Rarity] or 50,
                })
            end
        end
        table.sort(scriptStateSV, function(scriptStateEN, scriptStateBQ)
            if scriptStateEN.chance ~= scriptStateBQ.chance then
                return scriptStateEN.chance > scriptStateBQ.chance
            end
            if scriptStateEN.rank ~= scriptStateBQ.rank then
                return scriptStateEN.rank < scriptStateBQ.rank
            end
            return scriptStateEN.name < scriptStateBQ.name
        end)
        return scriptStateSV
    end
    task.spawn(function()
        local scriptStateAW
        for loopSlotCN = 1, 60 do
            scriptStateAW = getDebugTagsContainer()
            if scriptStateAW then
                break
            end
            task.wait(1)
        end
        if not scriptStateAW then
            return
        end
        local rebirthLayoutOffset = 1000
            local scriptStateDZ = 64
        local scriptStateZT = # rebirthRarityList
            local scriptStateTV = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_ShowOthers", - 10000)
        local rebirthSelectedEggHatched = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_SelectedEggHatched", rebirthLayoutOffset + 1)
            local rebirthPetLabels = {
        }
        for loopSlotDB = 1, scriptStateDZ do
            rebirthPetLabels[loopSlotDB] = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_EggPetRow_"..loopSlotDB, rebirthLayoutOffset + 1 + loopSlotDB)
            if rebirthPetLabels[loopSlotDB] then
                rebirthPetLabels[loopSlotDB].TextSize = math.max(7, math.floor((rebirthPetLabels[loopSlotDB].TextSize or 14) * 0.72))
            end
        end
        local scriptStateCO = rebirthLayoutOffset + scriptStateDZ + 2
            local scriptStateQT = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_SecretsHatched", scriptStateCO);
        scriptStateCO = scriptStateCO + 1
        local rebirthGemGenieQuests = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_GemGenieQuests", scriptStateCO);
        scriptStateCO = scriptStateCO + 1
        local rebirthRebirthFuses = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_RebirthFuses", scriptStateCO);
        scriptStateCO = scriptStateCO + 1
        local scriptStateNL = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_SeasonPassQuests", scriptStateCO);
        scriptStateCO = scriptStateCO + 1
        local scriptStateAEA = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_OldSailorQuests", scriptStateCO);
        scriptStateCO = scriptStateCO + 1
        local rebirthXLChance = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_XLChance", 8)
            local scriptStateAF = {
        }
        for loopSlotBD = 1, scriptStateZT do
            scriptStateAF[loopSlotBD] = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_XLChanceRow_"..loopSlotBD, 8 + loopSlotBD)
            if scriptStateAF[loopSlotBD] then
                scriptStateAF[loopSlotBD].TextSize = math.max(7, math.floor((scriptStateAF[loopSlotBD].TextSize or 14) * 0.72))
            end
        end
        local scriptStateGU = getOrCreateDebugLabel(scriptStateAW, "BGSI_Lite_SuperLegendaryChance", 8 + scriptStateZT + 1)
            local scriptStateX = {
            rebirthSelectedEggHatched,
            scriptStateQT,
            rebirthGemGenieQuests,
            rebirthRebirthFuses,
            scriptStateNL,
            scriptStateAEA,
            rebirthXLChance,
            scriptStateGU,
        }
        local rebirthShowOthers = false
            local scriptStateAEY = false
        local scriptStateKF = false
            local scriptStateVP = 0
        local scriptStateBM = 0
            local function setDebugLabelText(debugLabel, labelText)
            if not debugLabel or typeof(debugLabel) ~= "Instance" then
                return
            end
            debugLabel.RichText = true
            debugLabel.Text = tostring(labelText or "")
            local scriptStateACY = debugLabel
            resizeDebugLabelToText(scriptStateACY)
            task.defer(function()
                resizeDebugLabelToText(scriptStateACY)
            end)
        end
        local function rebirthUpdateLabelsVisibility()
            for loopSlotDI, rebirthOtherLabel in ipairs(scriptStateX) do
                if rebirthOtherLabel and rebirthOtherLabel.Parent then
                    rebirthOtherLabel.Parent.Visible = rebirthShowOthers
                end
            end
            for loopSlotDU, rebirthPetLabel in ipairs(rebirthPetLabels) do
                if rebirthPetLabel and rebirthPetLabel.Parent then
                    rebirthPetLabel.Parent.Visible = rebirthShowOthers and scriptStateAEY and loopSlotDU <= scriptStateVP
                end
            end
            for loopSlotBR, rebirthRarityLabel in ipairs(scriptStateAF) do
                if rebirthRarityLabel and rebirthRarityLabel.Parent then
                    rebirthRarityLabel.Parent.Visible = rebirthShowOthers and scriptStateKF and loopSlotBR <= scriptStateBM
                end
            end
        end
        local function rebirthUpdateShowOthersButton()
            setDebugLabelText(scriptStateTV, rebirthShowOthers and "<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">Hide Others</stroke>" or "<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">Show Others</stroke>")
        end
        makeDebugLabelClickable(scriptStateTV, "BGSI_Lite_ShowOthersClick", function()
            rebirthShowOthers = not rebirthShowOthers
            rebirthUpdateLabelsVisibility()
            rebirthUpdateShowOthersButton()
        end)
        makeDebugLabelClickable(rebirthSelectedEggHatched, "BGSI_Lite_SelectedEggClick", function()
            scriptStateAEY = not scriptStateAEY
            rebirthUpdateLabelsVisibility()
        end)
        makeDebugLabelClickable(rebirthXLChance, "BGSI_Lite_XLChanceClick", function()
            scriptStateKF = not scriptStateKF
            rebirthUpdateLabelsVisibility()
        end)
        rebirthUpdateShowOthersButton()
        rebirthUpdateLabelsVisibility()
        while true do
            task.wait(1)
            local scriptStateXA = getPlayerDataSnapshot()
            local rebirthSelectedEgg = tostring(Config.selectedEgg or "")
            local scriptStateAS = type(scriptStateXA.EggsOpened) == "table" and scriptStateXA.EggsOpened or {
            }
            local scriptStateMX = type(scriptStateXA.QuestsCompleted) == "table" and scriptStateXA.QuestsCompleted or {
            }
            local rebirthEggDisplayName = rebirthSelectedEgg ~= "" and rebirthSelectedEgg:gsub("%s*Egg$", "") or "Selected Egg"
            local scriptStateABV = rebirthSelectedEgg ~= "" and tonumber(scriptStateAS[rebirthSelectedEgg]) or nil
            setDebugLabelText(rebirthSelectedEggHatched, string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">%s Eggs Hatched <b><font color = \"#ffe942\">%s</font></b> <font color = \"#888888\">%s</font></stroke>", rebirthEggDisplayName, formatNumberWithCommas(scriptStateABV or 0), scriptStateAEY and "v" or ">"))
            local scriptStateWS = getPetsForSelectedEgg(rebirthSelectedEgg)
            local rebirthDiscoveredPets = type(scriptStateXA.Discovered) == "table" and scriptStateXA.Discovered or {
            }
            scriptStateVP = math.min(# scriptStateWS, scriptStateDZ)
            if rebirthSelectedEgg == "" then
                scriptStateVP = 1
                setDebugLabelText(rebirthPetLabels[1], "<stroke color = \"#000000\" joins = \"round\" thickness = \"1.5\">  Select an egg to list pets.</stroke>")
            elseif # scriptStateWS == 0 then
                scriptStateVP = 1
                setDebugLabelText(rebirthPetLabels[1], "<stroke color = \"#000000\" joins = \"round\" thickness = \"1.5\">  No PetsData rows for this egg.</stroke>")
            else
                for loopSlotCY = 1, scriptStateVP do
                    setDebugLabelText(rebirthPetLabels[loopSlotCY], string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"1.5\">  %s <b><font color = \"#cfe9ff\">%s</font></b></stroke>", scriptStateWS[loopSlotCY].name, formatNumberWithCommas(countDiscoveredPetVariants(rebirthDiscoveredPets, scriptStateWS[loopSlotCY].name))))
                end
            end
            for rebirthPetLabelIndex = scriptStateVP + 1, scriptStateDZ do
                if rebirthPetLabels[rebirthPetLabelIndex] then
                    rebirthPetLabels[rebirthPetLabelIndex].Text = ""
                end
            end
            setDebugLabelText(scriptStateQT, string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">Secrets Hatched <b><font color = \"#ff6bff\">%s</font></b></stroke>", formatNumberWithCommas(scriptStateXA.SecretsHatched)))
            setDebugLabelText(rebirthGemGenieQuests, string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">Gem Genie Quests <b><font color = \"#40e0ff\">%s</font></b></stroke>", formatNumberWithCommas(scriptStateXA.GemGenieCompletions)))
            setDebugLabelText(rebirthRebirthFuses, string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">Rebirth Machine Fuses <b><font color = \"#7cff4f\">%s</font></b></stroke>", formatNumberWithCommas(scriptStateXA.RebirthMachineFuses)))
            local rebirthQuestCount2 = 0
            for rebirthQuestKey, scriptStateIY in pairs(scriptStateMX) do
                if type(rebirthQuestKey) == "string" and type(scriptStateIY) == "number" then
                    if rebirthQuestKey:match("^daily%-challenge%-") or rebirthQuestKey:match("^hourly%-challenge%-") then
                        rebirthQuestCount2 = rebirthQuestCount2 + scriptStateIY
                    end
                end
            end
            setDebugLabelText(scriptStateNL, string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">Season Pass Quests <b><font color = \"#ffa500\">%s</font></b></stroke>", formatNumberWithCommas(rebirthQuestCount2)))
            setDebugLabelText(scriptStateAEA, string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">Old Sailor Quests <b><font color = \"#4fd1c5\">%s</font></b></stroke>", formatNumberWithCommas(scriptStateMX["sailor-bounty"])))
            local scriptStateOQ, scriptStateDN = getXLChanceForRarity("Secret", scriptStateXA)
            local rebirthSecretBonusStr =(type(scriptStateDN) == "number" and scriptStateDN ~= 0) and(" +"..tostring(math.floor(scriptStateDN * 100 + 0.5)).."%") or ""
            setDebugLabelText(rebirthXLChance, string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">XL Chance (Secret%s) <b><font color = \"#b6f7ff\">1/%s</font></b> <font color = \"#888888\">%s</font></stroke>", rebirthSecretBonusStr, formatOneInChance(scriptStateOQ), scriptStateKF and "v" or ">"))
            scriptStateBM = 0
            for loopSlotBT, scriptStateJU in ipairs(rebirthRarityList) do
                local scriptStateIR = getXLChanceForRarity(scriptStateJU, scriptStateXA)
            if type(scriptStateIR) == "number" then
                    scriptStateBM = loopSlotBT
                    setDebugLabelText(scriptStateAF[loopSlotBT], string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"1.5\">  %s <b><font color = \"#cfe9ff\">1/%s</font></b></stroke>", scriptStateJU, formatOneInChance(scriptStateIR)))
                end
            end
            local scriptStateAZ, rebirthSuperLegendaryBonus = getSuperLegendaryChance(scriptStateXA)
            local rebirthSuperLegendaryBonusStr =(type(rebirthSuperLegendaryBonus) == "number" and rebirthSuperLegendaryBonus ~= 0) and(" +"..tostring(math.floor(rebirthSuperLegendaryBonus * 100 + 0.5)).."%") or ""
            setDebugLabelText(scriptStateGU, string.format("<stroke color = \"#000000\" joins = \"round\" thickness = \"2\">Super Legendary Chance%s <b><font color = \"#ffd166\">1/%s</font></b></stroke>", rebirthSuperLegendaryBonusStr, formatOneInChance(scriptStateAZ)))
            rebirthUpdateLabelsVisibility()
        end
    end)
end
do
    local scriptStateVO = "(Click 'Load egg list' below)"
            local scriptStateRK = "(Select an egg first)"
    local scriptStateADI = "(No tracked locations)"
            local scriptStateND, locationDropdownOptions
    if type(Config.selectedEgg) == "string" and Config.selectedEgg ~= "" then
        scriptStateND = {
            Config.selectedEgg
        }
        locationDropdownOptions = Config.selectedEgg
    else
        scriptStateND = {
            scriptStateVO
        }
        locationDropdownOptions = scriptStateVO
    end
    local scriptStateXN, locationDropdown
    local scriptStateAFS = {
    }
    local function formatEggLocationOption(scriptStateLP)
        local locationPosition = scriptStateLP and scriptStateLP.position
            local posX = locationPosition and locationPosition.X or 0
        local posY = locationPosition and locationPosition.Y or 0
            local scriptStateWB = locationPosition and locationPosition.Z or 0
        return string.format("X %.1f,Y %.1f,Z %.1f", posX, posY, scriptStateWB)
    end
    local function refreshEggLocationDropdown(scriptStateDS)
        if not locationDropdown then
            return
        end
        scriptStateAFS = {
        }
        local scriptStateTO = Config.selectedEgg
            local scriptStateCJ, scriptStateEY = {
        }, scriptStateRK
        if type(scriptStateTO) ~= "string" or scriptStateTO == "" or scriptStateTO == scriptStateVO then
            scriptStateCJ = {
                scriptStateRK
            }
        else
            local eggLocations = getEggLocationsByName(scriptStateTO, scriptStateDS == true)
            if # eggLocations == 0 then
                scriptStateCJ = {
                    scriptStateADI
                }
                scriptStateEY = scriptStateADI
            else
                local locationPriorities = type(Config.selectedEggLocationPriorities) == "table" and Config.selectedEggLocationPriorities or {
                }
                local scriptStateZX = locationPriorities[scriptStateTO]
                for loopSlotAZ, scriptStateUK in ipairs(eggLocations) do
                    local scriptStateSQ = formatEggLocationOption(scriptStateUK, loopSlotAZ)
                    scriptStateAFS[scriptStateSQ] = scriptStateUK.key
                    table.insert(scriptStateCJ, scriptStateSQ)
                    if scriptStateUK.key == scriptStateZX then
                        scriptStateEY = scriptStateSQ
                    end
                end
                if scriptStateEY == scriptStateRK then
                    scriptStateEY = scriptStateCJ[1]
                end
            end
        end
        if locationDropdown.SetValues then
            locationDropdown:SetValues(scriptStateCJ)
        end
        if locationDropdown.SetValue then
            pcall(function()
                locationDropdown:SetValue(scriptStateEY)
            end)
        end
    end
    local function refreshEggDropdownOptions(scriptStateMQ)
        local scriptStateTT = safeGetChildren(scriptStateMQ == true)
            if # scriptStateTT == 0 then
            Fluent:Notify({
                Title = "Eggs",
                Content = "No tracked eggs found yet.",
                Duration = 4
            })
            refreshEggLocationDropdown(scriptStateMQ)
            return
        end
        if scriptStateXN.SetValues then
            scriptStateXN:SetValues(scriptStateTT)
        end
        if type(Config.selectedEgg) ~= "string" or Config.selectedEgg == "" or not table.find(scriptStateTT, Config.selectedEgg) then
            Config.selectedEgg = scriptStateTT[1]
            saveConfig()
        end
        if scriptStateXN.SetValue then
            pcall(function()
                scriptStateXN:SetValue(Config.selectedEgg)
            end)
        end
        refreshEggLocationDropdown(scriptStateMQ)
    end
    scriptStateXN = eggTab:AddDropdown("SelectEgg", {
        Title = "Select Egg",
        Values = scriptStateND,
        Default = locationDropdownOptions,
        Multi = false,
        Search = true,
        Callback = function(selectedEggCallback)
            if selectedEggCallback and selectedEggCallback ~= scriptStateVO then
                Config.selectedEgg = selectedEggCallback
            saveConfig()
            refreshEggLocationDropdown(true)
            end
        end,
    })
    locationDropdown = eggTab:AddDropdown("SelectEggLocation", {
        Title = "Prioritised Location",
        Values = {
            scriptStateRK
        },
        Default = scriptStateRK,
        Multi = false,
        Search = true,
        Callback = function(scriptStateGM)
            local locationKeyFromDisplay = scriptStateAFS[scriptStateGM]
            local scriptStateVA = Config.selectedEgg
            if not locationKeyFromDisplay or type(scriptStateVA) ~= "string" or scriptStateVA == "" then
                return
            end
            Config.selectedEggLocationPriorities = type(Config.selectedEggLocationPriorities) == "table" and Config.selectedEggLocationPriorities or {
            }
            Config.selectedEggLocationPriorities[scriptStateVA] = locationKeyFromDisplay
            saveConfig()
        end,
    })
    eggTab:AddButton({
        Title = "Load egg list",
        Callback = function()
            refreshEggDropdownOptions(true)
        end,
    })
    eggTab:AddButton({
        Title = "Refresh egg locations",
        Callback = function()
            task.spawn(function()
                refreshEggScanNotification(false)
                refreshEggDropdownOptions(true)
            end)
        end,
    })
    eggTab:AddSection("Hatch")
    eggTab:AddToggle("AutoHatch", {
        Title = "Auto Hatch",
        Default = Config.autoHatch,
        Callback = function(scriptStateRG)
            Config.autoHatch = scriptStateRG;saveConfig()
        end,
    })
    eggTab:AddToggle("NoHatchAnim", {
        Title = "No Hatch Animation",
        Default = Config.noHatchAnim,
        Callback = function(scriptStateGQ)
            Config.noHatchAnim = scriptStateGQ
            saveConfig()
            if not hatchEffectModule then
                return
            end
            if scriptStateGQ then
                hatchEffectModule.Play = function(self,
                scriptStateUW)
                    if scriptStateUW and scriptStateUW.Pets then
                        local scriptStateCL = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
            if scriptStateCL:FindFirstChild("Hatching") then
                            scriptStateCL.Hatching.Visible = false
                        end
                        if scriptStateCL:FindFirstChild("HUD") then
                            scriptStateCL.HUD.Visible = true
                        end
                        self.animationPlaying = false
                    end
                end
            else
                hatchEffectModule.Play = scriptStateID
            end
        end,
    })
    eggTab:AddToggle("AutoSpamE", {
        Title = "Auto Spam E",
        Default = Config.autoSpamE,
        Callback = function(scriptStateFD)
            Config.autoSpamE = scriptStateFD;saveConfig()
        end,
    })
    eggTab:AddSection("Bounty")
    eggTab:AddToggle("AutoBounty", {
        Title = "Auto Hatch Bounty Egg",
        Default = Config.autoBounty,
        Callback = function(scriptStateGH)
            Config.autoBounty = scriptStateGH;saveConfig()
        end,
    })
    eggTab:AddToggle("SpawnRift", {
        Title = "Spawn Rift for Bounty (every hour)",
        Default = Config.spawnRift,
        Callback = function(scriptStateIZ)
            Config.spawnRift = scriptStateIZ;saveConfig()
        end,
    })
    eggTab:AddSection("Admin Abuse")
    eggTab:AddToggle("AutoLuckEgg", {
        Title = "Auto Hatch 4x Egg (AA)",
        Default = Config.autoLuckEgg,
        Callback = function(scriptStateGE)
            Config.autoLuckEgg = scriptStateGE;saveConfig()
        end,
    })
end
activeStates.BGSI_Lite_LuckEggActive = false
task.spawn(function()
    local luckEggCooldown = 0
    while true do
        task.wait(0)
        if Config.autoLuckEgg ~= true then
            if activeStates.BGSI_Lite_LuckEggActive then
                activeStates.BGSI_Lite_LuckEggActive = false
            end
            task.wait(BGSI_FEATURE_IDLE_WAIT or 0.85)
            continue
        end
        local summonedEgg = workspace:FindFirstChild("SummonedEgg")
            local scriptStateTL = summonedEgg and summonedEgg:FindFirstChild("EggPlatformSpawn")
            if not scriptStateTL then
            if activeStates.BGSI_Lite_LuckEggActive then
                activeStates.BGSI_Lite_LuckEggActive = false
                luckEggCooldown = 0
            end
            task.wait(1)
            continue
        end
        activeStates.BGSI_Lite_LuckEggActive = true
        local scriptStateDA = LocalPlayer and LocalPlayer.Character
            local scriptStateFV = scriptStateDA and scriptStateDA:FindFirstChild("HumanoidRootPart")
            if not scriptStateFV then
            task.wait(0.2)
            continue
        end
        if tick() - luckEggCooldown >= 5 then
            local rebirthPetVariant = scriptStateTL:IsA("BasePart") and scriptStateTL or scriptStateTL:FindFirstChildWhichIsA("BasePart", true)
            if rebirthPetVariant then
                pcall(function()
                    scriptStateFV.CFrame = rebirthPetVariant.CFrame + Vector3.new(0, 3, - 5)
                end)
                luckEggCooldown = tick()
            end
        end
        pcall(function()
            remoteEvent:FireServer("HatchEgg", "4x Luck 600M Egg", getMaxHatchAmount())
        end)
    end
end)
task.spawn(function()
    local scriptStateAFX = 0
    while true do
        task.wait(0)
        if Config.autoHatch ~= true then
            scriptStateAFX = 0;
            continue
        end
        if isPriorityAutomationActive() or activeStates.BGSI_Lite_LuckEggActive or activeStates.BGSI_Lite_RiftEggActive then
            continue
        end
        local scriptStateRX = LocalPlayer and LocalPlayer.Character
            if not scriptStateRX or not scriptStateRX:FindFirstChild("HumanoidRootPart") then
            continue
        end
        local scriptStateEL = Config.selectedEgg
            if type(scriptStateEL) ~= "string" or scriptStateEL == "" then
            continue
        end
        if tick() - scriptStateAFX >= 10 then
            pcall(function()
                teleportToEggByName(scriptStateEL)
            end)
            scriptStateAFX = tick()
        end
        fireHatchEgg(scriptStateEL)
    end
end)
task.spawn(function()
    while true do
        task.wait(0)
        if Config.autoSpamE ~= true then
            continue
        end
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
    end
end)
local function getLuckEggPosition(scriptStateMK)
    if type(scriptStateMK) ~= "table" then
        return nil
    end
    if type(scriptStateMK.Egg) == "string" then
        return scriptStateMK.Egg
    end
    local scriptStateT = scriptStateMK.Task
            if type(scriptStateT) == "table" then
        if type(scriptStateT.Egg) == "string" then
            return scriptStateT.Egg
        end
        if type(scriptStateT[1]) == "table" and type(scriptStateT[1].Egg) == "string" then
            return scriptStateT[1].Egg
        end
    end
    if type(scriptStateMK.Tasks) == "table" then
        for loopSlotP, scriptStateBV in pairs(scriptStateMK.Tasks) do
            if type(scriptStateBV) == "table" then
                if type(scriptStateBV.Egg) == "string" then
                    return scriptStateBV.Egg
                end
                if type(scriptStateBV.Item) == "table" and type(scriptStateBV.Item.Egg) == "string" then
                    return scriptStateBV.Item.Egg
                end
            end
        end
    end
    if type(scriptStateMK.Rewards) == "table" then
        for loopSlotM, rewardItem in ipairs(scriptStateMK.Rewards) do
            if type(rewardItem) == "table" and type(rewardItem.Egg) == "string" then
                return rewardItem.Egg
            end
        end
    end
    return nil
end
local scriptStateAAR = false
            local function stopLuckEggAutomation()
    if bountyUtil and type(bountyUtil.GetQuest) == "function" and type(bountyUtil.GetSeed) == "function" then
        for loopSlotCK, scriptStateXM in ipairs({
            0,
            - 1,
            1
        }) do
            local loopSlotBO, scriptStateAFE = pcall(function()
                return bountyUtil:GetQuest(bountyUtil:GetSeed() + scriptStateXM)
            end)
            if loopSlotBO then
                local scriptStateEH = getLuckEggPosition(scriptStateAFE)
            if type(scriptStateEH) == "string" and scriptStateEH ~= "" then
                    return scriptStateEH
                end
            end
        end
    end
    local scriptStateZZ, questKey = pcall(function()
        return profileStore:IsReady() and profileStore:Get() or nil
    end)
    if scriptStateZZ and type(questKey) == "table" then
        for loopSlotAY, scriptStateSJ in ipairs({
            "Bounty",
            "BountyQuest",
            "DailyBounty"
        }) do
            local eggResult = getLuckEggPosition(questKey[scriptStateSJ])
            if type(eggResult) == "string" and eggResult ~= "" then
                return eggResult
            end
        end
    end
    if not bountyUtil and not scriptStateAAR then
        scriptStateAAR = true
        warn("[1rzHub Lite] BountyUtil module not found - Auto Bounty won't work in this game version.")
    end
    return nil
end
task.spawn(function()
    local scriptStatePN = 0
    while true do
        task.wait(0)
        if Config.autoBounty ~= true then
            continue
        end
        if isPriorityAutomationActive() or activeStates.BGSI_Lite_LuckEggActive or activeStates.BGSI_Lite_RiftEggActive then
            continue
        end
        local scriptStateCI = stopLuckEggAutomation()
            if not scriptStateCI then
            task.wait(2)
            continue
        end
        local scriptStateST = LocalPlayer and LocalPlayer.Character
            if not scriptStateST or not scriptStateST:FindFirstChild("HumanoidRootPart") then
            continue
        end
        if tick() - scriptStatePN >= 5 then
            pcall(function()
                teleportToEggByName(scriptStateCI)
            end)
            scriptStatePN = tick()
        end
        fireHatchEgg(scriptStateCI)
    end
end)
task.spawn(function()
    while true do
        if not Config.spawnRift then
            task.wait(2)
            continue
        end
        local scriptStateZL = stopLuckEggAutomation()
            if scriptStateZL then
            local bountyWorld =(scriptStateZL == "Mining Egg" or scriptStateZL == "Neon Egg" or scriptStateZL == "Cyber Egg") and "Minigame Paradise" or "The Overworld"
            pcall(function()
                remoteFunction:InvokeServer("SummonRift", {
                    Type = "Egg",
                    Name = scriptStateZL,
                    World = bountyWorld,
                    Time = 5,
                    Luck = 5,
                })
            end)
        end
        task.wait(3600)
    end
end) do
    scriptStateCZ:AddSection("Present Rain")
    scriptStateCZ:AddToggle("AutoCollectPresentRain", {
        Title = "Auto Collect Present Rain",
        Default = Config.autoCollectPresentRain,
        Callback = function(scriptStateQK)
            Config.autoCollectPresentRain = scriptStateQK
            saveConfig()
        end,
    })
end
local scriptStateZK = {
}
local function findPresentRainCollectables(scriptStateAFM)
    if not Config.autoCollectPresentRain then
        return
    end
    if not scriptStateAFM or typeof(scriptStateAFM) ~= "Instance" or not scriptStateAFM:IsA("Folder") then
        return
    end
    local scriptStateQ = scriptStateAFM.Name
            if type(scriptStateQ) ~= "string" or scriptStateQ == "" or scriptStateZK[scriptStateQ] then
        return
    end
    scriptStateZK[scriptStateQ] = true
    pcall(function()
        remoteEvent:FireServer("CollectPresentRain", scriptStateQ)
    end)
end
task.spawn(function()
    local scriptStateAES = Workspace:WaitForChild("Markers", 600)
            if not scriptStateAES then
        return
    end
    local scriptStateZE = scriptStateAES:WaitForChild("PresentRain", 600)
            if not scriptStateZE then
        return
    end
    for loopSlotL, scriptStateACL in ipairs(scriptStateZE:GetChildren()) do
        findPresentRainCollectables(scriptStateACL)
    end
    scriptStateZE.ChildAdded:Connect(function(scriptStateDH)
        task.defer(function()
            findPresentRainCollectables(scriptStateDH)
        end)
    end)
end)
local function getSelectedChestName()
    local loopSlotBX, scriptStateBS = pcall(function()
        return profileStore:IsReady() and profileStore:Get() or nil
    end)
    return loopSlotBX and type(scriptStateBS) == "table" and scriptStateBS or nil
end
local function fireRemoteEventRepeatedly(scriptStateQA, scriptStateKI)
    if not scriptStateQA then
        return
    end
    if scriptStateQA.SetValues then
        scriptStateQA:SetValues(scriptStateKI)
    elseif scriptStateQA.Refresh then
        scriptStateQA:Refresh(scriptStateKI, false)
    end
end
local function getPotionList(scriptStateCU)
    local scriptStateRZ = Workspace:FindFirstChild("Rendered")
    return scriptStateRZ and scriptStateRZ:FindFirstChild(scriptStateCU) or nil
end
local function getPotionDisplayName(scriptStateABT)
    if not scriptStateABT then
        return nil
    end
    local pivotSuccess, scriptStateCK = pcall(function()
        return scriptStateABT:GetPivot()
    end)
    if pivotSuccess and typeof(scriptStateCK) == "CFrame" then
        return scriptStateCK
    end
    local scriptStateADC = scriptStateABT:IsA("BasePart") and scriptStateABT or scriptStateABT:FindFirstChildWhichIsA("BasePart", true)
    return scriptStateADC and scriptStateADC.CFrame or nil
end
do
    local function addUniqueName(nameList, scriptStateVH, scriptStateBP)
        if type(scriptStateBP) == "string" and scriptStateBP ~= "" and not scriptStateVH[scriptStateBP] then
            scriptStateVH[scriptStateBP] = true
            table.insert(nameList, scriptStateBP)
        end
    end
    local function getWorldChestNames()
        local chestList, chestSet = {
        }, {
        }
        local chestFolder = getPotionList("Chests")
            if chestFolder then
            for loopSlotCW, scriptStateLD in ipairs(chestFolder:GetChildren()) do
                addUniqueName(chestList, chestSet, scriptStateLD.Name)
            end
        end
        for chestIndex, scriptStateAU in ipairs({
            "Giant Chest",
            "Infinity Chest",
            "Ticket Chest",
            "Void Chest"
        }) do
            addUniqueName(chestList, chestSet, scriptStateAU)
        end
        table.sort(chestList)
        return chestList
    end
    local function getChestRiftNames()
        local loopSlotX, riftSet = {
        }, {
        }
        if type(riftData) == "table" then
            for riftKeyEntry, potionEntry in pairs(riftData) do
                if type(potionEntry) == "table" and potionEntry.Type == "Chest" then
                    addUniqueName(loopSlotX, riftSet, riftKeyEntry)
                end
            end
        end
        local scriptStateJQ = getPotionList("Rifts")
            if scriptStateJQ then
            for loopSlotAU, scriptStateACA in ipairs(scriptStateJQ:GetChildren()) do
                local riftInfoEntry = type(riftData) == "table" and riftData[scriptStateACA.Name] or nil
            if type(riftInfoEntry) == "table" and riftInfoEntry.Type == "Chest" then
                    addUniqueName(loopSlotX, riftSet, scriptStateACA.Name)
                end
            end
        end
        for loopSlotCO, defaultChestName in ipairs({
            "golden-chest",
            "royal-chest",
            "super-chest",
            "dice-rift",
            "moon-chest"
        }) do
            addUniqueName(loopSlotX, riftSet, defaultChestName)
        end
        table.sort(loopSlotX)
        return loopSlotX
    end
    local function findRenderedObjectByName(objectName, worldList)
        if type(objectName) ~= "string" or objectName == "" then
            return nil
        end
        local worldChestList = string.lower(objectName)
        for worldListIndex, filteredEggs in ipairs(worldList) do
            local filteredEggs = getPotionList(filteredEggs)
            if filteredEggs then
                for loopSlotF, renderedChild in ipairs(filteredEggs:GetChildren()) do
                    if string.lower(renderedChild.Name) == worldChestList then
                        return renderedChild
                    end
                end
            end
        end
        return nil
    end
    local function getRiftWorldName(scriptStateRC)
        local riftWorldData = type(riftData) == "table" and riftData[scriptStateRC] or nil
            if type(riftWorldData) == "table" and type(riftWorldData.World) == "string" then
            return riftWorldData.World
        end
        return scriptStateRC == "dice-rift" and "Minigame Paradise" or "The Overworld"
    end
    local function summonMoonRiftIfNeeded(riftEggName)
        if type(riftEggName) ~= "string" or riftEggName == "" then
            return
        end
        if string.find(string.lower(riftEggName), "moon", 1, true) then
            pcall(function()
                remoteFunction:InvokeServer("SummonMoonRift", {
                    Type = "Chest",
                    Time = 1
                })
            end)
            return
        end
        pcall(function()
            remoteFunction:InvokeServer("SummonRift", {
                Name = riftEggName,
                Type = "Chest",
                Time = 5,
                World = getRiftWorldName(riftEggName),
            })
        end)
    end
    local function teleportToRift(scriptStateGY)
        local scriptStateMB = findRenderedObjectByName(scriptStateGY, {
            "Rifts"
        })
        local scriptStateYX = getPotionDisplayName(scriptStateMB)
            if scriptStateYX then
            teleportToCFrame(scriptStateYX + Vector3.new(0, 3, 0))
        end
    end
    -- Chest helper: attempts to claim the named chest with the supported remotes.
    local function claimChestByName(chestName)
        if type(chestName) ~= "string" or chestName == "" then
            return
        end
        pcall(function()
            remoteEvent:FireServer("ClaimChest", chestName, true)
            remoteEvent:FireServer("ClaimChest", chestName)
        end)
    end
    local worldChestList = getWorldChestNames()
            if Config.selectedWorldChest == "Giant Chest" and table.find(worldChestList, Config.selectedChest) then
        Config.selectedWorldChest = Config.selectedChest
    end
    if not table.find(worldChestList, Config.selectedWorldChest) then
        Config.selectedWorldChest = worldChestList[1] or "Giant Chest"
    end
    local chestRiftNames = getChestRiftNames()
            if not table.find(chestRiftNames, Config.selectedChest) then
        Config.selectedChest = chestRiftNames[1] or "golden-chest"
    end
    potionTab:AddSection("Normal Chests")
    local worldChestDropdown = potionTab:AddDropdown("SelectedWorldChest", {
        Title = "Select Chest",
        Values = worldChestList,
        Default = Config.selectedWorldChest,
        Multi = false,
        Search = true,
        Callback = function(selectedWorldChestCallback)
            Config.selectedWorldChest = selectedWorldChestCallback
            saveConfig()
        end,
    })
    potionTab:AddToggle("AutoClaimWorldChest", {
        Title = "Auto Claim Chest",
        Default = Config.autoClaimWorldChest,
        Callback = function(autoClaimWorldChestToggle)
            Config.autoClaimWorldChest = autoClaimWorldChestToggle
            saveConfig()
        end,
    })
    potionTab:AddSection("Rift Chests")
    local scriptStateABS = potionTab:AddDropdown("SelectedRiftChest", {
        Title = "Select Rift Chest",
        Values = chestRiftNames,
        Default = Config.selectedChest,
        Multi = false,
        Search = true,
        Callback = function(selectedRiftChestCallback)
            Config.selectedChest = selectedRiftChestCallback
            saveConfig()
        end,
    })
    potionTab:AddButton({
        Title = "Refresh chest lists",
        Callback = function()
            fireRemoteEventRepeatedly(worldChestDropdown, getWorldChestNames())
            fireRemoteEventRepeatedly(scriptStateABS, getChestRiftNames())
        end,
    })
    potionTab:AddToggle("AutoChestSummon", {
        Title = "Auto Spawn Rift Chest",
        Default = Config.autoChestSummon,
        Callback = function(scriptStateQJ)
            Config.autoChestSummon = scriptStateQJ
            saveConfig()
        end,
    })
    potionTab:AddToggle("AutoChest", {
        Title = "Auto Use Keys on Rift Chest",
        Default = Config.autoChest,
        Callback = function(scriptStateGJ)
            Config.autoChest = scriptStateGJ
            saveConfig()
        end,
    })
    task.spawn(function()
        while true do
            task.wait(Config.autoClaimWorldChest and 1 or 0.85)
            if Config.autoClaimWorldChest then
                claimChestByName(Config.selectedWorldChest)
            end
        end
    end)
    task.spawn(function()
        local scriptStateACV = 0
        while true do
            task.wait(Config.autoChestSummon and 1 or 0.85)
            if Config.autoChestSummon and tick() - scriptStateACV >= 3600 then
                summonMoonRiftIfNeeded(Config.selectedChest)
                scriptStateACV = tick()
            end
        end
    end)
    task.spawn(function()
        local scriptStateZW = 0
        while true do
            task.wait(Config.autoChest and 0.3 or 0.85)
            if Config.autoChest then
                if tick() - scriptStateZW >= 3 then
                    teleportToRift(Config.selectedChest)
                    scriptStateZW = tick()
                end
                pcall(function()
                    remoteEvent:FireServer("UnlockRiftChest", Config.selectedChest, false)
                end)
            end
        end
    end)
end
do
    local function addUniqueRiftName(scriptStateBC, scriptStateFY, scriptStateOH)
        if type(scriptStateOH) == "string" and scriptStateOH ~= "" and not scriptStateFY[scriptStateOH] then
            scriptStateFY[scriptStateOH] = true
            table.insert(scriptStateBC, scriptStateOH)
        end
    end
    local function splitRiftNameAndIndex(scriptStateUO)
        local scriptStatePL, scriptStateKL = string.match(tostring(scriptStateUO or ""), "^(.-)%-(%d+)$")
        return scriptStatePL, tonumber(scriptStateKL)
    end
    local function normalizeRiftName(scriptStateWZ)
        local scriptStateKV = string.lower(tostring(scriptStateWZ or ""))
        scriptStateKV = string.gsub(scriptStateKV, "%-all$", "")
        scriptStateKV = string.gsub(scriptStateKV, "%-rift$", "")
        return scriptStateKV
    end
    local function getRiftEggOptions()
        local loopSlotCB, loopSlotAM = {
        }, {
        }
        local scriptStateLM = type(riftData) == "table" and next(riftData) ~= nil
            if type(riftData) == "table" then
            for loopSlotCU, scriptStateTH in pairs(riftData) do
                if type(scriptStateTH) == "table" and scriptStateTH.Type == "Egg" then
                    addUniqueRiftName(loopSlotCB, loopSlotAM, loopSlotCU)
                end
            end
        end
        local scriptStateIX = getPotionList("Rifts")
            if scriptStateIX then
            for loopSlotAD, scriptStateZB in ipairs(scriptStateIX:GetChildren()) do
                local scriptStateNE = scriptStateLM and riftData[scriptStateZB.Name] or nil
            if not scriptStateLM or(type(scriptStateNE) == "table" and scriptStateNE.Type == "Egg") then
                    addUniqueRiftName(loopSlotCB, loopSlotAM, scriptStateZB.Name)
                end
            end
        end
        local scriptStateOL = {
        }
        for loopSlotCC, scriptStateHK in ipairs(loopSlotCB) do
            local loopSlotDH, scriptStateTW = splitRiftNameAndIndex(scriptStateHK)
            if loopSlotDH and scriptStateTW then
                scriptStateOL[loopSlotDH] =(scriptStateOL[loopSlotDH] or 0) + 1
            end
        end
        for loopSlotAG, scriptStateQV in pairs(scriptStateOL) do
            if scriptStateQV > 1 then
                addUniqueRiftName(loopSlotCB, loopSlotAM, loopSlotAG.."-all")
            end
        end
        table.sort(loopSlotCB)
        return loopSlotCB
    end
    local function resolveAllRiftSelection(scriptStateHM)
        if type(scriptStateHM) ~= "string" or scriptStateHM == "" then
            return scriptStateHM
        end
        local baseNamePart = string.match(scriptStateHM, "^(.-)%-all$")
            if not baseNamePart then
            return scriptStateHM
        end
        local selectedRiftOption, scriptStateQS, scriptStateQP = nil, - 1, normalizeRiftName(baseNamePart)
        for loopSlotDG, riftOption in ipairs(getRiftEggOptions()) do
            local loopSlotDN, riftIndexPart = splitRiftNameAndIndex(riftOption)
            if loopSlotDN and riftIndexPart and normalizeRiftName(loopSlotDN) == scriptStateQP and riftIndexPart > scriptStateQS then
                selectedRiftOption, scriptStateQS = riftOption, riftIndexPart
            end
        end
        return selectedRiftOption or scriptStateHM
    end
    local function getRiftEggName(scriptStateCN)
        if type(riftData) == "table" then
            local potionDataEntry = riftData[scriptStateCN]
            if type(potionDataEntry) == "table" and potionDataEntry.Type == "Egg" and type(potionDataEntry.Egg) == "string" then
                return potionDataEntry.Egg
            end
        end
        local scriptStateVF = tostring(scriptStateCN or ""):gsub("%-rift%-?%d*$", ""):gsub("-", " ")
        return scriptStateVF:gsub("(%a)([%w_']*)", function(firstLetter, scriptStateAFG)
            return firstLetter:upper()..
            scriptStateAFG:lower()
        end).." Egg"
    end
    local function getRiftIconImage(riftDisplay)
        local displayChild = riftDisplay and riftDisplay:FindFirstChild("Display")
            local surfaceGuiChild = displayChild and displayChild:FindFirstChild("SurfaceGui")
        local scriptStateXP = surfaceGuiChild and surfaceGuiChild:FindFirstChild("Icon")
            local scriptStateDD = scriptStateXP and scriptStateXP:FindFirstChild("Luck")
        return scriptStateDD and(tonumber(tostring(scriptStateDD.Text):match("%d+")) or 0) or 0
    end
    local function findMatchingRift(riftSearchName)
        local riftsFolder = getPotionList("Rifts")
            if not riftsFolder then
            return nil
        end
        local riftDisplayName, scriptStateJG, scriptStateNQ = string.lower(riftSearchName or ""), nil, - 1
        for loopSlotY, scriptStateCD in ipairs(riftsFolder:GetChildren()) do
            if string.lower(scriptStateCD.Name) == riftDisplayName then
                local riftIconLuck = getRiftIconImage(scriptStateCD)
            if riftIconLuck > scriptStateNQ then
                    scriptStateJG, scriptStateNQ = scriptStateCD, riftIconLuck
                end
            end
        end
        return scriptStateJG
    end
    local function hatchSelectedRiftEgg()
        local scriptStateADM = resolveAllRiftSelection(Config.selectedRiftEgg)
            if type(scriptStateADM) ~= "string" or scriptStateADM == "" then
            return
        end
        if string.find(string.lower(scriptStateADM), "moon", 1, true) then
            pcall(function()
                remoteFunction:InvokeServer("SummonMoonRift", {
                    Type = "Egg",
                    Time = 5,
                    Luck = 5
                })
            end)
            return
        end
        local scriptStateFU = getRiftEggName(scriptStateADM)
            local scriptStateJY =(scriptStateFU == "Mining Egg" or scriptStateFU == "Neon Egg" or scriptStateFU == "Cyber Egg") and "Minigame Paradise" or "The Overworld"
        pcall(function()
            remoteFunction:InvokeServer("SummonRift", {
                Type = "Egg",
                Name = scriptStateFU,
                World = scriptStateJY,
                Time = 5,
                Luck = 5,
            })
        end)
    end
    local riftEggOptions = getRiftEggOptions()
            if Config.selectedRiftEgg == "" or not table.find(riftEggOptions, Config.selectedRiftEgg) then
        Config.selectedRiftEgg = riftEggOptions[1] or ""
    end
    local scriptStateADK = 0
    eggTab:AddSection("Rift Eggs")
    local scriptStateFH = eggTab:AddDropdown("SelectRiftEgg", {
        Title = "Rift Egg",
        Values = # riftEggOptions > 0 and riftEggOptions or {
            "(No rifts found)"
        },
        Default = Config.selectedRiftEgg ~= "" and Config.selectedRiftEgg or "(No rifts found)",
        Multi = false,
        Search = true,
        Callback = function(riftEggCallback)
            if riftEggCallback and riftEggCallback ~= "(No rifts found)" then
                Config.selectedRiftEgg = riftEggCallback
            saveConfig()
            end
        end,
    })
    eggTab:AddButton({
        Title = "Refresh rift list",
        Callback = function()
            fireRemoteEventRepeatedly(scriptStateFH,
            getRiftEggOptions())
        end,
    })
    eggTab:AddToggle("AutoRiftEgg", {
        Title = "Auto Hatch Rift Egg",
        Default = Config.autoRiftEgg,
        Callback = function(scriptStateAAI)
            Config.autoRiftEgg = scriptStateAAI
            if not scriptStateAAI then
                activeStates.BGSI_Lite_RiftEggActive = false
            end
            saveConfig()
        end,
    })
    eggTab:AddToggle("AutoRiftEggSpawn", {
        Title = "Auto Spawn Rift Egg",
        Default = Config.autoRiftEggSpawn,
        Callback = function(scriptStateCG)
            Config.autoRiftEggSpawn = scriptStateCG
            if scriptStateCG then
                hatchSelectedRiftEgg()
                lastRiftSpawnAt = tick()
            end
            saveConfig()
        end,
    })
    task.spawn(function()
        while true do
            task.wait(Config.autoRiftEggSpawn and 1 or 0.85)
            if Config.autoRiftEggSpawn then
                local scriptStateLT = tostring(Config.selectedRiftEgg or "")
            local scriptStateNP = string.find(string.lower(scriptStateLT), "moon", 1, true) and 14400 or 3600
            if tick() - scriptStateADK >= scriptStateNP then
                    hatchSelectedRiftEgg()
                    scriptStateADK = tick()
                end
            end
        end
    end)
    task.spawn(function()
        local riftActiveCooldown = 0
        while true do
            task.wait(Config.autoRiftEgg and 0 or 0.85)
            if not Config.autoRiftEgg then
                activeStates.BGSI_Lite_RiftEggActive = false
                continue
            end
            local scriptStateON = resolveAllRiftSelection(Config.selectedRiftEgg)
            local scriptStateUN = scriptStateON and findMatchingRift(scriptStateON)
            activeStates.BGSI_Lite_RiftEggActive = scriptStateUN ~= nil
            if not scriptStateUN or isPriorityAutomationActive() or activeStates.BGSI_Lite_LuckEggActive then
                continue
            end
            if tick() - riftActiveCooldown >= 5 then
                local scriptStateCB = getPotionDisplayName(scriptStateUN)
            if scriptStateCB then
                    teleportToCFrame(scriptStateCB + Vector3.new(3, 5, 0))
                end
                riftActiveCooldown = tick()
            end
            fireHatchEgg(getRiftEggName(scriptStateON))
        end
    end)
end
do
    local function getPotionNames()
        local scriptStateKC = {
        }
        if type(potionData) == "table" then
            for loopSlotCX, scriptStateUF in pairs(potionData) do
                if type(loopSlotCX) == "string" and type(scriptStateUF) == "table" then
                    table.insert(scriptStateKC, {
                        name = loopSlotCX,
                        order = tonumber(scriptStateUF.LayoutOrder) or 9999
                    })
                end
            end
        end
        table.sort(scriptStateKC, function(scriptStateHA, scriptStateQF)
            return scriptStateHA.order == scriptStateQF.order and scriptStateHA.name < scriptStateQF.name or scriptStateHA.order < scriptStateQF.order
        end)
        local loopSlotCE = {
        }
        for loopSlotBS, scriptStatePS in ipairs(scriptStateKC) do
            table.insert(loopSlotCE, scriptStatePS.name)
        end
        if # loopSlotCE == 0 then
            loopSlotCE = {
                "Speed",
                "Lucky",
                "Mythic",
                "Coins",
                "Secret Elixir",
                "Infinity Elixir",
                "Egg Elixir"
            }
        end
        return loopSlotCE
    end
    local function getPotionLevels(scriptStateJ)
        local scriptStateRU = type(potionData) == "table" and potionData[scriptStateJ] or nil
            if type(scriptStateRU) == "table" then
            if scriptStateRU.OneLevel == true then
                return{
                    "1"
                }
            end
            local potionBuffExpiry = scriptStateRU.Buff and scriptStateRU.Buff.Expiry
            if type(potionBuffExpiry) == "table" and # potionBuffExpiry > 0 then
                local scriptStateNA = {
                }
                for loopSlotAJ = 1, # potionBuffExpiry do
                    scriptStateNA[loopSlotAJ] = tostring(loopSlotAJ)
                end
                return scriptStateNA
            end
        end
        return{
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7"
        }
    end
    local scriptStateWI = getPotionNames()
            if not table.find(scriptStateWI, Config.potionType) then
        Config.potionType = scriptStateWI[1]
    end
    local scriptStateMW = getPotionLevels(Config.potionType)
            if not table.find(scriptStateMW, tostring(Config.potionLevel)) then
        Config.potionLevel = tonumber(scriptStateMW[1]) or 1
    end
    scriptStateYT:AddSection("Auto Use")
    local potionLevelDropdown
    scriptStateYT:AddDropdown("PotionType", {
        Title = "Potion Type",
        Values = scriptStateWI,
        Default = Config.potionType,
        Multi = false,
        Search = true,
        Callback = function(selectedPotionTypeCallback)
            Config.potionType = selectedPotionTypeCallback
            local scriptStateIN = getPotionLevels(selectedPotionTypeCallback)
            fireRemoteEventRepeatedly(potionLevelDropdown, scriptStateIN)
            if not table.find(scriptStateIN, tostring(Config.potionLevel)) then
                Config.potionLevel = tonumber(scriptStateIN[1]) or 1
                if potionLevelDropdown and potionLevelDropdown.SetValue then
                    pcall(function()
                        potionLevelDropdown:SetValue(tostring(Config.potionLevel))
                    end)
                end
            end
            saveConfig()
        end,
    })
    potionLevelDropdown = scriptStateYT:AddDropdown("PotionLevel", {
        Title = "Level",
        Values = scriptStateMW,
        Default = tostring(Config.potionLevel),
        Multi = false,
        Callback = function(scriptStateKQ)
            Config.potionLevel = tonumber(scriptStateKQ) or 1
            saveConfig()
        end,
    })
    scriptStateYT:AddSlider("PotionUseAmount", {
        Title = "Potions Per Use",
        Min = 1,
        Max = 250,
        Default = Config.potionUseAmount,
        Rounding = 0,
        Callback = function(scriptStateAFB)
            Config.potionUseAmount = math.clamp(math.floor(tonumber(scriptStateAFB) or 1),
            1,
            250)
            saveConfig()
        end,
    })
    scriptStateYT:AddToggle("AutoUsePotions", {
        Title = "Auto Use Potions",
        Default = Config.potionAuto,
        Callback = function(scriptStateGS)
            Config.potionAuto = scriptStateGS
            saveConfig()
        end,
    })
    task.spawn(function()
        while true do
            task.wait(Config.potionAuto and 0.15 or 0.85)
            if Config.potionAuto then
                pcall(function()
                    remoteEvent:FireServer("UsePotion", Config.potionType, Config.potionLevel, Config.potionUseAmount)
                end)
            end
        end
    end)
end
do
    local scriptStateBY = {
        "Pets",
        "Buffs",
        "Shops",
        "Rift",
        "Minigames"
    }
    gameTab:AddSection("Thangs")
    gameTab:AddToggle("AutoPlaytime", {
        Title = "Claim Playtime",
        Default = Config.autoPlaytime,
        Callback = function(scriptStateFS)
            Config.autoPlaytime = scriptStateFS;saveConfig()
        end,
    })
    gameTab:AddToggle("AutoEquipBestPets", {
        Title = "Auto Equip Best Pets",
        Default = Config.autoEquipBestPets,
        Callback = function(autoEquipBestPetsToggle)
            Config.autoEquipBestPets = autoEquipBestPetsToggle;saveConfig()
        end,
    })
    gameTab:AddToggle("AutoUpgradeMastery", {
        Title = "Auto Upgrade Mastery",
        Default = Config.autoUpgradeMastery,
        Callback = function(autoUpgradeMasteryToggle)
            Config.autoUpgradeMastery = autoUpgradeMasteryToggle;saveConfig()
        end,
    })
    gameTab:AddToggle("AutoPowerOrbEquipped", {
        Title = "Auto Power Orb",
        Default = Config.autoPowerOrbEquipped,
        Callback = function(scriptStateAER)
            Config.autoPowerOrbEquipped = scriptStateAER;saveConfig()
        end,
    })
    gameTab:AddSection("Coins and Bubbles")
    gameTab:AddToggle("AutoCollectCoins", {
        Title = "Auto Collect Coins/Pickups",
        Default = Config.autoCollectCoins,
        Callback = function(autoCollectCoinsToggle)
            Config.autoCollectCoins = autoCollectCoinsToggle
            pcall(installPickupRangeHook)
            saveConfig()
        end,
    })
    gameTab:AddToggle("AutoBubble", {
        Title = "Auto Bubble",
        Default = Config.autoBubble,
        Callback = function(scriptStateTF)
            Config.autoBubble = scriptStateTF;saveConfig()
        end,
    })
    gameTab:AddToggle("AutoSellBubble", {
        Title = "Auto Sell Bubble",
        Default = Config.autoSell,
        Callback = function(scriptStateAEL)
            Config.autoSell = scriptStateAEL;saveConfig()
        end,
    })

    gameTab:AddSection("Shops")

    local cachedShopData = nil

    local function getShopData()
        if type(cachedShopData) == "table" then
            return cachedShopData
        end

        local ok, shops = pcall(function()
            return require(ReplicatedStorage.Shared.Data.Shops)
        end)

        if ok and type(shops) == "table" then
            cachedShopData = shops
        else
            cachedShopData = {}
        end

        return cachedShopData
    end

    local function refreshShopData()
        cachedShopData = nil
        return getShopData()
    end

    local function getSelectedValues(selectionTable)
        local selectedValues = {}

        if type(selectionTable) ~= "table" then
            return selectedValues
        end

        local hasArrayValues = false
        for _, selectedName in ipairs(selectionTable) do
            hasArrayValues = true
            if type(selectedName) == "string" and selectedName ~= "" then
                table.insert(selectedValues, selectedName)
            end
        end

        if hasArrayValues then
            return selectedValues
        end

        for selectedName, isSelected in pairs(selectionTable) do
            if isSelected and type(selectedName) == "string" and selectedName ~= "" then
                table.insert(selectedValues, selectedName)
            end
        end

        table.sort(selectedValues)
        return selectedValues
    end

    local function getSortedShopNames()
        local shopNames = {}
        local shops = getShopData()

        for shopName in pairs(shops) do
            if type(shopName) == "string" and shopName ~= "" then
                table.insert(shopNames, shopName)
            end
        end

        table.sort(shopNames)
        return shopNames
    end

    local function getShopItemName(shopItem, depth)
        depth = depth or 0
        if depth > 4 or shopItem == nil then
            return nil
        end

        if type(shopItem) == "string" then
            return shopItem
        end

        if type(shopItem) ~= "table" then
            return tostring(shopItem)
        end

        local itemData = shopItem.Item
        if type(itemData) == "string" then
            return itemData
        elseif type(itemData) == "table" then
            local productData = itemData.Product
            if type(productData) == "string" then
                return productData
            elseif type(productData) == "table" then
                local nestedProductName = getShopItemName(productData, depth + 1)
                if nestedProductName then
                    return nestedProductName
                end
            end

            local directItemName = itemData.Name or itemData.Item or itemData.ItemName or itemData.Id
            if type(directItemName) == "string" then
                return directItemName
            elseif directItemName ~= nil then
                return tostring(directItemName)
            end

            if itemData[1] ~= nil then
                return getShopItemName(itemData[1], depth + 1)
            end
        end

        local directName = shopItem.Name or shopItem.ItemName or shopItem.Id or shopItem.Product
        if type(directName) == "string" then
            return directName
        elseif directName ~= nil then
            return tostring(directName)
        end

        if shopItem[1] ~= nil then
            return getShopItemName(shopItem[1], depth + 1)
        end

        return nil
    end

    local function eachShopSlot(shopName, shopData, callback)
        if type(shopData) ~= "table" then
            return
        end

        for _, listName in ipairs({ "PermanentItems", "RandomItems", "Items" }) do
            local itemList = shopData[listName]
            if type(itemList) == "table" then
                for slotIndex, shopItem in ipairs(itemList) do
                    callback(shopName, slotIndex, shopItem)
                end

                for slotIndex, shopItem in pairs(itemList) do
                    if type(slotIndex) ~= "number" or slotIndex > #itemList then
                        callback(shopName, slotIndex, shopItem)
                    end
                end
            end
        end

        if type(shopData.Slots) == "table" then
            for slotIndex, shopItem in pairs(shopData.Slots) do
                callback(shopName, tonumber(slotIndex) or slotIndex, shopItem)
            end
        end
    end

    local function getSortedShopItemNames()
        local itemNames = {}
        local seenItems = {}
        local shops = getShopData()

        for shopName, shopData in pairs(shops) do
            if type(shopName) == "string" then
                eachShopSlot(shopName, shopData, function(_, _, shopItem)
                    local itemName = getShopItemName(shopItem)
                    if type(itemName) == "string" and itemName ~= "" and not seenItems[itemName] then
                        seenItems[itemName] = true
                        table.insert(itemNames, itemName)
                    end
                end)
            end
        end

        table.sort(itemNames)
        return itemNames
    end

    local function resolveShopItemSelection(selectedItemName)
        if type(selectedItemName) ~= "string" or selectedItemName == "" then
            return nil, nil
        end

        local directShopName, directSlot = selectedItemName:match("^(.-)%s*|%s*Slot%s*#?(%d+)$")
        if directShopName and directSlot then
            return directShopName, tonumber(directSlot)
        end

        local selectedLower = string.lower(selectedItemName)
        local shops = getShopData()

        for shopName, shopData in pairs(shops) do
            if type(shopName) == "string" then
                local foundShop, foundSlot = nil, nil
                eachShopSlot(shopName, shopData, function(currentShopName, slotIndex, shopItem)
                    if foundShop then
                        return
                    end

                    local itemName = getShopItemName(shopItem)
                    if type(itemName) == "string" and string.lower(itemName) == selectedLower then
                        foundShop = currentShopName
                        foundSlot = slotIndex
                    end
                end)

                if foundShop and foundSlot ~= nil then
                    return foundShop, foundSlot
                end
            end
        end

        return nil, nil
    end

    local function getShopSlotCount(shopName)
        local shopData = getShopData()[shopName]
        if type(shopData) ~= "table" then
            return 3
        end

        local slotCount = tonumber(shopData.SlotCount)
        if slotCount and slotCount >= 1 then
            return math.floor(slotCount)
        end

        for _, listName in ipairs({ "RandomItems", "PermanentItems", "Items" }) do
            if type(shopData[listName]) == "table" and #shopData[listName] > 0 then
                return #shopData[listName]
            end
        end

        if type(shopData.Slots) == "table" then
            local highestSlot = 0
            for slotIndex in pairs(shopData.Slots) do
                highestSlot = math.max(highestSlot, tonumber(slotIndex) or 0)
            end
            if highestSlot > 0 then
                return highestSlot
            end
        end

        return 3
    end

    local shopDropdown
    local shopItemDropdown

    local function refreshShopDropdowns()
        refreshShopData()

        local shopNames = getSortedShopNames()
        local shopItemNames = getSortedShopItemNames()

        if #shopNames == 0 then
            shopNames = { "No shops found" }
        end
        if #shopItemNames == 0 then
            shopItemNames = { "No shop items found" }
        end

        fireRemoteEventRepeatedly(shopDropdown, shopNames)
        fireRemoteEventRepeatedly(shopItemDropdown, shopItemNames)
    end

    gameTab:AddButton({
        Title = "Load Shop Lists",
        Description = "Loads shop names and item names into the dropdowns below.",
        Callback = function()
            refreshShopDropdowns()
        end,
    })

    shopDropdown = gameTab:AddDropdown("SelectedShops", {
        Title = "Select Shops - leave empty for all",
        Values = { "Click Load Shop Lists" },
        Default = Config.selectedShops or {},
        Multi = true,
        Search = true,
        Callback = function(selectedShops)
            Config.selectedShops = selectedShops or {}
            saveConfig()
        end,
    })

    shopItemDropdown = gameTab:AddDropdown("SelectedShopItems", {
        Title = "Select Shop Items - optional",
        Values = { "Click Load Shop Lists" },
        Default = Config.selectedShopItems or {},
        Multi = true,
        Search = true,
        Callback = function(selectedShopItems)
            Config.selectedShopItems = selectedShopItems or {}
            saveConfig()
        end,
    })

    gameTab:AddInput("ShopBuyInterval", {
        Title = "Buy Delay",
        Default = tostring(Config.shopInterval or 1),
        Numeric = true,
        Callback = function(intervalText)
            local buyDelay = tonumber(intervalText)
            if buyDelay then
                Config.shopInterval = math.clamp(buyDelay, 0.1, 60)
                saveConfig()
            end
        end,
    })

    gameTab:AddToggle("AutoBuyShops", {
        Title = "Auto Buy Shops",
        Description = "Buys selected shop items. If no item is selected, it buys random slots from selected shops.",
        Default = Config.autoBuyShops == true,
        Callback = function(enabled)
            Config.autoBuyShops = enabled == true
            saveConfig()
        end,
    })

    task.spawn(function()
        while true do
            if Config.autoBuyShops ~= true then
                task.wait(0.85)
                continue
            end

            task.wait(tonumber(Config.shopInterval) or 1)

            local selectedItems = getSelectedValues(Config.selectedShopItems or {})
            if #selectedItems > 0 then
                local selectedItem = selectedItems[math.random(1, #selectedItems)]
                local shopName, slotIndex = resolveShopItemSelection(selectedItem)
                if shopName and slotIndex ~= nil then
                    pcall(function()
                        remoteEvent:FireServer("BuyShopItem", shopName, slotIndex, true)
                    end)
                end
            else
                local selectedShops = getSelectedValues(Config.selectedShops or {})
                if #selectedShops == 0 then
                    selectedShops = getSortedShopNames()
                end

                if #selectedShops > 0 then
                    local shopName = selectedShops[math.random(1, #selectedShops)]
                    if getShopData()[shopName] then
                        local slotIndex = math.random(1, getShopSlotCount(shopName))
                        pcall(function()
                            remoteEvent:FireServer("BuyShopItem", shopName, slotIndex, true)
                        end)
                    end
                end
            end
        end
    end)

    gameTab:AddSection("Mystery Boxes")
    local function getGiftNames()
        local giftNames = {
        }
        if type(giftData) == "table" then
            for loopSlotCZ, scriptStateAEU in pairs(giftData) do
                if type(loopSlotCZ) == "string" and type(scriptStateAEU) == "table" and scriptStateAEU.Type == "Gift" then
                    table.insert(giftNames, loopSlotCZ)
                end
            end
        end
        table.sort(giftNames)
        if # giftNames == 0 then
            giftNames = {
                "Mystery Box",
                "Admin Mystery Box",
                "OG Mystery Box"
            }
        end
        return giftNames
    end
    local mysteryBoxDropdown = gameTab:AddDropdown("SelectedMysteryBox", {
        Title = "Select Box",
        Values = {
            Config.selectedMysteryBox ~= "" and Config.selectedMysteryBox or "Mystery Box"
        },
        Default = Config.selectedMysteryBox ~= "" and Config.selectedMysteryBox or "Mystery Box",
        Multi = false,
        Search = true,
        Callback = function(selectedMysteryBoxCallback)
            Config.selectedMysteryBox = selectedMysteryBoxCallback
            saveConfig()
        end,
    })
    gameTab:AddButton({
        Title = "Load Mystery Boxes",
        Callback = function()
            fireRemoteEventRepeatedly(mysteryBoxDropdown,
            getGiftNames())
        end,
    })
    gameTab:AddToggle("AutoOpenMystery", {
        Title = "Auto Open Box",
        Default = Config.autoOpenMystery,
        Callback = function(scriptStateRA)
            Config.autoOpenMystery = scriptStateRA;saveConfig()
        end,
    })
    gameTab:AddInput("AutoOpenMysteryDelay", {
        Title = "Open Delay",
        Default = tostring(Config.autoOpenMysteryDelay),
        Numeric = true,
        Callback = function(scriptStateIC)
            local parsedDelayValue = tonumber(scriptStateIC)
            if parsedDelayValue then
                Config.autoOpenMysteryDelay = math.clamp(parsedDelayValue,
                0.1,
                60)
            saveConfig()
            end
        end,
    })
    task.spawn(function()
        while true do
            task.wait(Config.autoPlaytime and 5 or 0.85)
            if Config.autoPlaytime then
                pcall(function()
                    remoteEvent:FireServer("ClaimAllPlaytime")
                end)
            end
        end
    end)
    task.spawn(function()
        while true do
            task.wait(Config.autoEquipBestPets and 3 or 0.85)
            if Config.autoEquipBestPets then
                pcall(function()
                    remoteEvent:FireServer("EquipBestPets")
                end)
            end
        end
    end)
    task.spawn(function()
        while true do
            task.wait(Config.autoUpgradeMastery and 2 or 0.85)
            if Config.autoUpgradeMastery then
                for thangsCategoryIndex, scriptStateNK in ipairs(scriptStateBY) do
                    if not Config.autoUpgradeMastery then
                        break
                    end
                    pcall(function()
                        remoteEvent:FireServer("UpgradeMastery", scriptStateNK)
                    end)
                    task.wait(0.25)
                end
            end
        end
    end)
    task.spawn(function()
        while true do
            task.wait(Config.autoPowerOrbEquipped and 0.4 or 0.85)
            if Config.autoPowerOrbEquipped then
                local scriptStateAR = getSelectedChestName()
            local scriptStateRE = scriptStateAR and scriptStateAR.Teams and scriptStateAR.TeamEquipped and scriptStateAR.Teams[scriptStateAR.TeamEquipped]
                local scriptStateOC = scriptStateRE and scriptStateRE.Pets
            if type(scriptStateOC) == "table" then
                    for loopSlotDP, scriptStateIB in ipairs(scriptStateOC) do
                        if not Config.autoPowerOrbEquipped then
                            break
                        end
                        if scriptStateIB and scriptStateIB ~= "" then
                            pcall(function()
                                remoteEvent:FireServer("UsePowerOrb", scriptStateIB)
                            end)
                            task.wait(0.08)
                        end
                    end
                end
            end
        end
    end)
    task.spawn(function()
        while true do
            task.wait(Config.autoCollectCoins and 2 or 0.85)
            if Config.autoCollectCoins then
                pcall(installPickupRangeHook)
                pcall(function()
                    remoteEvent:FireServer("UseGoldenOrb")
                end)
            end
        end
    end)
    task.spawn(function()
        while true do
            task.wait(Config.autoBubble and 0.03 or 0.85)
            if Config.autoBubble then
                pcall(function()
                    remoteEvent:FireServer("BlowBubble")
                end)
            end
        end
    end)
    task.spawn(function()
        while true do
            task.wait(Config.autoSell and 1 or 0.85)
            if Config.autoSell then
                pcall(function()
                    remoteEvent:FireServer("SellBubble")
                end)
            end
        end
    end)
    task.spawn(function()
        local function claimAllGifts()
            local scriptStateWK = getPotionList("Gifts")
            if not scriptStateWK then
                return
            end
            for loopSlotJ, scriptStateKA in ipairs(scriptStateWK:GetChildren()) do
                pcall(function()
                    remoteEvent:FireServer("ClaimGift", scriptStateKA.Name)
                end)
            end
        end
        while true do
            local scriptStateIP = math.clamp(tonumber(Config.autoOpenMysteryDelay) or 0.2, 0.1, 60)
            task.wait(Config.autoOpenMystery and scriptStateIP or 0.85)
            if Config.autoOpenMystery and type(Config.selectedMysteryBox) == "string" and Config.selectedMysteryBox ~= "" then
                pcall(function()
                    remoteEvent:FireServer("UseGift", Config.selectedMysteryBox, 50)
                end)
                claimAllGifts()
                task.wait()
                claimAllGifts()
            end
        end
    end)
end
do
    -- Auto enchant UI: builds the enchant dropdowns from the game enchant data.
    local function getEnchantNames()
        local scriptStateDL = {
        }
        if type(enchantData) == "table" then
            for scriptStateME in pairs(enchantData) do
                if type(scriptStateME) == "string" and not scriptStateME:lower():find("^super%-") then
                    table.insert(scriptStateDL, scriptStateME)
                end
            end
            table.sort(scriptStateDL)
        end
        if # scriptStateDL == 0 then
            scriptStateDL = {
                "secret-hunter",
                "ultra-roller"
            }
        end
        return scriptStateDL
    end
    local enchantNameList = getEnchantNames()
            local targetEnchantDropdownValues = {
        "(None - single target)"
    }
    for loopSlotDC, scriptStateG in ipairs(enchantNameList) do
        table.insert(targetEnchantDropdownValues, scriptStateG)
    end
    local enchantCurrencyOptions = {
        "Auto (Secret = Crystals,Normal = Gems)",
        "Auto (Secret = Crystals,Normal = Reroll Orbs)",
        "Gems",
        "Reroll Orbs",
    }
    scriptStateTJ:AddSection("Auto Enchant Equipped Pets")
    scriptStateTJ:AddToggle("AutoEnchant", {
        Title = "Auto Enchant",
        Default = Config.autoEnchant,
        Callback = function(scriptStateADD)
            Config.autoEnchant = scriptStateADD;saveConfig()
        end,
    })
    scriptStateTJ:AddDropdown("TargetEnchant1", {
        Title = "Target Enchant 1",
        Values = enchantNameList,
        Default = Config.equippedTargetEnchant,
        Multi = false,
        Callback = function(scriptStateXJ)
            if scriptStateXJ then
                Config.equippedTargetEnchant = scriptStateXJ;saveConfig()
            end
        end,
    })
    scriptStateTJ:AddDropdown("TargetEnchant2", {
        Title = "Target Enchant 2",
        Values = targetEnchantDropdownValues,
        Default =(Config.equippedTargetEnchant2 ~= "" and Config.equippedTargetEnchant2) or "(None - single target)",
        Multi = false,
        Callback = function(scriptStateHT)
            if scriptStateHT then
                Config.equippedTargetEnchant2 =(scriptStateHT == "(None - single target)") and "" or scriptStateHT;saveConfig()
            end
        end,
    })
    scriptStateTJ:AddInput("TargetEnchantLevel", {
        Title = "Target Level (0  =  any)",
        Default = tostring(Config.equippedTargetEnchantLevel or 0),
        Numeric = true,
        Callback = function(scriptStateRT)
            local scriptStateABH = tonumber(scriptStateRT)
            Config.equippedTargetEnchantLevel =(scriptStateABH and scriptStateABH >= 0) and scriptStateABH or 0
            saveConfig()
        end,
    })
    scriptStateTJ:AddDropdown("EnchantCurrency", {
        Title = "Currency",
        Values = enchantCurrencyOptions,
        Default = Config.equippedEnchantCurrency,
        Multi = false,
        Callback = function(scriptStateDV)
            if scriptStateDV then
                Config.equippedEnchantCurrency = scriptStateDV;saveConfig()
            end
        end,
    })
end
local function normalizeEnchantName(scriptStateTX)
    if type(scriptStateTX) ~= "string" then
        return""
    end
    return string.lower(scriptStateTX):gsub("[%s_%-]", "")
end
local function getPetEnchantList(scriptStateHJ)
    local scriptStateRI = {
    }
    local scriptStateYY = scriptStateHJ and(scriptStateHJ.Enchants or scriptStateHJ.Enchantments) or {
    }
    for loopSlotBP = 1, 2 do
        local scriptStateYE = scriptStateYY[loopSlotBP] or scriptStateYY[tostring(loopSlotBP)]
            if type(scriptStateYE) == "table" then
            local scriptStateKR = scriptStateYE.Id or scriptStateYE.ID or scriptStateYE.Name or scriptStateYE.Enchant or ""
            if scriptStateKR and scriptStateKR ~= "" then
                scriptStateRI[loopSlotBP] = tostring(scriptStateKR)
            end
        end
    end
    return scriptStateRI
end
local function findPetEnchantSlot(scriptStateKS, scriptStateAY)
    if not scriptStateAY or scriptStateAY == "" or scriptStateAY == "(None - single target)" then
        return nil
    end
    local scriptStateRS = normalizeEnchantName(scriptStateAY)
            local scriptStateIU = getPetEnchantList(scriptStateKS)
    for loopSlotW = 1, 2 do
        if scriptStateIU[loopSlotW] and normalizeEnchantName(scriptStateIU[loopSlotW]) == scriptStateRS then
            return loopSlotW
        end
    end
    return nil
end
local function getEnchantData(scriptStateABA)
    if not scriptStateABA or scriptStateABA == "" or type(enchantData) ~= "table" then
        return nil
    end
    local scriptStateOP = enchantData[scriptStateABA]
            if scriptStateOP then
        return scriptStateOP
    end
    local scriptStateYC = normalizeEnchantName(scriptStateABA)
    for loopSlotDY, scriptStateO in pairs(enchantData) do
        if type(loopSlotDY) == "string" and type(scriptStateO) == "table" and normalizeEnchantName(loopSlotDY) == scriptStateYC then
            return scriptStateO
        end
    end
    return nil
end
local function isSpecialEnchant(scriptStateADR)
    local scriptStateABZ = getEnchantData(scriptStateADR)
            if type(scriptStateABZ) ~= "table" then
        return false
    end
    return scriptStateABZ.Special == true or scriptStateABZ.Secret == true
end
local function getEnchantMaxLevel(scriptStateSH)
    local scriptStateAAD = getEnchantData(scriptStateSH)
            if type(scriptStateAAD) ~= "table" then
        return nil
    end
    if type(scriptStateAAD.Levels) == "number" and scriptStateAAD.Levels > 0 then
        return scriptStateAAD.Levels
    end
    if type(scriptStateAAD.Buffs) == "table" then
        local enchantBuffCount = # scriptStateAAD.Buffs
            if enchantBuffCount > 0 then
            return enchantBuffCount
        end
    end
    return nil
end
local function isSingleLevelEnchant(scriptStateAAS)
    if isSpecialEnchant(scriptStateAAS) then
        return true
    end
    local scriptStateAFO = getEnchantMaxLevel(scriptStateAAS)
    return type(scriptStateAFO) == "number" and scriptStateAFO == 1
end
local function hasShadowCrystalCurrency()
    local potionUseSuccess, scriptStateNR = pcall(function()
        return profileStore:Get()
    end)
    if not potionUseSuccess or type(scriptStateNR) ~= "table" then
        return false
    end
    local function normalizeEnchantName(scriptStateAFH)
        return type(scriptStateAFH) == "number" and scriptStateAFH > 0
    end
    if type(scriptStateNR.Powerups) == "table" and normalizeEnchantName(scriptStateNR.Powerups["Shadow Crystal"]) then
        return true
    end
    if type(scriptStateNR.Currencies) == "table" and(normalizeEnchantName(scriptStateNR.Currencies["Shadow Crystals"]) or normalizeEnchantName(scriptStateNR.Currencies["ShadowCrystals"])) then
        return true
    end
    if normalizeEnchantName(scriptStateNR.ShadowCrystals) then
        return true
    end
    return false
end
local function resolveEnchantCurrency(enchantCurrencyParam, scriptStateE)
    local scriptStateEF = isSpecialEnchant(scriptStateE)
            if scriptStateEF and not hasShadowCrystalCurrency() then
        if enchantCurrencyParam == "Auto (Secret = Crystals,Normal = Reroll Orbs)" then
            return"Reroll Orbs"
        end
        return"Gems"
    end
    if enchantCurrencyParam == "Auto (Secret = Crystals,Normal = Gems)" then
        return scriptStateEF and "Shadow Crystals" or "Gems"
    end
    if enchantCurrencyParam == "Auto (Secret = Crystals,Normal = Reroll Orbs)" then
        return scriptStateEF and "Shadow Crystals" or "Reroll Orbs"
    end
    return enchantCurrencyParam
end
local function getPetEnchantInfo(scriptStateZM, scriptStateAEV, scriptStateVS)
    if not scriptStateAEV or scriptStateAEV == "" or scriptStateAEV == "(None - single target)" then
        return nil
    end
    local scriptStateAAA = tonumber(scriptStateVS) or 0
            if scriptStateAAA > 0 and isSingleLevelEnchant(scriptStateAEV) then
        scriptStateAAA = 0
    end
    if scriptStateAAA <= 0 then
        return findPetEnchantSlot(scriptStateZM, scriptStateAEV)
    end
    local scriptStateJT = normalizeEnchantName(scriptStateAEV)
            local scriptStateBH = scriptStateZM and(scriptStateZM.Enchants or scriptStateZM.Enchantments) or {
    }
    for loopSlotDQ = 1, 2 do
        local scriptStateWF = scriptStateBH[loopSlotDQ] or scriptStateBH[tostring(loopSlotDQ)]
            if type(scriptStateWF) == "table" then
            local potionAmount = scriptStateWF.Id or scriptStateWF.ID or scriptStateWF.Name or scriptStateWF.Enchant or ""
            if normalizeEnchantName(potionAmount) == scriptStateJT then
                local scriptStateWN = tonumber(scriptStateWF.Level or scriptStateWF.Lv or scriptStateWF.Tier or scriptStateWF.Rank)
            local scriptStateADG = getEnchantMaxLevel(potionAmount)
                local scriptStateIK =(scriptStateADG and scriptStateADG > 0) and math.min(scriptStateAAA, scriptStateADG) or scriptStateAAA
            if scriptStateWN == nil or scriptStateWN >= scriptStateIK then
                    return loopSlotDQ
                end
            end
        end
    end
    return nil
end
local dualEnchantWhitelist = {
    ["lathanpng"] = true,
    ["arsu_121"] = true,
    ["nachobus543"] = true,
    ["KaiRblxALT"] = true,
    ["CwCinfinite1"] = true,
    ["BingusGrandFather"] = true,
    ["WillsBigRightBall"] = true,
    ["PraetoriusGetTheHuzz"] = true,
    ["YT_JackMaBoey"] = true,
    ["RattyyCattyy1"] = true,
    ["KamalMohsen1999"] = true,
    ["Kayzoom_99"] = true,
    ["Kay_doom99"] = true,
    ["Kayfoom99"] = true,
    ["spiderman_skibid"] = true,
    ["3neitheriteingots"] = true,
}

local normalizedDualEnchantWhitelist = {}
for whitelistedName in pairs(dualEnchantWhitelist) do
    normalizedDualEnchantWhitelist[string.lower(whitelistedName)] = true
end

local isDualEnchantWhitelisted = false
do
    local playerName = LocalPlayer and LocalPlayer.Name
    if type(playerName) == "string" then
        isDualEnchantWhitelisted = normalizedDualEnchantWhitelist[string.lower(playerName)] == true
    end
end

-- Auto enchant rule: normal users need a shiny/2-slot pet; whitelisted users bypass this.
local function canPetUseDualEnchantMode(scriptStateACP)
    if not scriptStateACP then
        return false
    end
    if isDualEnchantWhitelisted then
        return true
    end
    if enchantModule and type(enchantModule.GetMaxEnchantSlots) == "function" then
        local scriptStateSE, scriptStatePX = pcall(enchantModule.GetMaxEnchantSlots, enchantModule, scriptStateACP)
        if scriptStateSE and type(scriptStatePX) == "number" then
            return scriptStatePX >= 2
        end
    end
    return scriptStateACP.Shiny == true or scriptStateACP.IsShiny == true
end
local function getEnchantablePets()
    local scriptStateACE, scriptStateGP = pcall(function()
        return profileStore:Get()
    end)
    if not scriptStateACE or type(scriptStateGP) ~= "table" then
        return{
        }
    end
    if not scriptStateGP.Teams or not scriptStateGP.TeamEquipped then
        return{
        }
    end
    local scriptStateTI = scriptStateGP.Teams[scriptStateGP.TeamEquipped]
    return(scriptStateTI and type(scriptStateTI.Pets) == "table") and scriptStateTI.Pets or {
    }
end
local function getEnchantCurrency(scriptStateVC)
    local scriptStateQQ, scriptStateACB = pcall(function()
        return profileStore:Get()
    end)
    if not scriptStateQQ or type(scriptStateACB) ~= "table" or type(scriptStateACB.Pets) ~= "table" then
        return nil
    end
    for loopSlotBV, scriptStateQG in ipairs(scriptStateACB.Pets) do
        if scriptStateQG.Id == scriptStateVC then
            return scriptStateQG
        end
    end
    return nil
end
local autoEnchantThreadRunning = false
            -- Auto enchant loop: rerolls equipped pets until the target enchant setup is found.
local function getEnchantTargetList()
    if autoEnchantThreadRunning then
        return
    end
    autoEnchantThreadRunning = true
    task.spawn(function()
        while Config.autoEnchant do
            local targetEnchantOne = Config.equippedTargetEnchant or ""
            local targetEnchantTwo = Config.equippedTargetEnchant2 or ""
            local targetEnchantLevel = tonumber(Config.equippedTargetEnchantLevel) or 0
            local selectedEnchantCurrencyMode = Config.equippedEnchantCurrency or "Auto (Secret = Crystals,Normal = Gems)"
            local hasSecondEnchantTarget = targetEnchantTwo ~= "" and targetEnchantTwo ~= "(None - single target)"
            local equippedPetIds = getEnchantablePets()
            for loopSlotH, equippedPetId in ipairs(equippedPetIds) do
                if not Config.autoEnchant then
                    break
                end
                local petData = getEnchantCurrency(equippedPetId)
            if petData and petData.Super ~= true then
                    local canUseDualEnchant = canPetUseDualEnchantMode(petData)
                    while Config.autoEnchant do
                        petData = getEnchantCurrency(equippedPetId)
                        if not petData then
                            break
                        end
                        local hasTargetEnchantOne = getPetEnchantInfo(petData, targetEnchantOne, targetEnchantLevel)
            local hasTargetEnchantTwo = hasSecondEnchantTarget and getPetEnchantInfo(petData, targetEnchantTwo, targetEnchantLevel) or nil
                        local targetEnchantSatisfied = false
            if hasSecondEnchantTarget and canUseDualEnchant then
                            targetEnchantSatisfied =(hasTargetEnchantOne and hasTargetEnchantTwo) and true or false
                        elseif hasSecondEnchantTarget then
                            targetEnchantSatisfied =(hasTargetEnchantOne or hasTargetEnchantTwo) and true or false
                        else
                            targetEnchantSatisfied = hasTargetEnchantOne ~= nil
                        end
                        if targetEnchantSatisfied then
                            break
                        end
                        local currentSlotForTargetOne = findPetEnchantSlot(petData, targetEnchantOne)
            local currentSlotForTargetTwo = hasSecondEnchantTarget and findPetEnchantSlot(petData, targetEnchantTwo) or nil
                        local rerollSlot = nil
            local targetEnchantForCurrency = targetEnchantOne
            if hasSecondEnchantTarget and canUseDualEnchant then
                            if currentSlotForTargetOne and not currentSlotForTargetTwo then
                                rerollSlot = currentSlotForTargetOne;
                                targetEnchantForCurrency = targetEnchantTwo
                            end
                            if currentSlotForTargetTwo and not currentSlotForTargetOne then
                                rerollSlot = currentSlotForTargetTwo;
                                targetEnchantForCurrency = targetEnchantOne
                            end
                        end
                        local resolvedEnchantCurrency = resolveEnchantCurrency(selectedEnchantCurrencyMode, targetEnchantForCurrency)
            if resolvedEnchantCurrency == "Shadow Crystals" then
                            pcall(function()
                                remoteEvent:FireServer("UseShadowCrystal", equippedPetId, rerollSlot)
                            end)
                        elseif resolvedEnchantCurrency == "Reroll Orbs" then
                            pcall(function()
                                remoteFunction:InvokeServer("RerollEnchants", equippedPetId, "Powerup", rerollSlot)
                            end)
                        else
                            pcall(function()
                                remoteFunction:InvokeServer("RerollEnchants", equippedPetId, "Gems", rerollSlot)
                            end)
                        end
                        task.wait(0.55)
                        if not Config.autoEnchant then
                            break
                        end
                        petData = getEnchantCurrency(equippedPetId)
                        if petData then
                            hasTargetEnchantOne = getPetEnchantInfo(petData, targetEnchantOne, targetEnchantLevel)
                            hasTargetEnchantTwo = hasSecondEnchantTarget and getPetEnchantInfo(petData, targetEnchantTwo, targetEnchantLevel) or nil
                            local targetSatisfiedAfterReroll = false
            if hasSecondEnchantTarget and canUseDualEnchant then
                                targetSatisfiedAfterReroll =(hasTargetEnchantOne and hasTargetEnchantTwo) and true or false
                            elseif hasSecondEnchantTarget then
                                targetSatisfiedAfterReroll =(hasTargetEnchantOne or hasTargetEnchantTwo) and true or false
                            else
                                targetSatisfiedAfterReroll = hasTargetEnchantOne ~= nil
                            end
                            if targetSatisfiedAfterReroll then
                                break
                            end
                        end
                        task.wait(0.2)
                    end
                end
                task.wait(0.05)
            end
            task.wait(0.3)
        end
        autoEnchantThreadRunning = false
    end)
end
if Config.autoEnchant then
    getEnchantTargetList()
end
task.spawn(function()
    local lastAutoEnchantState = false
    while true do
        task.wait(0.3)
        if Config.autoEnchant and not lastAutoEnchantState then
            getEnchantTargetList()
        end
        lastAutoEnchantState = Config.autoEnchant
    end
end) do
    scriptStateUC:AddSection("Gem Genie")
    local function getSelectedEnchantTarget()
        local scriptStateUV, scriptStateOF = {
        }, {
        }
        local function isPetAllowedForEnchanting(scriptStatePP)
            if type(scriptStatePP) ~= "string" or scriptStatePP == "" or scriptStateOF[scriptStatePP] then
                return
            end
            scriptStateOF[scriptStatePP] = true
            table.insert(scriptStateUV, scriptStatePP)
        end
        for loopSlotE, scriptStateADO in ipairs({
            "Spin Ticket",
            "Reroll Orb",
            "Power Orb",
            "Lucky",
            "Speed",
            "Coins",
            "Mythic",
            "Royal Key",
            "Dream Shard",
            "Infinity Elixir",
            "Secret Elixir",
            "Egg Elixir",
            "Ultra Infinity Elixir",
            "Wonderland Elixir",
            "Rune Rock",
            "Green Fragment",
            "Shadow Crystal",
            "Mystery Box",
        }) do
            isPetAllowedForEnchanting(scriptStateADO)
        end
        local loopSlotAC, scriptStateACZ = pcall(function()
            return require(ReplicatedStorage.Shared.Data.Quests.GenieQuest)
        end)
        if loopSlotAC and type(scriptStateACZ) == "function" then
            local scriptStateTE, scriptStateJC = pcall(function()
                return profileStore:Get()
            end)
            if scriptStateTE and type(scriptStateJC) == "table" then
                for loopSlotB = 1, 1500 do
                    local scriptStateRW, scriptStateAEJ = pcall(scriptStateACZ, scriptStateJC, loopSlotB)
                    if scriptStateRW and type(scriptStateAEJ) == "table" and type(scriptStateAEJ.Rewards) == "table" then
                        for loopSlotBL, scriptStateBF in ipairs(scriptStateAEJ.Rewards) do
                            if type(scriptStateBF) == "table" then
                                isPetAllowedForEnchanting(scriptStateBF.Name or scriptStateBF.Currency or scriptStateBF.Item)
                            end
                        end
                    end
                end
            end
        end
        table.sort(scriptStateUV)
        return scriptStateUV
    end
    local scriptStateLF = getSelectedEnchantTarget()
            if not table.find(scriptStateLF, Config.gemGenieTargetItem) then
        Config.gemGenieTargetItem = scriptStateLF[1] or "Shadow Crystal"
            saveConfig()
    end
    scriptStateUC:AddDropdown("GemGenieTarget", {
        Title = "Target Item",
        Values = scriptStateLF,
        Default = Config.gemGenieTargetItem,
        Multi = false,
        Search = true,
        Callback = function(scriptStateP)
            Config.gemGenieTargetItem = scriptStateP;saveConfig()
        end,
    })
    scriptStateUC:AddToggle("AutoGemGenie", {
        Title = "Auto Gem Genie",
        Default = Config.autoGemGenie,
        Callback = function(scriptStatePC)
            Config.autoGemGenie = scriptStatePC;saveConfig()
        end,
    })
    scriptStateUC:AddToggle("OptimisedGemGenie", {
        Title = "Optimised mode (only hatch tasks,ignores selected item)",
        Default = Config.optimisedGemGenie,
        Callback = function(scriptStateACK)
            Config.optimisedGemGenie = scriptStateACK;saveConfig()
        end,
    })
    scriptStateUC:AddSection("Season Pass")
    scriptStateUC:AddToggle("AutoSeason", {
        Title = "Auto Claim Season Pass",
        Default = Config.autoSeason,
        Callback = function(scriptStateJF)
            Config.autoSeason = scriptStateJF;saveConfig()
        end,
    })
    scriptStateUC:AddToggle("AutoDailyHourly", {
        Title = "Auto Season Pass Quests (daily/hourly)",
        Default = Config.autoDailyHourlyChallenge,
        Callback = function(scriptStateABO)
            Config.autoDailyHourlyChallenge = scriptStateABO;saveConfig()
        end,
    })
    scriptStateUC:AddSection("Global Incentive")
    scriptStateUC:AddToggle("AutoGlobalIncentive", {
        Title = "Auto Global Incentive Quests",
        Default = Config.autoGlobalIncentive,
        Callback = function(scriptStateOK)
            Config.autoGlobalIncentive = scriptStateOK;saveConfig()
        end,
    })
    scriptStateUC:AddToggle("AutoClaimGlobalIncentive", {
        Title = "Auto Claim Global Incentive",
        Default = Config.autoClaimGlobalIncentive,
        Callback = function(scriptStatePU)
            Config.autoClaimGlobalIncentive = scriptStatePU;saveConfig()
        end,
    })
end
task.spawn(function()
    while true do
        if Config.autoSeason then
            pcall(function()
                remoteEvent:FireServer("ClaimSeason")
            end)
        end
        task.wait(5)
    end
end)
task.spawn(function()
    while true do
        if Config.autoClaimGlobalIncentive then
            pcall(function()
                remoteEvent:FireServer("ClaimGlobalIncentiveQuest")
                for loopSlotDK = 1, 10 do
                    remoteEvent:FireServer("ClaimGlobalIncentives", loopSlotDK)
                end
            end)
        end
        task.wait(1)
    end
end)
local function getGemGenieQuestData()
    if not profileStore:IsReady() then
        return nil
    end
    local scriptStateOO = profileStore:Get()
            if not scriptStateOO then
        return nil
    end
    local scriptStateZS = scriptStateOO.GemGenie
            if type(scriptStateZS) == "table" then
        if type(scriptStateZS.Quest) == "table" then
            local scriptStateAEQ = scriptStateZS.Quest
            if(scriptStateAEQ.Completed == false or scriptStateAEQ.Completed == nil) and type(scriptStateAEQ.Tasks) == "table" and next(scriptStateAEQ.Tasks) then
                return scriptStateAEQ
            end
        end
        if type(scriptStateZS.ActiveQuest) == "table" then
            local scriptStateUE = scriptStateZS.ActiveQuest
            if(scriptStateUE.Completed == false or scriptStateUE.Completed == nil) then
                return scriptStateUE
            end
        end
    end
    if questModule and type(questModule.FindById) == "function" then
        local scriptStateRJ, scriptStateRN = pcall(function()
            return questModule:FindById(scriptStateOO, "gem-genie")
        end)
        if scriptStateRJ and scriptStateRN and(scriptStateRN.Completed == false or scriptStateRN.Completed == nil) then
            return scriptStateRN
        end
    end
    return nil
end
local function getQuestTaskByType(scriptStateQM, scriptStateJZ, scriptStateS)
    local scriptStateBI, scriptStatePY = pcall(function()
        return require(ReplicatedStorage.Shared.Data.Quests.GenieQuest)
    end)
    if not scriptStateBI or type(scriptStatePY) ~= "function" then
        return nil
    end
    local function claimCompletedQuestRewards(scriptStateABG)
        if type(scriptStateABG) ~= "table" then
            return false
        end
        for loopSlotCI, scriptStateNW in pairs(scriptStateABG) do
            if type(scriptStateNW) == "string" and string.lower(scriptStateNW) == string.lower(scriptStateS) then
                return true
            end
        end
        if type(scriptStateABG.Item) == "table" then
            for loopSlotCQ, scriptStateFX in pairs(scriptStateABG.Item) do
                if type(scriptStateFX) == "string" and string.lower(scriptStateFX) == string.lower(scriptStateS) then
                    return true
                end
            end
        end
        return false
    end
    for loopSlotBW = 1, 3 do
        local scriptStateTG, scriptStateYD = pcall(scriptStatePY, scriptStateQM, scriptStateJZ +(loopSlotBW - 1))
        if scriptStateTG and type(scriptStateYD) == "table" and type(scriptStateYD.Rewards) == "table" then
            for loopSlotV, scriptStateLU in ipairs(scriptStateYD.Rewards) do
                if claimCompletedQuestRewards(scriptStateLU) then
                    return loopSlotBW, scriptStateYD
                end
            end
        end
    end
    return nil
end
local function runGemGenieTask(loopSlotAE, scriptStateWA)
    local loopSlotAT, scriptStateLY = pcall(function()
        return require(ReplicatedStorage.Shared.Data.Quests.GenieQuest)
    end)
    if not loopSlotAT or type(scriptStateLY) ~= "function" then
        return nil
    end
    for loopSlotDV = 1, 3 do
        local scriptStateJW, scriptStateADH = pcall(scriptStateLY, loopSlotAE, scriptStateWA +(loopSlotDV - 1))
        if scriptStateJW and type(scriptStateADH) == "table" and type(scriptStateADH.Tasks) == "table" then
            local scriptStateMM = true
            for loopSlotDE, scriptStateHG in pairs(scriptStateADH.Tasks) do
                if type(scriptStateHG) == "table" and not isHatchBountyTask(scriptStateHG) then
                    scriptStateMM = false
                    break
                end
            end
            if scriptStateMM then
                return loopSlotDV, scriptStateADH
            end
        end
    end
    return nil
end
task.spawn(function()
    while true do
        if not Config.autoGemGenie then
            if activeStates.BGSI_Lite_GemGenieActive then
                activeStates.BGSI_Lite_GemGenieActive = false
                resumeNormalAutomation()
            end
            task.wait(0.5)
            continue
        end
        local scriptStateMU = getGemGenieQuestData()
            if not scriptStateMU then
            local scriptStateXX, scriptStateLE = pcall(function()
                return profileStore:Get()
            end)
            if not scriptStateXX or not scriptStateLE then
                task.wait(1)
                continue
            end
            local scriptStateH = scriptStateLE.GemGenie or {
            }
            local scriptStateSC = tonumber(scriptStateH.Next) or 0
            local scriptStateSB = getCurrentTimestamp()
            if scriptStateSC > scriptStateSB then
                activeStates.BGSI_Lite_GemGenieActive = false
                resumeNormalAutomation()
                task.wait(1)
                continue
            end
            local scriptStateCA = tonumber(scriptStateH.Seed) or 0
            local scriptStateGR, scriptStateXF
            if Config.optimisedGemGenie then
                scriptStateGR, scriptStateXF = runGemGenieTask(scriptStateLE, scriptStateCA)
            else
                scriptStateGR, scriptStateXF = getQuestTaskByType(scriptStateLE, scriptStateCA, Config.gemGenieTargetItem or "")
            end
            if scriptStateGR then
                pcall(function()
                    remoteEvent:FireServer("StartGenieQuest", scriptStateGR)
                end)
                task.wait(2)
            else
                pcall(function()
                    remoteEvent:FireServer("RerollGenie")
                end)
                task.wait(0.5)
            end
            continue
        end
        activeStates.BGSI_Lite_GemGenieActive = true
        pauseNormalAutomation()
        for loopSlotDF, scriptStateBJ in ipairs(makeIndexList(scriptStateMU.Tasks)) do
            if not Config.autoGemGenie then
                break
            end
            local scriptStateWX = scriptStateMU.Tasks[scriptStateBJ]
            if type(scriptStateWX) == "table" then
                local scriptStateGT = getBountyTaskRequirement(scriptStateWX)
            local scriptStateJI = getBountyTaskProgress(scriptStateMU, scriptStateBJ)
            if scriptStateJI < scriptStateGT then
                    local fallbackUtilityD = function()
                        return Config.autoGemGenie == true
                    end
                    local fallbackUtilityB = function()
                        return getGemGenieQuestData()
                    end
                    if isCoinOrCollectBountyTask(scriptStateWX) then
                        runCollectCurrencyBountyTask(fallbackUtilityB, scriptStateBJ, scriptStateGT, fallbackUtilityD, getBountyCurrencyName(scriptStateWX))
                    elseif isHatchBountyTask(scriptStateWX) then
                        runHatchBountyTask(fallbackUtilityB, scriptStateBJ, scriptStateGT, fallbackUtilityD)
                    elseif isBubbleBountyTask(scriptStateWX) then
                        runBubbleBountyTask(fallbackUtilityB, scriptStateBJ, scriptStateGT, fallbackUtilityD)
                    else
                        task.wait(0.08)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)
local function stopGemGenieAutomation()
    local scriptStateFE = {
    }
    if not profileStore:IsReady() then
        return scriptStateFE
    end
    local scriptStateFK = profileStore:Get()
            if not scriptStateFK then
        return scriptStateFE
    end
    local scriptStateUU = {
        scriptStateFK.Quests,
        scriptStateFK.ActiveQuests,
        scriptStateFK.DailyChallenges,
        scriptStateFK.HourlyChallenges
    }
    local scriptStateTD = {
    }
    for loopSlotQ, scriptStateAEH in ipairs(scriptStateUU) do
        if type(scriptStateAEH) == "table" then
            for loopSlotBG, scriptStateIM in pairs(scriptStateAEH) do
                if type(scriptStateIM) == "table" then
                    local scriptStateRO = scriptStateIM.Id or scriptStateIM.ID
            if type(scriptStateRO) == "string" and(scriptStateRO:match("^daily%-challenge%-%d+$") or scriptStateRO:match("^hourly%-challenge%-%d+$")) then
                        if not scriptStateTD[scriptStateRO] and(scriptStateIM.Completed == false or scriptStateIM.Completed == nil) then
                            scriptStateTD[scriptStateRO] = true
                            table.insert(scriptStateFE, scriptStateIM)
                        end
                    end
                end
            end
        end
    end
    return scriptStateFE
end
local function runSeasonChallengeTask(scriptStateSN)
    if not profileStore:IsReady() then
        return nil
    end
    local scriptStateDR = profileStore:Get()
            if questModule and type(questModule.FindById) == "function" then
        local scriptStateADW, scriptStateMP = pcall(function()
            return questModule:FindById(scriptStateDR, scriptStateSN)
        end)
        if scriptStateADW and scriptStateMP then
            return scriptStateMP
        end
    end
    for loopSlotAR, scriptStateHS in ipairs({
        scriptStateDR and scriptStateDR.Quests,
        scriptStateDR and scriptStateDR.ActiveQuests
    }) do
        if type(scriptStateHS) == "table" then
            for loopSlotAP, scriptStateIJ in pairs(scriptStateHS) do
                if type(scriptStateIJ) == "table" and(scriptStateIJ.Id == scriptStateSN or scriptStateIJ.ID == scriptStateSN) then
                    return scriptStateIJ
                end
            end
        end
    end
    return nil
end
task.spawn(function()
    while true do
        if not Config.autoDailyHourlyChallenge then
            if activeStates.BGSI_Lite_SeasonActive then
                activeStates.BGSI_Lite_SeasonActive = false
                resumeNormalAutomation()
            end
            task.wait(0.5)
            continue
        end
        if activeStates.BGSI_Lite_GemGenieActive then
            task.wait(0.5)
            continue
        end
        local scriptStateSA = stopGemGenieAutomation()
            if # scriptStateSA == 0 then
            activeStates.BGSI_Lite_SeasonActive = false
            resumeNormalAutomation()
            task.wait(2)
            continue
        end
        local scriptStateWQ = false
        for loopSlotAH, scriptStateAAE in ipairs(scriptStateSA) do
            for loopSlotAW, scriptStateTB in ipairs(makeIndexList(scriptStateAAE.Tasks)) do
                local scriptStateWO = scriptStateAAE.Tasks[scriptStateTB]
            if type(scriptStateWO) == "table" then
                    local scriptStateCW = getBountyTaskRequirement(scriptStateWO)
            local scriptStateUP = getBountyTaskProgress(scriptStateAAE, scriptStateTB)
            if scriptStateUP < scriptStateCW then
                        scriptStateWQ = true;
                        break
                    end
                end
            end
            if scriptStateWQ then
                break
            end
        end
        if not scriptStateWQ then
            activeStates.BGSI_Lite_SeasonActive = false
            resumeNormalAutomation()
            task.wait(2)
            continue
        end
        activeStates.BGSI_Lite_SeasonActive = true
        pauseNormalAutomation()
        for loopSlotDL, scriptStateZC in ipairs(scriptStateSA) do
            if not Config.autoDailyHourlyChallenge then
                break
            end
            if activeStates.BGSI_Lite_GemGenieActive then
                break
            end
            local scriptStateKZ = scriptStateZC.Id or scriptStateZC.ID
            for loopSlotBA, scriptStateAC in ipairs(makeIndexList(scriptStateZC.Tasks)) do
                if not Config.autoDailyHourlyChallenge then
                    break
                end
                if activeStates.BGSI_Lite_GemGenieActive then
                    break
                end
                local scriptStateDY = scriptStateZC.Tasks[scriptStateAC]
            if type(scriptStateDY) == "table" then
                    local scriptStateADS = getBountyTaskRequirement(scriptStateDY)
            local scriptStateTP = getBountyTaskProgress(scriptStateZC, scriptStateAC)
            if scriptStateTP < scriptStateADS then
                        local fallbackUtilityA = function()
                            return Config.autoDailyHourlyChallenge and not activeStates.BGSI_Lite_GemGenieActive
                        end
                        local fallbackUtilityG = function()
                            return runSeasonChallengeTask(scriptStateKZ)
                        end
                        if isCoinOrCollectBountyTask(scriptStateDY) then
                            runCollectCurrencyBountyTask(fallbackUtilityG, scriptStateAC, scriptStateADS, fallbackUtilityA, getBountyCurrencyName(scriptStateDY))
                        elseif isHatchBountyTask(scriptStateDY) then
                            runHatchBountyTask(fallbackUtilityG, scriptStateAC, scriptStateADS, fallbackUtilityA)
                        elseif isBubbleBountyTask(scriptStateDY) then
                            runBubbleBountyTask(fallbackUtilityG, scriptStateAC, scriptStateADS, fallbackUtilityA)
                        else
                            task.wait(0.08)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)
local function getSeasonQuestList()
    local scriptStateAAV = {
    }
    if not profileStore:IsReady() then
        return scriptStateAAV
    end
    local scriptStateUQ = profileStore:Get()
            if not scriptStateUQ then
        return scriptStateAAV
    end
    local scriptStateIE = {
    }
    for loopSlotCM, scriptStateCV in ipairs({
        scriptStateUQ.Quests,
        scriptStateUQ.ActiveQuests
    }) do
        if type(scriptStateCV) == "table" then
            for loopSlotAN, scriptStateACG in pairs(scriptStateCV) do
                if type(scriptStateACG) == "table" then
                    local scriptStateWY = scriptStateACG.Id or scriptStateACG.ID
            if type(scriptStateWY) == "string" and scriptStateWY:sub(1, 17) == "global-incentive-" then
                        if not scriptStateIE[scriptStateWY] and(scriptStateACG.Completed == false or scriptStateACG.Completed == nil) then
                            scriptStateIE[scriptStateWY] = true
                            table.insert(scriptStateAAV, scriptStateACG)
                        end
                    end
                end
            end
        end
    end
    return scriptStateAAV
end
local function runGlobalIncentiveTask(scriptStateGG)
    if not profileStore:IsReady() then
        return nil
    end
    local scriptStateZN = profileStore:Get()
            if questModule and type(questModule.FindById) == "function" then
        local scriptStateEC, scriptStateAEW = pcall(function()
            return questModule:FindById(scriptStateZN, scriptStateGG)
        end)
        if scriptStateEC and scriptStateAEW then
            return scriptStateAEW
        end
    end
    for loopSlotAK, scriptStateQD in ipairs({
        scriptStateZN and scriptStateZN.Quests,
        scriptStateZN and scriptStateZN.ActiveQuests
    }) do
        if type(scriptStateQD) == "table" then
            for loopSlotA, scriptStateGL in pairs(scriptStateQD) do
                if type(scriptStateGL) == "table" and(scriptStateGL.Id == scriptStateGG or scriptStateGL.ID == scriptStateGG) then
                    return scriptStateGL
                end
            end
        end
    end
    return nil
end
task.spawn(function()
    while true do
        if not Config.autoGlobalIncentive then
            if activeStates.BGSI_Lite_GlobalIncentiveActive then
                activeStates.BGSI_Lite_GlobalIncentiveActive = false
                resumeNormalAutomation()
            end
            task.wait(0.5)
            continue
        end
        if activeStates.BGSI_Lite_GemGenieActive or activeStates.BGSI_Lite_SeasonActive then
            task.wait(0.5)
            continue
        end
        local scriptStateEW = getSeasonQuestList()
            if # scriptStateEW == 0 then
            activeStates.BGSI_Lite_GlobalIncentiveActive = false
            resumeNormalAutomation()
            task.wait(3)
            continue
        end
        local scriptStateRM = false
        for loopSlotD, scriptStateAFT in ipairs(scriptStateEW) do
            for loopSlotCA, scriptStateWC in ipairs(makeIndexList(scriptStateAFT.Tasks)) do
                local scriptStateJA = scriptStateAFT.Tasks[scriptStateWC]
            if type(scriptStateJA) == "table" then
                    local scriptStateLR = getBountyTaskRequirement(scriptStateJA)
            local scriptStateGF = getBountyTaskProgress(scriptStateAFT, scriptStateWC)
            if scriptStateGF < scriptStateLR then
                        scriptStateRM = true;
                        break
                    end
                end
            end
            if scriptStateRM then
                break
            end
        end
        if not scriptStateRM then
            activeStates.BGSI_Lite_GlobalIncentiveActive = false
            resumeNormalAutomation()
            task.wait(3)
            continue
        end
        activeStates.BGSI_Lite_GlobalIncentiveActive = true
        pauseNormalAutomation()
        for loopSlotZ, scriptStateVX in ipairs(scriptStateEW) do
            if not Config.autoGlobalIncentive then
                break
            end
            if activeStates.BGSI_Lite_GemGenieActive or activeStates.BGSI_Lite_SeasonActive then
                break
            end
            local scriptStateHW = scriptStateVX.Id or scriptStateVX.ID
            for loopSlotK, scriptStateADB in ipairs(makeIndexList(scriptStateVX.Tasks)) do
                if not Config.autoGlobalIncentive then
                    break
                end
                if activeStates.BGSI_Lite_GemGenieActive or activeStates.BGSI_Lite_SeasonActive then
                    break
                end
                local scriptStateAFI = scriptStateVX.Tasks[scriptStateADB]
            if type(scriptStateAFI) == "table" then
                    local scriptStateSF = getBountyTaskRequirement(scriptStateAFI)
            local scriptStateR = getBountyTaskProgress(scriptStateVX, scriptStateADB)
            if scriptStateR < scriptStateSF then
                        local fallbackUtilityC = function()
                            return Config.autoGlobalIncentive and not activeStates.BGSI_Lite_GemGenieActive and not activeStates.BGSI_Lite_SeasonActive
                        end
                        local fallbackUtilityF = function()
                            return runGlobalIncentiveTask(scriptStateHW)
                        end
                        if isCoinOrCollectBountyTask(scriptStateAFI) then
                            runCollectCurrencyBountyTask(fallbackUtilityF, scriptStateADB, scriptStateSF, fallbackUtilityC, getBountyCurrencyName(scriptStateAFI))
                        elseif isHatchBountyTask(scriptStateAFI) then
                            runHatchBountyTask(fallbackUtilityF, scriptStateADB, scriptStateSF, fallbackUtilityC)
                        elseif isBubbleBountyTask(scriptStateAFI) then
                            runBubbleBountyTask(fallbackUtilityF, scriptStateADB, scriptStateSF, fallbackUtilityC)
                        else
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end) do
    scriptStateOB:AddSection("Dream Fountain")
    scriptStateOB:AddToggle("DreamShrine", {
        Title = "Auto Dreamer Fountain",
        Default = Config.DreamerShrineEnabled,
        Callback = function(scriptStateAV)
            Config.DreamerShrineEnabled = scriptStateAV;saveConfig()
        end,
    })
    scriptStateOB:AddInput("DreamShrineAmount", {
        Title = "Amount",
        Default = tostring(Config.DreamerShrineAmount),
        Placeholder = "1-20",
        Numeric = true,
        Callback = function(scriptStateIW)
            local scriptStateAE = tonumber(scriptStateIW)
            if scriptStateAE then
                Config.DreamerShrineAmount = math.clamp(math.floor(scriptStateAE),
                1,
                20);saveConfig()
            end
        end,
    })
    scriptStateOB:AddSection("Bubble Shrine")
    local scriptStateD = {
        "Lucky",
        "Mythic",
        "Speed",
        "Tickets",
        "Coins"
    }
    local scriptStateSD = {
        "1",
        "2",
        "3",
        "4",
        "5"
    }
    scriptStateOB:AddDropdown("ShrinePotion", {
        Title = "Potion",
        Values = scriptStateD,
        Default = Config.shrinePotion,
        Multi = false,
        Callback = function(scriptStateACT)
            Config.shrinePotion = scriptStateACT;saveConfig()
        end,
    })
    scriptStateOB:AddDropdown("ShrineLevel", {
        Title = "Level",
        Values = scriptStateSD,
        Default = tostring(Config.shrineLevel),
        Multi = false,
        Callback = function(scriptStateIA)
            Config.shrineLevel = tonumber(scriptStateIA) or 1;saveConfig()
        end,
    })
    scriptStateOB:AddInput("ShrineAmount", {
        Title = "Amount",
        Default = tostring(Config.shrineAmount),
        Placeholder = "0-1000",
        Numeric = true,
        Callback = function(scriptStateDC)
            local scriptStateABI = tonumber(scriptStateDC)
            if scriptStateABI then
                Config.shrineAmount = math.clamp(math.floor(scriptStateABI),
                0,
                1000);saveConfig()
            end
        end,
    })
    scriptStateOB:AddToggle("AutoShrine", {
        Title = "Auto Donate to Bubble Shrine",
        Default = Config.shrineAuto,
        Callback = function(scriptStateXQ)
            Config.shrineAuto = scriptStateXQ;saveConfig()
        end,
    })
end
task.spawn(function()
    while true do
        if Config.DreamerShrineEnabled then
            pcall(function()
                remoteFunction:InvokeServer("DonateToDreamerShrine", Config.DreamerShrineAmount or 1)
            end)
        end
        task.wait(5)
    end
end)
task.spawn(function()
    while true do
        if Config.shrineAuto then
            pcall(function()
                remoteFunction:InvokeServer("DonateToShrine", {
                    Level = Config.shrineLevel,
                    Type = "Potion",
                    Name = Config.shrinePotion,
                    Amount = Config.shrineAmount,
                })
            end)
        end
        task.wait(5)
    end
end)
local function getShrinePotionName(scriptStateAFV)
    if not scriptStateAFV or scriptStateAFV == "" then
        return nil
    end
    local scriptStateAED = string.upper(scriptStateAFV):gsub("%s+", ""):gsub(",", "")
            local scriptStateOJ, scriptStateYQ = scriptStateAED:match("^(%d+%.?%d*)([KMBTQ]?)$")
    if not scriptStateOJ then
        return nil
    end
    local scriptStateNB = tonumber(scriptStateOJ)
            if not scriptStateNB then
        return nil
    end
    if scriptStateYQ == "K" then
        return scriptStateNB * 1e3
    end
    if scriptStateYQ == "M" then
        return scriptStateNB * 1e6
    end
    if scriptStateYQ == "B" then
        return scriptStateNB * 1e9
    end
    if scriptStateYQ == "T" then
        return scriptStateNB * 1e12
    end
    if scriptStateYQ == "Q" then
        return scriptStateNB * 1e15
    end
    return scriptStateNB
end
local function getShrineLevelValue(loopSlotO)
    local scriptStateACS = {
    }
    if not loopSlotO or loopSlotO == "" then
        return scriptStateACS
    end
    for scriptStateFZ in string.gmatch(loopSlotO, "([^,]+)") do
        scriptStateFZ = scriptStateFZ:match("^%s*(.-)%s*$")
        if scriptStateFZ and scriptStateFZ ~= "" then
            table.insert(scriptStateACS, scriptStateFZ)
        end
    end
    return scriptStateACS
end
local function getShrineAmountValue(scriptStateYW)
    scriptStateYW = tonumber(scriptStateYW) or 0
    local scriptStateABQ = {
        "",
        "K",
        "M",
        "B",
        "T",
        "Q"
    }
    local scriptStateEZ = 1
    while scriptStateYW >= 1000 and scriptStateEZ < # scriptStateABQ do
        scriptStateYW = scriptStateYW / 1000;
        scriptStateEZ = scriptStateEZ + 1
    end
    return string.format("%.1f%s", scriptStateYW, scriptStateABQ[scriptStateEZ])
end
local function runShrineDonation(scriptStateTR)
    scriptStateTR = tonumber(scriptStateTR) or 0
    local scriptStateCS = tostring(math.floor(scriptStateTR))
    while true do
        local scriptStateBK
        scriptStateCS, scriptStateBK = scriptStateCS:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        if scriptStateBK == 0 then
            break
        end
    end
    return scriptStateCS
end
local scriptStateDX = {
    Bubbles = "\240\159\159\163",
    Coins = "\240\159\170\153",
    Gems = "\240\159\146\142",
    Snowflakes = "\226\157\132\239\184\143",
    CircusTickets = "\240\159\142\159\239\184\143",
    GameTickets = "\240\159\142\171",
    Tickets = "\240\159\142\171",
    Pearls = "\226\154\170",
    Clovers = "\240\159\141\128",
}
local statsUtil, worldUtil
pcall(function()
    statsUtil = require(ReplicatedStorage.Shared.Utils.Stats.StatsUtil)
end)
pcall(function()
    worldUtil = require(ReplicatedStorage.Shared.Utils.WorldUtil)
end)
local function getWebhookAvatarUrl(scriptStateWL)
    if type(scriptStateWL) ~= "number" or scriptStateWL ~= scriptStateWL then
        return"—"
    end
    if math.abs(scriptStateWL) >= 1000 then
        return"x"..
        getShrineAmountValue(scriptStateWL)
    end
    return"x"..
    string.format("%.4g", scriptStateWL)
end
local function getWebhookRequestFunction()
    local scriptStateUY = {
        Coins = 0,
        Gems = 0,
        Pearls = 0,
        Tickets = 0,
        LuckDisplay = "—",
        SecretLuckDisplay = "—",
        InfinityLuckDisplay = "—",
    }
    pcall(function()
        if not profileStore:IsReady() then
            return
        end
        local scriptStateIL = profileStore:Get() or {
        }
        scriptStateUY.Coins = tonumber(scriptStateIL.Coins) or 0
        scriptStateUY.Gems = tonumber(scriptStateIL.Gems) or 0
        scriptStateUY.Pearls = tonumber(scriptStateIL.Pearls) or 0
        scriptStateUY.Tickets = tonumber(scriptStateIL.Tickets or scriptStateIL.GameTickets or scriptStateIL.CircusTickets) or 0
        local scriptStateAAM = "The Overworld"
            if worldUtil and type(worldUtil.GetPlayerWorld) == "function" then
            pcall(function()
                scriptStateAAM = worldUtil:GetPlayerWorld(LocalPlayer) or scriptStateAAM
            end)
        end
        if statsUtil then
            pcall(function()
                if type(statsUtil.GetLuckMultiplier) == "function" then
                    local scriptStateVW = statsUtil:GetLuckMultiplier(LocalPlayer, scriptStateIL, scriptStateAAM, true)
            if type(scriptStateVW) == "number" and scriptStateVW == scriptStateVW then
                        scriptStateUY.LuckDisplay = string.format("+%.2f%%",(scriptStateVW - 1) * 100)
                    end
                end
            end)
            pcall(function()
                if type(statsUtil.GetSecretLuck) == "function" then
                    local scriptStateAAZ = statsUtil:GetSecretLuck(scriptStateIL, nil)
            if type(scriptStateAAZ) == "number" then
                        scriptStateUY.SecretLuckDisplay = getWebhookAvatarUrl(scriptStateAAZ)
                    end
                end
            end)
            pcall(function()
                if type(statsUtil.GetInfinityLuck) == "function" then
                    local scriptStateACI =(scriptStateAAM == "Christmas World") and "Aurora Egg" or nil
            local scriptStateVQ = statsUtil:GetInfinityLuck(scriptStateIL, scriptStateACI)
            if type(scriptStateVQ) == "number" then
                        scriptStateUY.InfinityLuckDisplay = getWebhookAvatarUrl(scriptStateVQ)
                    end
                end
            end)
        end
    end)
    return scriptStateUY
end
local function getDiscordTimestamp()
    local scriptStateXG = {
        BubblesBlown = 0,
        EggsHatched = 0
    }
    if not LocalPlayer:FindFirstChild("leaderstats") then
        return scriptStateXG
    end
    for loopSlotAS, scriptStateAFC in ipairs(LocalPlayer.leaderstats:GetChildren()) do
        if scriptStateAFC.Name == "\240\159\159\163 Bubbles" then
            scriptStateXG.BubblesBlown = scriptStateAFC.Value
        elseif scriptStateAFC.Name == "\240\159\165\154 Hatches" then
            scriptStateXG.EggsHatched = scriptStateAFC.Value
        end
    end
    return scriptStateXG
end
local function getWebhookPingText()
    return getDiscordTimestamp().EggsHatched
end
local petChanceData = {
} do
    local function sendWebhookPayload(scriptStateTZ)
        if type(scriptStateTZ) == "number" and scriptStateTZ == scriptStateTZ then
            return scriptStateTZ
        end
        if type(scriptStateTZ) == "string" then
            return tonumber(scriptStateTZ)
        end
        return nil
    end
    local function getCurrencyAmountByName(scriptStateBU, scriptStateGC, scriptStateMC)
        if scriptStateGC > 12 or type(scriptStateBU) ~= "table" or scriptStateMC[scriptStateBU] then
            return
        end
        scriptStateMC[scriptStateBU] = true
        local scriptStateADF = scriptStateBU.Pet;
            local scriptStateEE = sendWebhookPayload(scriptStateBU.Chance)
            if type(scriptStateADF) == "string" and scriptStateADF ~= "" and scriptStateEE then
            petChanceData[scriptStateADF] = scriptStateEE
        end
        if type(scriptStateBU.Pets) == "table" then
            for loopSlotU, scriptStateKU in pairs(scriptStateBU.Pets) do
                if type(scriptStateKU) == "table" then
                    local scriptStateQL = scriptStateKU.Pet or scriptStateKU.Name;
            local scriptStateYZ = sendWebhookPayload(scriptStateKU.Chance)
            if type(scriptStateQL) == "string" and scriptStateQL ~= "" and scriptStateYZ then
                        petChanceData[scriptStateQL] = scriptStateYZ
                    end
                end
            end
        end
        if type(scriptStateBU.Name) == "string" and(type(scriptStateADF) ~= "string" or scriptStateADF == "") and scriptStateEE then
            local scriptStateACJ = scriptStateBU.Type
            if scriptStateACJ ~= "Powerup" and scriptStateACJ ~= "Potion" and scriptStateACJ ~= "Egg" and type(scriptStateBU.Cost) ~= "table" then
                if not(type(scriptStateBU.Interval) == "number" and type(scriptStateBU.Pets) == "table") then
                    petChanceData[scriptStateBU.Name] = scriptStateEE
                end
            end
        end
        for loopSlotBJ, scriptStateNO in pairs(scriptStateBU) do
            if type(scriptStateNO) == "table" then
                getCurrencyAmountByName(scriptStateNO, scriptStateGC + 1, scriptStateMC)
            end
        end
    end
    for loopSlotDO, scriptStatePM in ipairs({
        function()
            return require(ReplicatedStorage.Shared.Framework.Constants)
        end,
        function()
            return require(ReplicatedStorage.Shared.Constants)
        end,
    }) do
        local loopSlotBE, scriptStateCQ = pcall(scriptStatePM)
        if loopSlotBE and type(scriptStateCQ) == "table" then
            getCurrencyAmountByName(scriptStateCQ, 0, {
            })
        end
    end
end
local function checkLowCurrencyWebhook(scriptStateAFQ, scriptStateDP)
    if type(scriptStateAFQ) == "string" and petChanceData[scriptStateAFQ] then
        return petChanceData[scriptStateAFQ]
    end
    if type(scriptStateDP) == "table" and type(scriptStateDP.Chance) == "number" then
        return scriptStateDP.Chance
    end
    return 100
end
local function getPetVariantName(scriptStateSU)
    if not remoteFunction or type(scriptStateSU) ~= "string" or scriptStateSU == "" then
        return nil
    end
    local scriptStateXU, scriptStateRH = pcall(function()
        return remoteFunction:InvokeServer("GetExisting", scriptStateSU)
    end)
    if not scriptStateXU then
        return nil
    end
    if type(scriptStateRH) == "number" then
        return math.floor(scriptStateRH)
    end
    if type(scriptStateRH) == "string" then
        local scriptStateAEK = tonumber(scriptStateRH) or tonumber(scriptStateRH:match("%d+"))
            if scriptStateAEK then
            return math.floor(scriptStateAEK)
        end
    end
    return nil
end
local function buildPetWebhookEmbed(scriptStateHC, scriptStateRV, scriptStateHH, scriptStateVT)
    if type(scriptStateHC) ~= "string" or scriptStateHC == "" then
        return scriptStateHC
    end
    local scriptStateBT = {
    }
    if scriptStateVT then
        table.insert(scriptStateBT, "XL")
    end
    if scriptStateRV then
        table.insert(scriptStateBT, "Shiny")
    end
    if scriptStateHH then
        table.insert(scriptStateBT, "Mythic")
    end
    if # scriptStateBT == 0 then
        return scriptStateHC
    end
    return table.concat(scriptStateBT, " ").." "..
    scriptStateHC
end
local function sendPetWebhook(scriptStateUL, scriptStateADL, scriptStateXY)
    local scriptStateYI = scriptStateUL and scriptStateUL.Images
            if type(scriptStateYI) ~= "table" then
        return nil
    end
    local scriptStateOI
    if scriptStateADL and scriptStateXY then
        scriptStateOI = scriptStateYI[4] or scriptStateYI.MythicShiny or scriptStateYI["Shiny Mythic"] or scriptStateYI.ShinyMythic
    elseif scriptStateADL then
        scriptStateOI = scriptStateYI[2] or scriptStateYI.Shiny
    elseif scriptStateXY then
        scriptStateOI = scriptStateYI[3] or scriptStateYI.Mythic
    else
        scriptStateOI = scriptStateYI[1] or scriptStateYI.Normal
    end
    if not scriptStateOI then
        for loopSlotCS = 1, 4 do
            if scriptStateYI[loopSlotCS] then
                scriptStateOI = scriptStateYI[loopSlotCS];
                break
            end
        end
        if not scriptStateOI then
            scriptStateOI = scriptStateYI.Normal or scriptStateYI.Shiny or scriptStateYI.Mythic
        end
    end
    if not scriptStateOI then
        return nil
    end
    local scriptStateWR = string.match(tostring(scriptStateOI), "rbxassetid://(%d+)") or tostring(tonumber(scriptStateOI) or "")
            if scriptStateWR ~= "" then
        local scriptStateACO = ("https://thumbnails.roblox.com/v1/assets?assetIds=%s&size=420x420&format=Png"):format(scriptStateWR)
            local scriptStateFI
        local thumbnailRequestOk = pcall(function()
            scriptStateFI = game:HttpGet(scriptStateACO)
        end)
        if not thumbnailRequestOk or not scriptStateFI or scriptStateFI == "" then
            thumbnailRequestOk = pcall(function()
                scriptStateFI = HttpService:GetAsync(scriptStateACO)
            end)
        end
        if thumbnailRequestOk and scriptStateFI and scriptStateFI ~= "" then
            local scriptStateABU, scriptStateNH = pcall(function()
                return HttpService:JSONDecode(scriptStateFI)
            end)
            if scriptStateABU and scriptStateNH and scriptStateNH.data and scriptStateNH.data[1] and scriptStateNH.data[1].imageUrl then
                return scriptStateNH.data[1].imageUrl
            end
        end
    end
    if type(scriptStateOI) == "string" and scriptStateOI:find("http") then
        return scriptStateOI
    end
    return nil
end
local function normalizeVariantList(scriptStatePH)
    if scriptStatePH < 1e-06 then
        return string.format("%.2e%%", scriptStatePH)
    elseif scriptStatePH < 0.01 then
        return string.format("%.8f%%", scriptStatePH)
    else
        return string.format("%.6f%%", scriptStatePH)
    end
end
local function findPetByNameAndVariant(scriptStateJM, scriptStateACU, scriptStateZU)
    if not scriptStateJM and not scriptStateACU and not scriptStateZU then
        return nil
    end
    if scriptStateZU then
        if scriptStateJM and scriptStateACU then
            return"SM XL"
        end
        if scriptStateJM then
            return"Shiny XL"
        end
        if scriptStateACU then
            return"Mythic XL"
        end
        return"XL"
    end
    if scriptStateJM and scriptStateACU then
        return"SM"
    end
    if scriptStateJM then
        return"Shiny"
    end
    if scriptStateACU then
        return"Mythic"
    end
    return nil
end
local function getRebirthMachineCost(scriptStateKB)
    scriptStateKB = tostring(scriptStateKB or "")
    scriptStateKB = scriptStateKB:match("^%s*(.-)%s*$") or ""
    scriptStateKB = scriptStateKB:gsub("<@!?(%d+)>", "%1")
    scriptStateKB = scriptStateKB:gsub("%D", "")
    if # scriptStateKB < 15 then
        return nil
    end
    return scriptStateKB
end
local function runRebirthFuse(scriptStateQZ, scriptStateACW)
    local scriptStateLH = request or http_request or(syn and syn.request) or(http and http.request)
            if type(scriptStateLH) ~= "function" then
        return false
    end
    local scriptStateKX = Config.webhookPingEnabled and getRebirthMachineCost(Config.webhookPingUserId) or nil
            if scriptStateKX then
        scriptStateACW.content = "<@"..
        scriptStateKX..">"
        scriptStateACW.allowed_mentions = {
            users = {
                scriptStateKX
            },
            parse = {
            }
        }
    end
    local scriptStateSX, scriptStatePK = pcall(function()
        return scriptStateLH({
            Url = scriptStateQZ,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(scriptStateACW),
        })
    end)
    if scriptStateSX and scriptStatePK then
        local scriptStateUJ = scriptStatePK.StatusCode
            if scriptStateUJ == nil or scriptStateUJ == 200 or scriptStateUJ == 204 then
            return true
        end
    end
    return false
end
local function runRebirthMachineLoop(scriptStateEI, scriptStateOR, scriptStateXO, scriptStateBZ, scriptStateYR)
    if not Config.webhookEnabled or Config.webhookURL == "" then
        return
    end
    local scriptStateABR = getShrineLevelValue(Config.webhookURL)
    for loopSlotBY, webhookURLEntry in ipairs(scriptStateABR) do
        local scriptStateAAK = Config.webhookHidePlayerName == true
            local scriptStateGN =(scriptStateAAK and scriptStateYR) or scriptStateEI
        runRebirthFuse(webhookURLEntry, {
            embeds = {
                {
                    title = scriptStateGN,
                    color = scriptStateOR,
                    fields = scriptStateXO,
                    thumbnail = scriptStateBZ and {
                        url = scriptStateBZ
                    } or nil,
                    footer = {
                        text = os.date("%Y-%m-%d %H:%M:%S")
                    },
                }
            },
        })
        task.wait(0.1)
    end
end
activeStates.LiteSendWebhook = runRebirthMachineLoop do
    scriptStateKM:AddToggle("WebhookEnabled", {
        Title = "Enable Webhook",
        Default = Config.webhookEnabled,
        Callback = function(scriptStateAO)
            Config.webhookEnabled = scriptStateAO;saveConfig()
        end,
    })
    scriptStateKM:AddInput("WebhookURL", {
        Title = "Webhook URL(s)",
        Default = Config.webhookURL,
        Placeholder = "Discord webhook URL(s),comma-separated",
        Callback = function(scriptStateTM)
            Config.webhookURL = scriptStateTM;saveConfig()
        end,
    })
    scriptStateKM:AddToggle("WebhookHideName", {
        Title = "Hide username in webhooks",
        Default = Config.webhookHidePlayerName,
        Callback = function(scriptStateET)
            Config.webhookHidePlayerName = scriptStateET;saveConfig()
        end,
    })
    scriptStateKM:AddSection("Ping")
    scriptStateKM:AddToggle("WebhookPingEnabled", {
        Title = "Ping User",
        Default = Config.webhookPingEnabled,
        Callback = function(scriptStateGD)
            Config.webhookPingEnabled = scriptStateGD;saveConfig()
        end,
    })
    scriptStateKM:AddInput("WebhookPingUserId", {
        Title = "Discord User ID",
        Default = Config.webhookPingUserId,
        Placeholder = "right click user -> Copy User ID",
        Callback = function(scriptStateDW)
            Config.webhookPingUserId = scriptStateDW;saveConfig()
        end,
    })
    scriptStateKM:AddSection("Low Currency Alerts")
    scriptStateKM:AddToggle("LowCurrencyEnabled", {
        Title = "Enable Low Currency Alerts",
        Default = Config.webhookLowCurrencyEnabled,
        Callback = function(scriptStateRL)
            Config.webhookLowCurrencyEnabled = scriptStateRL;saveConfig()
        end,
    })
    scriptStateKM:AddInput("LowCoins", {
        Title = "Coins Below",
        Default = Config.webhookLowCoinsBelow,
        Placeholder = "e.g. 10M",
        Callback = function(scriptStateABN)
            Config.webhookLowCoinsBelow = scriptStateABN;saveConfig()
        end,
    })
    scriptStateKM:AddInput("LowGems", {
        Title = "Gems Below",
        Default = Config.webhookLowGemsBelow,
        Placeholder = "e.g. 100K",
        Callback = function(scriptStateAEN)
            Config.webhookLowGemsBelow = scriptStateAEN;saveConfig()
        end,
    })
    scriptStateKM:AddInput("LowPearls", {
        Title = "Pearls Below",
        Default = Config.webhookLowPearlsBelow,
        Placeholder = "e.g. 1K",
        Callback = function(scriptStateTS)
            Config.webhookLowPearlsBelow = scriptStateTS;saveConfig()
        end,
    })
    scriptStateKM:AddInput("LowTickets", {
        Title = "Tickets Below",
        Default = Config.webhookLowTicketsBelow,
        Placeholder = "e.g. 50",
        Callback = function(scriptStateHV)
            Config.webhookLowTicketsBelow = scriptStateHV;saveConfig()
        end,
    })
    scriptStateKM:AddSlider("LowCurrencyCooldown", {
        Title = "Alert Cooldown (minutes)",
        Min = 1,
        Max = 180,
        Default = Config.webhookLowCurrencyCooldownMinutes,
        Rounding = 0,
        Callback = function(scriptStateZP)
            Config.webhookLowCurrencyCooldownMinutes = math.floor(scriptStateZP);saveConfig()
        end,
    })
end
task.spawn(function()
    local scriptStateDE = {
        Coins = 0,
        Gems = 0,
        Pearls = 0,
        Tickets = 0
    }
    while true do
        task.wait(5)
        if not Config.webhookEnabled or not Config.webhookLowCurrencyEnabled then
            continue
        end
        local scriptStateJV = math.max(60,(tonumber(Config.webhookLowCurrencyCooldownMinutes) or 30) * 60)
            local scriptStateKO = getWebhookRequestFunction()
        local scriptStateKP = tick()
            local scriptStateACF = {
        }
        local function getAdminRebirthPetCandidate(scriptStateXL, scriptStateXD, scriptStateXC, scriptStateHE)
            local scriptStateVD = getShrinePotionName(scriptStateHE)
            if not scriptStateVD then
                return
            end
            local scriptStateYH = scriptStateKO[scriptStateXL] or 0
            if scriptStateYH >= scriptStateVD then
                return
            end
            if(scriptStateKP -(scriptStateDE[scriptStateXL] or 0)) < scriptStateJV then
                return
            end
            table.insert(scriptStateACF, {
                key = scriptStateXL,
                label = scriptStateXD,
                emoji = scriptStateXC,
                current = scriptStateYH,
                threshold = scriptStateHE
            })
        end
        getAdminRebirthPetCandidate("Coins", "Coins", "\240\159\170\153", Config.webhookLowCoinsBelow)
        getAdminRebirthPetCandidate("Gems", "Gems", "\240\159\146\142", Config.webhookLowGemsBelow)
        getAdminRebirthPetCandidate("Pearls", "Pearls", "\226\154\170", Config.webhookLowPearlsBelow)
        getAdminRebirthPetCandidate("Tickets", "Tickets", "\240\159\142\171", Config.webhookLowTicketsBelow)
        if # scriptStateACF > 0 then
            local scriptStateYP = {
                {
                    name = "Player",
                    value =("%s (%s)"):format(LocalPlayer.Name,
                    LocalPlayer.UserId),
                    inline = false
                }
            }
            local scriptStateGI = {
                {
                    name = "Player",
                    value = "Player (hidden)",
                    inline = false
                }
            }
            for loopSlotBK, scriptStateFW in ipairs(scriptStateACF) do
                local scriptStateTC = {
                    name =("%s %s"):format(scriptStateFW.emoji,
                    scriptStateFW.label),
                    value =("Current: `%s`\nBelow: `%s`"):format(getShrineAmountValue(scriptStateFW.current),
                    tostring(scriptStateFW.threshold)),
                    inline = true,
                }
                table.insert(scriptStateYP, scriptStateTC)
                table.insert(scriptStateGI, scriptStateTC)
            end
            runRebirthMachineLoop("Low Currency Alert", 16753920, scriptStateYP, nil, "Low Currency Alert")
            for loopSlotDT, scriptStateQR in ipairs(scriptStateACF) do
                scriptStateDE[scriptStateQR.key] = scriptStateKP
            end
        end
    end
end)
remoteEvent.OnClientEvent:Connect(function(scriptStateKW, scriptStateNY, ...)
    if not Config.webhookEnabled then
        return
    end
    local scriptStatePO
    if scriptStateKW == "HatchEgg" or scriptStateKW == "HatchPowerupEgg" or scriptStateKW == "ExclusiveHatch" then
        if type(scriptStateNY) == "table" then
            scriptStatePO = scriptStateNY.Pets or(scriptStateNY.Name and {
                scriptStateNY
            }) or nil
        end
    elseif scriptStateKW == "ItemsReceived" then
        if type(scriptStateNY) == "table" then
            scriptStatePO = {
            }
            for loopSlotCF, scriptStateABW in ipairs(scriptStateNY) do
                if type(scriptStateABW) == "table" and scriptStateABW.Type == "Pet" then
                    table.insert(scriptStatePO, scriptStateABW)
                end
            end
            if # scriptStatePO == 0 then
                scriptStatePO = nil
            end
        end
    end
    if not scriptStatePO or type(scriptStatePO) ~= "table" or # scriptStatePO == 0 then
        return
    end
    for loopSlotAA, scriptStateACH in ipairs(scriptStatePO) do
        if loopSlotAA > 1 then
            task.wait(0.1)
        end
        local scriptStateFL = scriptStateACH.Name or(scriptStateACH.Pet and scriptStateACH.Pet.Name) or "Unknown"
            local scriptStateEQ = petRarityData and petRarityData[scriptStateFL] or {
        }
        local scriptStatePG = scriptStateEQ.Rarity or "Unknown"
            if scriptStatePG ~= "Secret" and scriptStatePG ~= "Infinity" then
            continue
        end
        local scriptStateLS = scriptStateACH.Shiny or(scriptStateACH.Pet and scriptStateACH.Pet.Shiny) or false
            local scriptStateNI = scriptStateACH.Mythic or(scriptStateACH.Pet and scriptStateACH.Pet.Mythic) or false
        local scriptStateKK = scriptStateACH.XL or(scriptStateACH.Pet and scriptStateACH.Pet.XL) or false
            if scriptStateNI and not(scriptStatePG == "Legendary" or scriptStatePG == "Secret" or scriptStatePG == "Infinity") then
            scriptStateNI = false
        end
        local scriptStateKY = 3447003
            if scriptStatePG == "Secret" then
            if scriptStateLS and scriptStateNI then
                scriptStateKY = 65280
            elseif scriptStateNI then
                scriptStateKY = 16753920
            elseif scriptStateLS then
                scriptStateKY = 16776960
            else
                scriptStateKY = 16711680
            end
        elseif scriptStatePG == "Infinity" then
            if scriptStateLS and scriptStateNI then
                scriptStateKY = 65280
            elseif scriptStateNI then
                scriptStateKY = 16753920
            elseif scriptStateLS then
                scriptStateKY = 16776960
            else
                scriptStateKY = 10181046
            end
        end
        local scriptStateAK = getWebhookRequestFunction()
            local scriptStateVZ = getDiscordTimestamp()
        local scriptStateXR = string.format("‌🟣 Current Bubbles: %s\n🪙 Coins: %s\n💎 Gems: %s\n🥚 Total Eggs: %s\n🍀 Luck: %s\n❓ Secret luck: %s\n♾️ Infinity luck: %s", getShrineAmountValue(scriptStateVZ.BubblesBlown), getShrineAmountValue(scriptStateAK.Coins), getShrineAmountValue(scriptStateAK.Gems), runShrineDonation(scriptStateVZ.EggsHatched), tostring(scriptStateAK.LuckDisplay), tostring(scriptStateAK.SecretLuckDisplay), tostring(scriptStateAK.InfinityLuckDisplay))
            local scriptStateAFP = 1
            if scriptStateKK then
            scriptStateAFP = 2
        end
        if scriptStateLS and scriptStateNI then
            scriptStateAFP = scriptStateAFP * 2.25
        elseif scriptStateLS then
            scriptStateAFP = scriptStateAFP * 1.5
        elseif scriptStateNI then
            scriptStateAFP = scriptStateAFP * 1.75
        end
        local scriptStateYA = {
        }
        if type(scriptStateEQ.Stats) == "table" then
            for loopSlotCH, scriptStateACC in pairs(scriptStateEQ.Stats) do
                local scriptStateAAB = scriptStateDX[loopSlotCH] or ""
                table.insert(scriptStateYA, string.format("\226\128\140%s %s: +%s", scriptStateAAB, loopSlotCH, runShrineDonation(math.floor(scriptStateACC * scriptStateAFP))))
            end
        end
        if scriptStateEQ.Tag and scriptStateEQ.Tag ~= "" then
            table.insert(scriptStateYA, "\240\159\143\183\239\184\143 Origins: "..tostring(scriptStateEQ.Tag))
        end
        local scriptStateZY =(# scriptStateYA > 0) and table.concat(scriptStateYA, "\n") or "No stats available"
            local scriptStateVN = buildPetWebhookEmbed(scriptStateFL, scriptStateLS, scriptStateNI, scriptStateKK)
        local scriptStateBR = getPetVariantName(scriptStateVN)
        scriptStateZY = scriptStateZY.."\n\nExist: "..(scriptStateBR and runShrineDonation(scriptStateBR) or "—")
        local scriptStateMO = checkLowCurrencyWebhook(scriptStateFL, scriptStateEQ)
            local scriptStateAEC = 100 / scriptStateMO
        local scriptStateYS = 1
            if scriptStateLS then
            scriptStateYS = scriptStateYS * 40
        end
        if scriptStateNI then
            scriptStateYS = scriptStateYS * 100
        end
        if scriptStateKK then
            scriptStateYS = scriptStateYS * 400
        end
        local scriptStateDO = scriptStateAEC * scriptStateYS
            local scriptStatePV =(1 / scriptStateDO) * 100
        local scriptStateVJ = math.floor(scriptStateAEC)
            local scriptStateAEX =(1 / scriptStateAEC) * 100
        local scriptStateBX = string.format("Base: 1/%s (%s)", runShrineDonation(scriptStateVJ), normalizeVariantList(scriptStateAEX))
            local scriptStateXK = scriptStateBX
            if scriptStateYS > 1 then
            local scriptStateAEG = findPetByNameAndVariant(scriptStateLS, scriptStateNI, scriptStateKK) or "Variant"
            scriptStateXK = string.format("%s | %s: 1/%s (%s)", scriptStateBX, scriptStateAEG, runShrineDonation(math.floor(scriptStateDO)), normalizeVariantList(scriptStatePV))
        end
        local scriptStateWG = sendPetWebhook(scriptStateEQ, scriptStateLS, scriptStateNI)
            local scriptStateAEB = scriptStatePG
            if scriptStateEQ.Celestial == true then
            scriptStateAEB = "Celestial"
        elseif scriptStateEQ.Infinity == true then
            scriptStateAEB = "Infinity"
        end
        local scriptStateABD = findPetByNameAndVariant(scriptStateLS, scriptStateNI, scriptStateKK) or ""
            local function runAdminRebirthMachineLoop(scriptStateOS)
            if scriptStateABD ~= "" then
                return string.format("%s hatched a %s \"%s\" %s", scriptStateOS, scriptStateABD, scriptStateAEB, scriptStateFL)
            end
            return string.format("%s hatched a \"%s\" %s", scriptStateOS, scriptStateAEB, scriptStateFL)
        end
        local scriptStateXT = runAdminRebirthMachineLoop(LocalPlayer.Name)
            local scriptStateGO = runAdminRebirthMachineLoop("Player")
        runRebirthMachineLoop(scriptStateXT, scriptStateKY, {
            {
                name = "User Info",
                value = scriptStateXR,
                inline = false
            },
            {
                name = "Pet Info",
                value = scriptStateZY,
                inline = false
            },
            {
                name = "Chance",
                value = scriptStateXK,
                inline = false
            },
        }, scriptStateWG, scriptStateGO)
    end
end) do
    local scriptStatePA = {
        "Normal",
        "Shiny",
        "Mythic",
        "Shiny Mythic"
    }
    local function normalizeRebirthVariants(scriptStateDU)
        local scriptStateFQ, scriptStateFM = {
        }, {
        }
        local function cleanupScriptState(scriptStateBW)
            if type(scriptStateBW) ~= "string" then
                return
            end
            for loopSlotBM, scriptStateAFA in ipairs(scriptStatePA) do
                if string.lower(scriptStateAFA) == string.lower(scriptStateBW) and not scriptStateFM[scriptStateAFA] then
                    scriptStateFM[scriptStateAFA] = true;
                    table.insert(scriptStateFQ, scriptStateAFA)
                end
            end
        end
        if type(scriptStateDU) == "table" then
            for loopSlotBZ, scriptStateWV in pairs(scriptStateDU) do
                if type(loopSlotBZ) == "number" then
                    cleanupScriptState(scriptStateWV)
                elseif scriptStateWV == true then
                    cleanupScriptState(loopSlotBZ)
                elseif type(scriptStateWV) == "string" then
                    cleanupScriptState(scriptStateWV)
                end
            end
        elseif type(scriptStateDU) == "string" then
            cleanupScriptState(scriptStateDU)
        end
        if # scriptStateFQ == 0 then
            cleanupScriptState("Normal")
        end
        return scriptStateFQ
    end
    Config.RebirthVariants = normalizeRebirthVariants(Config.RebirthVariants)
    scriptStateGB:AddInput("RebirthPet", {
        Title = "Pet Name(s)",
        Default = Config.RebirthPetName,
        Placeholder = "e.g. Man Face Lord",
        Callback = function(scriptStateJS)
            Config.RebirthPetName = scriptStateJS;saveConfig()
        end,
    })
    scriptStateGB:AddInput("AdminRebirthPet", {
        Title = "Admin Pet Name(s)",
        Default = Config.AdminRebirthPetName,
        Placeholder = "e.g. Man Face Lord",
        Callback = function(scriptStateWD)
            Config.AdminRebirthPetName = scriptStateWD;saveConfig()
        end,
    })
    scriptStateGB:AddDropdown("RebirthVariants", {
        Title = "Variant(s)",
        Values = scriptStatePA,
        Default = Config.RebirthVariants,
        Multi = true,
        Callback = function(scriptStateVK)
            Config.RebirthVariants = normalizeRebirthVariants(scriptStateVK)
            saveConfig()
        end,
    })
    scriptStateGB:AddToggle("RebirthMachine", {
        Title = "Auto Rebirth Machine",
        Default = Config.RebirthMachineEnabled,
        Callback = function(scriptStateKT)
            Config.RebirthMachineEnabled = scriptStateKT;saveConfig()
        end,
    })
    scriptStateGB:AddToggle("AdminRebirthMachine", {
        Title = "Auto Admin Rebirth Machine",
        Default = Config.AdminRebirthMachineEnabled,
        Callback = function(scriptStateYO)
            Config.AdminRebirthMachineEnabled = scriptStateYO;saveConfig()
        end,
    })
end
local function splitCommaSeparatedPetNames(loopSlotDA)
    local scriptStateUZ = {
    }
    if not loopSlotDA or loopSlotDA == "" then
        return scriptStateUZ
    end
    for scriptStateAQ in string.gmatch(loopSlotDA, "([^,]+)") do
        local scriptStateHR = scriptStateAQ:match("^%s*(.-)%s*$")
            if scriptStateHR and scriptStateHR ~= "" then
            table.insert(scriptStateUZ, scriptStateHR)
        end
    end
    return scriptStateUZ
end
local function getMatchingPetIdsForRebirth(scriptStateDT, scriptStateACR)
    local scriptStateK = {
    }
    local scriptStateQU, scriptStateHZ = pcall(function()
        return profileStore:Get()
    end)
    if not scriptStateQU or type(scriptStateHZ) ~= "table" or type(scriptStateHZ.Pets) ~= "table" then
        return scriptStateK
    end
    local scriptStateAAG = {
    }
    for loopSlotAQ, scriptStateTK in ipairs(splitCommaSeparatedPetNames(scriptStateACR)) do
        scriptStateAAG[scriptStateTK] = true
    end
    for loopSlotN, scriptStateGX in ipairs(scriptStateHZ.Pets) do
        if scriptStateGX.Id and scriptStateAAG[scriptStateGX.Name] then
            local scriptStateQW = "Normal"
            local scriptStateADU = scriptStateGX.Shiny == true;
            local scriptStateML = scriptStateGX.Mythic == true
            if scriptStateADU and scriptStateML then
                scriptStateQW = "Shiny Mythic"
            elseif scriptStateADU then
                scriptStateQW = "Shiny"
            elseif scriptStateML then
                scriptStateQW = "Mythic"
            end
            if scriptStateQW == scriptStateDT then
                table.insert(scriptStateK, scriptStateGX.Id)
            end
        end
    end
    return scriptStateK
end
-- Rebirth helper: gathers matching pets and sends them to the rebirth machine.
local function runRebirthMachine(scriptStateMD, scriptStateYK, scriptStateNU)
    local scriptStateAI
    for loopSlotDM, scriptStateAD in ipairs(Config.RebirthVariants or {
        "Normal"
    }) do
        local scriptStateAFD = getMatchingPetIdsForRebirth(scriptStateAD, scriptStateYK)
            if # scriptStateAFD >= scriptStateMD then
            scriptStateAI = scriptStateAFD;
            break
        end
    end
    if not scriptStateAI then
        return
    end
    local scriptStateADV = {
    };
    local scriptStateVY = {
    }
    while # scriptStateADV < scriptStateMD do
        local scriptStateW = scriptStateAI[math.random(1, # scriptStateAI)]
            if not scriptStateVY[scriptStateW] then
            scriptStateVY[scriptStateW] = true;
            table.insert(scriptStateADV, scriptStateW)
        end
    end
    pcall(function()
        remoteFunction:InvokeServer(scriptStateNU, scriptStateADV)
    end)
end
local function canUseRebirthMachine()
    local scriptStateMF, scriptStatePQ = pcall(function()
        return profileStore:Get()
    end)
    if not scriptStateMF or not scriptStatePQ then
        return false
    end
    local scriptStateDQ = scriptStatePQ.NextRebirthMachineUse
            if type(scriptStateDQ) == "table" then
        scriptStateDQ = scriptStateDQ.NextRebirthMachineUse or scriptStateDQ.Next or scriptStateDQ.Value
    end
    if not scriptStateDQ then
        return true
    end
    return getCurrentTimestamp() >= scriptStateDQ
end
local function canUseAdminRebirthMachine()
    local scriptStateAAL, scriptStateJD = pcall(function()
        return profileStore:Get()
    end)
    if not scriptStateAAL or not scriptStateJD then
        return false
    end
    local scriptStateGK = scriptStateJD.NextAdminRebirthMachineUse
            if type(scriptStateGK) == "table" then
        scriptStateGK = scriptStateGK.NextAdminRebirthMachineUse or scriptStateGK.Next or scriptStateGK.Value
    end
    if not scriptStateGK then
        return true
    end
    return getCurrentTimestamp() >= scriptStateGK
end
local function isAdminRebirthMachineVisible()
    local scriptStateAEE, scriptStateOM = pcall(function()
        return workspace:FindFirstChild("AdminRebirthMachine", true) ~= nil
    end)
    return scriptStateAEE and scriptStateOM
end
task.spawn(function()
    while true do
        if Config.RebirthMachineEnabled and canUseRebirthMachine() then
            runRebirthMachine(5, Config.RebirthPetName, "UseRebirthMachine")
        end
        task.wait(0.5)
    end
end)
task.spawn(function()
    while true do
        if Config.AdminRebirthMachineEnabled and isAdminRebirthMachineVisible() and canUseAdminRebirthMachine() then
            runRebirthMachine(4, Config.AdminRebirthPetName, "UseAdminRebirthMachine")
        end
        task.wait(0.5)
    end
end) do
    scriptStateAFW:AddSection("Performance")
    scriptStateAFW:AddToggle("DisableRendering", {
        Title = "Disable 3D Rendering (AFK / save GPU)",
        Default = Config.disableRendering,
        Callback = function(scriptStateAT)
            Config.disableRendering = scriptStateAT
            saveConfig()
            pcall(function()
                RunService:Set3dRenderingEnabled(not scriptStateAT)
            end)
        end,
    })
    scriptStateAFW:AddInput("ChunkerRenderDistance", {
        Title = "Chunk render distance",
        Description = "Controls how many game chunks are rendered around you.",
        Default = tostring(Config.chunkerRenderDistance),
        Placeholder = "e.g. 4, 15, 30",
        Numeric = true,
        Callback = function(value)
            local renderDistance = tonumber(value)
            if not renderDistance or renderDistance ~= renderDistance then
                return
            end
            Config.chunkerRenderDistance = math.max(1, math.floor(renderDistance))
            _G.BGSI_CHUNK_RENDER_DISTANCE = Config.chunkerRenderDistance
            installChunkerRenderDistanceHook()
            saveConfig()
            refreshChunkerAroundPlayer()
        end,
    })
    pcall(function()
        RunService:Set3dRenderingEnabled(not Config.disableRendering)
    end)
end
Fluent:Notify({
    Title = "1rzHub Lite",
    Content = "Loaded.",
    Duration = 3
})
if type(getgenv) == "function" then
    getgenv()._1rzHubLite_LoadComplete = true
end
