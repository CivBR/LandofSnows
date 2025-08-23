-- SpyMissionDetector.lua
-- Indirect detection system for spy missions based on game state changes
-- Detects: Tech Steal, Rig Election, and Coup missions

local SpyMissionDetector = {}

-- Mission type constants
SpyMissionDetector.MISSION_STEAL_TECH = 1
SpyMissionDetector.MISSION_RIG_ELECTION = 2
SpyMissionDetector.MISSION_COUP = 3

-- Detection thresholds
local INFLUENCE_RIG_THRESHOLD = 30   -- Minimum influence jump to detect rigging
local TECH_PROGRESS_THRESHOLD = 0.95 -- Tech must be less than 95% complete to count as stolen

-- State tracking tables
local tTechProgress = {}      -- [playerID][techID] = progress
local tCSInfluence = {}       -- [playerID][csID] = influence
local tCSAllies = {}          -- [csID] = allyPlayerID
local tLastTurnProcessed = {} -- [playerID] = turnNumber
local tDetectedMissions = {}  -- [playerID] = {missionType = count}

-- Callback registry for mission detection
local tCallbacks = {
	[SpyMissionDetector.MISSION_STEAL_TECH] = {},
	[SpyMissionDetector.MISSION_RIG_ELECTION] = {},
	[SpyMissionDetector.MISSION_COUP] = {}
}

-- Initialize detector for a player
function SpyMissionDetector.InitializePlayer(iPlayer)
	tTechProgress[iPlayer] = tTechProgress[iPlayer] or {}
	tCSInfluence[iPlayer] = tCSInfluence[iPlayer] or {}
	tDetectedMissions[iPlayer] = tDetectedMissions[iPlayer] or {}
	tLastTurnProcessed[iPlayer] = -1
end

-- Register a callback for mission detection
function SpyMissionDetector.RegisterCallback(missionType, callback)
	if tCallbacks[missionType] then
		table.insert(tCallbacks[missionType], callback)
	end
end

-- Trigger callbacks for detected mission
local function TriggerCallbacks(missionType, iPlayer, targetData)
	if tCallbacks[missionType] then
		for _, callback in ipairs(tCallbacks[missionType]) do
			callback(iPlayer, missionType, targetData)
		end
	end

	-- Track detection
	tDetectedMissions[iPlayer] = tDetectedMissions[iPlayer] or {}
	tDetectedMissions[iPlayer][missionType] = (tDetectedMissions[iPlayer][missionType] or 0) + 1
end

-- Check for stolen technology
local function CheckStolenTech(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end

	local team = Teams[player:GetTeam()]
	local currentTechs = {}

	-- Build current tech state
	for tech in GameInfo.Technologies() do
		local techID = tech.ID
		if team:IsHasTech(techID) then
			currentTechs[techID] = true

			-- Check if this tech was just acquired
			local previousProgress = tTechProgress[iPlayer][techID] or 0

			-- Tech is considered stolen if:
			-- 1. We have it now but didn't before
			-- 2. Previous progress was below threshold (not almost complete)
			if previousProgress < TECH_PROGRESS_THRESHOLD and previousProgress > 0 then
				-- Likely stolen!
				local targetData = {
					techID = techID,
					techName = Locale.ConvertTextKey(tech.Description),
					previousProgress = previousProgress
				}

				print(string.format("Player %d likely stole tech: %s (was at %.1f%% progress)",
					iPlayer, targetData.techName, previousProgress * 100))

				TriggerCallbacks(SpyMissionDetector.MISSION_STEAL_TECH, iPlayer, targetData)
			end
		else
			-- Track progress on uncompleted techs
			local progress = team:GetTeamTechs():GetResearchProgress(techID)
			local cost = team:GetTeamTechs():GetResearchCost(techID)
			if cost > 0 then
				tTechProgress[iPlayer][techID] = progress / cost
			else
				tTechProgress[iPlayer][techID] = 0
			end
		end
	end

	-- Clear completed techs from progress tracking
	for techID, _ in pairs(currentTechs) do
		tTechProgress[iPlayer][techID] = 1.0
	end
end

-- Check for rigged elections (sudden influence jumps)
local function CheckRiggedElection(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end

	-- Check all city-states
	for iCS = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS - 1 do
		local csPlayer = Players[iCS]
		if csPlayer and csPlayer:IsAlive() and csPlayer:IsMinorCiv() then
			local currentInfluence = csPlayer:GetMinorCivFriendshipWithMajor(iPlayer)
			local previousInfluence = tCSInfluence[iPlayer][iCS] or 0

			-- Check for sudden influence jump
			local influenceDelta = currentInfluence - previousInfluence

			if influenceDelta >= INFLUENCE_RIG_THRESHOLD then
				-- Check if this wasn't from a normal source (quest, gold gift, unit gift)
				-- We detect rigging if there's a large jump without obvious cause

				-- Additional check: see if player has spies
				local hasSpies = false
				for unit in player:Units() do
					if unit:GetUnitClassType() == GameInfoTypes.UNITCLASS_SPY then
						hasSpies = true
						break
					end
				end

				if hasSpies then
					local targetData = {
						csID = iCS,
						csName = csPlayer:GetName(),
						influenceGain = influenceDelta,
						newInfluence = currentInfluence
					}

					print(string.format("Player %d likely rigged election in %s: +%d influence",
						iPlayer, targetData.csName, influenceDelta))

					TriggerCallbacks(SpyMissionDetector.MISSION_RIG_ELECTION, iPlayer, targetData)
				end
			end

			-- Update tracked influence
			tCSInfluence[iPlayer][iCS] = currentInfluence
		end
	end
end

-- Check for successful coups (ally changes)
local function CheckCoup(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end

	-- Check all city-states for ally changes
	for iCS = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS - 1 do
		local csPlayer = Players[iCS]
		if csPlayer and csPlayer:IsAlive() and csPlayer:IsMinorCiv() then
			local currentAlly = csPlayer:GetAlly()
			local previousAlly = tCSAllies[iCS] or -1

			-- Check if player just became the ally
			if currentAlly == iPlayer and previousAlly ~= iPlayer and previousAlly ~= -1 then
				-- Additional check: was there a sudden influence spike?
				local influence = csPlayer:GetMinorCivFriendshipWithMajor(iPlayer)
				local previousInfluence = tCSInfluence[iPlayer][iCS] or 0

				-- Coups typically result in exact ally threshold influence
				local allyThreshold = GameDefines.FRIENDSHIP_THRESHOLD_ALLIES or 60

				-- Check if influence jumped to near ally threshold (coup signature)
				if math.abs(influence - allyThreshold) <= 5 or
					(influence >= allyThreshold and previousInfluence < allyThreshold - 20) then
					-- Check for spies
					local hasSpies = false
					for unit in player:Units() do
						if unit:GetUnitClassType() == GameInfoTypes.UNITCLASS_SPY then
							hasSpies = true
							break
						end
					end

					if hasSpies then
						local targetData = {
							csID = iCS,
							csName = csPlayer:GetName(),
							previousAlly = previousAlly,
							influence = influence
						}

						print(string.format("Player %d likely performed coup in %s (was allied to Player %d)",
							iPlayer, targetData.csName, previousAlly))

						TriggerCallbacks(SpyMissionDetector.MISSION_COUP, iPlayer, targetData)
					end
				end
			end

			-- Update ally tracking
			tCSAllies[iCS] = currentAlly
		end
	end
end

-- Main detection function - call each turn for each player
function SpyMissionDetector.ProcessPlayer(iPlayer)
	local currentTurn = Game.GetGameTurn()

	-- Skip if already processed this turn
	if tLastTurnProcessed[iPlayer] == currentTurn then
		return
	end

	-- Initialize if needed
	SpyMissionDetector.InitializePlayer(iPlayer)

	-- Run detection checks
	CheckStolenTech(iPlayer)
	CheckRiggedElection(iPlayer)
	CheckCoup(iPlayer)

	-- Mark as processed
	tLastTurnProcessed[iPlayer] = currentTurn
end

-- Get detection statistics for a player
function SpyMissionDetector.GetDetectionStats(iPlayer)
	return tDetectedMissions[iPlayer] or {}
end

-- Reset detection for a player
function SpyMissionDetector.ResetPlayer(iPlayer)
	tTechProgress[iPlayer] = {}
	tCSInfluence[iPlayer] = {}
	tDetectedMissions[iPlayer] = {}
	tLastTurnProcessed[iPlayer] = -1
end

-- Hook into game events
function SpyMissionDetector.Initialize()
	-- Process all players each turn
	GameEvents.PlayerDoTurn.Add(function(iPlayer)
		SpyMissionDetector.ProcessPlayer(iPlayer)
	end)

	-- Initialize tracking on game start
	Events.LoadScreenClose.Add(function()
		-- Initialize city-state ally tracking
		for iCS = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS - 1 do
			local csPlayer = Players[iCS]
			if csPlayer and csPlayer:IsAlive() and csPlayer:IsMinorCiv() then
				tCSAllies[iCS] = csPlayer:GetAlly()
			end
		end

		-- Initialize player tracking
		for iPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
			local player = Players[iPlayer]
			if player and player:IsAlive() then
				SpyMissionDetector.InitializePlayer(iPlayer)

				-- Initialize CS influence tracking
				for iCS = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS - 1 do
					local csPlayer = Players[iCS]
					if csPlayer and csPlayer:IsAlive() and csPlayer:IsMinorCiv() then
						tCSInfluence[iPlayer][iCS] = csPlayer:GetMinorCivFriendshipWithMajor(iPlayer)
					end
				end
			end
		end
	end)

	print("SpyMissionDetector initialized")
end

-- Advanced detection: Check for spy positioning near targets
function SpyMissionDetector.CheckSpyProximity(iPlayer, iTargetPlayer)
	local player = Players[iPlayer]
	local targetPlayer = Players[iTargetPlayer]

	if not player or not targetPlayer then
		return false
	end

	-- Check if player has any spies near target's cities
	for unit in player:Units() do
		if unit:GetUnitClassType() == GameInfoTypes.UNITCLASS_SPY then
			local plot = unit:GetPlot()
			if plot then
				-- Check nearby cities
				for city in targetPlayer:Cities() do
					local cityPlot = city:Plot()
					local distance = Map.PlotDistance(plot:GetX(), plot:GetY(),
						cityPlot:GetX(), cityPlot:GetY())
					if distance <= 3 then -- Spy operating range
						return true
					end
				end
			end
		end
	end

	return false
end

-- Export the module
return SpyMissionDetector
