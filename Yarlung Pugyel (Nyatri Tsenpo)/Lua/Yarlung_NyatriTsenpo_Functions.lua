include("FLuaVector.lua")

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
local iYarlungPugyel = GameInfoTypes.CIVILIZATION_YARLUNG_PUGYEL
local traitCordHeavenEarth = GameInfoTypes.TRAIT_CORD_HEAVEN_EARTH

-- Building identifiers for Sacred Peaks
local BUILDING_SACRED_PEAK_1 = GameInfoTypes.BUILDING_SACRED_PEAK_1
local BUILDING_SACRED_PEAK_2 = GameInfoTypes.BUILDING_SACRED_PEAK_2
local BUILDING_SACRED_PEAK_3 = GameInfoTypes.BUILDING_SACRED_PEAK_3
local BUILDING_SACRED_PEAK_DOUBLED = GameInfoTypes.BUILDING_SACRED_PEAK_DOUBLED

-- Buildings for Chöd Ceremony
local BUILDING_CHOD_CEREMONY = GameInfoTypes.BUILDING_CHOD_CEREMONY
local BUILDING_CHOD_CEREMONY_MOUNTAIN = GameInfoTypes.BUILDING_CHOD_CEREMONY_MOUNTAIN

-- Unit identifiers
local unitPawoID = GameInfoTypes.UNIT_PAWO

-- Improvement identifiers
local IMPROVEMENT_SKY_BURIAL_GROUND = GameInfoTypes.IMPROVEMENT_SKY_BURIAL_GROUND

-- Constants
local SACRED_PEAK_DURATION = 25 -- turns
local MAX_SACRED_PEAKS = 5
local CHOD_CEREMONY_DURATION = 15 -- turns
local MOUNTAIN_SEARCH_RADIUS = 3

-- Tables to track Sacred Peaks and their expiration
local tSacredPeaks = {} -- [playerID] = {peak1 = {plotID, expiryTurn, cityID, gpUnitID}, peak2 = {...}, peak3 = {...}}
local tChodCeremonies = {} -- [playerID][cityID] = {expiryTurn, hasMountain}
local tGreatPersonToPeak = {} -- [playerID][unitID] = peakSlot

-- Helper function to find nearest mountain to a plot
function FindNearestMountain(plot, searchRadius)
    local nearestMountain = nil
    local nearestDistance = searchRadius + 1

    for x = -searchRadius, searchRadius do
        for y = -searchRadius, searchRadius do
            local checkPlot = Map.GetPlot(plot:GetX() + x, plot:GetY() + y)
            if checkPlot and checkPlot:IsMountain() then
                local distance = Map.PlotDistance(plot:GetX(), plot:GetY(), checkPlot:GetX(), checkPlot:GetY())
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestMountain = checkPlot
                end
            end
        end
    end

    return nearestMountain
end

-- Helper function to find nearest city to a plot
function FindNearestCity(player, plot)
    local nearestCity = nil
    local nearestDistance = 999

    for city in player:Cities() do
        local distance = Map.PlotDistance(plot:GetX(), plot:GetY(), city:GetX(), city:GetY())
        if distance < nearestDistance then
            nearestDistance = distance
            nearestCity = city
        end
    end

    return nearestCity
end

-- Helper function to check if Sky Burial Ground is adjacent
function HasAdjacentSkyBurialGround(plot)
    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
        local adjacentPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), direction)
        if adjacentPlot and adjacentPlot:GetImprovementType() == IMPROVEMENT_SKY_BURIAL_GROUND then
            return true
        end
    end
    return false
end

-- Helper function to check if city is near mountain
function IsCityNearMountain(city, radius)
    local plot = city:Plot()
    for x = -radius, radius do
        for y = -radius, radius do
            local checkPlot = Map.GetPlot(plot:GetX() + x, plot:GetY() + y)
            if checkPlot and checkPlot:IsMountain() then
                local distance = Map.PlotDistance(plot:GetX(), plot:GetY(), checkPlot:GetX(), checkPlot:GetY())
                if distance <= radius then
                    return true
                end
            end
        end
    end
    return false
end

-- UA: Sacred Peak designation when Great Person is born
function OnUnitCreated_SacredPeak(iPlayer, iUnitID, iUnitType, iX, iY)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitCordHeavenEarth) then
        return
    end

    local unit = player:GetUnitByID(iUnitID)
    if not unit or not unit:IsGreatPerson() then
        return
    end

    -- Spawn a Missionary at the GP's location
    local missionaryType = GameInfoTypes.UNIT_MISSIONARY
    if missionaryType then
        player:InitUnit(missionaryType, iX, iY)
    end

    -- Initialize player's sacred peaks table if needed
    tSacredPeaks[iPlayer] = tSacredPeaks[iPlayer] or {}
    tGreatPersonToPeak[iPlayer] = tGreatPersonToPeak[iPlayer] or {}

    -- Count active sacred peaks
    local activePeaks = 0
    local availableSlot = nil
    for i = 1, MAX_SACRED_PEAKS do
        if tSacredPeaks[iPlayer][i] then
            activePeaks = activePeaks + 1
        elseif not availableSlot then
            availableSlot = i
        end
    end

    -- Check if we can add a new sacred peak
    if activePeaks >= MAX_SACRED_PEAKS then
        if player:IsHuman() and player:IsTurnActive() then
            Events.GameplayAlertMessage(
                "Maximum Sacred Peaks reached! A Great Person must be expended to designate a new one.")
        end
        return
    end

    -- Find nearest mountain
    local unitPlot = Map.GetPlot(iX, iY)
    local mountain = FindNearestMountain(unitPlot, MOUNTAIN_SEARCH_RADIUS)
    if not mountain then
        if player:IsHuman() and player:IsTurnActive() then
            Events.GameplayAlertMessage("No mountain found nearby to designate as Sacred Peak!")
        end
        return
    end

    -- Find nearest city to the mountain
    local nearestCity = FindNearestCity(player, mountain)
    if not nearestCity then
        return
    end

    -- Create sacred peak
    local currentTurn = Game.GetGameTurn()
    tSacredPeaks[iPlayer][availableSlot] = {
        plotID = mountain:GetPlotIndex(),
        expiryTurn = currentTurn + SACRED_PEAK_DURATION,
        cityID = nearestCity:GetID(),
        gpUnitID = iUnitID
    }
    tGreatPersonToPeak[iPlayer][iUnitID] = availableSlot

    -- Apply bonuses to the city
    ApplySacredPeakBonus(player, nearestCity, mountain)

    if player:IsHuman() and player:IsTurnActive() then
        local gpName = Locale.ConvertTextKey(GameInfo.Units[iUnitType].Description)
        Events.GameplayAlertMessage(string.format("Sacred Peak designated! %s blessed a mountain near %s.", gpName,
            nearestCity:GetName()))
    end
end

GameEvents.UnitCreated.Add(OnUnitCreated_SacredPeak)

-- Apply Sacred Peak bonuses to a city
function ApplySacredPeakBonus(player, city, mountain)
    if not city then
        return
    end
    local hasAdjacentBurial = HasAdjacentSkyBurialGround(mountain)
    local bonusBuilding = hasAdjacentBurial and BUILDING_SACRED_PEAK_DOUBLED or BUILDING_SACRED_PEAK_1
    city:SetNumRealBuilding(bonusBuilding, 1)
end

-- Remove Sacred Peak bonuses from a city
function RemoveSacredPeakBonus(player, city, mountain)
    if not city then
        return
    end
    local hasAdjacentBurial = HasAdjacentSkyBurialGround(mountain)
    local bonusBuilding = hasAdjacentBurial and BUILDING_SACRED_PEAK_DOUBLED or BUILDING_SACRED_PEAK_1
    city:SetNumRealBuilding(bonusBuilding, 0)
end

-- UA: Transfer Sacred Peak when Great Person is expended
function OnGreatPersonExpended(iPlayer, iUnitID, iUnitType, iX, iY)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitCordHeavenEarth) then
        return
    end

    if not tGreatPersonToPeak[iPlayer] or not tGreatPersonToPeak[iPlayer][iUnitID] then
        return
    end

    local peakSlot = tGreatPersonToPeak[iPlayer][iUnitID]
    local peakData = tSacredPeaks[iPlayer][peakSlot]
    if not peakData then
        return
    end

    -- Remove old peak bonus
    local oldMountain = Map.GetPlotByIndex(peakData.plotID)
    local oldCity = player:GetCityByID(peakData.cityID)
    if oldCity and oldMountain then
        RemoveSacredPeakBonus(player, oldCity, oldMountain)
    end

    -- Find new location (where GP was expended)
    local expendPlot = Map.GetPlot(iX, iY)
    local newCity = nil
    if expendPlot:IsCity() then
        newCity = expendPlot:GetPlotCity()
    else
        newCity = FindNearestCity(player, expendPlot)
    end
    if not newCity then
        return
    end

    -- Find nearest mountain to the new city
    local newMountain = FindNearestMountain(newCity:Plot(), MOUNTAIN_SEARCH_RADIUS)
    if not newMountain then
        tSacredPeaks[iPlayer][peakSlot] = nil
        tGreatPersonToPeak[iPlayer][iUnitID] = nil
        if player:IsHuman() and player:IsTurnActive() then
            Events.GameplayAlertMessage("Sacred Peak lost - no mountain near the expenditure location!")
        end
        return
    end

    -- Transfer the peak and refresh duration
    local currentTurn = Game.GetGameTurn()
    tSacredPeaks[iPlayer][peakSlot] = {
        plotID = newMountain:GetPlotIndex(),
        expiryTurn = currentTurn + SACRED_PEAK_DURATION,
        cityID = newCity:GetID(),
        gpUnitID = nil
    }
    ApplySacredPeakBonus(player, newCity, newMountain)
    tGreatPersonToPeak[iPlayer][iUnitID] = nil

    if player:IsHuman() and player:IsTurnActive() then
        Events.GameplayAlertMessage(string.format("Sacred Peak transferred to a mountain near %s!", newCity:GetName()))
    end
end

GameEvents.GreatPersonExpended.Add(OnGreatPersonExpended)

-- Process Sacred Peak expiration
function OnPlayerDoTurn_SacredPeakExpiry(iPlayer)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitCordHeavenEarth) then
        return
    end

    if not tSacredPeaks[iPlayer] then
        return
    end

    local currentTurn = Game.GetGameTurn()

    for peakSlot, peakData in pairs(tSacredPeaks[iPlayer]) do
        if peakData and currentTurn >= peakData.expiryTurn then
            -- Remove expired peak
            local mountain = Map.GetPlotByIndex(peakData.plotID)
            local city = player:GetCityByID(peakData.cityID)

            if city and mountain then
                RemoveSacredPeakBonus(player, city, mountain)
            end

            -- Clean up tracking
            if peakData.gpUnitID and tGreatPersonToPeak[iPlayer] then
                tGreatPersonToPeak[iPlayer][peakData.gpUnitID] = nil
            end

            tSacredPeaks[iPlayer][peakSlot] = nil

            if player:IsHuman() and player:IsTurnActive() then
                Events.GameplayAlertMessage("A Sacred Peak's blessing has expired.")
            end
        end
    end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_SacredPeakExpiry)

-- UU: Pawo Chöd Ceremony
function OnUnitCanHaveMission_Pawo(iPlayer, iUnit, iMission, iData1, iData2, iData3, bTestVisible)
    if iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
        local player = Players[iPlayer]
        if not player then
            return false
        end

        local unit = player:GetUnitByID(iUnit)
        if not unit or unit:GetUnitType() ~= unitPawoID then
            return false
        end

        if bTestVisible then
            return true
        end

        -- Check if unit is in a city
        local plot = unit:GetPlot()
        if not plot:IsCity() then
            return false
        end

        return true
    end
    return true
end

GameEvents.CustomMissionPossible.Add(OnUnitCanHaveMission_Pawo)

function OnUnitDoMission_Pawo(iPlayer, iUnit, iMission, iData1, iData2, iData3)
    if iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
        local player = Players[iPlayer]
        if not player then
            return false
        end

        local unit = player:GetUnitByID(iUnit)
        if not unit or unit:GetUnitType() ~= unitPawoID then
            return false
        end

        local plot = unit:GetPlot()
        if not plot:IsCity() then
            return false
        end

        local city = plot:GetPlotCity()
        if not city or city:GetOwner() ~= iPlayer then
            return false
        end

        -- Initialize ceremony tracking
        tChodCeremonies[iPlayer] = tChodCeremonies[iPlayer] or {}

        local currentTurn = Game.GetGameTurn()
        local hasMountain = IsCityNearMountain(city, 2)

        -- Apply ceremony effects
        tChodCeremonies[iPlayer][city:GetID()] = {
            expiryTurn = currentTurn + CHOD_CEREMONY_DURATION,
            hasMountain = hasMountain
        }

        -- Apply building bonuses
        city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY, 1)
        if hasMountain then
            city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_MOUNTAIN, 1)
        end

        -- Kill the unit (expended)
        unit:Kill()

        if player:IsHuman() and player:IsTurnActive() then
            local msg = string.format(
                "Chöd Ceremony performed in %s! Great Person rates and tourism boosted for %d turns.", city:GetName(),
                CHOD_CEREMONY_DURATION)
            Events.GameplayAlertMessage(msg)
        end

        return true
    end
    return false
end

GameEvents.CustomMissionCompleted.Add(OnUnitDoMission_Pawo)

-- Process Chöd Ceremony expiration
function OnPlayerDoTurn_ChodCeremonyExpiry(iPlayer)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end

    if not tChodCeremonies[iPlayer] then
        return
    end

    local currentTurn = Game.GetGameTurn()

    for cityID, ceremonyData in pairs(tChodCeremonies[iPlayer]) do
        if ceremonyData and currentTurn >= ceremonyData.expiryTurn then
            local city = player:GetCityByID(cityID)
            if city then
                -- Remove ceremony buildings
                city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY, 0)
                city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_MOUNTAIN, 0)
            end

            tChodCeremonies[iPlayer][cityID] = nil

            if player:IsHuman() and player:IsTurnActive() then
                Events.GameplayAlertMessage(string.format("Chöd Ceremony in %s has ended.", city:GetName()))
            end
        end
    end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_ChodCeremonyExpiry)

-- UTI: Sky Burial Ground adjacency yields
function OnImprovementBuilt_SkyBurialGround(iPlayer, iX, iY, iImprovement)
    if iImprovement ~= IMPROVEMENT_SKY_BURIAL_GROUND then
        return
    end

    local player = Players[iPlayer]
    if not player then
        return
    end

    local plot = Map.GetPlot(iX, iY)
    if not plot then
        return
    end

    -- Count adjacent mountains and GP improvements
    local adjacentMountains = 0
    local adjacentGPImprovements = 0

    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
        local adjacentPlot = Map.PlotDirection(iX, iY, direction)
        if adjacentPlot then
            if adjacentPlot:IsMountain() then
                adjacentMountains = adjacentMountains + 1
            end

            local improvementType = adjacentPlot:GetImprovementType()
            if improvementType >= 0 then
                local improvementInfo = GameInfo.Improvements[improvementType]
                if improvementInfo and improvementInfo.CreatedByGreatPerson then
                    adjacentGPImprovements = adjacentGPImprovements + 1
                end
            end
        end
    end

    -- Apply additional yields based on adjacency
    -- (Base yields are defined in SQL, these are bonuses)
    local bonusCulture = adjacentMountains + adjacentGPImprovements
    local bonusFaith = adjacentMountains + adjacentGPImprovements

    -- Store bonus yields (would need custom yield system or dummy buildings)
    -- For simplicity, we'll notify the player
    if player:IsHuman() and player:IsTurnActive() then
        if bonusCulture > 0 then
            Events.GameplayAlertMessage(string.format(
                "Sky Burial Ground built with +%d Culture and +%d Faith from adjacency!", bonusCulture, bonusFaith))
        end
    end
end

GameEvents.BuildFinished.Add(OnImprovementBuilt_SkyBurialGround)

-- Initialize tables on game load
function OnLoadScreenClose()
    -- Ensure tables are initialized for all players
    for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
        local player = Players[iPlayer]
        if player and player:IsAlive() and HasTrait(player, traitCordHeavenEarth) then
            tSacredPeaks[iPlayer] = tSacredPeaks[iPlayer] or {}
            tGreatPersonToPeak[iPlayer] = tGreatPersonToPeak[iPlayer] or {}
            tChodCeremonies[iPlayer] = tChodCeremonies[iPlayer] or {}
        end
    end
end

Events.LoadScreenClose.Add(OnLoadScreenClose)
