local api = require("api")


local buffman = {
	name = "Buffman",
	author = "Powerpoint",
	version = "0.3",
	desc = "You're so buff, man, take off your shirt bro."
}

local sigmawolfWindow

--battlefocus rank3 13612
--freerunner rank2 13779
-- Changing this ID will change the buff displayed & tracked
-- (127 is the ID for Inspire buff that thwart applies)
local inspiredBuffId = 127
local battleFocusBuffId = 13612
local freeRunnerBuffId = 13779


local inspiredBuffInfo = {}
local battleFocusBuffInfo = {}
local freeRunnerBuffInfo = {}

local xPos = 0
local yPos = 0


function randIntEither()
  if math.random() < 0.5 then
    return math.random(-500, -100)
  else
    return math.random(100, 500)
  end
end

local inspireBuff = {
	freshStack = false,
	stackTime = 0
}
local battleFocusBuff = {
	freshStack = false,
	stackTime = 0
}
local freeRunnerBuff = {
	freshStack = false,
	stackTime = 0
}

local function sigmaWolfActive()
	xPos = randIntEither()
	yPos = randIntEither()
	sigmawolfWindow:AddAnchor("CENTER", "UIParent", xPos, yPos)
	

	-- show the sigma wolf image
	sigmawolfWindow:Show(true)

	-- api:DoIn(1000, sigmaWolfStop) this doesnt work for some reason
end

local function sigmaWolfStop()
	sigmawolfWindow:Show(false)
end

local function gutsActive()
	gutsWindow:AddAnchor("CENTER", "UIParent", randIntEither(), randIntEither())
	

	-- show the sigma wolf image
	gutsWindow:Show(true)
end

local function gutsStop()
	gutsWindow:Show(false)
end

local function narutoActive()
	freeRunnerCanvas:AddAnchor("CENTER", "UIParent", randIntEither(), randIntEither())
	

	-- show the sigma wolf image
	freeRunnerCanvas:Show(true)
	-- narutoWindow:Show(true)
end

local function narutoStop()
	freeRunnerCanvas:Show(false)
	-- narutoWindow:Show(false)
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
		ApplyTextColor(inspiredLabel, {0, 0.2, 0.7, 1})
        ApplyTextColor(inspiredLabel2, {0.85, 0, 0.5, 1})

		ApplyTextColor(freeRunnerLabel, {0, 0.2, 0.7, 1})
        ApplyTextColor(freeRunnerLabel2, {0.85, 0, 0.5, 1})

		ApplyTextColor(battleFocusLabel, {0, 0.2, 0.7, 1})
        ApplyTextColor(battleFocusLabel2, {0.85, 0, 0.5, 1})
		textRand = 1
	else
		ApplyTextColor(inspiredLabel, {0, 0.2, 1, 1})
		ApplyTextColor(inspiredLabel2, {1, 0, 0.85, 1})

		ApplyTextColor(freeRunnerLabel, {0, 0.2, 1, 1})
		ApplyTextColor(freeRunnerLabel2, {1, 0, 0.85, 1})

		ApplyTextColor(battleFocusLabel, {0, 0.2, 1, 1})
		ApplyTextColor(battleFocusLabel2, {1, 0, 0.85, 1})
		textRand = 0
	end



	if inspiredBuffInfo == nil then
		return
	end
		
	local buffCount = api.Unit:UnitBuffCount("player")
	for i = 1, buffCount, 1 do
		local buff = api.Unit:UnitBuff("player", i)
		if buff.buff_id == inspiredBuffInfo.buff_id then
			if buff.timeLeft > 31000 and inspireBuff.freshStack == false then
				inspireBuff.freshStack = true
				sigmaWolfActive()
			end
			if buff.timeLeft < 21000 and inspireBuff.freshStack == true then
				inspireBuff.freshStack = false
				sigmaWolfStop()
			end
			--return
		end
		if buff.buff_id == battleFocusBuffId then
			if buff.timeLeft > 19000 and battleFocusBuff.freshStack == false then
				battleFocusBuff.freshStack = true
				gutsActive()
			end
			if buff.timeLeft < 9000 and battleFocusBuff.freshStack == true then
				battleFocusBuff.freshStack = false
				gutsStop()
			end
			--return
		end
		if buff.buff_id == freeRunnerBuffId then
			if buff.timeLeft > 29000 and freeRunnerBuff.freshStack == false then
				freeRunnerBuff.freshStack = true
				narutoActive()
			end
			if buff.timeLeft < 18000 and freeRunnerBuff.freshStack == true then
				freeRunnerBuff.freshStack = false
				narutoStop()
			end
			--return
		end
	end

	--canvas:Show(false)
end


local function OnLoad()
	-- inspired buff steup: rank6 buffid = 127
	inspiredBuffInfo = api.Ability:GetBuffTooltip(inspiredBuffId)
	-- create window to hold the sigma wolf image
	sigmawolfWindow = api.Interface:CreateWindow("sigmawolfWindow", "wolf")
	sigmawolfWindow:AddAnchor("CENTER", "UIParent", 0, 0)
	sigmawolfWindow:SetExtent(300, 300)
	sigmawolfWindow:SetSounds("community")

	-- creating drawable for the sigma wolf image
	local mapDrawable = sigmawolfWindow:CreateImageDrawable("Textures/Defaults/White.dds", "overlay")
	mapDrawable:SetExtent(250, 250)
    mapDrawable:AddAnchor("CENTER", sigmawolfWindow, 0, 10)
	mapDrawable:SetSRGB(false)
	mapDrawable:SetTgaTexture("../Addon/buffman/assets/sigma.png")
	mapDrawable:SetVisible(true)

	-- create 2 text labels for the buff name, offset slightly to create a shadow effect
	inspiredLabel = sigmawolfWindow:CreateChildWidget("label", "label", 0, true)
	inspiredLabel:AddAnchor("TOP", sigmawolfWindow, "TOP", 0, -35)
	inspiredLabel:SetText(string.format("%s POPPED", inspiredBuffInfo.name))
	ApplyTextColor(inspiredLabel, {0, 0.2, 1, 1})
	inspiredLabel.style:SetFontSize(44)


	inspiredLabel2 = sigmawolfWindow:CreateChildWidget("label", "label", 0, true)
	inspiredLabel2:AddAnchor("TOP", sigmawolfWindow, "TOP", 5, -30)
	inspiredLabel2:SetText(string.format("%s POPPED", inspiredBuffInfo.name))
	ApplyTextColor(inspiredLabel2, {1, 0, 0.85, 1})
	inspiredLabel2.style:SetFontSize(44)
	-- end inspired buff setup


	-- battlefocus buff setup: rank3 buffid = 13612
	battleFocusBuffInfo = api.Ability:GetBuffTooltip(battleFocusBuffId)
	-- create window to hold the guts image
	gutsWindow = api.Interface:CreateWindow("gutsWindow", "u wont like me when im angry")
	gutsWindow:AddAnchor("CENTER", "UIParent", 0, 0)
	gutsWindow:SetExtent(300, 300)
	gutsWindow:SetSounds("community")

	-- creating drawable for the guts image
	local gutsDrawable = gutsWindow:CreateImageDrawable("Textures/Defaults/White.dds", "overlay")
	gutsDrawable:SetExtent(250, 250)
    gutsDrawable:AddAnchor("CENTER", gutsWindow, 0, 10)
	gutsDrawable:SetSRGB(false)
	gutsDrawable:SetTgaTexture("../Addon/buffman/assets/guts.png")
	gutsDrawable:SetVisible(true)

	-- create 2 text labels for the buff name, offset slightly to create a shadow effect
	battleFocusLabel = gutsWindow:CreateChildWidget("label", "label", 0, true)
	battleFocusLabel:AddAnchor("TOP", gutsWindow, "TOP", 0, -35)
	battleFocusLabel:SetText(string.format("%s POPPED", battleFocusBuffInfo.name))
	ApplyTextColor(battleFocusLabel, {0, 0.2, 1, 1})
	battleFocusLabel.style:SetFontSize(44)


	battleFocusLabel2 = gutsWindow:CreateChildWidget("label", "label", 0, true)
	battleFocusLabel2:AddAnchor("TOP", gutsWindow, "TOP", 5, -30)
	battleFocusLabel2:SetText(string.format("%s POPPED", battleFocusBuffInfo.name))
	ApplyTextColor(battleFocusLabel2, {1, 0, 0.85, 1})
	battleFocusLabel2.style:SetFontSize(44)
	-- end battlefocus buff setup




	--freerunner rank2 13779
	freeRunnerBuffInfo = api.Ability:GetBuffTooltip(freeRunnerBuffId)
	-- create empty window to hold the freerunner buff icon and text	
	freeRunnerCanvas = api.Interface:CreateWindow("freeRunnerAlert", "im fast as fuck boi")
	freeRunnerCanvas:AddAnchor("CENTER", "UIParent", 0, 0)
	freeRunnerCanvas:SetExtent(300, 300)
	freeRunnerCanvas:SetSounds("community")

	-- creating drawable for the naruto image
	local narutoDrawable = freeRunnerCanvas:CreateImageDrawable("Textures/Defaults/White.dds", "overlay")
	narutoDrawable:SetExtent(250, 250)
    narutoDrawable:AddAnchor("CENTER", freeRunnerCanvas, 0, 10)
	narutoDrawable:SetSRGB(false)
	narutoDrawable:SetTgaTexture("../Addon/buffman/assets/naruto.png")
	narutoDrawable:SetVisible(true)

	
	freeRunnerLabel = freeRunnerCanvas:CreateChildWidget("label", "label", 0, true)
	freeRunnerLabel:SetText(string.format("%s POPPED", freeRunnerBuffInfo.name))
	ApplyTextColor(freeRunnerLabel, {0, 0.2, 1, 1})
	freeRunnerLabel:AddAnchor("TOP", freeRunnerCanvas, "TOP", 0, -35)
	freeRunnerLabel.style:SetFontSize(44)
	

	freeRunnerLabel2 = freeRunnerCanvas:CreateChildWidget("label", "label", 0, true)
	freeRunnerLabel2:SetText(string.format("%s POPPED", freeRunnerBuffInfo.name))
	ApplyTextColor(freeRunnerLabel2, {1, 0, 0.85, 1})
	freeRunnerLabel2:AddAnchor("TOP", freeRunnerCanvas, "TOP", 5, -30)
	freeRunnerLabel2.style:SetFontSize(44)

	
	


  api.On("UPDATE", OnUpdate)
end

local function OnUnload()
	if freeRunnerCanvas ~= nil then
		freeRunnerCanvas:Show(false)
		freeRunnerCanvas = nil
	end

    if sigmawolfWindow ~= nil then
        sigmawolfWindow:Show(false)
        sigmawolfWindow = nil
    end

	if gutsWindow ~= nil then
        gutsWindow:Show(false)
        gutsWindow = nil
    end

	if narutoWindow ~= nil then
        narutoWindow:Show(false)
        narutoWindow = nil
    end
end

buffman.OnLoad = OnLoad
buffman.OnUnload = OnUnload

return buffman
