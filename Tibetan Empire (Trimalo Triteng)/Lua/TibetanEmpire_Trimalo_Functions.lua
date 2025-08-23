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
local iTibetanTrimalo = GameInfoTypes.CIVILIZATION_TIBETAN_EMPIRE_TRIMALO
local traitSovereignLady = GameInfoTypes.TRAIT_SOVEREIGN_LADY

-- Building identifiers for Mandate system
local BUILDING_MANDATE_1 = GameInfoTypes.BUILDING_MANDATE_1
local BUILDING_MANDATE_2 = GameInfoTypes.BUILDING_MANDATE_2
local BUILDING_MANDATE_3 = GameInfoTypes.BUILDING_MANDATE_3
local BUILDING_MANDATE_PRODUCTION = GameInfoTypes.BUILDING_MANDATE_PRODUCTION
local BUILDING_MANDATE_FAITH = GameInfoTypes.BUILDING_MANDATE_FAITH
local BUILDING_LONCHEN_PRODUCTION = GameInfoTypes.BUILDING_LONCHEN_PRODUCTION
local BUILDING_LONCHEN_FOREIGN = GameInfoTypes.BUILDING_LONCHEN_FOREIGN
local BUILDING_ZEAL_MOVEMENT = GameInfoTypes.BUILDING_ZEAL_MOVEMENT
local BUILDING_TSUKLAKHANG = GameInfoTypes.BUILDING_TSUKLAKHANG

-- Unit identifiers
local unitLonchenID = GameInfoTypes.UNIT_LONCHEN

-- Promotion identifiers
local PROMOTION_ZEAL = GameInfoTypes.PROMOTION_ZEAL
local PROMOTION_ZEAL_1 = GameInfoTypes.PROMOTION_ZEAL_1
local PROMOTION_ZEAL_2 = GameInfoTypes.PROMOTION_ZEAL_2
local PROMOTION_ZEAL_3 = GameInfoTypes.PROMOTION_ZEAL_3
local PROMOTION_ZEAL_MOVEMENT = GameInfoTypes.PROMOTION_ZEAL_MOVEMENT

-- Constants
local MAX_MANDATES = 3
local MANDATE_PRODUCTION_BONUS = 10         -- % per Mandate
local MANDATE_FAITH_BONUS = 10              -- flat Faith per Mandate
local MANDATE_INFLUENCE_BONUS = 25          -- Influence to all City-States when expended
local LONCHEN_PRODUCTION_PER_RELIGIOUS = 10 -- % per religious building
local LONCHEN_FOREIGN_STEAL_PERCENT = 0.05  -- 5% of foreign Faith and Science
local ZEAL_MOVEMENT_DURATION = 5            -- turns

-- Tables to track Mandates and Lönchen
local tMandateCount = {}      -- [playerID] = count
local tLonchenCities = {}     -- [playerID][cityID] = unitID
local tLonchenForeign = {}    -- [playerID][unitID] = {ownerID, x, y}
local tZealMovementUnits = {} -- [playerID][unitID] = expiryTurn

-- Helper function to count religious buildings in a city
function CountReligiousBuildingsInCity(city)
	local count = 0
	local religiousBuildings = { GameInfoTypes.BUILDING_SHRINE, GameInfoTypes.BUILDING_TEMPLE,
		GameInfoTypes.BUILDING_TSUKLAKHANG, GameInfoTypes.BUILDING_MONASTERY,
		GameInfoTypes.BUILDING_CATHEDRAL, GameInfoTypes.BUILDING_MOSQUE,
		GameInfoTypes.BUILDING_PAGODA, GameInfoTypes.BUILDING_GURDWARA,
		GameInfoTypes.BUILDING_SYNAGOGUE, GameInfoTypes.BUILDING_MANDIR,
		GameInfoTypes.BUILDING_STUPA, GameInfoTypes.BUILDING_CHURCH }

	for _, buildingID in ipairs(religiousBuildings) do
		if buildingID and city:IsHasBuilding(buildingID) then
			count = count + 1
		end
	end

	return count
end

-- UA: Gain Mandate on capturing Capital or City-State
function OnCityCaptureComplete_Mandate(iOldOwner, bIsCapital, iX, iY, iNewOwner, iPop, bConquest)
	local newOwner = Players[iNewOwner]
	if not newOwner or not newOwner:IsAlive() then
		return
	end
	if not HasTrait(newOwner, traitSovereignLady) then
		return
	end

	local oldOwner = Players[iOldOwner]
	if not oldOwner then
		return
	end

	-- Check if it's a capital or city-state
	local gainMandate = false
	if bIsCapital then
		gainMandate = true
	elseif oldOwner:IsMinorCiv() then
		gainMandate = true
	end

	if not gainMandate then
		return
	end

	-- Initialize mandate count
	tMandateCount[iNewOwner] = tMandateCount[iNewOwner] or 0

	-- Check if at max mandates
	if tMandateCount[iNewOwner] >= MAX_MANDATES then
		if newOwner:IsHuman() and newOwner:IsTurnActive() then
			Events.GameplayAlertMessage("Maximum Mandates reached! Cannot gain more.")
		end
		return
	end

	-- Gain a mandate
	tMandateCount[iNewOwner] = tMandateCount[iNewOwner] + 1
	UpdateMandateBonuses(iNewOwner)

	if newOwner:IsHuman() and newOwner:IsTurnActive() then
		local cityName = Map.GetPlot(iX, iY):GetPlotCity():GetName()
		Events.GameplayAlertMessage(string.format(
			"[COLOR_POSITIVE_TEXT]Mandate gained![ENDCOLOR] Captured %s. Total Mandates: %d/%d", cityName,
			tMandateCount[iNewOwner], MAX_MANDATES))
	end
end

GameEvents.CityCaptureComplete.Add(OnCityCaptureComplete_Mandate)

-- Update Mandate bonuses (production and faith)
function UpdateMandateBonuses(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end

	local capital = player:GetCapitalCity()
	if not capital then
		return
	end

	local mandates = tMandateCount[iPlayer] or 0

	-- Clear old mandate buildings
	capital:SetNumRealBuilding(BUILDING_MANDATE_1, 0)
	capital:SetNumRealBuilding(BUILDING_MANDATE_2, 0)
	capital:SetNumRealBuilding(BUILDING_MANDATE_3, 0)
	capital:SetNumRealBuilding(BUILDING_MANDATE_PRODUCTION, 0)
	capital:SetNumRealBuilding(BUILDING_MANDATE_FAITH, 0)

	-- Add appropriate mandate buildings
	if mandates >= 1 then
		capital:SetNumRealBuilding(BUILDING_MANDATE_1, 1)
		capital:SetNumRealBuilding(BUILDING_MANDATE_PRODUCTION, mandates)
		capital:SetNumRealBuilding(BUILDING_MANDATE_FAITH, mandates)
	end
	if mandates >= 2 then
		capital:SetNumRealBuilding(BUILDING_MANDATE_2, 1)
	end
	if mandates >= 3 then
		capital:SetNumRealBuilding(BUILDING_MANDATE_3, 1)
	end
end

-- Expend Mandate for influence and production
function ExpendMandate(iPlayer)
	local player = Players[iPlayer]
	if not player then
		return false
	end

	tMandateCount[iPlayer] = tMandateCount[iPlayer] or 0

	if tMandateCount[iPlayer] <= 0 then
		if player:IsHuman() then
			Events.GameplayAlertMessage("No Mandates available to expend!")
		end
		return false
	end

	-- Reduce mandate count
	tMandateCount[iPlayer] = tMandateCount[iPlayer] - 1
	UpdateMandateBonuses(iPlayer)

	-- Grant influence to all met city-states
	local influenceGranted = 0
	for csID = 0, GameDefines.MAX_MINOR_CIVS - 1 do
		local cs = Players[csID]
		if cs and cs:IsAlive() and cs:IsMinorCiv() then
			if Teams[player:GetTeam()]:IsHasMet(cs:GetTeam()) then
				cs:ChangeMinorCivFriendshipWithMajor(iPlayer, MANDATE_INFLUENCE_BONUS)
				influenceGranted = influenceGranted + 1
			end
		end
	end

	-- Hurry production in capital
	local capital = player:GetCapitalCity()
	if capital then
		local currentProduction = capital:GetProduction()
		local productionNeeded = capital:GetProductionNeeded()
		local bonus = math.floor(productionNeeded * 0.25)
		capital:ChangeProduction(bonus)
	end

	if player:IsHuman() then
		Events.GameplayAlertMessage(string.format(
			"[COLOR_POSITIVE_TEXT]Mandate Expended![ENDCOLOR] +%d Influence with %d City-States, 25%% Production in Capital. Mandates remaining: %d",
			MANDATE_INFLUENCE_BONUS, influenceGranted, tMandateCount[iPlayer]))
	end

	return true
end

-- UGP: Lönchen stationed in cities
function OnUnitSetXY_Lonchen(iPlayer, iUnit, iX, iY)
	local player = Players[iPlayer]
	if not player then
		return
	end

	local unit = player:GetUnitByID(iUnit)
	if not unit or unit:GetUnitType() ~= unitLonchenID then
		return
	end

	-- Initialize tracking tables
	tLonchenCities[iPlayer] = tLonchenCities[iPlayer] or {}
	tLonchenForeign[iPlayer] = tLonchenForeign[iPlayer] or {}

	-- Check if unit is in a city
	local plot = Map.GetPlot(iX, iY)
	if plot and plot:IsCity() then
		local city = plot:GetPlotCity()
		local cityOwner = city:GetOwner()

		if cityOwner == iPlayer then
			-- Lönchen in own city
			local cityID = city:GetID()

			-- Remove from foreign tracking
			tLonchenForeign[iPlayer][iUnit] = nil

			-- Add to city tracking
			tLonchenCities[iPlayer][cityID] = iUnit

			-- Apply production bonus based on religious buildings
			UpdateLonchenCityBonus(player, city)
		else
			-- Lönchen in foreign territory
			tLonchenForeign[iPlayer][iUnit] = {
				ownerID = cityOwner,
				x = iX,
				y = iY
			}

			-- Remove from city tracking
			for cID, uID in pairs(tLonchenCities[iPlayer]) do
				if uID == iUnit then
					tLonchenCities[iPlayer][cID] = nil
					local c = player:GetCityByID(cID)
					if c then
						UpdateLonchenCityBonus(player, c)
					end
					break
				end
			end
		end
	else
		-- Not in a city, remove from tracking
		tLonchenForeign[iPlayer][iUnit] = nil

		for cityID, unitID in pairs(tLonchenCities[iPlayer]) do
			if unitID == iUnit then
				tLonchenCities[iPlayer][cityID] = nil
				local c = player:GetCityByID(cityID)
				if c then
					UpdateLonchenCityBonus(player, c)
				end
				break
			end
		end
	end
end

GameEvents.UnitSetXY.Add(OnUnitSetXY_Lonchen)

-- Update Lönchen city production bonus
function UpdateLonchenCityBonus(player, city)
	if not city then
		return
	end

	local iPlayer = player:GetID()
	local cityID = city:GetID()

	-- Check if Lönchen is stationed
	local hasLonchen = false
	if tLonchenCities[iPlayer] and tLonchenCities[iPlayer][cityID] then
		hasLonchen = true
	end

	if hasLonchen then
		local religiousCount = CountReligiousBuildingsInCity(city)
		local bonus = religiousCount * LONCHEN_PRODUCTION_PER_RELIGIOUS / 10 -- Convert percentage to building count
		city:SetNumRealBuilding(BUILDING_LONCHEN_PRODUCTION, bonus)
	else
		city:SetNumRealBuilding(BUILDING_LONCHEN_PRODUCTION, 0)
	end
end

-- Process Lönchen foreign territory stealing
function OnPlayerDoTurn_LonchenForeign(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end
	if not HasTrait(player, traitSovereignLady) then
		return
	end

	if not tLonchenForeign[iPlayer] then
		return
	end

	local capital = player:GetCapitalCity()
	if not capital then
		return
	end

	local totalFaithStolen = 0
	local totalScienceStolen = 0

	for unitID, data in pairs(tLonchenForeign[iPlayer]) do
		local unit = player:GetUnitByID(unitID)
		if unit and unit:GetUnitType() == unitLonchenID then
			local foreignPlayer = Players[data.ownerID]
			if foreignPlayer and foreignPlayer:IsAlive() then
				-- Steal faith and science
				local foreignFaith = foreignPlayer:GetFaith()
				local foreignScience = foreignPlayer:GetScience()

				local faithSteal = math.floor(foreignFaith * LONCHEN_FOREIGN_STEAL_PERCENT)
				local scienceSteal = math.floor(foreignScience * LONCHEN_FOREIGN_STEAL_PERCENT)

				totalFaithStolen = totalFaithStolen + faithSteal
				totalScienceStolen = totalScienceStolen + scienceSteal
			end
		else
			-- Unit no longer exists or valid
			tLonchenForeign[iPlayer][unitID] = nil
		end
	end

	if totalFaithStolen > 0 or totalScienceStolen > 0 then
		capital:SetNumRealBuilding(BUILDING_LONCHEN_FOREIGN, totalFaithStolen + totalScienceStolen)

		if player:IsHuman() and player:IsTurnActive() then
			Events.GameplayAlertMessage(string.format("Lönchen stealing: +%d Faith, +%d Science", totalFaithStolen,
				totalScienceStolen))
		end
	else
		capital:SetNumRealBuilding(BUILDING_LONCHEN_FOREIGN, 0)
	end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_LonchenForeign)

-- UGP: Lönchen purge to gain Mandate
function OnUnitKilled_LonchenPurge(iPlayer, iUnit, iUnitType, iX, iY, bDelay, iKiller)
	-- Check if it's a Lönchen being killed by its owner (purge)
	if iUnitType ~= unitLonchenID then
		return
	end
	if iPlayer ~= iKiller then
		return
	end -- Must be killed by own player

	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end
	if not HasTrait(player, traitSovereignLady) then
		return
	end

	tMandateCount[iPlayer] = tMandateCount[iPlayer] or 0

	-- Only works if no mandates
	if tMandateCount[iPlayer] > 0 then
		if player:IsHuman() then
			Events.GameplayAlertMessage("Can only purge Lönchen when you have no Mandates!")
		end
		return
	end

	-- Gain a mandate
	tMandateCount[iPlayer] = 1
	UpdateMandateBonuses(iPlayer)

	if player:IsHuman() then
		Events.GameplayAlertMessage("[COLOR_POSITIVE_TEXT]Lönchen Purged![ENDCOLOR] Gained 1 Mandate.")
	end
end

GameEvents.UnitPrekill.Add(OnUnitKilled_LonchenPurge)

-- UB: Tsuklakhang Zeal promotions
function OnCityTrained_Tsuklakhang(iPlayer, iCity, iUnit, bGold, bFaith)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end
	if not HasTrait(player, traitSovereignLady) then
		return
	end

	local city = player:GetCityByID(iCity)
	if not city or not city:IsHasBuilding(BUILDING_TSUKLAKHANG) then
		return
	end

	local unit = player:GetUnitByID(iUnit)
	if not unit then
		return
	end

	-- Only military units get Zeal
	if unit:IsCombatUnit() and not unit:IsGreatPerson() then
		local mandates = tMandateCount[iPlayer] or 0

		-- Apply appropriate Zeal promotion based on mandate count
		if mandates == 1 then
			unit:SetHasPromotion(PROMOTION_ZEAL_1, true)
		elseif mandates == 2 then
			unit:SetHasPromotion(PROMOTION_ZEAL_2, true)
		elseif mandates >= 3 then
			unit:SetHasPromotion(PROMOTION_ZEAL_3, true)
		else
			unit:SetHasPromotion(PROMOTION_ZEAL, true) -- Base zeal with no mandates
		end

		-- Check if Lönchen is stationed in the city
		if tLonchenCities[iPlayer] and tLonchenCities[iPlayer][iCity] then
			-- Add movement bonus
			unit:SetHasPromotion(PROMOTION_ZEAL_MOVEMENT, true)

			-- Track for expiration
			tZealMovementUnits[iPlayer] = tZealMovementUnits[iPlayer] or {}
			local currentTurn = Game.GetGameTurn()
			tZealMovementUnits[iPlayer][iUnit] = currentTurn + ZEAL_MOVEMENT_DURATION

			if player:IsHuman() and player:IsTurnActive() then
				Events.GameplayAlertMessage(string.format("Unit trained with Zeal and +1 Movement for %d turns!",
					ZEAL_MOVEMENT_DURATION))
			end
		end
	end
end

GameEvents.CityTrained.Add(OnCityTrained_Tsuklakhang)

-- Process Zeal movement expiration
function OnPlayerDoTurn_ZealMovementExpiry(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end

	if not tZealMovementUnits[iPlayer] then
		return
	end

	local currentTurn = Game.GetGameTurn()

	for unitID, expiryTurn in pairs(tZealMovementUnits[iPlayer]) do
		if currentTurn >= expiryTurn then
			local unit = player:GetUnitByID(unitID)
			if unit then
				unit:SetHasPromotion(PROMOTION_ZEAL_MOVEMENT, false)
			end
			tZealMovementUnits[iPlayer][unitID] = nil
		end
	end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_ZealMovementExpiry)

-- Custom mission for expending Mandate
function OnCustomMissionPossible_ExpendMandate(iPlayer, iUnit, iMission, iData1, iData2, iData3, bTestVisible)
	if iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
		local player = Players[iPlayer]
		if not player then
			return false
		end
		if not HasTrait(player, traitSovereignLady) then
			return false
		end

		if bTestVisible then
			return true
		end

		tMandateCount[iPlayer] = tMandateCount[iPlayer] or 0
		return tMandateCount[iPlayer] > 0
	end
	return true
end

GameEvents.CustomMissionPossible.Add(OnCustomMissionPossible_ExpendMandate)

function OnCustomMissionStart_ExpendMandate(iPlayer, iUnit, iMission, iData1, iData2, iData3)
	if iMission == GameInfoTypes.MISSION_CULTURE_BOMB then
		local player = Players[iPlayer]
		if not player then
			return false
		end
		if not HasTrait(player, traitSovereignLady) then
			return false
		end

		return ExpendMandate(iPlayer)
	end
	return false
end

GameEvents.CustomMissionStart.Add(OnCustomMissionStart_ExpendMandate)

-- Initialize tables on game load
function OnLoadScreenClose()
	-- Ensure tables are initialized for all players
	for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
		local player = Players[iPlayer]
		if player and player:IsAlive() and HasTrait(player, traitSovereignLady) then
			tMandateCount[iPlayer] = tMandateCount[iPlayer] or 0
			tLonchenCities[iPlayer] = tLonchenCities[iPlayer] or {}
			tLonchenForeign[iPlayer] = tLonchenForeign[iPlayer] or {}
			tZealMovementUnits[iPlayer] = tZealMovementUnits[iPlayer] or {}

			-- Update mandate bonuses on load
			UpdateMandateBonuses(iPlayer)
		end
	end
end

Events.LoadScreenClose.Add(OnLoadScreenClose)
