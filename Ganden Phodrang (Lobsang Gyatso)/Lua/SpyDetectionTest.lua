-- SpyDetectionTest.lua
-- Test and demonstration file for the spy mission detection system
-- This file provides debug commands and test scenarios for verifying spy mission detection

local SpyMissionDetector = include("SpyMissionDetector.lua")

-- Test module
local SpyDetectionTest = {}

-- Debug flag
local DEBUG_MODE = true

-- Test counters
local tTestResults = {
	techStealTests = 0,
	rigElectionTests = 0,
	coupTests = 0,
	falsePositives = 0,
	totalTests = 0
}

-- Logging function
local function DebugLog(message)
	if DEBUG_MODE then
		print("[SPY_DETECTION_TEST] " .. message)
	end
end

-- Simulate a tech steal for testing
function SpyDetectionTest.SimulateTechSteal(iPlayer, techID)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		DebugLog("Invalid player for tech steal simulation")
		return false
	end

	local team = Teams[player:GetTeam()]
	local tech = GameInfo.Technologies[techID]

	if not tech then
		DebugLog("Invalid tech ID: " .. tostring(techID))
		return false
	end

	DebugLog(string.format("Simulating tech steal: Player %d stealing %s",
		iPlayer, Locale.ConvertTextKey(tech.Description)))

	-- Store current progress
	local previousProgress = team:GetTeamTechs():GetResearchProgress(techID)
	local cost = team:GetTeamTechs():GetResearchCost(techID)

	-- Grant the tech instantly (simulating a steal)
	team:SetHasTech(techID, true)

	-- Force detection check
	SpyMissionDetector.ProcessPlayer(iPlayer)

	tTestResults.techStealTests = tTestResults.techStealTests + 1
	tTestResults.totalTests = tTestResults.totalTests + 1

	DebugLog(string.format("Tech steal simulation complete. Previous progress: %.1f%%",
		(previousProgress / cost) * 100))

	return true
end

-- Simulate an election rig for testing
function SpyDetectionTest.SimulateRigElection(iPlayer, iCityState, influenceAmount)
	local player = Players[iPlayer]
	local csPlayer = Players[iCityState]

	if not player or not player:IsAlive() then
		DebugLog("Invalid player for rig election simulation")
		return false
	end

	if not csPlayer or not csPlayer:IsAlive() or not csPlayer:IsMinorCiv() then
		DebugLog("Invalid city-state for rig election simulation")
		return false
	end

	influenceAmount = influenceAmount or 40

	DebugLog(string.format("Simulating election rig: Player %d in %s (+%d influence)",
		iPlayer, csPlayer:GetName(), influenceAmount))

	-- Store current influence
	local previousInfluence = csPlayer:GetMinorCivFriendshipWithMajor(iPlayer)

	-- Add influence instantly (simulating a rig)
	csPlayer:ChangeMinorCivFriendshipWithMajor(iPlayer, influenceAmount)

	-- Force detection check
	SpyMissionDetector.ProcessPlayer(iPlayer)

	tTestResults.rigElectionTests = tTestResults.rigElectionTests + 1
	tTestResults.totalTests = tTestResults.totalTests + 1

	DebugLog(string.format("Election rig simulation complete. Influence: %d -> %d",
		previousInfluence, csPlayer:GetMinorCivFriendshipWithMajor(iPlayer)))

	return true
end

-- Simulate a coup for testing
function SpyDetectionTest.SimulateCoup(iPlayer, iCityState)
	local player = Players[iPlayer]
	local csPlayer = Players[iCityState]

	if not player or not player:IsAlive() then
		DebugLog("Invalid player for coup simulation")
		return false
	end

	if not csPlayer or not csPlayer:IsAlive() or not csPlayer:IsMinorCiv() then
		DebugLog("Invalid city-state for coup simulation")
		return false
	end

	DebugLog(string.format("Simulating coup: Player %d in %s",
		iPlayer, csPlayer:GetName()))

	-- Store previous ally
	local previousAlly = csPlayer:GetAlly()

	-- Set influence to ally threshold (simulating successful coup)
	local allyThreshold = GameDefines.FRIENDSHIP_THRESHOLD_ALLIES or 60
	csPlayer:SetMinorCivFriendshipWithMajor(iPlayer, allyThreshold)

	-- Force ally update
	csPlayer:DoMinorCivAlliesUpdate()

	-- Force detection check
	SpyMissionDetector.ProcessPlayer(iPlayer)

	tTestResults.coupTests = tTestResults.coupTests + 1
	tTestResults.totalTests = tTestResults.totalTests + 1

	DebugLog(string.format("Coup simulation complete. Previous ally: %d, New ally: %d",
		previousAlly, csPlayer:GetAlly()))

	return true
end

-- Verify detection accuracy
function SpyDetectionTest.VerifyDetection(iPlayer)
	local stats = SpyMissionDetector.GetDetectionStats(iPlayer)

	DebugLog("=== Detection Statistics for Player " .. iPlayer .. " ===")
	DebugLog("Tech Steals Detected: " .. (stats[SpyMissionDetector.MISSION_STEAL_TECH] or 0))
	DebugLog("Elections Rigged Detected: " .. (stats[SpyMissionDetector.MISSION_RIG_ELECTION] or 0))
	DebugLog("Coups Detected: " .. (stats[SpyMissionDetector.MISSION_COUP] or 0))

	return stats
end

-- Test bonus application
function SpyDetectionTest.VerifyBonuses(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return false
	end

	local capital = player:GetCapitalCity()
	if not capital then
		DebugLog("No capital city found for player " .. iPlayer)
		return false
	end

	-- Check for spy mission buildings
	local techStealBuildings = capital:GetNumBuilding(GameInfoTypes.BUILDING_SPY_POPULATION_TRANSFER) or 0
	local coupBonusBuildings = capital:GetNumBuilding(GameInfoTypes.BUILDING_SPY_COUP_BONUS) or 0

	DebugLog("=== Bonus Buildings for Player " .. iPlayer .. " ===")
	DebugLog("Tech Steal Buildings: " .. techStealBuildings)
	DebugLog("Coup Bonus Buildings: " .. coupBonusBuildings)

	-- Calculate expected yields
	local scienceBonus = techStealBuildings * 2
	local cultureBonus = techStealBuildings * 1
	local goldBonus = coupBonusBuildings * 2
	local faithBonus = coupBonusBuildings * 3

	DebugLog("Expected Bonuses:")
	DebugLog("  Science: +" .. scienceBonus)
	DebugLog("  Culture: +" .. cultureBonus)
	DebugLog("  Gold: +" .. goldBonus)
	DebugLog("  Faith: +" .. faithBonus)

	return true
end

-- Run comprehensive test suite
function SpyDetectionTest.RunTestSuite(iPlayer)
	DebugLog("=====================================")
	DebugLog("Starting Spy Detection Test Suite")
	DebugLog("=====================================")

	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		DebugLog("ERROR: Invalid player ID: " .. tostring(iPlayer))
		return false
	end

	-- Reset detection stats
	SpyMissionDetector.ResetPlayer(iPlayer)

	-- Test 1: Tech Steal Detection
	DebugLog("\n--- TEST 1: Tech Steal Detection ---")
	local techToSteal = nil
	for tech in GameInfo.Technologies() do
		if not Teams[player:GetTeam()]:IsHasTech(tech.ID) then
			techToSteal = tech.ID
			break
		end
	end

	if techToSteal then
		SpyDetectionTest.SimulateTechSteal(iPlayer, techToSteal)
		Game.DoFromUIDiploEvent(FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_HUMAN_WANTS_PAUSE, 0, 0)
	else
		DebugLog("No available tech to steal for testing")
	end

	-- Test 2: Rig Election Detection
	DebugLog("\n--- TEST 2: Rig Election Detection ---")
	local testCS = nil
	for iCS = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS - 1 do
		local csPlayer = Players[iCS]
		if csPlayer and csPlayer:IsAlive() and csPlayer:IsMinorCiv() then
			testCS = iCS
			break
		end
	end

	if testCS then
		SpyDetectionTest.SimulateRigElection(iPlayer, testCS, 35)
		Game.DoFromUIDiploEvent(FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_HUMAN_WANTS_PAUSE, 0, 0)
	else
		DebugLog("No city-state available for testing")
	end

	-- Test 3: Coup Detection
	DebugLog("\n--- TEST 3: Coup Detection ---")
	if testCS then
		SpyDetectionTest.SimulateCoup(iPlayer, testCS)
		Game.DoFromUIDiploEvent(FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_HUMAN_WANTS_PAUSE, 0, 0)
	end

	-- Verify results
	DebugLog("\n--- VERIFICATION ---")
	SpyDetectionTest.VerifyDetection(iPlayer)
	SpyDetectionTest.VerifyBonuses(iPlayer)

	-- Summary
	DebugLog("\n=====================================")
	DebugLog("Test Suite Complete")
	DebugLog("Total Tests Run: " .. tTestResults.totalTests)
	DebugLog("Tech Steal Tests: " .. tTestResults.techStealTests)
	DebugLog("Rig Election Tests: " .. tTestResults.rigElectionTests)
	DebugLog("Coup Tests: " .. tTestResults.coupTests)
	DebugLog("=====================================")

	return true
end

-- Console commands for testing
function SpyDetectionTest.RegisterConsoleCommands()
	-- Register test commands that can be called from FireTuner
	if Modding and Modding.OpenSaveData then
		DebugLog("Spy Detection Test Commands Registered")
		DebugLog("Use FireTuner console to run:")
		DebugLog("  SpyDetectionTest.RunTestSuite(0) -- Run full test suite for Player 0")
		DebugLog("  SpyDetectionTest.SimulateTechSteal(0, techID) -- Simulate tech steal")
		DebugLog("  SpyDetectionTest.SimulateRigElection(0, csID) -- Simulate election rig")
		DebugLog("  SpyDetectionTest.SimulateCoup(0, csID) -- Simulate coup")
		DebugLog("  SpyDetectionTest.VerifyDetection(0) -- Check detection stats")
		DebugLog("  SpyDetectionTest.VerifyBonuses(0) -- Check bonus buildings")
	end
end

-- Auto-test on game load for debugging
function SpyDetectionTest.OnLoadScreenClose()
	if DEBUG_MODE then
		DebugLog("Spy Detection Test Module Loaded")
		SpyDetectionTest.RegisterConsoleCommands()

		-- Optionally run automatic test for human player
		local humanPlayer = Players[Game.GetActivePlayer()]
		if humanPlayer and humanPlayer:IsAlive() then
			-- Uncomment to auto-test:
			-- SpyDetectionTest.RunTestSuite(Game.GetActivePlayer())
		end
	end
end

Events.LoadScreenClose.Add(SpyDetectionTest.OnLoadScreenClose)

-- Export module
return SpyDetectionTest
