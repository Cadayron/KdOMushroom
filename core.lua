-- Wild Mushroom Tracker Addon by Cadayron (ElvUI only)
-- Credits to Hydra and Smelly for code inspiration
local E, L, DF = unpack(ElvUI)

if E.myclass ~= "DRUID" then return end
local mushWidth = (DF.unitframe.layouts.Primary.player.width - (E:Scale(2)))/3 --86
local mushHeight = DF.unitframe.layouts.Primary.player.power.height
local tMushroom = {}

tMushroom = CreateFrame("Frame", "tMushroom", ElvUF_Player)
for i = 1, 3 do
	tMushroom[i] = CreateFrame("Frame", "tMushroom"..i, tMushroom)

	tMushroom[i]:SetFrameLevel(0)
	tMushroom[i]:Size(mushWidth, mushHeight)
	tMushroom[i]:SetTemplate("Default")
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

local function MushroomUpdate(self)
	for i = 1, 3 do
		local haveTotem, totemName, start, duration = GetTotemInfo(i)
		if haveTotem then
			tMushroom[i]:Show()
			local timeLeft = (start+duration) - GetTime()
			tMushroom[i].status:SetMinMaxValues(0, 300)
			tMushroom[i].status:SetValue(timeLeft)
			local r, g, b = ElvUF.ColorGradient(timeLeft, duration, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			tMushroom[i].status:SetStatusBarColor(r, g, b)
		else
			tMushroom[i]:Hide()
		end
	end 	
	
end

local UpdateMushroom = CreateFrame("Frame")
UpdateMushroom:SetScript("OnUpdate", MushroomUpdate)