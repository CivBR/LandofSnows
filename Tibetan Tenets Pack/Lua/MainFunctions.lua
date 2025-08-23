-- Buddhist Religion Expansion - Main Functions
print("Buddhist Religion Expansion: Loading Main Functions")

-- Belief IDs
local beliefSacredPeaks = GameInfo.Beliefs["BELIEF_SACRED_PEAKS"]
local beliefUniversalCompassion = GameInfo.Beliefs["BELIEF_UNIVERSAL_COMPASSION"]
local beliefGompas = GameInfo.Beliefs["BELIEF_GOMPAS"]
local beliefMonasticDebate = GameInfo.Beliefs["BELIEF_MONASTIC_DEBATE"]
local beliefNonSectarianism = GameInfo.Beliefs["BELIEF_NON_SECTARIANISM"]

-- Building IDs
local buildingMountainCulture = GameInfoTypes["BUILDING_BUDDHIST_MOUNTAIN_CULTURE"]
local buildingGompaMountainFaith = GameInfoTypes["BUILDING_BUDDHIST_GOMPA_MOUNTAIN_FAITH"]
local buildingUniversalCompassion = GameInfoTypes["BUILDING_BUDDHIST_UNIVERSAL_COMPASSION"]
local buildingTradeRoutePressure = GameInfoTypes["BUILDING_BUDDHIST_TRADE_PRESSURE"]
local buildingNonSectarian = GameInfoTypes["BUILDING_BUDDHIST_NON_SECTARIAN"]
local buildingGompa = GameInfoTypes["BUILDING_GOMPA"]

-- Helper function to check if a city is adjacent to a mountain
function IsCityAdjacentToMountain(pCity)
	local pPlot = pCity:Plot()
	if not pPlot then return false end

	for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
		local pAdjacentPlot = Map.PlotDirection(pPlot:GetX(), pPlot:GetY(), direction)
		if pAdjacentPlot and pAdjacentPlot:IsMountain() then
			return true
		end
	end
	return false
end

-- Helper function to check if player has a specific belief
function PlayerHasBelief(pPlayer, beliefID)
	if not pPlayer:HasCreatedReligion() then return false end

	local religion = pPlayer:GetReligionCreatedByPlayer()
	for i, v in ipairs(Game.GetBeliefsInReligion(religion)) do
		if v == beliefID then
			return true
		end
	end
	return false
end

-- Sacred Peaks & Hidden Valleys: Mountain Culture Bonus
function ProcessSacredPeaks(iPlayer)
	local pPlayer = Players[iPlayer]
	if not pPlayer:IsAlive() then return end

	-- Check if player has Sacred Peaks pantheon
	local hasSacredPeaks = false
	for i, v in ipairs(Game.GetBeliefsInReligion(pPlayer:GetReligionCreatedByPlayer())) do
		if v == beliefSacredPeaks.ID then
			hasSacredPeaks = true
			break
		end
	end

	-- Also check if city follows a religion with Sacred Peaks
	for pCity in pPlayer:Cities() do
		local shouldHaveBonus = false

		if hasSacredPeaks and IsCityAdjacentToMountain(pCity) then
			shouldHaveBonus = true
		else
			-- Check if city follows a religion with Sacred Peaks
			local majorityReligion = pCity:GetReligiousMajority()
			if majorityReligion > 0 then
				for i, v in ipairs(Game.GetBeliefsInReligion(majorityReligion)) do
					if v == beliefSacredPeaks.ID then
						if IsCityAdjacentToMountain(pCity) then
							shouldHaveBonus = true
							break
						end
					end
				end
			end
		end

		-- Apply or remove the dummy building
		if shouldHaveBonus then
			if pCity:GetNumBuilding(buildingMountainCulture) == 0 then
				pCity:SetNumRealBuilding(buildingMountainCulture, 1)
			end
		else
			if pCity:GetNumBuilding(buildingMountainCulture) > 0 then
				pCity:SetNumRealBuilding(buildingMountainCulture, 0)
			end
		end
	end
end

-- Universal Compassion: Happiness from foreign cities following religion
function ProcessUniversalCompassion(iPlayer)
	local pPlayer = Players[iPlayer]
	if not pPlayer:IsAlive() or not pPlayer:HasCreatedReligion() then return end

	if not PlayerHasBelief(pPlayer, beliefUniversalCompassion.ID) then return end

	local religion = pPlayer:GetReligionCreatedByPlayer()
	local happinessCount = 0

	-- Count City-States following this religion
	for iCSPlayer = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS - 1 do
		local pCSPlayer = Players[iCSPlayer]
		if pCSPlayer and pCSPlayer:IsAlive() and pCSPlayer:IsMinorCiv() then
			for pCity in pCSPlayer:Cities() do
				if pCity:GetReligiousMajority() == religion then
					happinessCount = happinessCount + 2
					break -- Only count once per CS
				end
			end
		end
	end

	-- Count foreign capitals following this religion
	for iOtherPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
		if iOtherPlayer ~= iPlayer then
			local pOtherPlayer = Players[iOtherPlayer]
			if pOtherPlayer and pOtherPlayer:IsAlive() then
				local pCapital = pOtherPlayer:GetCapitalCity()
				if pCapital and pCapital:GetReligiousMajority() == religion then
					happinessCount = happinessCount + 2
				end
			end
		end
	end

	-- Apply happiness via dummy building in capital
	local pCapital = pPlayer:GetCapitalCity()
	if pCapital then
		-- Clear existing building first
		pCapital:SetNumRealBuilding(buildingUniversalCompassion, 0)
		-- Set happiness on the building type temporarily
		local buildingInfo = GameInfo.Buildings[buildingUniversalCompassion]
		if buildingInfo then
			-- Apply the calculated happiness
			if happinessCount > 0 then
				pCapital:SetNumRealBuilding(buildingUniversalCompassion, happinessCount)
			end
		end
	end
end

-- Gompa Mountain Faith Bonus
function ProcessGompaMountainBonus(iPlayer, iCity)
	local pPlayer = Players[iPlayer]
	local pCity = pPlayer:GetCityByID(iCity)

	if not pCity then return end

	-- Check if city has a Gompa and is adjacent to mountain
	if pCity:IsHasBuilding(buildingGompa) and IsCityAdjacentToMountain(pCity) then
		if pCity:GetNumBuilding(buildingGompaMountainFaith) == 0 then
			pCity:SetNumRealBuilding(buildingGompaMountainFaith, 1)
		end
	else
		if pCity:GetNumBuilding(buildingGompaMountainFaith) > 0 then
			pCity:SetNumRealBuilding(buildingGompaMountainFaith, 0)
		end
	end
end

-- Monastic Debate: Enhanced Trade Route Pressure
function ProcessMonasticDebate(iPlayer)
	local pPlayer = Players[iPlayer]
	if not pPlayer:IsAlive() or not pPlayer:HasCreatedReligion() then return end

	if not PlayerHasBelief(pPlayer, beliefMonasticDebate.ID) then return end

	-- Apply trade route pressure bonus to all cities
	for pCity in pPlayer:Cities() do
		if pCity:GetNumBuilding(buildingTradeRoutePressure) == 0 then
			pCity:SetNumRealBuilding(buildingTradeRoutePressure, 1)
		end
	end
end

-- Non-Sectarianism: Faith burst when other religions spread
local lastKnownReligions = {}

function ProcessNonSectarianism(iPlayer)
	local pPlayer = Players[iPlayer]
	if not pPlayer:IsAlive() or not pPlayer:HasCreatedReligion() then return end

	if not PlayerHasBelief(pPlayer, beliefNonSectarianism.ID) then return end

	local myReligion = pPlayer:GetReligionCreatedByPlayer()
	local faithBurst = 0

	-- Initialize tracking if needed
	if not lastKnownReligions[iPlayer] then
		lastKnownReligions[iPlayer] = {}
	end

	-- Check each city for religion changes
	for pCity in pPlayer:Cities() do
		local cityID = pCity:GetID()
		local currentMajority = pCity:GetReligiousMajority()

		-- Initialize city tracking
		if lastKnownReligions[iPlayer][cityID] == nil then
			lastKnownReligions[iPlayer][cityID] = currentMajority
		end

		-- Check if a different religion has spread
		if currentMajority > 0 and currentMajority ~= myReligion then
			if lastKnownReligions[iPlayer][cityID] ~= currentMajority then
				-- New foreign religion has taken hold
				faithBurst = faithBurst + 20 -- Base faith burst

				-- Scale with city size
				local population = pCity:GetPopulation()
				faithBurst = faithBurst + (population * 2)

				-- Update tracking
				lastKnownReligions[iPlayer][cityID] = currentMajority
			end
		end
	end

	-- Apply faith burst
	if faithBurst > 0 then
		pPlayer:ChangeFaith(faithBurst)

		-- Notification to player
		if pPlayer:IsHuman() then
			local message = "[COLOR_POSITIVE_TEXT]Non-Sectarianism:[ENDCOLOR] +" ..
				faithBurst .. " [ICON_PEACE] Faith from foreign religion spread!"
			pPlayer:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, message, "Faith Burst!", -1, -1)
		end
	end
end

-- Main turn processing
function BuddhistBeliefs_PlayerDoTurn(iPlayer)
	ProcessSacredPeaks(iPlayer)
	ProcessUniversalCompassion(iPlayer)
	ProcessMonasticDebate(iPlayer)
	ProcessNonSectarianism(iPlayer)

	-- Check all cities for Gompa mountain bonus
	local pPlayer = Players[iPlayer]
	if pPlayer and pPlayer:IsAlive() then
		for pCity in pPlayer:Cities() do
			ProcessGompaMountainBonus(iPlayer, pCity:GetID())
		end
	end
end

-- City capture handler
function BuddhistBeliefs_CityCaptured(iOldOwner, bCapital, iX, iY, iNewOwner, iPop, bConquest)
	local pPlot = Map.GetPlot(iX, iY)
	if not pPlot then return end

	local pCity = pPlot:GetPlotCity()
	if not pCity then return end

	-- Reprocess beliefs for new owner
	BuddhistBeliefs_PlayerDoTurn(iNewOwner)

	-- Clean up old owner's dummy buildings
	if iOldOwner ~= -1 then
		BuddhistBeliefs_PlayerDoTurn(iOldOwner)
	end
end

-- Building constructed handler
function BuddhistBeliefs_BuildingConstructed(iPlayer, iCity, iBuilding)
	if iBuilding == buildingGompa then
		ProcessGompaMountainBonus(iPlayer, iCity)
	end
end

-- Religion founded handler
function BuddhistBeliefs_ReligionFounded(iPlayer, iHolyCity, eReligion, eBelief1, eBelief2, eBelief3, eBelief4, eBelief5)
	local pPlayer = Players[iPlayer]
	if not pPlayer or not pPlayer:IsAlive() then return end

	-- Check for our beliefs and apply initial effects
	local beliefs = { eBelief1, eBelief2, eBelief3, eBelief4, eBelief5 }

	for _, belief in ipairs(beliefs) do
		if belief == beliefSacredPeaks.ID then
			ProcessSacredPeaks(iPlayer)
		elseif belief == beliefUniversalCompassion.ID then
			ProcessUniversalCompassion(iPlayer)
		elseif belief == beliefMonasticDebate.ID then
			ProcessMonasticDebate(iPlayer)
		elseif belief == beliefNonSectarianism.ID then
			-- Initialize tracking
			if not lastKnownReligions[iPlayer] then
				lastKnownReligions[iPlayer] = {}
			end
		end
	end
end

-- Religion enhanced handler
function BuddhistBeliefs_ReligionEnhanced(iPlayer, eReligion, eBelief1, eBelief2)
	BuddhistBeliefs_ReligionFounded(iPlayer, -1, eReligion, eBelief1, eBelief2, -1, -1, -1)
end

-- Hook up events
GameEvents.PlayerDoTurn.Add(BuddhistBeliefs_PlayerDoTurn)
GameEvents.CityCaptureComplete.Add(BuddhistBeliefs_CityCaptured)
GameEvents.CityConstructed.Add(BuddhistBeliefs_BuildingConstructed)
GameEvents.ReligionFounded.Add(BuddhistBeliefs_ReligionFounded)
GameEvents.ReligionEnhanced.Add(BuddhistBeliefs_ReligionEnhanced)

print("Buddhist Religion Expansion: Main Functions Loaded Successfully")
