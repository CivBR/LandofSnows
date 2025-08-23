include("FLuaVector.lua")

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

local iTibet = GameInfoTypes.CIVILIZATION_TIBET_THUPTEN_GYATSO
local traitTibet = GameInfoTypes["TRAIT_TIBET_THUPTEN_GYATSO"]

local tCityStateFriendGiftTurn = {}   -- Table to track which city-states have already given their Great Person gift to each player
local CS_GIFT_GP_INTERVAL = 25        -- Turns between Great Person gifts from City-States

local DIPLOMAT_SCIENCE_PERCENT = 0.15 -- 15% of science per tech difference
local DUMMY_SCIENCE_BUILDING = GameInfoTypes.BUILDING_DIPLOMAT_SCIENCE
local BUILDING_MENTSIKHANG_FOOD = GameInfoTypes.BUILDING_MENTSIKHANG_FOOD
local BUILDING_MENTSIKHANG_PROD = GameInfoTypes.BUILDING_MENTSIKHANG_PROD

local MinorTraitToGreatPersonUnit = {
	[GameInfoTypes.MINOR_TRAIT_RELIGIOUS] = GameInfoTypes.UNIT_PROPHET,
	[GameInfoTypes.MINOR_TRAIT_CULTURED] = GameInfoTypes.UNIT_ARTIST,
	[GameInfoTypes.MINOR_TRAIT_MARITIME] = GameInfoTypes.UNIT_SCIENTIST,
	[GameInfoTypes.MINOR_TRAIT_MILITARISTIC] = GameInfoTypes.UNIT_GREAT_GENERAL,
	[GameInfoTypes.MINOR_TRAIT_MERCANTILE] = GameInfoTypes.UNIT_MERCHANT
}

local BONUS_WLTKD_TURNS = 2
local unitKusungID = GameInfoTypes.UNIT_KUSUNG

-- Count active Research Agreements for a player
local function CountActiveRAs(iPlayer)
	local p = Players[iPlayer]
	local count = 0
	for otherPlayerID = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
		if otherPlayerID ~= iPlayer then
			local op = Players[otherPlayerID]
			if op and op:IsAlive() and not op:IsMinorCiv() then
				if Teams[p:GetTeam()]:IsHasResearchAgreement(op:GetTeam()) then
					count = count + 1
				end
			end
		end
	end
	return count
end

-- UA: Add a dummy building to the capital that grants science for the bonus
function OnPlayerDoTurn_TibetDiplomatScience(iPlayer)
	local p = Players[iPlayer]
	if not p or not p:IsAlive() then
		return
	end
	if not HasTrait(p, traitTibet) then
		return
	end

	local capital = p:GetCapitalCity()
	if not capital then
		return
	end

	local totalBonus = 0
	for otherID = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
		if otherID ~= iPlayer then
			local op = Players[otherID]
			if op and op:IsAlive() and not op:IsMinorCiv() then
				if p:IsMyDiplomatVisitingThem(otherID) then
					local diff = p:GetNumTechDifference(otherID)
					if diff > 0 then
						local opScience = op:GetScience()
						local bonus = math.floor(opScience * diff * DIPLOMAT_SCIENCE_PERCENT)
						totalBonus = totalBonus + bonus
					end
				end
			end
		end
	end

	if totalBonus > 0 then
		capital:SetNumRealBuilding(DUMMY_SCIENCE_BUILDING, totalBonus)
	else
		capital:SetNumRealBuilding(DUMMY_SCIENCE_BUILDING, 0)
	end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_TibetDiplomatScience)

-- UA: City-State periodic Great Person gift
function OnPlayerDoTurn_CityStateFriendGift(iPlayer)
	local player = Players[iPlayer]
	if not player or not player:IsAlive() then
		return
	end
	if not HasTrait(player, traitTibet) then
		return
	end

	local turn = Game.GetGameTurn()
	tCityStateFriendGiftTurn[iPlayer] = tCityStateFriendGiftTurn[iPlayer] or {}

	for csID = 0, GameDefines.MAX_MINOR_CIVS - 1 do
		local cs = Players[csID]
		if cs and cs:IsAlive() and cs:IsMinorCiv() and cs:IsFriends(iPlayer) then
			tCityStateFriendGiftTurn[iPlayer][csID] = tCityStateFriendGiftTurn[iPlayer][csID] or -CS_GIFT_GP_INTERVAL
			if turn - tCityStateFriendGiftTurn[iPlayer][csID] >= CS_GIFT_GP_INTERVAL then
				local trait = cs:GetMinorCivTrait()
				local gpType = MinorTraitToGreatPersonUnit[trait]
				if gpType then
					local capital = player:GetCapitalCity()
					if capital then
						player:InitUnit(gpType, capital:GetX(), capital:GetY())
						if player:IsHuman() and player:IsTurnActive() then
							local gpName = Locale.ConvertTextKey(GameInfo.Units[gpType].Description)
							local csName = Locale.ConvertTextKey(cs:GetNameKey())
							local text = Locale.ConvertTextKey(
								"[COLOR_POSITIVE_TEXT]{1_Unit}[ENDCOLOR] has arrived from {2_CityState}!", gpName,
								csName)
							Events.GameplayAlertMessage(text)
						end
					end
				end
				tCityStateFriendGiftTurn[iPlayer][csID] = turn
			end
		end
	end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_CityStateFriendGift)

-- UU: Kusung strength buff per RA
function OnPlayerDoTurn_KusungBuff(iPlayer)
	local p = Players[iPlayer]
	if not p or not p:IsAlive() then
		return
	end
	if not HasTrait(p, traitTibet) then
		return
	end

	local baseStrength = 50
	local embassyBonus = 0
	local pTeam = Teams[p:GetTeam()]
	for otherPlayerID = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
		if otherPlayerID ~= iPlayer then
			local otherPlayer = Players[otherPlayerID]
			if otherPlayer and otherPlayer:IsAlive() then
				local otherTeam = Teams[otherPlayer:GetTeam()]
				if pTeam:HasEmbassyAtTeam(otherPlayer:GetTeam()) then
					embassyBonus = embassyBonus + 1
				end
			end
		end
	end
	local bonus = (CountActiveRAs(iPlayer) * 2) + (embassyBonus * 2)
	if bonus > 40 then
		bonus = 40
	end

	for unit in p:Units() do
		if unit:GetUnitType() == unitKusungID then
			unit:SetBaseCombatStrength(baseStrength + bonus)
		end
	end
end

GameEvents.PlayerDoTurn.Add(OnPlayerDoTurn_KusungBuff)

-- UU: Trigger WLTKD on Kusung upgrade
function OnUnitUpgraded_KusungWLTKD(iPlayer, iUnitID, iNewUnitID)
	local p = Players[iPlayer]
	if not p or not p:IsAlive() then
		return
	end
	if not HasTrait(p, traitTibet) then
		return
	end

	local unit = p:GetUnitByID(iUnitID)
	if unit and unit:GetUnitType() == unitKusungID then
		for city in p:Cities() do
			city:ChangeWeLoveTheKingDayCounter(BONUS_WLTKD_TURNS)
		end
		if p:IsHuman() and p:IsTurnActive() then
			local msg = "Kusung upgrade has started [COLOR_POSITIVE_TEXT]We Love the King Day[ENDCOLOR] in your cities!"
			Events.GameplayAlertMessage(msg)
		end
	end
end

GameEvents.UnitUpgraded.Add(OnUnitUpgraded_KusungWLTKD)

-- UB: +4 Food and Production per City-State Friend or DoF / Heal units per RA
function OnCityDoTurn_Mentsikhang(iPlayer)
	local p = Players[iPlayer]
	if not p or not p:IsAlive() then
		return
	end
	if not HasTrait(p, traitTibet) then
		return
	end

	for city in p:Cities() do
		if city:IsHasBuilding(GameInfoTypes.BUILDING_MENTSIKHANG) then
			local bonusCount = 0
			for csID = 0, GameDefines.MAX_MINOR_CIVS - 1 do
				if Players[csID]:IsFriends(iPlayer) then
					bonusCount = bonusCount + 4
				end
			end
			for iOtherPlayer = 0, GameDefines.MAX_MAJOR_CIVS - 1 do
				if iOtherPlayer ~= iPlayer then
					local otherPlayer = Players[iOtherPlayer]
					if otherPlayer and otherPlayer:IsAlive() and p:IsDoF(iOtherPlayer) then
						bonusCount = bonusCount + 4
					end
				end
			end

			if city:IsHasBuilding(GameInfoTypes.BUILDING_OBSERVATORY) then
				bonusCount = bonusCount * 2
			end
			city:SetNumRealBuilding(BUILDING_MENTSIKHANG_FOOD, bonusCount)
			city:SetNumRealBuilding(BUILDING_MENTSIKHANG_PROD, bonusCount)
		else
			city:SetNumRealBuilding(BUILDING_MENTSIKHANG_FOOD, 0)
			city:SetNumRealBuilding(BUILDING_MENTSIKHANG_PROD, 0)
		end
	end

	local healAmount = CountActiveRAs(iPlayer) * 10
	if healAmount > 80 then
		healAmount = 80
	end
	if healAmount > 0 then
		local cx, cy = city:GetX(), city:GetY()
		local healed = false
		for unit in p:Units() do
			if unit:GetX() == cx and unit:GetY() == cy then
				unit:ChangeDamage(-healAmount)
				healed = true
			end
		end
		if healed and p:IsHuman() and p:IsTurnActive() then
			Events.GameplayAlertMessage("Units have been healed by a Mentsikhang!")
		end
	end
end

GameEvents.PlayerDoTurn.Add(OnCityDoTurn_Mentsikhang)
