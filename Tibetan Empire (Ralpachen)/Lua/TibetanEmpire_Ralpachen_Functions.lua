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
local iTibetanRalpachen = GameInfoTypes.CIVILIZATION_TIBETAN_EMPIRE_RALPACHEN
local traitChakravartinSilkRoad = GameInfoTypes.TRAIT_CHAKRAVARTIN_SILK_ROAD

-- Building identifiers
local BUILDING_TRADE_ROUTE_GOLD = GameInfoTypes.BUILDING_TRADE_ROUTE_GOLD
local BUILDING_HOLY_SITE_ROAD_BONUS = GameInfoTypes.BUILDING_HOLY_SITE_ROAD_BONUS
local BUILDING_TITHE_ACTIVE = GameInfoTypes.BUILDING_TITHE_ACTIVE
local BUILDING_TITHE_FAITH_BONUS = GameInfoTypes.BUILDING_TITHE_FAITH_BONUS
local BUILDING_CORVEE_SPAWNER = GameInfoTypes.BUILDING_CORVEE_SPAWNER
local BUILDING_CHOLON_FAITH_BONUS = GameInfoTypes.BUILDING_CHOLON_FAITH_BONUS
local BUILDING_ZIMCHONGPA_GARRISON = GameInfoTypes.BUILDING_ZIMCHONGPA_GARRISON
local BUILDING_ZIMCHONGPA_CONNECTION = GameInfoTypes.BUILDING_ZIMCHONGPA_CONNECTION

-- Unit identifiers
local unitCholonID = GameInfoTypes.UNIT_CHOLON
local unitZimchongpaID = GameInfoTypes.UNIT_ZIMCHONGPA

-- Process identifiers
local PROCESS_TITHE = GameInfoTypes.PROCESS_TITHE

-- Promotion identifiers
local PROMOTION_CORVEE = GameInfoTypes.PROMOTION_CORVEE
local PROMOTION_ZIMCHONGPA_HILL = GameInfoTypes.PROMOTION_ZIMCHONGPA_HILL
local PROMOTION_ZIMCHONGPA_MOUNTAIN = GameInfoTypes.PROMOTION_ZIMCHONGPA_MOUNTAIN

-- Improvement identifiers
local IMPROVEMENT_HOLY_SITE = GameInfoTypes.IMPROVEMENT_HOLY_SITE
local IMPROVEMENT_CUSTOMS_HOUSE = GameInfoTypes.IMPROVEMENT_CUSTOMS_HOUSE

-- Constants
local TITHE_CONVERSION_RATE = 0.3 -- 30% of Gold/Production to Faith
local CORVEE_DURATION = 20 -- turns
local CHOLON_FAITH_BONUS_PER_CS = 0.1 -- 10% per CS connection

-- Tables to track effects
local tCorveUnits = {} -- [playerID][unitID] = expiryTurn
local tTitheCities = {} -- [playerID][cityID] = true/false
local tZimchongpaGarrison = {} -- [playerID][cityID] = unitID
local tCityConnections = {} -- [playerID] = {cityIDs with connections}

-- Helper function to count city connections
function CountCityConnections(player)
    local count = 0
    local capital = player:GetCapitalCity()
    if not capital then
        return 0
    end

    for city in player:Cities() do
        if city ~= capital and city:IsConnectedToCapital() then
            count = count + 1
        end
    end

    -- Add Zimchongpa garrison connections
    if tZimchongpaGarrison[player:GetID()] then
        for cityID, unitID in pairs(tZimchongpaGarrison[player:GetID()]) do
            local city = player:GetCityByID(cityID)
            if city and not city:IsConnectedToCapital() then
                count = count + 1
            end
        end
    end

    return count
end

-- Helper function to count CS connections
function CountCSConnections(player)
    local count = 0
    local iPlayer = player:GetID()

    for csID = 0, GameDefines.MAX_MINOR_CIVS - 1 do
        local cs = Players[csID]
        if cs and cs:IsAlive() and cs:IsMinorCiv() then
            -- Check if CS has a trade route with player
            local csCapital = cs:GetCapitalCity()
            if csCapital then
                for i = 0, csCapital:GetNumTradeRoutes() - 1 do
                    local route = csCapital:GetTradeRoute(i)
                    if route and route:GetDestinationCity():GetOwner() == iPlayer then
                        count = count + 1
                        break
                    end
                end
            end
        end
    end

    return count
end

-- UA: Trade Routes generate Gold for City Connections
function OnPlayerDoTurn_TradeRouteGold(iPlayer)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitChakravartinSilkRoad) then
        return
    end

    local capital = player:GetCapitalCity()
    if not capital then
        return
    end

    local cityConnections = CountCityConnections(player)
    local totalGold = 0

    -- Check each trade route
    for city in player:Cities() do
        for i = 0, city:GetNumTradeRoutes() - 1 do
            local route = city:GetTradeRoute(i)
            if route then
                -- Check if route passes through our territory
                local passesThroughOurTerritory = false
                -- Simplified check - if destination is one of our cities
                local destCity = route:GetDestinationCity()
                if destCity and destCity:GetOwner() ~= iPlayer then
                    -- Foreign trade route - assume it passes through if we have cities nearby
                    passesThroughOurTerritory = true
                end

                if passesThroughOurTerritory then
                    totalGold = totalGold + cityConnections
                end
            end
        end
    end

    -- Apply gold bonus
    if totalGold > 0 then
        capital:SetNumRealBuilding(BUILDING_TRADE_ROUTE_GOLD, totalGold)

        if player:IsHuman() and player:IsTurnActive() then
            Events.GameplayAlertMessage(string.format("Trade Routes: +%d Gold from %d City Connections", totalGold,
                cityConnections))
        end
    else
        capital:SetNumRealBuilding(BUILDING_TRADE_ROUTE_GOLD, 0)
    end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_TradeRouteGold)

-- UA: Roads on/adjacent to Holy Sites yield bonuses
function OnPlayerDoTurn_HolySiteRoadBonus(iPlayer)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitChakravartinSilkRoad) then
        return
    end

    local capital = player:GetCapitalCity()
    if not capital then
        return
    end

    local bonusCount = 0

    -- Check all plots owned by player
    for i = 0, Map.GetNumPlots() - 1 do
        local plot = Map.GetPlotByIndex(i)
        if plot and plot:GetOwner() == iPlayer then
            -- Check if plot has road
            if plot:IsRoute() then
                -- Check if plot has Holy Site
                if plot:GetImprovementType() == IMPROVEMENT_HOLY_SITE then
                    bonusCount = bonusCount + 1
                else
                    -- Check if adjacent to Holy Site
                    for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
                        local adjacentPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), direction)
                        if adjacentPlot and adjacentPlot:GetOwner() == iPlayer and adjacentPlot:GetImprovementType() ==
                            IMPROVEMENT_HOLY_SITE then
                            bonusCount = bonusCount + 1
                            break
                        end
                    end
                end
            end
        end
    end

    -- Apply bonuses
    capital:SetNumRealBuilding(BUILDING_HOLY_SITE_ROAD_BONUS, bonusCount)
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_HolySiteRoadBonus)

-- UA: Tithe Process
function OnCityDoTurn_TitheProcess(iPlayer)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitChakravartinSilkRoad) then
        return
    end

    tTitheCities[iPlayer] = tTitheCities[iPlayer] or {}

    for city in player:Cities() do
        local cityID = city:GetID()
        local wasTithe = tTitheCities[iPlayer][cityID]
        local isTithe = city:IsProductionProcess() and city:GetProductionProcess() == PROCESS_TITHE

        -- Check for Zimchongpa garrison providing Tithe
        local hasZimchongpa = false
        if tZimchongpaGarrison[iPlayer] and tZimchongpaGarrison[iPlayer][cityID] then
            local unit = player:GetUnitByID(tZimchongpaGarrison[iPlayer][cityID])
            if unit and unit:GetUnitType() == unitZimchongpaID then
                hasZimchongpa = true
                isTithe = true -- Zimchongpa provides Tithe regardless of production
            end
        end

        if isTithe then
            -- Calculate Faith from Gold and Production
            local cityGold = city:GetYieldRate(GameInfoTypes.YIELD_GOLD)
            local cityProduction = city:GetYieldRate(GameInfoTypes.YIELD_PRODUCTION)
            local faithFromGold = math.floor(cityGold * TITHE_CONVERSION_RATE)
            local faithFromProd = math.floor(cityProduction * TITHE_CONVERSION_RATE)
            local totalFaith = faithFromGold + faithFromProd

            -- Apply Faith bonus
            city:SetNumRealBuilding(BUILDING_TITHE_FAITH_BONUS, totalFaith)
            city:SetNumRealBuilding(BUILDING_TITHE_ACTIVE, 1)

            -- Siphon Gold (reduce treasury)
            player:ChangeGold(-faithFromGold)
            player:ChangeFaith(totalFaith)

            tTitheCities[iPlayer][cityID] = true

            -- Mark city as having Zimchongpa connection if applicable
            if hasZimchongpa then
                city:SetNumRealBuilding(BUILDING_ZIMCHONGPA_CONNECTION, 1)
            end
        else
            -- Clear Tithe buildings
            city:SetNumRealBuilding(BUILDING_TITHE_FAITH_BONUS, 0)
            city:SetNumRealBuilding(BUILDING_TITHE_ACTIVE, 0)
            city:SetNumRealBuilding(BUILDING_ZIMCHONGPA_CONNECTION, 0)

            tTitheCities[iPlayer][cityID] = false
        end
    end
end

GameEvents.PlayerDoTurn.Add(OnCityDoTurn_TitheProcess)

-- UA: Corvée unit spawning during Tithe
function OnCityTrained_Corvee(iPlayer, iCity, iUnit, bGold, bFaith)
    if not bFaith then
        return
    end -- Must be Faith purchase

    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end
    if not HasTrait(player, traitChakravartinSilkRoad) then
        return
    end

    local city = player:GetCityByID(iCity)
    if not city then
        return
    end

    -- Check if city is doing Tithe
    local isTithe = false
    if tTitheCities[iPlayer] and tTitheCities[iPlayer][iCity] then
        isTithe = true
    end

    if not isTithe then
        return
    end

    local unit = player:GetUnitByID(iUnit)
    if not unit or not unit:IsCombatUnit() or unit:IsGreatPerson() then
        return
    end

    local capital = player:GetCapitalCity()
    if not capital then
        return
    end

    -- Spawn Corvée copy in capital
    local unitType = unit:GetUnitType()
    local corveeUnit = player:InitUnit(unitType, capital:GetX(), capital:GetY())

    if corveeUnit then
        -- Apply Corvée promotion (combat penalty, no XP)
        corveeUnit:SetHasPromotion(PROMOTION_CORVEE, true)

        -- Track expiration
        tCorveUnits[iPlayer] = tCorveUnits[iPlayer] or {}
        local currentTurn = Game.GetGameTurn()
        tCorveUnits[iPlayer][corveeUnit:GetID()] = currentTurn + CORVEE_DURATION

        if player:IsHuman() and player:IsTurnActive() then
            Events.GameplayAlertMessage(string.format(
                "[COLOR_POSITIVE_TEXT]Corvée unit spawned![ENDCOLOR] Will expire in %d turns.", CORVEE_DURATION))
        end
    end
end

GameEvents.CityTrained.Add(OnCityTrained_Corvee)

-- Process Corvée unit expiration
function OnPlayerDoTurn_CorveeExpiry(iPlayer)
    local player = Players[iPlayer]
    if not player or not player:IsAlive() then
        return
    end

    if not tCorveUnits[iPlayer] then
        return
    end

    local currentTurn = Game.GetGameTurn()

    for unitID, expiryTurn in pairs(tCorveUnits[iPlayer]) do
        if currentTurn >= expiryTurn then
            local unit = player:GetUnitByID(unitID)
            if unit then
                unit:Kill() -- Remove expired Corvée unit

                if player:IsHuman() and player:IsTurnActive() then
                    Events.GameplayAlertMessage("A Corvée unit has expired and been disbanded.")
                end
            end
            tCorveUnits[iPlayer][unitID] = nil
        end
    end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_CorveeExpiry)

-- UU: Chölön Faith mission on City-States
function OnCholonMission(iPlayer, iUnit, iX, iY)
    local player = Players[iPlayer]
    if not player then
        return false
    end

    local unit = player:GetUnitByID(iUnit)
    if not unit or unit:GetUnitType() ~= unitCholonID then
        return false
    end

    local plot = Map.GetPlot(iX, iY)
    if not plot or not plot:IsCity() then
        return false
    end

    local city = plot:GetPlotCity()
    if not city then
        return false
    end

    local cityOwner = Players[city:GetOwner()]
    if not cityOwner or not cityOwner:IsMinorCiv() then
        return false
    end

    -- Count CS connections
    local csConnections = CountCSConnections(player)

    -- Base mission value (similar to Great Merchant)
    local baseFaith = 350 -- Base amount
    local bonusMultiplier = 1 + (csConnections * CHOLON_FAITH_BONUS_PER_CS)
    local totalFaith = math.floor(baseFaith * bonusMultiplier)

    -- Grant Faith instead of Gold
    player:ChangeFaith(totalFaith)

    -- Also grant influence
    cityOwner:ChangeMinorCivFriendshipWithMajor(iPlayer, 30)

    -- Kill the unit
    unit:Kill()

    if player:IsHuman() then
        Events.GameplayAlertMessage(string.format(
            "[COLOR_POSITIVE_TEXT]Chölön mission complete![ENDCOLOR] +%d Faith (%.0f%% bonus from %d CS connections)",
            totalFaith, (bonusMultiplier - 1) * 100, csConnections))
    end

    return true
end

-- UU: Chölön builds Holy Site
function OnUnitCanHaveMission_Cholon(iPlayer, iUnit, iMission, iData1, iData2, iData3, bTestVisible)
    if iMission == GameInfoTypes.MISSION_TRADE or iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
        local player = Players[iPlayer]
        if not player then
            return false
        end

        local unit = player:GetUnitByID(iUnit)
        if not unit or unit:GetUnitType() ~= unitCholonID then
            return false
        end

        if bTestVisible then
            return true
        end

        local plot = unit:GetPlot()
        if not plot then
            return false
        end

        if iMission == GameInfoTypes.MISSION_TRADE then
            -- Trade mission on CS
            return plot:IsCity() and Players[plot:GetPlotCity():GetOwner()]:IsMinorCiv()
        elseif iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
            -- Build Holy Site
            return not plot:IsCity() and not plot:IsWater() and plot:GetImprovementType() < 0
        end
    end
    return true
end

GameEvents.CustomMissionPossible.Add(OnUnitCanHaveMission_Cholon)

function OnUnitDoMission_Cholon(iPlayer, iUnit, iMission, iData1, iData2, iData3)
    local player = Players[iPlayer]
    if not player then
        return false
    end

    local unit = player:GetUnitByID(iUnit)
    if not unit or unit:GetUnitType() ~= unitCholonID then
        return false
    end

    if iMission == GameInfoTypes.MISSION_TRADE then
        -- Faith mission on CS
        return OnCholonMission(iPlayer, iUnit, unit:GetX(), unit:GetY())
    elseif iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
        -- Build Holy Site
        local plot = unit:GetPlot()
        if plot and not plot:IsCity() and not plot:IsWater() then
            plot:SetImprovementType(IMPROVEMENT_HOLY_SITE)
            unit:Kill()

            if player:IsHuman() then
                Events.GameplayAlertMessage("[COLOR_POSITIVE_TEXT]Holy Site constructed![ENDCOLOR]")
            end
            return true
        end
    end

    return false
end

GameEvents.CustomMissionCompleted.Add(OnUnitDoMission_Cholon)

-- UU: Zimchongpa garrison effects
function OnUnitSetXY_Zimchongpa(iPlayer, iUnit, iX, iY)
    local player = Players[iPlayer]
    if not player then
        return
    end

    local unit = player:GetUnitByID(iUnit)
    if not unit or unit:GetUnitType() ~= unitZimchongpaID then
        return
    end

    -- Initialize tracking
    tZimchongpaGarrison[iPlayer] = tZimchongpaGarrison[iPlayer] or {}

    -- Check if unit is garrisoned in a city
    local plot = Map.GetPlot(iX, iY)
    if plot and plot:IsCity() then
        local city = plot:GetPlotCity()
        if city and city:GetOwner() == iPlayer and unit:IsFortified() then
            -- Unit is garrisoned
            local cityID = city:GetID()

            -- Clear any previous garrison by this unit
            for cID, uID in pairs(tZimchongpaGarrison[iPlayer]) do
                if uID == iUnit then
                    tZimchongpaGarrison[iPlayer][cID] = nil
                    local oldCity = player:GetCityByID(cID)
                    if oldCity then
                        oldCity:SetNumRealBuilding(BUILDING_ZIMCHONGPA_GARRISON, 0)
                    end
                end
            end

            -- Set new garrison
            tZimchongpaGarrison[iPlayer][cityID] = iUnit
            city:SetNumRealBuilding(BUILDING_ZIMCHONGPA_GARRISON, 1)

            if player:IsHuman() and player:IsTurnActive() then
                Events.GameplayAlertMessage(string.format(
                    "Zimchongpa garrison: %s is now connected to capital and has Tithe benefits!", city:GetName()))
            end
        else
            -- Not garrisoned, remove from tracking
            for cityID, unitID in pairs(tZimchongpaGarrison[iPlayer]) do
                if unitID == iUnit then
                    tZimchongpaGarrison[iPlayer][cityID] = nil
                    local c = player:GetCityByID(cityID)
                    if c then
                        c:SetNumRealBuilding(BUILDING_ZIMCHONGPA_GARRISON, 0)
                    end
                    break
                end
            end
        end
    else
        -- Not in a city, remove from tracking
        for cityID, unitID in pairs(tZimchongpaGarrison[iPlayer]) do
            if unitID == iUnit then
                tZimchongpaGarrison[iPlayer][cityID] = nil
                local c = player:GetCityByID(cityID)
                if c then
                    c:SetNumRealBuilding(BUILDING_ZIMCHONGPA_GARRISON, 0)
                end
                break
            end
        end
    end
end

GameEvents.UnitSetXY.Add(OnUnitSetXY_Zimchongpa)

-- Initialize tables on game load
function OnLoadScreenClose()
    for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
        local player = Players[iPlayer]
        if player and player:IsAlive() and HasTrait(player, traitChakravartinSilkRoad) then
            tCorveUnits[iPlayer] = tCorveUnits[iPlayer] or {}
            tTitheCities[iPlayer] = tTitheCities[iPlayer] or {}
            tZimchongpaGarrison[iPlayer] = tZimchongpaGarrison[iPlayer] or {}
            tCityConnections[iPlayer] = tCityConnections[iPlayer] or {}
        end
    end
end

Events.LoadScreenClose.Add(OnLoadScreenClose)
