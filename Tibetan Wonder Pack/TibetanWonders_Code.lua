WARN_NOT_SHARED = true; include("SaveUtils"); MY_MOD_NAME = "TibetanWonders";
include("PlotIterators.lua")

-- Game Info Types
local yFaith = GameInfoTypes.YIELD_FAITH;
local yFood = GameInfoTypes.YIELD_FOOD;
local yScience = GameInfoTypes.YIELD_SCIENCE;
local yGold = GameInfoTypes.YIELD_GOLD;

-- Wonder Building Types
local wonderYumbuLagang = GameInfoTypes.BUILDING_YUMBU_LAGANG
local wonderJokhangTemple = GameInfoTypes.BUILDING_JOKHANG_TEMPLE
local wonderSamyeMonastery = GameInfoTypes.BUILDING_SAMYE_MONASTERY
local wonderPotalaPalace = GameInfoTypes.BUILDING_POTALA_PALACE
local wonderNorbulingka = GameInfoTypes.BUILDING_NORBULINGKA
local wonderDegeParkhang = GameInfoTypes.BUILDING_DEGE_PARKHANG

-- Unit Types
local missionaryType = GameInfoTypes.UNIT_MISSIONARY
local greatProphetType = GameInfoTypes.UNIT_PROPHET
local inquisitorType = GameInfoTypes.UNIT_INQUISITOR

----------------------------------------------------------
-- YUMBU LAGANG: Mountain Defense Bonus
----------------------------------------------------------
function YumbuLagang_FindOwner(ownerId, cityId, buildingType, bGold, bFaithOrCulture)
	if (wonderYumbuLagang == buildingType) then
		save("YumbuLagang_owner", ownerId)
		save("YumbuLagang_cityId", cityId)
		print("Yumbu Lagang built by player " .. ownerId .. " in city " .. cityId)
		YumbuLagang_UpdateMountainDefense(ownerId)
	end
end

function YumbuLagang_UpdateMountainDefense(playerId)
	local player = Players[playerId]
	if not player then return end

	for city in player:Cities() do
		local cityDefense = 0
		for loopPlot in PlotAreaSpiralIterator(city:Plot(), 3, SECTOR_NORTH, DIRECTION_CLOCKWISE, DIRECTION_OUTWARDS, CENTRE_EXCLUDE) do
			if loopPlot:IsMountain() then
				cityDefense = cityDefense + 5
			end
		end
		if cityDefense > 0 then
			-- Add mountain defense bonus to city
			Game.SetCityExtraDefense(city:GetX(), city:GetY(), cityDefense)
		end
	end
end

----------------------------------------------------------
-- JOKHANG TEMPLE: Foreign Great Work Faith Bonus
----------------------------------------------------------
function JokhangTemple_FindOwner(ownerId, cityId, buildingType, bGold, bFaithOrCulture)
	if (wonderJokhangTemple == buildingType) then
		save("JokhangTemple_owner", ownerId)
		save("JokhangTemple_cityId", cityId)
		print("Jokhang Temple built by player " .. ownerId .. " in city " .. cityId)
	end
end

function JokhangTemple_CheckGreatWorks(playerId)
	if playerId ~= load("JokhangTemple_owner") then return end

	local player = Players[playerId]
	local city = player:GetCityByID(load("JokhangTemple_cityId"))
	if not city then return end

	local faithBonus = 0
	local buildingInfo = GameInfo.Buildings[wonderJokhangTemple]

	-- Check for foreign great works in the city
	for building in city:Buildings() do
		if building:GetNumGreatWorks() > 0 then
			for i = 0, building:GetNumGreatWorks() - 1 do
				local greatWork = building:GetGreatWork(i)
				if greatWork and greatWork:GetPlayer() ~= playerId then
					faithBonus = faithBonus + 3
				end
			end
		end
	end

	-- Apply faith bonus
	if faithBonus > 0 then
		city:SetNumRealBuilding(GameInfoTypes.BUILDING_FAITH_BONUS, faithBonus)
	end
end

----------------------------------------------------------
-- SAMYE MONASTERY: Religious Unit Movement Bonus
----------------------------------------------------------
function SamyeMonastery_FindOwner(ownerId, cityId, buildingType, bGold, bFaithOrCulture)
	if (wonderSamyeMonastery == buildingType) then
		save("SamyeMonastery_owner", ownerId)
		print("Samye Monastery built by player " .. ownerId)
	end
end

function SamyeMonastery_UnitMovementBonus(playerId, unitId)
	if playerId ~= load("SamyeMonastery_owner") then return end

	local player = Players[playerId]
	local unit = player:GetUnitByID(unitId)
	if not unit then return end

	local unitType = unit:GetUnitType()
	if unitType == missionaryType or unitType == greatProphetType or unitType == inquisitorType then
		unit:SetMoves(unit:GetMoves() + 60) -- +1 movement point
	end
end

----------------------------------------------------------
-- POTALA PALACE: Defense from Religious Followers
----------------------------------------------------------
function PotalaPalace_FindOwner(ownerId, cityId, buildingType, bGold, bFaithOrCulture)
	if (wonderPotalaPalace == buildingType) then
		save("PotalaPalace_owner", ownerId)
		print("Potala Palace built by player " .. ownerId)
		PotalaPalace_UpdateDefense(ownerId)
	end
end

function PotalaPalace_UpdateDefense(playerId)
	local player = Players[playerId]
	if not player then return end

	for city in player:Cities() do
		local defenseBonus = 0
		local totalFollowers = 0

		-- Count religious followers in the city
		for religion = 0, GameDefines.RELIGION_LAST - 1 do
			totalFollowers = totalFollowers + city:GetNumFollowers(religion)
		end

		defenseBonus = math.floor(totalFollowers / 100) * 5 -- 5 defense per 100 followers
		if defenseBonus > 0 then
			Game.SetCityExtraDefense(city:GetX(), city:GetY(), defenseBonus)
		end
	end
end

----------------------------------------------------------
-- NORBULINGKA: Garden Efficacy Doubling
----------------------------------------------------------
function Norbulingka_FindOwner(ownerId, cityId, buildingType, bGold, bFaithOrCulture)
	if (wonderNorbulingka == buildingType) then
		save("Norbulingka_owner", ownerId)
		print("Norbulingka built by player " .. ownerId)
		Norbulingka_UpdateGardens(ownerId)
	end
end

function Norbulingka_UpdateGardens(playerId)
	local player = Players[playerId]
	if not player then return end

	for city in player:Cities() do
		if city:IsHasBuilding(GameInfoTypes.BUILDING_GARDEN) then
			-- Double garden food yield
			city:SetNumRealBuilding(GameInfoTypes.BUILDING_GARDEN_BONUS, 1)
		end
	end
end

----------------------------------------------------------
-- DEGE PARKHANG: Religious Pressure from Great Works
----------------------------------------------------------
function DegeParkhang_FindOwner(ownerId, cityId, buildingType, bGold, bFaithOrCulture)
	if (wonderDegeParkhang == buildingType) then
		save("DegeParkhang_owner", ownerId)
		save("DegeParkhang_cityId", cityId)
		print("Dégé Parkhang built by player " .. ownerId .. " in city " .. cityId)
	end
end

function DegeParkhang_UpdateReligiousPressure(playerId)
	if playerId ~= load("DegeParkhang_owner") then return end

	local player = Players[playerId]
	local city = player:GetCityByID(load("DegeParkhang_cityId"))
	if not city then return end

	local literatureWorks = 0

	-- Count Great Works of Writing in the city
	for building in city:Buildings() do
		if building:GetNumGreatWorks() > 0 then
			for i = 0, building:GetNumGreatWorks() - 1 do
				local greatWork = building:GetGreatWork(i)
				if greatWork and greatWork:GetGreatWorkType() == GameInfoTypes.GREAT_WORK_LITERATURE then
					literatureWorks = literatureWorks + 1
				end
			end
		end
	end

	-- Increase religious pressure based on literature works
	if literatureWorks > 0 then
		local pressureBonus = literatureWorks * 2
		local religionType = player:GetReligionCreatedByPlayer()
		if religionType > 0 then
			Game.SetCityReligiousPressure(city:GetX(), city:GetY(), religionType, pressureBonus, 6 + literatureWorks)
		end
	end
end

----------------------------------------------------------
-- EVENT REGISTRATIONS
----------------------------------------------------------
GameEvents.CityConstructed.Add(YumbuLagang_FindOwner)
GameEvents.CityConstructed.Add(JokhangTemple_FindOwner)
GameEvents.CityConstructed.Add(SamyeMonastery_FindOwner)
GameEvents.CityConstructed.Add(PotalaPalace_FindOwner)
GameEvents.CityConstructed.Add(Norbulingka_FindOwner)
GameEvents.CityConstructed.Add(DegeParkhang_FindOwner)

-- Update events
GameEvents.PlayerDoTurn.Add(function(playerId)
	YumbuLagang_UpdateMountainDefense(playerId)
	JokhangTemple_CheckGreatWorks(playerId)
	PotalaPalace_UpdateDefense(playerId)
	Norbulingka_UpdateGardens(playerId)
	DegeParkhang_UpdateReligiousPressure(playerId)
end)

-- Unit movement bonus for Samye Monastery
GameEvents.UnitCreated.Add(SamyeMonastery_UnitMovementBonus)

-- City capture updates
GameEvents.CityCaptureComplete.Add(function(iOldOwner, bIsCapital, iX, iY, iNewOwner, iPop, bConquest)
	local plot = Map.GetPlot(iX, iY)
	local city = plot:GetPlotCity()

	if city:IsHasBuilding(wonderYumbuLagang) then
		save("YumbuLagang_owner", iNewOwner)
		YumbuLagang_UpdateMountainDefense(iNewOwner)
	end

	if city:IsHasBuilding(wonderJokhangTemple) then
		save("JokhangTemple_owner", iNewOwner)
		save("JokhangTemple_cityId", city:GetID())
	end

	if city:IsHasBuilding(wonderSamyeMonastery) then
		save("SamyeMonastery_owner", iNewOwner)
	end

	if city:IsHasBuilding(wonderPotalaPalace) then
		save("PotalaPalace_owner", iNewOwner)
		PotalaPalace_UpdateDefense(iNewOwner)
	end

	if city:IsHasBuilding(wonderNorbulingka) then
		save("Norbulingka_owner", iNewOwner)
		Norbulingka_UpdateGardens(iNewOwner)
	end

	if city:IsHasBuilding(wonderDegeParkhang) then
		save("DegeParkhang_owner", iNewOwner)
		save("DegeParkhang_cityId", city:GetID())
	end
end)

print("Tibetan Wonder Pack - Custom Mechanics Loaded Successfully")
