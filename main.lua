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
local buffIdToTrack = 127
local battleFocusBuffId = 13612
local freeRunnerBuffId = 13779


local trackedBuffInfo = {}
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
	canvas:Show(true)
	sigmawolfWindow:Show(true)

	-- api:DoIn(1000, sigmaWolfStop) this doesnt work for some reason
end

local function sigmaWolfStop()
	canvas:Show(false)
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
		ApplyTextColor(zealLabel, {0, 0.2, 0.7, 1})
        ApplyTextColor(zealLabel2, {0.85, 0, 0.5, 1})

		ApplyTextColor(freeRunnerLabel, {0, 0.2, 0.7, 1})
        ApplyTextColor(freeRunnerLabel2, {0.85, 0, 0.5, 1})
		textRand = 1
	else
		ApplyTextColor(zealLabel, {0, 0.2, 1, 1})
		ApplyTextColor(zealLabel2, {1, 0, 0.85, 1})

		ApplyTextColor(freeRunnerLabel, {0, 0.2, 1, 1})
		ApplyTextColor(freeRunnerLabel2, {1, 0, 0.85, 1})
		textRand = 0
	end



	if trackedBuffInfo == nil then
		return
	end
		
	local buffCount = api.Unit:UnitBuffCount("player")
	for i = 1, buffCount, 1 do
		local buff = api.Unit:UnitBuff("player", i)
		if buff.buff_id == trackedBuffInfo.buff_id then
			--canvas:Show(true)
			
			if buff.timeLeft > 31000 and inspireBuff.freshStack == false then
				inspireBuff.freshStack = true
				sigmaWolfActive()
			end
			if buff.timeLeft < 30000 and inspireBuff.freshStack == true then
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
			if buff.timeLeft < 18000 and battleFocusBuff.freshStack == true then
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
			if buff.timeLeft < 28000 and freeRunnerBuff.freshStack == true then
				freeRunnerBuff.freshStack = false
				narutoStop()
			end
			--return
		end
	end

	--canvas:Show(false)
end

local function setSpawnMapImage(mapDdsPath)
	if mapDdsPath == nil then return end
	if dawnsdropMapWindow == nil then return end
	sigmawolfWindow.mapDrawable:SetTexture(mapDdsPath)
end

local function OnLoad()
	-- create window to hold the sigma wolf image
	sigmawolfWindow = api.Interface:CreateWindow("sigmawolfWindow", "wolf")
	sigmawolfWindow:AddAnchor("CENTER", "UIParent", 0, 0)
	sigmawolfWindow:SetExtent(400, 400)

	-- creating drawable for the sigma wolf image
	local mapDrawable = sigmawolfWindow:CreateImageDrawable("Textures/Defaults/White.dds", "overlay")
	mapDrawable:SetExtent(300, 300)
    mapDrawable:AddAnchor("CENTER", sigmawolfWindow, 0, 0)
    mapDrawable:SetVisible(false)
	mapDrawable:SetSRGB(false)

	local visible = mapDrawable:SetTgaTexture("../Addon/buffman/assets/sigma.png")
	mapDrawable:SetVisible(visible)



	-- create empty window to hold the buff icon and text
	canvas = api.Interface:CreateEmptyWindow("zealAlert")
	canvas:Show(false)

	zealLabel = canvas:CreateChildWidget("label", "label", 0, true)
	zealLabel:SetText("ZEAL POPPED")
	zealLabel:AddAnchor("TOPLEFT", canvas, "TOPLEFT", 0, 22)
	zealLabel.style:SetFontSize(44)

	zealIcon = CreateItemIconButton("zealIcon", canvas)
	zealIcon:Show(true)
	F_SLOT.ApplySlotSkin(zealIcon, zealIcon.back, SLOT_STYLE.BUFF)
	zealIcon:AddAnchor("TOPLEFT", canvas, "TOPLEFT", -24, -60)

	trackedBuffInfo = api.Ability:GetBuffTooltip(buffIdToTrack)
	
  	F_SLOT.SetIconBackGround(zealIcon, trackedBuffInfo.path)
	zealLabel:SetText(string.format("%s POPPED", trackedBuffInfo.name))
	ApplyTextColor(zealLabel, {0, 0.2, 1, 1})
	canvas:AddAnchor("CENTER", "UIParent", 0, -300)

	zealLabel2 = canvas:CreateChildWidget("label", "label", 0, true)
	zealLabel2:SetText(string.format("%s POPPED", trackedBuffInfo.name))
	ApplyTextColor(zealLabel2, {1, 0, 0.85, 1})
	zealLabel2:AddAnchor("TOPLEFT", canvas, "TOPLEFT", 5, 27)
	zealLabel2.style:SetFontSize(44)
	----------------------------------

	--battlefocus rank3 13612
	-- create window to hold the guts image
	gutsWindow = api.Interface:CreateWindow("gutsWindow", "u wont like me when im angry")
	gutsWindow:AddAnchor("CENTER", "UIParent", 0, 0)
	gutsWindow:SetExtent(400, 400)

	-- creating drawable for the guts image
	local gutsDrawable = gutsWindow:CreateImageDrawable("Textures/Defaults/White.dds", "overlay")
	gutsDrawable:SetExtent(300, 300)
    gutsDrawable:AddAnchor("CENTER", gutsWindow, 0, 0)
    gutsDrawable:SetVisible(false)
	gutsDrawable:SetSRGB(false)

	local visible = gutsDrawable:SetTgaTexture("../Addon/buffman/assets/guts.png")
	gutsDrawable:SetVisible(visible)

	


	-- create empty window to hold the freerunner buff icon and text	
	freeRunnerCanvas = api.Interface:CreateEmptyWindow("freeRunnerAlert")
	freeRunnerCanvas:Show(false)

	freeRunnerLabel = freeRunnerCanvas:CreateChildWidget("label", "label", 0, true)
	freeRunnerLabel:SetText("FREERUNNER POPPED")
	freeRunnerLabel:AddAnchor("TOPLEFT", freeRunnerCanvas, "TOPLEFT", 0, 22)
	freeRunnerLabel.style:SetFontSize(44)

	freeRunnerIcon = CreateItemIconButton("freeRunnerIcon", freeRunnerCanvas)
	freeRunnerIcon:Show(true)
	F_SLOT.ApplySlotSkin(freeRunnerIcon, freeRunnerIcon.back, SLOT_STYLE.BUFF)
	freeRunnerIcon:AddAnchor("TOPLEFT", freeRunnerCanvas, "TOPLEFT", -24, -60)

	freeRunnerBuffInfo = api.Ability:GetBuffTooltip(freeRunnerBuffId)
	
  	F_SLOT.SetIconBackGround(freeRunnerIcon, freeRunnerBuffInfo.path)
	freeRunnerLabel:SetText(string.format("%s POPPED", freeRunnerBuffInfo.name))
	ApplyTextColor(freeRunnerLabel, {0, 0.2, 1, 1})
	freeRunnerCanvas:AddAnchor("CENTER", "UIParent", 0, -300)

	freeRunnerLabel2 = freeRunnerCanvas:CreateChildWidget("label", "label", 0, true)
	freeRunnerLabel2:SetText(string.format("%s POPPED", freeRunnerBuffInfo.name))
	ApplyTextColor(freeRunnerLabel2, {1, 0, 0.85, 1})
	freeRunnerLabel2:AddAnchor("TOPLEFT", freeRunnerCanvas, "TOPLEFT", 5, 27)
	freeRunnerLabel2.style:SetFontSize(44)

	--freerunner rank2 13779
	-- create window to hold the guts image
	-- narutoWindow = api.Interface:CreateWindow("narutoWindow", "sp33dy boi")
	-- narutoWindow:AddAnchor("CENTER", "UIParent", 0, 0)
	-- narutoWindow:SetExtent(400, 400)

	-- creating drawable for the naruto image
	local narutoDrawable = freeRunnerCanvas:CreateImageDrawable("Textures/Defaults/White.dds", "overlay")
	narutoDrawable:SetExtent(300, 300)
    narutoDrawable:AddAnchor("CENTER", freeRunnerCanvas, 0, 200)
    narutoDrawable:SetVisible(false)
	narutoDrawable:SetSRGB(false)

	local visible = narutoDrawable:SetTgaTexture("../Addon/buffman/assets/naruto.png")
	narutoDrawable:SetVisible(visible)


  api.On("UPDATE", OnUpdate)
end

local function OnUnload()
	if canvas ~= nil then
		canvas:Show(false)
		canvas = nil
	end
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
