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
local BUILDING_SACRED_PEAK = GameInfoTypes.BUILDING_SACRED_PEAK
local BUILDING_SACRED_PEAK_DOUBLED = GameInfoTypes.BUILDING_SACRED_PEAK_DOUBLED

-- Buildings for Chöd Ceremony
local BUILDING_CHOD_CEREMONY = GameInfoTypes.BUILDING_CHOD_CEREMONY
local BUILDING_CHOD_CEREMONY_MOUNTAIN = GameInfoTypes.BUILDING_CHOD_CEREMONY_MOUNTAIN
local BUILDING_CHOD_CEREMONY_ARTIST = GameInfoTypes.BUILDING_CHOD_CEREMONY_ARTIST
local BUILDING_CHOD_CEREMONY_WRITER = GameInfoTypes.BUILDING_CHOD_CEREMONY_WRITER
local BUILDING_CHOD_CEREMONY_MUSICIAN = GameInfoTypes.BUILDING_CHOD_CEREMONY_MUSICIAN
local BUILDING_CHOD_CEREMONY_TOURISM = GameInfoTypes.BUILDING_CHOD_CEREMONY_TOURISM

-- Unit identifiers
local unitPawoID = GameInfoTypes.UNIT_PAWO

-- Improvement identifiers
local IMPROVEMENT_SKY_BURIAL_GROUND = GameInfoTypes.IMPROVEMENT_SKY_BURIAL_GROUND

-- Dummy buildings for Sky Burial Ground adjacency yields
local BUILDING_DUMMY_SKY_BURIAL_CULTURE = GameInfoTypes.BUILDING_DUMMY_SKY_BURIAL_CULTURE
local BUILDING_DUMMY_SKY_BURIAL_FAITH = GameInfoTypes.BUILDING_DUMMY_SKY_BURIAL_FAITH
local BUILDING_DUMMY_SKY_BURIAL_TOURISM = GameInfoTypes.BUILDING_DUMMY_SKY_BURIAL_TOURISM

-- Constants
local SACRED_PEAK_DURATION = 20   -- turns
local MAX_SACRED_PEAKS = 5
local CHOD_CEREMONY_DURATION = 15 -- turns
local MOUNTAIN_SEARCH_RADIUS = 3

-- Tables to track Sacred Peaks and their expiration
local tSacredPeaks = {}       -- [playerID] = {peak1 = {plotID, expiryTurn, cityID, gpUnitID}, peak2 = {...}, peak3 = {...}}
local tChodCeremonies = {}    -- [playerID][cityID] = {expiryTurn, hasMountain}
local tGreatPersonToPeak = {} -- [playerID][unitID] = peakSlot



-- Custom Fallout
local FEATURE_SACRED_PEAK = GameInfoTypes.FEATURE_SACRED_PEAK


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
	local nearestDistance = 100

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

-- Helper to set or remove Sacred Peak feature on a plot
function SetSacredPeakFeature(plot, set)
	if not plot then return end
	if set then
		plot:SetFeatureType(FEATURE_SACRED_PEAK, -1)
	else
		if plot:GetFeatureType() == FEATURE_SACRED_PEAK then
			plot:SetFeatureType(-1, -1)
		end
	end
end

-- UA: Sacred Peak designation when Great Person is born
function OnUnitCreated_SacredPeak(iPlayer, iUnitID)
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

	-- Try to get the plot of the unit (may not be available immediately)
	local plot = unit:GetPlot()

	-- Helper to check if a mountain is already tracked as a Sacred Peak
	local function IsMountainAlreadySacred(playerID, plotIndex)
		if not tSacredPeaks[playerID] then return false end
		for _, peakData in pairs(tSacredPeaks[playerID]) do
			if peakData and peakData.plotID == plotIndex then
				return true
			end
		end
		return false
	end

	-- Find nearest mountain that is not already a Sacred Peak
	local mountain = nil
	if plot then
		local nearestMountain = nil
		local nearestDistance = MOUNTAIN_SEARCH_RADIUS + 1
		for x = -MOUNTAIN_SEARCH_RADIUS, MOUNTAIN_SEARCH_RADIUS do
			for y = -MOUNTAIN_SEARCH_RADIUS, MOUNTAIN_SEARCH_RADIUS do
				local checkPlot = Map.GetPlot(plot:GetX() + x, plot:GetY() + y)
				if checkPlot and checkPlot:IsMountain() and not IsMountainAlreadySacred(iPlayer, checkPlot:GetPlotIndex()) then
					local distance = Map.PlotDistance(plot:GetX(), plot:GetY(), checkPlot:GetX(), checkPlot:GetY())
					if distance < nearestDistance then
						nearestDistance = distance
						nearestMountain = checkPlot
					end
				end
			end
		end
		mountain = nearestMountain
	else
		-- fallback: use capital's plot
		local capital = player:GetCapitalCity()
		if capital then
			local capPlot = capital:Plot()
			local nearestMountain = nil
			local nearestDistance = MOUNTAIN_SEARCH_RADIUS + 2
			for x = -MOUNTAIN_SEARCH_RADIUS, MOUNTAIN_SEARCH_RADIUS do
				for y = -MOUNTAIN_SEARCH_RADIUS, MOUNTAIN_SEARCH_RADIUS do
					local checkPlot = Map.GetPlot(capPlot:GetX() + x, capPlot:GetY() + y)
					if checkPlot and checkPlot:IsMountain() and not IsMountainAlreadySacred(iPlayer, checkPlot:GetPlotIndex()) then
						local distance = Map.PlotDistance(capPlot:GetX(), capPlot:GetY(), checkPlot:GetX(),
							checkPlot:GetY())
						if distance < nearestDistance then
							nearestDistance = distance
							nearestMountain = checkPlot
						end
					end
				end
			end
			mountain = nearestMountain
		end
	end
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

	SetSacredPeakFeature(mountain, true)


	if player:IsHuman() and player:IsTurnActive() then
		local gpName = Locale.ConvertTextKey(GameInfo.Units[unit:GetUnitType()].Description)
		Events.GameplayAlertMessage(string.format("Sacred Peak designated! %s blessed a mountain near %s.", gpName,
			nearestCity:GetName()))
	end

	-- Spawn Missionary
	local missionaryType = GameInfoTypes.UNIT_MISSIONARY
	if missionaryType and player:HasCreatedReligion() then
		local capital = player:GetCapitalCity()
		if capital then
			-- Move any civilian units from capital before spawning missionary
			local capitalPlot = capital:Plot()
			local unitsToMove = {}

			for i = 0, capitalPlot:GetNumUnits() - 1 do
				local unitOnPlot = capitalPlot:GetUnit(i)
				if unitOnPlot and unitOnPlot:GetOwner() == iPlayer and not unitOnPlot:IsCombatUnit() then
					table.insert(unitsToMove, unitOnPlot)
				end
			end

			for _, unitToMove in ipairs(unitsToMove) do
				for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
					local adjacentPlot = Map.PlotDirection(capital:GetX(), capital:GetY(), direction)
					if adjacentPlot and unitToMove:CanMoveThrough(adjacentPlot) then
						unitToMove:SetXY(adjacentPlot:GetX(), adjacentPlot:GetY())
						break
					end
				end
			end

			player:InitUnit(missionaryType, capital:GetX(), capital:GetY())
		end
	end
end

Events.SerialEventUnitCreated.Add(OnUnitCreated_SacredPeak)

-- Apply Sacred Peak bonuses to a city
function ApplySacredPeakBonus(player, city, mountain)
	if not city then
		return
	end
	local hasAdjacentBurial = HasAdjacentSkyBurialGround(mountain)
	local bonusBuilding = hasAdjacentBurial and BUILDING_SACRED_PEAK_DOUBLED or BUILDING_SACRED_PEAK
	city:SetNumRealBuilding(bonusBuilding, 1)
end

-- Remove Sacred Peak bonuses from a city
function RemoveSacredPeakBonus(player, city, mountain)
	if not city then
		return
	end
	local hasAdjacentBurial = HasAdjacentSkyBurialGround(mountain)
	local bonusBuilding = hasAdjacentBurial and BUILDING_SACRED_PEAK_DOUBLED or BUILDING_SACRED_PEAK
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

	-- Use the unit ID provided by the event
	local expendedUnitID = iUnitID

	if not tGreatPersonToPeak[iPlayer] or not tGreatPersonToPeak[iPlayer][expendedUnitID] then
		return
	end

	local peakSlot = tGreatPersonToPeak[iPlayer][expendedUnitID]
	local peakData = tSacredPeaks[iPlayer][peakSlot]
	if not peakData then
		return
	end

	-- Remove old peak bonus
	local oldMountain = Map.GetPlotByIndex(peakData.plotID)
	local oldCity = player:GetCityByID(peakData.cityID)
	if oldCity and oldMountain then
		RemoveSacredPeakBonus(player, oldCity, oldMountain)
		SetSacredPeakFeature(oldMountain, false)
	end

	-- Find new location (where GP was expended) using actual expend coordinates
	local expendPlot = Map.GetPlot(iX, iY)
	local newCity = nil
	if expendPlot and expendPlot:IsCity() then
		newCity = expendPlot:GetPlotCity()
	elseif expendPlot then
		newCity = FindNearestCity(player, expendPlot)
	else
		newCity = player:GetCapitalCity()
	end
	if not newCity then
		return
	end

	-- Find nearest mountain to the new city
	local newMountain = FindNearestMountain(newCity:Plot(), MOUNTAIN_SEARCH_RADIUS)
	if not newMountain then
		tSacredPeaks[iPlayer][peakSlot] = nil
		tGreatPersonToPeak[iPlayer][expendedUnitID] = nil
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
	SetSacredPeakFeature(newMountain, true)
	tGreatPersonToPeak[iPlayer][expendedUnitID] = nil

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
				SetSacredPeakFeature(mountain, false)
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
function OnPawo_Ceremony(iPlayer, iUnit)
	local player = Players[iPlayer]
	if not player then
		return
	end

	local unit = player:GetUnitByID(iUnit)
	if not unit or unit:GetUnitType() ~= unitPawoID then
		return
	end

	local plot = unit:GetPlot()
	local city = nil
	if plot:IsCity() then
		local c = plot:GetPlotCity()
		if c and c:GetOwner() == iPlayer then city = c end
	end
	if not city then
		for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
			local adjPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), direction)
			if adjPlot and adjPlot:IsCity() then
				local c = adjPlot:GetPlotCity()
				if c and c:GetOwner() == iPlayer then
					city = c
					break
				end
			end
		end
	end
	if not city then return false end

	tChodCeremonies[iPlayer] = tChodCeremonies[iPlayer] or {}

	local currentTurn = Game.GetGameTurn()
	local hasMountain = IsCityNearMountain(city, 2)

	tChodCeremonies[iPlayer][city:GetID()] = {
		expiryTurn = currentTurn + CHOD_CEREMONY_DURATION,
		hasMountain = hasMountain
	}

	city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY, 1)
	if hasMountain then
		city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_MOUNTAIN, 1)
	end
	city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_ARTIST, 1)
	city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_WRITER, 1)
	city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_MUSICIAN, 1)
	city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_TOURISM, 1)

	unit:Kill()

	if player:IsHuman() and player:IsTurnActive() then
		local msg = string.format(
			"Chöd Ceremony performed in %s! Great Person rates and tourism boosted for %d turns.", city:GetName(),
			CHOD_CEREMONY_DURATION)
		Events.GameplayAlertMessage(msg)
	end
end

LuaEvents.OnPawo_Ceremony_Trigger.Add(OnPawo_Ceremony)

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
				-- Remove dummy buildings for GPP
				city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_ARTIST, 0)
				city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_WRITER, 0)
				city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_MUSICIAN, 0)
				-- Remove dummy building for Tourism
				city:SetNumRealBuilding(BUILDING_CHOD_CEREMONY_TOURISM, 0)
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
function UpdateSkyBurialGroundAdjacencyYields(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end

	-- Remove all dummy buildings from all cities first
	for city in player:Cities() do
		city:SetNumRealBuilding(BUILDING_DUMMY_SKY_BURIAL_CULTURE, 0)
		city:SetNumRealBuilding(BUILDING_DUMMY_SKY_BURIAL_FAITH, 0)
		city:SetNumRealBuilding(BUILDING_DUMMY_SKY_BURIAL_TOURISM, 0)
	end

	-- For each Sky Burial Ground, apply adjacency dummy buildings to the nearest city
	for plotIndex = 0, Map.GetNumPlots() - 1 do
		local plot = Map.GetPlotByIndex(plotIndex)
		if plot and plot:GetOwner() == iPlayer and plot:GetImprovementType() == IMPROVEMENT_SKY_BURIAL_GROUND then
			-- Count adjacent mountains and GP improvements
			local adjacentMountains = 0
			local adjacentGPImprovements = 0
			for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
				local adjacentPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), direction)
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
			local bonusCulture = adjacentMountains + adjacentGPImprovements
			local bonusFaith = adjacentMountains + adjacentGPImprovements

			-- Find nearest city
			local nearestCity = FindNearestCity(player, plot)
			if nearestCity then
				if bonusCulture > 0 then
					nearestCity:SetNumRealBuilding(BUILDING_DUMMY_SKY_BURIAL_CULTURE, bonusCulture)
				end
				if bonusFaith > 0 then
					nearestCity:SetNumRealBuilding(BUILDING_DUMMY_SKY_BURIAL_FAITH, bonusFaith)
				end
			end
		end
	end
end

function OnImprovementBuilt_SkyBurialGround(iPlayer, iX, iY, iImprovement)
	if iImprovement ~= IMPROVEMENT_SKY_BURIAL_GROUND then
		return
	end
	UpdateSkyBurialGroundAdjacencyYields(iPlayer)
end

GameEvents.BuildFinished.Add(OnImprovementBuilt_SkyBurialGround)

-- Also update adjacency yields at the start of each turn (in case of city capture, improvement pillage, etc.)
function OnPlayerDoTurn_SkyBurialAdjacency(iPlayer)
	UpdateSkyBurialGroundAdjacencyYields(iPlayer)
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_SkyBurialAdjacency)

-- Grant Tourism after Archaeology for each Sky Burial Ground
function OnPlayerDoTurn_SkyBurialTourism(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end
	local archaeologyTech = GameInfoTypes.TECH_ARCHAEOLOGY
	if not Teams[player:GetTeam()]:GetTeamTechs():HasTech(archaeologyTech) then
		return
	end
	for plotIndex = 0, Map.GetNumPlots() - 1 do
		local plot = Map.GetPlotByIndex(plotIndex)
		if plot and plot:GetOwner() == iPlayer and plot:GetImprovementType() == IMPROVEMENT_SKY_BURIAL_GROUND then
			local nearestCity = FindNearestCity(player, plot)
			if nearestCity then
				nearestCity:SetNumRealBuilding(BUILDING_DUMMY_SKY_BURIAL_TOURISM, 1)
			end
		end
	end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_SkyBurialTourism)

-- Initialize tables on game load
function OnLoadScreenClose()
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


-- Rebuild any existing Fallout/Sacred Peak feature symbols so FX starts now (no reload needed)
local NO_FEATURE  = -1
local iFallout    = GameInfoTypes.FEATURE_FALLOUT
local iSacredPeak = GameInfoTypes.FEATURE_SACRED_PEAK -- if you're using a separate feature

local function RebuildFeatureAt(plot)
	local fid = plot:GetFeatureType()
	if fid ~= NO_FEATURE and (fid == iFallout or (iSacredPeak and fid == iSacredPeak)) then
		local v = plot:GetFeatureVariety() or -1
		-- toggle off then back on to force landmark + FX to re-instantiate
		plot:SetFeatureType(NO_FEATURE, 0)
		plot:SetFeatureType(fid, v)
	end
end

local function RefreshAllFallout()
	local w, h = Map.GetGridSize()
	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local p = Map.GetPlot(x, y)
			if p then RebuildFeatureAt(p) end
		end
	end
	-- Optional: SV toggle nudges the renderer to refresh immediately
	if UI and UI.SetStrategicView then
		UI.SetStrategicView(true); UI.SetStrategicView(false)
	end
end

-- Run once when the map is ready
Events.LoadScreenClose.Add(RefreshAllFallout)
