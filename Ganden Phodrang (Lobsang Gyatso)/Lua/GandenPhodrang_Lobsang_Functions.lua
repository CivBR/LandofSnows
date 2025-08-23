include("FLuaVector.lua")
local SpyMissionDetector = include("SpyMissionDetector.lua")

-- Utility function to check if player has trait
function HasTrait(player, traitID)
    if Player.HasTrait then
        return player:HasTrait(traitID)
    else
        local leaderType = GameInfo.Leaders[player:GetLeaderType()].Type
        local traitType = GameInfo.Traits[traitID].Type
        for row in GameInfo.Leader_Traits("LeaderType = '" .. leaderType .. "' AND TraitType = '" .. traitType .. "'") do
            return true
        end
    end
    return false
end

local GameInfoTypes = GameInfoTypes

-- Civilization and trait identifiers
local iGandenLobsang = GameInfoTypes.CIVILIZATION_GANDEN_PHODRANG_LOBSANG_GYATSO
local traitTenSyllablesPower = GameInfoTypes.TRAIT_TEN_SYLLABLES_POWER

-- Building identifiers
local BUILDING_SPY_POPULATION_TRANSFER = GameInfoTypes.BUILDING_SPY_POPULATION_TRANSFER
local BUILDING_SPY_COUP_BONUS = GameInfoTypes.BUILDING_SPY_COUP_BONUS
local BUILDING_AMCHI_DEFENSE = GameInfoTypes.BUILDING_AMCHI_DEFENSE
local BUILDING_AMCHI_MARCH = GameInfoTypes.BUILDING_AMCHI_MARCH
local BUILDING_DANSA = GameInfoTypes.BUILDING_DANSA
local BUILDING_DANSA_UNEMPLOYED = GameInfoTypes.BUILDING_DANSA_UNEMPLOYED
local BUILDING_DANSA_RELIGIOUS_BONUS = GameInfoTypes.BUILDING_DANSA_RELIGIOUS_BONUS

-- Unit identifiers
local unitAmchiID = GameInfoTypes.UNIT_AMCHI
local unitMissionaryID = GameInfoTypes.UNIT_MISSIONARY
local unitInquisitorID = GameInfoTypes.UNIT_INQUISITOR
local unitProphetID = GameInfoTypes.UNIT_PROPHET

-- Promotion identifiers
local PROMOTION_MARCH = GameInfoTypes.PROMOTION_MARCH
local PROMOTION_MEDIC = GameInfoTypes.PROMOTION_MEDIC
local PROMOTION_AMCHI_BLESSED = GameInfoTypes.PROMOTION_AMCHI_BLESSED

-- Constants
local SPY_POPULATION_TRANSFER = 2 -- Population to transfer per spy mission
local DEFENSE_PER_FOLLOWER = 4 -- Defense per follower for Amchi
local AMCHI_HEAL_AMOUNT = 90 -- HP healed when Amchi expended

-- Tables to track effects
local tSpyMissions = {} -- [playerID] = {csID = hasCoup}
local tAmchiGarrison = {} -- [playerID][cityID] = unitID

-- Helper function to get player's religion
function GetPlayerReligion(player)
    local religion = player:GetReligionCreatedByPlayer()
    if religion > 0 then
        return religion
    end
    -- Check capital's majority religion
    local capital = player:GetCapitalCity()
    if capital then
        return capital:GetReligiousMajority()
    end
    return -1
end

-- Helper function to count followers in city
function CountFollowersInCity(city, religion)
    if religion < 0 then
        return 0
    end
    return city:GetNumFollowers(religion)
end

-- Helper function to find best city for population
function FindBestCityForPopulation(player)
    local bestCity = nil
    local bestScore = -1

    -- find city with lowest population
    for city in player:Cities() do
        local score = 100 - city:GetPopulation() -- Prefer smaller cities

        -- Bonus for having Dansa
        if city:IsHasBuilding(BUILDING_DANSA) then
            score = score + 20
        end

        if score > bestScore then
            bestScore = score
            bestCity = city
        end
    end

    return bestCity or player:GetCapitalCity()
end

-- UA: Callbacks for detected spy missions

-- Tech steal detection callback
function OnTechStealDetected(iPlayer, iMissionType, targetData)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitTenSyllablesPower) then
        return
    end

    -- Grant building bonus for tech steal
    local capital = player:GetCapitalCity()
    if capital then
        -- Track with dummy building for yield bonuses
        local currentCount = capital:GetNumBuilding(BUILDING_SPY_POPULATION_TRANSFER) or 0
        capital:SetNumRealBuilding(BUILDING_SPY_POPULATION_TRANSFER, math.min(currentCount + 1, 10))

        -- Transfer population from random enemy city
        local destCity = FindBestCityForPopulation(player)
        if destCity then
            destCity:ChangePopulation(SPY_POPULATION_TRANSFER, true)

            if player:IsHuman() and player:IsTurnActive() then
                Events.GameplayAlertMessage(string.format(
                    "[COLOR_POSITIVE_TEXT]Tech Steal Detected![ENDCOLOR] %s acquired! +%d population to %s",
                    targetData.techName, SPY_POPULATION_TRANSFER, destCity:GetName()))
            end
        end
    end
end

-- Rig election detection callback
function OnRigElectionDetected(iPlayer, iMissionType, targetData)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitTenSyllablesPower) then
        return
    end

    -- Transfer population from city-state
    local csPlayer = Players[targetData.csID]
    if csPlayer then
        -- Find CS capital
        local csCapital = csPlayer:GetCapitalCity()
        if csCapital and csCapital:GetPopulation() > 1 then
            csCapital:ChangePopulation(-1, false)

            local destCity = FindBestCityForPopulation(player)
            if destCity then
                destCity:ChangePopulation(SPY_POPULATION_TRANSFER, true)

                if player:IsHuman() and player:IsTurnActive() then
                    Events.GameplayAlertMessage(string.format(
                        "[COLOR_POSITIVE_TEXT]Election Rigged![ENDCOLOR] %s influence +%d! Transferred population to %s",
                        targetData.csName, targetData.influenceGain, destCity:GetName()))
                end
            end
        end
    end
end

-- Coup detection callback
function OnCoupDetected(iPlayer, iMissionType, targetData)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitTenSyllablesPower) then
        return
    end

    -- Convert CS population to player's religion
    local religion = GetPlayerReligion(player)
    local csPlayer = Players[targetData.csID]

    if religion > 0 and csPlayer then
        local csCapital = csPlayer:GetCapitalCity()
        if csCapital then
            local pop = csCapital:GetPopulation()
            csCapital:AdoptReligionFully(religion)

            -- Check if first coup on this CS
            tSpyMissions[iPlayer] = tSpyMissions[iPlayer] or {}
            local csID = targetData.csID

            if not tSpyMissions[iPlayer][csID] then
                -- First coup bonus
                tSpyMissions[iPlayer][csID] = true

                -- Grant coup bonus building (represents extra spy in abstract)
                local capital = player:GetCapitalCity()
                if capital then
                    local currentBonus = capital:GetNumBuilding(BUILDING_SPY_COUP_BONUS) or 0
                    capital:SetNumRealBuilding(BUILDING_SPY_COUP_BONUS, math.min(currentBonus + 1, 5))
                end

                if player:IsHuman() and player:IsTurnActive() then
                    Events.GameplayAlertMessage(string.format(
                        "[COLOR_POSITIVE_TEXT]Coup Success![ENDCOLOR] %s allied! Converted %d population to your religion. [COLOR_POSITIVE_TEXT]First coup bonus activated![ENDCOLOR]",
                        targetData.csName, pop))
                end
            else
                if player:IsHuman() and player:IsTurnActive() then
                    Events.GameplayAlertMessage(string.format(
                        "[COLOR_POSITIVE_TEXT]Coup Success![ENDCOLOR] %s allied! Converted %d population to your religion.",
                        targetData.csName, pop))
                end
            end
        end
    end
end

-- Initialize spy mission detection
function InitializeSpyDetection()
    if SpyMissionDetector then
        -- Register callbacks for each mission type
        SpyMissionDetector.RegisterCallback(SpyMissionDetector.MISSION_STEAL_TECH, OnTechStealDetected)
        SpyMissionDetector.RegisterCallback(SpyMissionDetector.MISSION_RIG_ELECTION, OnRigElectionDetected)
        SpyMissionDetector.RegisterCallback(SpyMissionDetector.MISSION_COUP, OnCoupDetected)

        -- Initialize the detector
        SpyMissionDetector.Initialize()

        print("Ganden Phodrang spy detection initialized")
    end
end

-- Track spy missions each turn
function OnPlayerDoTurn_SpyActivities(iPlayer)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitTenSyllablesPower) then
        return
    end

    -- Ensure tracking tables exist
    tSpyMissions[iPlayer] = tSpyMissions[iPlayer] or {}

    -- Process spy detection
    if SpyMissionDetector then
        SpyMissionDetector.ProcessPlayer(iPlayer)
    end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_SpyActivities)

-- UU: Amchi garrison effects
function OnUnitSetXY_Amchi(iPlayer, iUnit, iX, iY)
    local player = Players[iPlayer]
    if not player then
        return
    end

    local unit = player:GetUnitByID(iUnit)
    if not unit or unit:GetUnitType() ~= unitAmchiID then
        return
    end

    -- Initialize tracking
    tAmchiGarrison[iPlayer] = tAmchiGarrison[iPlayer] or {}

    -- Check if unit is garrisoned in a city
    local plot = Map.GetPlot(iX, iY)
    if plot and plot:IsCity() then
        local city = plot:GetPlotCity()
        if city and city:GetOwner() == iPlayer and unit:IsFortified() then
            -- Unit is garrisoned
            local cityID = city:GetID()

            -- Clear any previous garrison by this unit
            for cID, uID in pairs(tAmchiGarrison[iPlayer]) do
                if uID == iUnit then
                    tAmchiGarrison[iPlayer][cID] = nil
                    local oldCity = player:GetCityByID(cID)
                    if oldCity then
                        oldCity:SetNumRealBuilding(BUILDING_AMCHI_DEFENSE, 0)
                        oldCity:SetNumRealBuilding(BUILDING_AMCHI_MARCH, 0)
                    end
                end
            end

            -- Set new garrison
            tAmchiGarrison[iPlayer][cityID] = iUnit

            -- Calculate defense bonus based on followers
            local religion = GetPlayerReligion(player)
            local followers = CountFollowersInCity(city, religion)
            local defenseBonus = followers * DEFENSE_PER_FOLLOWER

            -- Apply bonuses
            city:SetNumRealBuilding(BUILDING_AMCHI_DEFENSE, math.min(defenseBonus / 10, 20)) -- Cap at 200 defense
            city:SetNumRealBuilding(BUILDING_AMCHI_MARCH, 1)

            if player:IsHuman() and player:IsTurnActive() then
                Events.GameplayAlertMessage(string.format(
                    "Amchi garrison in %s: +%d Defense from %d followers. Units gain March!", city:GetName(),
                    defenseBonus, followers))
            end
        else
            -- Not properly garrisoned, remove from tracking
            RemoveAmchiFromCity(player, iUnit)
        end
    else
        -- Not in a city, remove from tracking
        RemoveAmchiFromCity(player, iUnit)
    end
end

GameEvents.UnitSetXY.Add(OnUnitSetXY_Amchi)

-- Helper function to remove Amchi garrison effects
function RemoveAmchiFromCity(player, unitID)
    local iPlayer = player:GetID()
    if not tAmchiGarrison[iPlayer] then
        return
    end

    for cityID, uID in pairs(tAmchiGarrison[iPlayer]) do
        if uID == unitID then
            tAmchiGarrison[iPlayer][cityID] = nil
            local city = player:GetCityByID(cityID)
            if city then
                city:SetNumRealBuilding(BUILDING_AMCHI_DEFENSE, 0)
                city:SetNumRealBuilding(BUILDING_AMCHI_MARCH, 0)
            end
            break
        end
    end
end

-- UU: Units trained with Amchi garrison get March
function OnCityTrained_AmchiMarch(iPlayer, iCity, iUnit, bGold, bFaith)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitTenSyllablesPower) then
        return
    end

    -- Check if city has Amchi garrison
    if tAmchiGarrison[iPlayer] and tAmchiGarrison[iPlayer][iCity] then
        local unit = player:GetUnitByID(iUnit)
        if unit and unit:IsCombatUnit() and not unit:IsGreatPerson() then
            -- Grant March promotion
            unit:SetHasPromotion(PROMOTION_MARCH, true)

            if player:IsHuman() and player:IsTurnActive() then
                Events.GameplayAlertMessage("Unit trained with March promotion from Amchi garrison!")
            end
        end
    end
end

GameEvents.CityTrained.Add(OnCityTrained_AmchiMarch)

-- UU: Amchi healing when expended
function OnUnitKilled_AmchiHeal(iPlayer, iUnit, iUnitType, iX, iY, bDelay, iKiller)
    if iUnitType ~= unitAmchiID then
        return
    end
    if iPlayer ~= iKiller then
        return
    end -- Must be killed by own player (expended)

    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitTenSyllablesPower) then
        return
    end

    -- Heal all adjacent units
    local plot = Map.GetPlot(iX, iY)
    if not plot then
        return
    end

    local unitsHealed = 0

    -- Check center plot
    local numUnits = plot:GetNumUnits()
    for i = 0, numUnits - 1 do
        local unit = plot:GetUnit(i)
        if unit and unit:GetOwner() == iPlayer and unit:IsCombatUnit() then
            unit:ChangeDamage(-AMCHI_HEAL_AMOUNT)
            unit:SetHasPromotion(PROMOTION_MEDIC, true)
            unitsHealed = unitsHealed + 1
        end
    end

    -- Check adjacent plots
    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
        local adjacentPlot = Map.PlotDirection(iX, iY, direction)
        if adjacentPlot then
            local numUnits = adjacentPlot:GetNumUnits()
            for i = 0, numUnits - 1 do
                local unit = adjacentPlot:GetUnit(i)
                if unit and unit:GetOwner() == iPlayer and unit:IsCombatUnit() then
                    unit:ChangeDamage(-AMCHI_HEAL_AMOUNT)
                    unit:SetHasPromotion(PROMOTION_MEDIC, true)
                    unitsHealed = unitsHealed + 1
                end
            end
        end
    end

    if player:IsHuman() and unitsHealed > 0 then
        Events.GameplayAlertMessage(string.format(
            "[COLOR_POSITIVE_TEXT]Amchi expended![ENDCOLOR] Healed %d units and granted Medic promotion!", unitsHealed))
    end
end

GameEvents.UnitPrekill.Add(OnUnitKilled_AmchiHeal)

-- UB: Dansa bonuses (unemployed citizens and specialist science burst)
function UpdateDansaBonusAlways(player, city)
    if not city or not city:IsHasBuilding(BUILDING_DANSA) then
        city:SetNumRealBuilding(BUILDING_DANSA_UNEMPLOYED, 0)
        city:SetNumRealBuilding(BUILDING_DANSA_RELIGIOUS_BONUS, 0)
        return
    end
    -- Count unemployed citizens
    local unemployed = city:GetPopulation() - city:GetNumSpecialists() - city:GetNumWorkingPlots()
    if unemployed < 0 then
        unemployed = 0
    end
    city:SetNumRealBuilding(BUILDING_DANSA_UNEMPLOYED, unemployed)

    -- Bonus for religious buildings
    local religiousBuildings = 0
    local buildings = {GameInfoTypes.BUILDING_SHRINE, GameInfoTypes.BUILDING_TEMPLE, GameInfoTypes.BUILDING_MONASTERY,
                       GameInfoTypes.BUILDING_CATHEDRAL, GameInfoTypes.BUILDING_MOSQUE, GameInfoTypes.BUILDING_PAGODA}
    for _, buildingID in ipairs(buildings) do
        if buildingID and city:IsHasBuilding(buildingID) then
            religiousBuildings = religiousBuildings + 1
        end
    end
    city:SetNumRealBuilding(BUILDING_DANSA_RELIGIOUS_BONUS, religiousBuildings)
end

-- Update Dansa bonuses each turn with dummies
function OnPlayerDoTurn_DansaAlways(iPlayer)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitTenSyllablesPower) then
        return
    end
    for city in player:Cities() do
        if city:IsHasBuilding(BUILDING_DANSA) then
            UpdateDansaBonusAlways(player, city)
        else
            city:SetNumRealBuilding(BUILDING_DANSA_UNEMPLOYED, 0)
            city:SetNumRealBuilding(BUILDING_DANSA_RELIGIOUS_BONUS, 0)
        end
    end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_DansaAlways)

-- Science burst when religious unit is trained or born
function OnCityTrained_DansaScienceBurst(iPlayer, iCity, iUnit, bGold, bFaith)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitTenSyllablesPower) then
        return
    end
    local city = player:GetCityByID(iCity)
    if not city or not city:IsHasBuilding(BUILDING_DANSA) then
        return
    end
    local unit = player:GetUnitByID(iUnit)
    if not unit then
        return
    end
    local unitType = unit:GetUnitType()
    if unitType == unitMissionaryID or unitType == unitInquisitorID or unitType == unitProphetID or unitType ==
        unitAmchiID then
        local specialistCount = city:GetSpecialistCount()
        if specialistCount > 0 then
            local scienceBurst = specialistCount * 10 -- 10 Science per specialist
            local currentTech = player:GetCurrentResearch()
            if currentTech ~= -1 then
                player:ChangeResearchProgress(currentTech, scienceBurst)
                if player:IsHuman() and player:IsTurnActive() then
                    Events.GameplayAlertMessage(string.format(
                        "[COLOR_POSITIVE_TEXT]Religious unit trained in Dansa city![ENDCOLOR] Specialists provide %d Science to current research.",
                        scienceBurst))
                end
            end
        end
    end
end

GameEvents.CityTrained.Add(OnCityTrained_DansaScienceBurst)

function OnUnitCreated_DansaScienceBurst(iPlayer, iUnitID, iUnitType, iX, iY)
    if iUnitType ~= unitProphetID and iUnitType ~= unitMissionaryID and iUnitType ~= unitInquisitorID and iUnitType ~=
        unitAmchiID then
        return
    end
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitTenSyllablesPower) then
        return
    end
    local plot = Map.GetPlot(iX, iY)
    if plot and plot:IsCity() then
        local city = plot:GetPlotCity()
        if city and city:GetOwner() == iPlayer and city:IsHasBuilding(BUILDING_DANSA) then
            local specialistCount = city:GetTotalSpecialistCount()
            if specialistCount > 0 then
                local scienceBurst = specialistCount * 10
                local currentTech = player:GetCurrentResearch()
                if currentTech ~= -1 then
                    player:ChangeResearchProgress(currentTech, scienceBurst)
                    if player:IsHuman() and player:IsTurnActive() then
                        Events.GameplayAlertMessage(string.format(
                            "[COLOR_POSITIVE_TEXT]Great Prophet born in Dansa city![ENDCOLOR] Specialists provide %d Science to current research.",
                            scienceBurst))
                    end
                end
            end
        end
    end
end

GameEvents.UnitCreated.Add(OnUnitCreated_DansaScienceBurst)

-- Initialize tables on game load
function OnLoadScreenClose()
    -- Ensure tables are initialized for all players
    for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
        local player = Players[iPlayer]
        if player and player:IsAlive() and HasTrait(player, traitTenSyllablesPower) then
            tSpyMissions[iPlayer] = tSpyMissions[iPlayer] or {}
            tAmchiGarrison[iPlayer] = tAmchiGarrison[iPlayer] or {}
        end
    end

    -- Initialize spy detection system
    InitializeSpyDetection()
end

Events.LoadScreenClose.Add(OnLoadScreenClose)
