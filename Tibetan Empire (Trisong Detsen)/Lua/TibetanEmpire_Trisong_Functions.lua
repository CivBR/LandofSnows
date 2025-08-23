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
local iTibetanTrisong = GameInfoTypes.CIVILIZATION_TIBETAN_EMPIRE_TRISONG_DETSEN
local traitPerfectFulfillment = GameInfoTypes.TRAIT_PERFECT_FULFILLMENT

-- Building identifiers
local BUILDING_COURTHOUSE = GameInfoTypes.BUILDING_COURTHOUSE
local BUILDING_COURTHOUSE_PRESSURE = GameInfoTypes.BUILDING_COURTHOUSE_PRESSURE
local BUILDING_COURTHOUSE_PRESSURE_GA = GameInfoTypes.BUILDING_COURTHOUSE_PRESSURE_GA
local BUILDING_TRANSLATION_PROJECT = GameInfoTypes.BUILDING_TRANSLATION_PROJECT
local BUILDING_TRANSLATION_PROJECT_GA = GameInfoTypes.BUILDING_TRANSLATION_PROJECT_GA
local BUILDING_GREAT_DEBATE = GameInfoTypes.BUILDING_GREAT_DEBATE
local BUILDING_GREAT_DEBATE_GA = GameInfoTypes.BUILDING_GREAT_DEBATE_GA
local BUILDING_HOLY_SITE_BONUS = GameInfoTypes.BUILDING_HOLY_SITE_BONUS

-- Unit identifiers
local unitChakgoTamakID = GameInfoTypes.UNIT_CHAKGO_TAMAK
local unitJetsunID = GameInfoTypes.UNIT_JETSUN
local unitGreatGeneralID = GameInfoTypes.UNIT_GREAT_GENERAL
local unitInquisitorID = GameInfoTypes.UNIT_INQUISITOR

-- Improvement identifiers
local IMPROVEMENT_HOLY_SITE = GameInfoTypes.IMPROVEMENT_HOLY_SITE
local IMPROVEMENT_CITADEL = GameInfoTypes.IMPROVEMENT_CITADEL

local PROMOTION_CHAKGO_TERRAIN = GameInfoTypes.PROMOTION_CHAKGO_TERRAIN
local PROMOTION_HOLY_SITE_STRENGTH = GameInfoTypes.PROMOTION_HOLY_SITE_STRENGTH

-- Constants
local TRANSLATION_PROJECT_DURATION = 10 -- turns
local GREAT_DEBATE_DURATION = 10        -- turns
local GA_POINTS_PER_FOLLOWER = 2
local HOLY_SITE_CS_BONUS = 2            -- % per Holy Site during Great Debate

-- Tables to track active effects
local tTranslationProjects = {} -- [playerID][cityID] = expiryTurn
local tGreatDebates = {}        -- [playerID] = expiryTurn
local tHolySiteCount = {}       -- [playerID] = count

-- Helper function to count religious buildings in a city
function CountReligiousBuildingsInCity(city)
	local count = 0
	local religiousBuildings = { GameInfoTypes.BUILDING_SHRINE, GameInfoTypes.BUILDING_TEMPLE,
		GameInfoTypes.BUILDING_MONASTERY, GameInfoTypes.BUILDING_CATHEDRAL,
		GameInfoTypes.BUILDING_MOSQUE, GameInfoTypes.BUILDING_PAGODA,
		GameInfoTypes.BUILDING_GURDWARA, GameInfoTypes.BUILDING_SYNAGOGUE,
		GameInfoTypes.BUILDING_MANDIR, GameInfoTypes.BUILDING_STUPA,
		GameInfoTypes.BUILDING_CHURCH }

	for _, buildingID in ipairs(religiousBuildings) do
		if buildingID and city:IsHasBuilding(buildingID) then
			count = count + 1
		end
	end

	return count
end

-- Helper function to check if unit is on hill
function IsUnitOnHill(unit)
	local plot = unit:GetPlot()
	return plot and plot:IsHills()
end

-- Helper function to check if unit is adjacent to mountain
function IsUnitAdjacentToMountain(unit)
	local plot = unit:GetPlot()
	if not plot then
		return false
	end

	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
		local adjacentPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), direction)
		if adjacentPlot and adjacentPlot:IsMountain() then
			return true
		end
	end
	return false
end

-- UA: Courthouse religious pressure boost
function OnPlayerDoTurn_CourthousePressure(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end
	if not HasTrait(player, traitPerfectFulfillment) then
		return
	end

	local isGoldenAge = player:IsGoldenAge()

	for city in player:Cities() do
		if city:IsHasBuilding(BUILDING_COURTHOUSE) then
			-- Apply pressure bonus
			if isGoldenAge then
				city:SetNumRealBuilding(BUILDING_COURTHOUSE_PRESSURE_GA, 1)
				city:SetNumRealBuilding(BUILDING_COURTHOUSE_PRESSURE, 0)
			else
				city:SetNumRealBuilding(BUILDING_COURTHOUSE_PRESSURE, 1)
				city:SetNumRealBuilding(BUILDING_COURTHOUSE_PRESSURE_GA, 0)
			end
		else
			city:SetNumRealBuilding(BUILDING_COURTHOUSE_PRESSURE, 0)
			city:SetNumRealBuilding(BUILDING_COURTHOUSE_PRESSURE_GA, 0)
		end
	end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_CourthousePressure)

-- UA: Great General builds Holy Sites
function OnUnitCanHaveMission_HolySite(iPlayer, iUnit, iMission, iData1, iData2, iData3, bTestVisible)
	if iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
		local player = Players[iPlayer]
		if not player then
			return false
		end
		if not HasTrait(player, traitPerfectFulfillment) then
			return false
		end

		local unit = player:GetUnitByID(iUnit)
		if not unit or unit:GetUnitType() ~= unitGreatGeneralID then
			return false
		end

		if bTestVisible then
			return true
		end

		-- Check if can build improvement here
		local plot = unit:GetPlot()
		if not plot then
			return false
		end

		-- Cannot build on city, water, or existing improvement
		if plot:IsCity() or plot:IsWater() or plot:GetImprovementType() >= 0 then
			return false
		end

		return true
	end
	return true
end

GameEvents.CustomMissionPossible.Add(OnUnitCanHaveMission_HolySite)

function OnUnitDoMission_HolySite(iPlayer, iUnit, iMission, iData1, iData2, iData3)
	if iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
		local player = Players[iPlayer]
		if not player then
			return false
		end
		if not HasTrait(player, traitPerfectFulfillment) then
			return false
		end

		local unit = player:GetUnitByID(iUnit)
		if not unit or unit:GetUnitType() ~= unitGreatGeneralID then
			return false
		end

		local plot = unit:GetPlot()
		if not plot then
			return false
		end

		-- Build Holy Site improvement
		plot:SetImprovementType(IMPROVEMENT_HOLY_SITE)
		plot:SetOwner(iPlayer, -1)

		-- Culture bomb adjacent tiles
		for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
			local adjacentPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), direction)
			if adjacentPlot and not adjacentPlot:IsCity() and not adjacentPlot:IsWater() then
				adjacentPlot:SetOwner(iPlayer, -1)
			end
		end

		-- Track Holy Site count
		tHolySiteCount[iPlayer] = (tHolySiteCount[iPlayer] or 0) + 1

		-- Kill the Great General
		unit:Kill()

		if player:IsHuman() and player:IsTurnActive() then
			Events.GameplayAlertMessage("[COLOR_POSITIVE_TEXT]Holy Site constructed![ENDCOLOR] Functions as a Citadel.")
		end

		return true
	end
	return false
end

GameEvents.CustomMissionCompleted.Add(OnUnitDoMission_HolySite)

-- UU: Chakgo Tamak hill/mountain combat bonuses
function OnCombatCalculation_ChakgoTamak(iAttacker, iDefender, iAttackingPlayer, iDefendingPlayer)
	local attacker = Players[iAttackingPlayer]:GetUnitByID(iAttacker)
	if attacker and attacker:GetUnitType() == unitChakgoTamakID then
		local onHill = IsUnitOnHill(attacker)
		local adjacentMountain = IsUnitAdjacentToMountain(attacker)
		if onHill or adjacentMountain then
			attacker:SetHasPromotion(PROMOTION_CHAKGO_TERRAIN, true)
		else
			attacker:SetHasPromotion(PROMOTION_CHAKGO_TERRAIN, false)
		end
	end
end

GameEvents.CombatCalculation.Add(OnCombatCalculation_ChakgoTamak)

-- UU: Chakgo Tamak courthouse construction and GA points on capture
function OnCityCaptureComplete_ChakgoTamak(iOldOwner, bIsCapital, iX, iY, iNewOwner, iPop, bConquest)
	local newOwner = Players[iNewOwner]
	if not newOwner or not newOwner:IsAlive() then
		return
	end
	if not HasTrait(newOwner, traitPerfectFulfillment) then
		return
	end

	local city = Map.GetPlot(iX, iY):GetPlotCity()
	if not city then
		return
	end

	-- Check if any Chakgo Tamak participated in the capture
	local chakgoParticipated = false
	for unit in newOwner:Units() do
		if unit:GetUnitType() == unitChakgoTamakID then
			local unitPlot = unit:GetPlot()
			if unitPlot and Map.PlotDistance(unitPlot:GetX(), unitPlot:GetY(), iX, iY) <= 2 then
				chakgoParticipated = true
				break
			end
		end
	end

	if not chakgoParticipated then
		return
	end

	-- Build courthouse
	city:SetNumRealBuilding(BUILDING_COURTHOUSE, 1)

	-- Calculate GA points based on followers
	local playerReligion = newOwner:GetReligionCreatedByPlayer()
	if playerReligion > 0 then
		local followers = city:GetNumFollowers(playerReligion)
		local gaPoints = followers * GA_POINTS_PER_FOLLOWER

		if gaPoints > 0 then
			newOwner:ChangeGoldenAgeProgressMeter(gaPoints)

			if newOwner:IsHuman() and newOwner:IsTurnActive() then
				Events.GameplayAlertMessage(string.format(
					"[COLOR_POSITIVE_TEXT]Chakgo Tamak conquest![ENDCOLOR] Courthouse built, +%d Golden Age points from %d followers.",
					gaPoints, followers))
			end
		end
	end
end

GameEvents.CityCaptureComplete.Add(OnCityCaptureComplete_ChakgoTamak)

-- UU: Jetsun Translation Project
function OnJetsunTranslationProject(iPlayer, iCity)
	local player = Players[iPlayer]
	if not player then
		return false
	end

	local city = player:GetCityByID(iCity)
	if not city then
		return false
	end

	-- Initialize tracking
	tTranslationProjects[iPlayer] = tTranslationProjects[iPlayer] or {}

	local currentTurn = Game.GetGameTurn()
	local isGoldenAge = player:IsGoldenAge()

	-- Apply Translation Project
	tTranslationProjects[iPlayer][iCity] = currentTurn + TRANSLATION_PROJECT_DURATION

	-- Count religious buildings for this city
	local religiousCount = CountReligiousBuildingsInCity(city)

	-- Apply bonuses
	city:SetNumRealBuilding(BUILDING_TRANSLATION_PROJECT, religiousCount)
	if isGoldenAge then
		city:SetNumRealBuilding(BUILDING_TRANSLATION_PROJECT_GA, religiousCount)
	end

	if player:IsHuman() then
		Events.GameplayAlertMessage(string.format(
			"[COLOR_POSITIVE_TEXT]Translation Project![ENDCOLOR] +%d Science and +1 per Specialist for %d turns%s",
			religiousCount * 4, TRANSLATION_PROJECT_DURATION, isGoldenAge and " (Golden Age bonus active!)" or ""))
	end

	return true
end

-- UU: Jetsun Great Debate
function OnJetsunGreatDebate(iPlayer)
	local player = Players[iPlayer]
	if not player then
		return false
	end

	local currentTurn = Game.GetGameTurn()
	local isGoldenAge = player:IsGoldenAge()

	-- Apply Great Debate
	tGreatDebates[iPlayer] = currentTurn + GREAT_DEBATE_DURATION

	-- Spawn Inquisitors in cities with Courthouses
	local inquisitorCount = 0
	for city in player:Cities() do
		if city:IsHasBuilding(BUILDING_COURTHOUSE) then
			-- Apply pressure bonus
			city:SetNumRealBuilding(BUILDING_GREAT_DEBATE, 1)

			-- Spawn Inquisitor
			player:InitUnit(unitInquisitorID, city:GetX(), city:GetY())
			inquisitorCount = inquisitorCount + 1
		end
	end

	-- Apply Holy Site combat bonus if in Golden Age
	if isGoldenAge then
		local holySites = tHolySiteCount[iPlayer] or 0
		if holySites > 0 then
			-- Apply bonus to all units
			for unit in player:Units() do
				if unit:IsCombatUnit() and not unit:IsGreatPerson() then
					unit:SetHasPromotion(PROMOTION_HOLY_SITE_STRENGTH, true)
				end
			end

			-- Store bonus amount for display
			local capital = player:GetCapitalCity()
			if capital then
				capital:SetNumRealBuilding(BUILDING_GREAT_DEBATE_GA, holySites)
			end
		end
	end

	if player:IsHuman() then
		Events.GameplayAlertMessage(string.format(
			"[COLOR_POSITIVE_TEXT]Great Debate![ENDCOLOR] Spawned %d Inquisitors, +25%% pressure range for %d turns%s",
			inquisitorCount, GREAT_DEBATE_DURATION,
			isGoldenAge and string.format(" (+%d%% CS from Holy Sites!)", holySites * HOLY_SITE_CS_BONUS) or ""))
	end

	return true
end

-- Custom mission handling for Jetsun
function OnUnitCanHaveMission_Jetsun(iPlayer, iUnit, iMission, iData1, iData2, iData3, bTestVisible)
	if iMission == GameInfoTypes.MISSION_ONE_SHOT_TOURISM or iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
		local player = Players[iPlayer]
		if not player then
			return false
		end

		local unit = player:GetUnitByID(iUnit)
		if not unit or unit:GetUnitType() ~= unitJetsunID then
			return false
		end

		if bTestVisible then
			return true
		end

		-- Must be in a city for Translation Project
		if iMission == GameInfoTypes.MISSION_ONE_SHOT_TOURISM then
			local plot = unit:GetPlot()
			return plot and plot:IsCity() and plot:GetPlotCity():GetOwner() == iPlayer
		end

		return true
	end
	return true
end

GameEvents.CustomMissionPossible.Add(OnUnitCanHaveMission_Jetsun)

function OnUnitDoMission_Jetsun(iPlayer, iUnit, iMission, iData1, iData2, iData3)
	local player = Players[iPlayer]
	if not player then
		return false
	end

	local unit = player:GetUnitByID(iUnit)
	if not unit or unit:GetUnitType() ~= unitJetsunID then
		return false
	end

	local success = false

	if iMission == GameInfoTypes.MISSION_ONE_SHOT_TOURISM then
		-- Translation Project
		local plot = unit:GetPlot()
		if plot and plot:IsCity() then
			local city = plot:GetPlotCity()
			if city and city:GetOwner() == iPlayer then
				success = OnJetsunTranslationProject(iPlayer, city:GetID())
			end
		end
	elseif iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
		-- Great Debate
		success = OnJetsunGreatDebate(iPlayer)
	end

	if success then
		-- Kill the Jetsun
		unit:Kill()
	end

	return success
end

GameEvents.CustomMissionCompleted.Add(OnUnitDoMission_Jetsun)

-- Process Translation Project expiration
function OnPlayerDoTurn_TranslationProjectExpiry(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end
	if not HasTrait(player, traitPerfectFulfillment) then
		return
	end

	if not tTranslationProjects[iPlayer] then
		return
	end

	local currentTurn = Game.GetGameTurn()

	for cityID, expiryTurn in pairs(tTranslationProjects[iPlayer]) do
		if currentTurn >= expiryTurn then
			local city = player:GetCityByID(cityID)
			if city then
				-- Remove Translation Project buildings
				city:SetNumRealBuilding(BUILDING_TRANSLATION_PROJECT, 0)
				city:SetNumRealBuilding(BUILDING_TRANSLATION_PROJECT_GA, 0)
			end

			tTranslationProjects[iPlayer][cityID] = nil

			if player:IsHuman() and player:IsTurnActive() then
				Events.GameplayAlertMessage(string.format("Translation Project in %s has ended.",
					city and city:GetName() or "a city"))
			end
		end
	end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_TranslationProjectExpiry)

-- Process Great Debate expiration
function OnPlayerDoTurn_GreatDebateExpiry(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end
	if not HasTrait(player, traitPerfectFulfillment) then
		return
	end

	if not tGreatDebates[iPlayer] then
		return
	end

	local currentTurn = Game.GetGameTurn()

	if currentTurn >= tGreatDebates[iPlayer] then
		-- Remove Great Debate buildings
		for city in player:Cities() do
			city:SetNumRealBuilding(BUILDING_GREAT_DEBATE, 0)
			city:SetNumRealBuilding(BUILDING_GREAT_DEBATE_GA, 0)
		end

		-- Remove Holy Site combat bonus
		for unit in player:Units() do
			if unit:IsCombatUnit() then
				unit:SetHasPromotion(PROMOTION_HOLY_SITE_STRENGTH, false)
			end
		end

		tGreatDebates[iPlayer] = nil

		if player:IsHuman() and player:IsTurnActive() then
			Events.GameplayAlertMessage("Great Debate effects have ended.")
		end
	end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_GreatDebateExpiry)

-- Count Holy Sites for combat bonus
function OnPlayerDoTurn_CountHolySites(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end
	if not HasTrait(player, traitPerfectFulfillment) then
		return
	end

	local count = 0
	for i = 0, Map.GetNumPlots() - 1 do
		local plot = Map.GetPlotByIndex(i)
		if plot and plot:GetOwner() == iPlayer and plot:GetImprovementType() == IMPROVEMENT_HOLY_SITE then
			count = count + 1
		end
	end

	tHolySiteCount[iPlayer] = count
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_CountHolySites)

-- Initialize tables on game load
function OnLoadScreenClose()
	-- Ensure tables are initialized for all players
	for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
		local player = Players[iPlayer]
		if player and player:IsAlive() and HasTrait(player, traitPerfectFulfillment) then
			tTranslationProjects[iPlayer] = tTranslationProjects[iPlayer] or {}
			tGreatDebates[iPlayer] = tGreatDebates[iPlayer] or nil
			tHolySiteCount[iPlayer] = tHolySiteCount[iPlayer] or 0
		end
	end
end

Events.LoadScreenClose.Add(OnLoadScreenClose)
