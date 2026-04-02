local api = require("api")


local buffman = {
	name = "Buffman",
	author = "Powerpoint",
	version = "0.3",
	desc = "You're so buff, man, take off your shirt bro."
}

--battlefocus rank3 13612
--freerunner rank2 13779
-- Changing this ID will change the buff displayed & tracked
-- (127 is the ID for Inspire buff that thwart applies)
local inspiredBuffId = 127
local inspiredBuffInfo = {}
local inspiredWindow
local inspiredLabel
local inspiredLabel2

local battleFocusBuffId = 13612
local battleFocusBuffInfo = {}
local battleFocusWindow
local battleFocusLabel
local battleFocusLabel2

local freeRunnerBuffId = 13779
local freeRunnerBuffInfo = {}
local freeRunnerWindow
local freeRunnerLabel
local freeRunnerLabel2



function randIntEither()
  if math.random() < 0.5 then
    return math.random(-500, -100)
  else
    return math.random(100, 500)
  end
end

local inspireBuff = {
	buffId = 127,
	isActive = false,
	window = window,
	title = "wolf",
	drawable = drawable,
	meme = "../Addon/buffman/assets/sigma.png",
	label1 = label1,
	label2 = label2,
}
local battleFocusBuff = {
	buffId = 13612,
	isActive = false,
	window = window,
	title = "u wont like me when im angry",
	drawable = drawable,
	meme = "../Addon/buffman/assets/guts.png",
	label1 = label1,
	label2 = label2,
}
local freeRunnerBuff = {
	buffId = 13779,
	isActive = false,
	window = window,
	title = "im fast af boi",
	drawable = drawable,
	meme = "../Addon/buffman/assets/naruto.png",
	label1 = label1,
	label2 = label2,
}
local frenzyBuff = {
	buffId = 182,
	isActive = false,
	window = window,
	title = "i miss my wife",
	drawable = drawable,
	meme = "../Addon/buffman/assets/corndog.png",
	label1 = label1,
	label2 = label2,
}

local function buffActive(trackedBuff)
	-- xPos = randIntEither()
	-- yPos = randIntEither()
	trackedBuff:AddAnchor("CENTER", "UIParent", randIntEither(), randIntEither())
	trackedBuff:Show(true)

	-- api:DoIn(1000, inspiredStop) this doesnt work for some reason
end

local function buffInactive(trackedBuff)
	trackedBuff:Show(false)
end

local lastUpdate = 0
local textRand = 0

local function OnUpdate(dt)
	--slowing down OnUpdate to only run every 100ms (10 times per second)
	lastUpdate = lastUpdate + dt
    if lastUpdate < 100 then
        return
    end

    lastUpdate = dt
	-----------------------------
	--textRand = math.random(1, 2)
	--alternate text color every update to make it flashy
	if textRand == 0 then
		ApplyTextColor(inspireBuff.label1, {0, 0.2, 0.7, 1})
        ApplyTextColor(inspireBuff.label2, {0.85, 0, 0.5, 1})

		ApplyTextColor(freeRunnerBuff.label1, {0, 0.2, 0.7, 1})
        ApplyTextColor(freeRunnerBuff.label2, {0.85, 0, 0.5, 1})

		ApplyTextColor(battleFocusBuff.label1, {0, 0.2, 0.7, 1})
        ApplyTextColor(battleFocusBuff.label2, {0.85, 0, 0.5, 1})

		ApplyTextColor(frenzyBuff.label1, {0, 0.2, 0.7, 1})
		ApplyTextColor(frenzyBuff.label2, {0.85, 0, 0.5, 1})
		textRand = 1
	else
		ApplyTextColor(inspireBuff.label1, {0, 0.2, 1, 1})
		ApplyTextColor(inspireBuff.label2, {1, 0, 0.85, 1})

		ApplyTextColor(freeRunnerBuff.label1, {0, 0.2, 1, 1})
		ApplyTextColor(freeRunnerBuff.label2, {1, 0, 0.85, 1})

		ApplyTextColor(battleFocusBuff.label1, {0, 0.2, 1, 1})
		ApplyTextColor(battleFocusBuff.label2, {1, 0, 0.85, 1})

		ApplyTextColor(frenzyBuff.label1, {0, 0.2, 1, 1})
		ApplyTextColor(frenzyBuff.label2, {1, 0, 0.85, 1})
		textRand = 0
	end



	if inspiredBuffInfo == nil then
		return
	end
		
	local buffCount = api.Unit:UnitBuffCount("player")
	for i = 1, buffCount, 1 do
		local buff = api.Unit:UnitBuff("player", i)
		if buff.buff_id == inspireBuff.buffId then
			if buff.timeLeft > 31000 and inspireBuff.isActive == false then
				inspireBuff.isActive = true
				buffActive(inspireBuff.window)
			end
			if buff.timeLeft < 21000 and inspireBuff.isActive == true then
				inspireBuff.isActive = false
				buffInactive(inspireBuff.window)
			end
			--return
		end
		if buff.buff_id == battleFocusBuff.buffId then
			if buff.timeLeft > 19000 and battleFocusBuff.isActive == false then
				battleFocusBuff.isActive = true
				buffActive(battleFocusBuff.window)
			end
			if buff.timeLeft < 9000 and battleFocusBuff.isActive == true then
				battleFocusBuff.isActive = false
				buffInactive(battleFocusBuff.window)
			end
			--return
		end
		if buff.buff_id == freeRunnerBuff.buffId then
			if buff.timeLeft > 29000 and freeRunnerBuff.isActive == false then
				freeRunnerBuff.isActive = true
				buffActive(freeRunnerBuff.window)
			end
			if buff.timeLeft < 18000 and freeRunnerBuff.isActive == true then
				freeRunnerBuff.isActive = false
				buffInactive(freeRunnerBuff.window)
			end
			--return
		end
		if buff.buff_id == frenzyBuff.buffId then
			if buff.timeLeft > 19000 and frenzyBuff.isActive == false then
				frenzyBuff.isActive = true
				buffActive(frenzyBuff.window)
			end
			if buff.timeLeft < 10000 and frenzyBuff.isActive == true then
				frenzyBuff.isActive = false
				buffInactive(frenzyBuff.window)
			end
			--return
		end
	end

	--canvas:Show(false)
end

local function buffBuilder(buffWindow, buffInfo, memeDrawable, label1, label2)
	-- setup the buff window attributes
	buffWindow:AddAnchor("CENTER", "UIParent", 0, 0)
	buffWindow:SetExtent(300, 300)
	buffWindow:SetSounds("community")
	
	-- setup drawable attributes for the meme image
	memeDrawable:SetExtent(250, 250)
    memeDrawable:AddAnchor("CENTER", buffWindow, 0, 10)
	memeDrawable:SetSRGB(false)
	memeDrawable:SetVisible(true)

	-- create 2 text labels for the buff name, offset slightly to create a shadow effect
	label1:AddAnchor("TOP", buffWindow, "TOP", 0, -35)
	label1:SetText(string.format("%s POPPED", buffInfo.name))
	ApplyTextColor(label1, {0, 0.2, 1, 1})
	label1.style:SetFontSize(44)

	label2:AddAnchor("TOP", buffWindow, "TOP", 5, -30)
	label2:SetText(string.format("%s POPPED", buffInfo.name))
	ApplyTextColor(label2, {1, 0, 0.85, 1})
	label2.style:SetFontSize(44)
end

local function buffBuilderCopy(trackedBuff)
	local buffInfo = api.Ability:GetBuffTooltip(trackedBuff.buffId)

	-- setup the buff window attributes
	trackedBuff.window = api.Interface:CreateWindow("inspiredWindow", trackedBuff.title)
	trackedBuff.window:AddAnchor("CENTER", "UIParent", 0, 0)
	trackedBuff.window:SetExtent(300, 300)
	trackedBuff.window:SetSounds("community")
	
	-- setup drawable attributes for the meme image
	trackedBuff.drawable = trackedBuff.window:CreateImageDrawable("Textures/Defaults/White.dds", "overlay")
	trackedBuff.drawable:SetTgaTexture(trackedBuff.meme)
	trackedBuff.drawable:SetExtent(250, 250)
    trackedBuff.drawable:AddAnchor("CENTER", trackedBuff.window, 0, 10)
	trackedBuff.drawable:SetSRGB(false)
	trackedBuff.drawable:SetVisible(true)

	-- create 2 text labels for the buff name, offset slightly to create a shadow effect
	trackedBuff.label1 = trackedBuff.window:CreateChildWidget("label", "label", 0, true)
	trackedBuff.label1:AddAnchor("TOP", trackedBuff.window, "TOP", 0, -35)
	trackedBuff.label1:SetText(string.format("%s POPPED", buffInfo.name))
	ApplyTextColor(trackedBuff.label1, {0, 0.2, 1, 1})
	trackedBuff.label1.style:SetFontSize(44)

	trackedBuff.label2 = trackedBuff.window:CreateChildWidget("label", "label", 0, true)
	trackedBuff.label2:AddAnchor("TOP", trackedBuff.window, "TOP", 5, -30)
	trackedBuff.label2:SetText(string.format("%s POPPED", buffInfo.name))
	ApplyTextColor(trackedBuff.label2, {1, 0, 0.85, 1})
	trackedBuff.label2.style:SetFontSize(44)
end

local function OnLoad()
	-- inspired buff setup: rank6 buffid = 127
	-- create window to hold the sigma wolf image
	buffBuilderCopy(inspireBuff)
	-- end inspired buff setup


	-- battlefocus buff setup: rank3 buffid = 13612
	-- create window to hold the battleFocus image
	buffBuilderCopy(battleFocusBuff)
	-- end battlefocus buff setup


	--freerunner buff setup: rank2 buffid = 13779
	-- create empty window to hold the freerunner buff icon and text	
	buffBuilderCopy(freeRunnerBuff)
	-- end freerunner buff setup

	--frenzy buff setup: rank1 buffid = 182
	-- create empty window to hold the frenzy buff icon and text	
	buffBuilderCopy(frenzyBuff)
	-- end freerunner buff setup


  api.On("UPDATE", OnUpdate)
end

local function OnUnload()
    if inspireBuff.window ~= nil then
        inspireBuff.window:Show(false)
        inspireBuff.window = nil
    end

	if battleFocusBuff.window ~= nil then
        battleFocusBuff.window:Show(false)
        battleFocusBuff.window = nil
    end

	if freeRunnerBuff.window ~= nil then
        freeRunnerBuff.window:Show(false)
        freeRunnerBuff.window = nil
    end
end

buffman.OnLoad = OnLoad
buffman.OnUnload = OnUnload

return buffman
