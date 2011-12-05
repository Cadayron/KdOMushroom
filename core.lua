-- Wild Mushroom Tracker Addon by Cadayron (ElvUI only)
-- Credits to Hydra and Smelly for code inspiration
local E, L, DF = unpack(ElvUI)

if E.myclass ~= "DRUID" then return end
local mushWidth = (DF.unitframe.layouts.Primary.player.width - (E:Scale(2)))/3 --86
local mushHeight = DF.unitframe.layouts.Primary.player.power.height
local tMushroom = {}
tMushroom = CreateFrame("Frame", "tMushroom", ElvUF_Player)

local function FormatTime(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", ceil(s / day))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	return format("%.1f", s)
end

local OnEvent = function(self, event, slot)
	local haveTotem = GetTotemInfo(slot)
	
	if haveTotem then
		tMushroom[slot]:Show()
	end
end

local OnUpdate = function(self)
	local slot = self.slot
	local haveTotem, totemName, start, duration = GetTotemInfo(slot)
		
	if haveTotem then
		local timeLeft = (start+duration) - GetTime()
		local r, g, b = ElvUF.ColorGradient(timeLeft, duration, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
		tMushroom[slot].status:SetMinMaxValues(0, 300)
		tMushroom[slot].status:SetValue(timeLeft)
		tMushroom[slot].status:SetStatusBarColor(r, g, b)
	else
		tMushroom[slot]:Hide()
	end
end

local OnShow = function(self)
	self:SetScript("OnUpdate", OnUpdate)
end

local OnHide = function(self)
	self:SetScript("OnUpdate", nil)
end

for i = 1, 3 do
	tMushroom[i] = CreateFrame("Frame", "tMushroom"..i, tMushroom)

	tMushroom[i]:SetFrameLevel(0)
	tMushroom[i]:Size(mushWidth, mushHeight)
	tMushroom[i]:SetTemplate("Default")
	tMushroom[i].slot = i
	tMushroom[i]:Hide()
	tMushroom[i]:SetScript("OnShow", OnShow)
	tMushroom[i]:SetScript("OnHide", OnHide)
	
	if i == 1 then
		tMushroom[i]:ClearAllPoints()
		tMushroom[i]:Point("BOTTOMLEFT", ElvUF_Player, "TOPLEFT", 0, 1)
	else
		tMushroom[i]:Point("TOPLEFT", tMushroom[i-1], "TOPRIGHT", 1, 0) 
	end
	
	tMushroom[i].status = CreateFrame("StatusBar", "status"..i, tMushroom[i])
	tMushroom[i].status:SetStatusBarTexture(E["media"].normTex)
	tMushroom[i].status:SetFrameLevel(6)
	tMushroom[i].status:Point("TOPLEFT", tMushroom[i], "TOPLEFT", 2, -2)
	tMushroom[i].status:Point("BOTTOMRIGHT", tMushroom[i], "BOTTOMRIGHT", -2, 2)
end

local UpdateMushroom = CreateFrame("Frame")
UpdateMushroom:RegisterEvent("PLAYER_TOTEM_UPDATE")
UpdateMushroom:SetScript("OnEvent", OnEvent)