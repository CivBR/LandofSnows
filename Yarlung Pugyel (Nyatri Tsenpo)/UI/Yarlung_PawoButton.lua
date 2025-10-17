include("IconSupport.lua")
include("Yarlung_NyatriTsenpo_Functions.lua")

local unitPawoID = GameInfoTypes.UNIT_PAWO

function Pawo_IsButtonPossible(pUnit)
	if pUnit:GetUnitType() == unitPawoID then
		local iPlayer = Game.GetActivePlayer()
		local plot = pUnit:GetPlot()
		if plot then
			-- Check current plot
			if plot:IsCity() then
				local city = plot:GetPlotCity()
				if city and city:GetOwner() == iPlayer then
					return true
				end
			end
			-- Check adjacent plots
			for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1 do
				local adjPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), direction)
				if adjPlot and adjPlot:IsCity() then
					local city = adjPlot:GetPlotCity()
					if city and city:GetOwner() == iPlayer then
						return true
					end
				end
			end
		end
	end
	return false
end

function Pawo_DoChodCeremony()
	local pUnit = UI.GetHeadSelectedUnit()
	local iPlayer = Game.GetActivePlayer()
	if pUnit and pUnit:GetUnitType() == unitPawoID then
		LuaEvents.OnPawo_Ceremony_Trigger(iPlayer, pUnit:GetID())
	end
end

function Pawo_SerialEventUnitInfoDirty()
	local pUnit = UI.GetHeadSelectedUnit()
	if not pUnit then return end
	if Pawo_IsButtonPossible(pUnit) then
		Controls.PawoChodButton:SetHide(false)
	else
		Controls.PawoChodButton:SetHide(true)
	end

	local buildCityButtonActive = pUnit:IsFound()
	local primaryStack = ContextPtr:LookUpControl("/InGame/WorldView/UnitPanel/PrimaryStack")
	local primaryStretchy = ContextPtr:LookUpControl("/InGame/WorldView/UnitPanel/PrimaryStretchy")
	primaryStack:CalculateSize()
	primaryStack:ReprocessAnchoring()
	local stackSize = primaryStack:GetSize()
	local stretchySize = primaryStretchy:GetSize()
	local buildCityButtonSize = 0
	if buildCityButtonActive then
		if OptionsManager.GetSmallUIAssets() and not UI.IsTouchScreenEnabled() then
			buildCityButtonSize = 36
		else
			buildCityButtonSize = 60
		end
	end
	primaryStretchy:SetSizeVal(stretchySize.x, stackSize.y + buildCityButtonSize + 348)
end

function Pawo_UpdateUnitInfoPanel()
	if not OptionsManager.GetSmallUIAssets() then
		Controls.PawoChodButton:SetSizeVal(50, 50)
		Controls.PawoChodButtonImage:SetSizeVal(64, 64)
		Controls.PawoChodButtonImage:SetTexture("UnitAction45_Expansion.dds")
	else
		Controls.PawoChodButton:SetSizeVal(36, 36)
		Controls.PawoChodButtonImage:SetSizeVal(45, 45)
		Controls.PawoChodButtonImage:SetTexture("UnitAction45_Expansion.dds")
	end
	Controls.PawoChodButtonImage:LocalizeAndSetToolTip("TXT_KEY_PAWO_CHOD_BUTTON_TOOLTIP")
	Controls.PawoChodButton:ChangeParent(ContextPtr:LookUpControl("/InGame/WorldView/UnitPanel/PrimaryStack"))
end

function InitializePawoButton()
	Events.LoadScreenClose.Add(Pawo_UpdateUnitInfoPanel)
	Events.SerialEventUnitInfoDirty.Add(Pawo_SerialEventUnitInfoDirty)
	Controls.PawoChodButton:RegisterCallback(Mouse.eLClick, Pawo_DoChodCeremony)
	IconHookup(1, 45, "EXPANSION_UNIT_ACTION_ATLAS", Controls.PawoChodButtonImage)
end

InitializePawoButton()
