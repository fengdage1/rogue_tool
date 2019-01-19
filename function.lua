function initIconSpells()
	for k,v in pairs(spellIcons) do
		iconSpells[v]=k
	end
end

function initCooldownSpells()
	for k,v in pairs(spellCooldownSlots) do
		coolDownSpell[k]=0
	end
end

function updatePlayerDebuff()
	local debuffs={}
	for i=1,debuffCnt,1 do
		local icon=UnitDebuff("player",i)
		if icon ~= nil then
			debuffs[icon]=true
		end
	end
	playerDebuffs=debuffs
end


function updatePlayerBuff()
	local buffs={}
	for i=1,buffCnt,1 do
		local icon=UnitBuff("player",i)
		if icon ~= nil then
			buffs[icon]=true
		end
	end
	playerBuffs = buffs
end

function updateTargetDebuff()
	local debuffs={}
	for i=1,debuffCnt,1 do
		local icon=UnitDebuff("target",i)
		if icon ~= nil then
			debuffs[icon]=true
		end
	end
	targetDebuffs = debuffs
end

function isPlayerDebuffExist(debuff)
	return playerDebuffs[spellIcons[debuff]]
end

function isPlayerBuffExist(buff)
	return playerBuffs[spellIcons[buff]]
end

function isTargetDebuffExist(debuff)
	return targetDebuffs[spellIcons[debuff]]
end

function updateCooldown()
	for k, v in pairs(spellCooldownSlots) do  
		local s, d = GetActionCooldown(spellCooldownSlots[k]);
		if d == 0 or d== 1 then
			coolDownSpell[k]=0
		else
			coolDownSpell[k]=s+d
		end
	end
end

function isSpellCooldown(spell)
	return coolDownSpell[spell] == 0
end

function updateRange()
	if IsActionInRange(spellSlots["Sinister Strike"])==1 then
		range=1
	elseif IsActionInRange(spellSlots["Shoot Bow"]) == 0 and IsActionInRange(spellSlots["Blind"]) == 1 then
		range=2
	else
		range=3
	end
end

function updateTrinket()
	GetInventoryItemTexture("player",13)
end

function updateControlInfo()
	local kidneyEnd = playerControl[playerName]["Kidney Shot"]["end"]
	local cheapEnd = playerControl[playerName]["Cheap Shot"]["end"]
	local gougeEnd = playerControl[playerName]["Gouge"]["end"]
	if kidneyEnd == nil then
		kidneyEnd=0
	end
	if cheapEnd == nil then
		cheapEnd = 0
	end
	if gougeEnd == nil then
		gougeEnd = 0
	end
	local stunEnd = 0
	if kidneyEnd > cheapEnd then
		stunEnd=kidneyEnd
	else
		stunEnd=cheapEnd
	end
	local now = GetTime()
	if stunEnd>now and stunEnd >= gougeEnd then
		controlInfo["type"]=STUN
		controlInfo["end"] = stunEnd
	elseif gougeEnd>now and gougeEnd>stunEnd then
		controlInfo["type"]=INCAP
		controlInfo["end"] = gougeEnd
	else
		controlInfo["type"]=nil
		controlInfo["end"] = nil
	end
end

function updateMainframe()
	if nextControl ~= nil then
		MAIN_FRAME.texture:SetTexture(spellIcons[nextControl])
	elseif cs == "Backstab" then
		MAIN_FRAME.texture:SetTexture(spellIcons["Backstab"])
	elseif cs == "Ambush" then 
		MAIN_FRAME.texture:SetTexture(spellIcons["Ambush"])
	else
		MAIN_FRAME.texture:SetTexture(spellIcons["Fear"])
	end
	if range==1 then
		MAIN_FRAME.texture:SetVertexColor(1,1,1)
	elseif range==2 then
		MAIN_FRAME.texture:SetVertexColor(0,1,0)
	elseif range==3 then
		MAIN_FRAME.texture:SetVertexColor(1,0,0)
	end
	local now = GetTime()
	if now<controlInfo["end"]-CONTROL_END_TIME_OFFSET then
		this.FontString:SetTextColor(1,0,0,1)
		MAIN_FRAME.FontString:SetText(math.floor(controlInfo["end"]-now))
		this.FontString:SetAlpha(1)
	else
		local c,t=getControlPreview()
		if t>now then
			this.FontString:SetTextColor(0,1,1,1)
			MAIN_FRAME.FontString:SetText(math.floor(t-now))
			this.FontString:SetAlpha(1)
		else
			this.FontString:SetAlpha(0)
		end
	end
end

function getControlPreview()
	local controlList={
		--[playerControl[playerName]["Cheap Shot"]["reset"]]="Cheap Shot",
		[max(playerControl[playerName]["Kidney Shot"]["reset"],coolDownSpell["Kidney Shot"])]="Kidney Shot",
		[max(playerControl[playerName]["Gouge"]["reset"],coolDownSpell["Gouge"])]="Gouge",
		[max(playerControl[playerName]["Blind"]["reset"],coolDownSpell["Blind"])]="Blind",
	}
	local tmp={}
	for k,v in pairs(controlList) do 
		table.insert(tmp,k) 
	end
	table.sort(tmp)
	return controlList[tmp[1]],tmp[1]
end

function checkNextControl(n,e,c)
	local control,casttime=nil,nil
	local energyRecover=0
	if n<controlInfo["end"] then
		energyRecover=checkEnergyRecover(n,controlInfo["end"])
		if energyRecover < 0 then
			energyRecover=0
		end
	end
	
	--如果偷袭可用，4星以下,不递减,使用偷袭
	if isPlayerBuffExist("Stealth") and e+energyRecover>=ENERGY_CAN_CHEAP and c<POINTS_CAN_CHEAP
	and n > playerControl[playerName]["Cheap Shot"]["reset"] then
		control="Cheap Shot"
		if n>=controlInfo["end"]then
			casttime = 0
		else
			casttime = controlInfo["end"] - CONTROL_END_TIME_OFFSET
		end
	--如果目标低于5星，凿击可用，并且不递减，能量大于等于45，使用凿击
	--[[elseif e+energyRecover>=ENERGY_CAN_GOUGE 
	and n>playerControl[playerName]["Gouge"]["reset"] and isSpellCooldown("Gouge") and not isPlayerBuffExist("Stealth")then
		control="Gouge"
		if n>=controlInfo["end"]  then
			casttime = 0
		else
			casttime = controlInfo["end"] - CONTROL_END_TIME_OFFSET
		end--]]
	--如果目标如果两星以上，且能量充足使用肾击
	elseif c>1 and (c+1)*10 + e+energyRecover > ENERGY_CAN_BACKSTAB and isSpellCooldown("Kidney Shot") and not isPlayerBuffExist("Stealth")
	and n >playerControl[playerName]["Kidney Shot"]["reset"] then
		control="Kidney Shot"
		if n>=controlInfo["end"]  then
			casttime = 0
		else
			casttime = controlInfo["end"] - CONTROL_END_TIME_OFFSET
		end
	--如果致盲可用不递减，能量大于29，使用致盲
	elseif e+energyRecover > ENERGY_CAN_BLIND and isSpellCooldown("Blind") and not isPlayerBuffExist("Stealth")
	and n >playerControl[playerName]["Blind"]["reset"] and n < playerControl[playerName]["Cheap Shot"]["reset"]
	--and (n < playerControl[playerName]["Gouge"]["reset"] or isSpellCooldown("Gouge") == false)
	and (n < playerControl[playerName]["Kidney Shot"]["reset"] or isSpellCooldown("Kidney Shot") == false)then
		control = "Blind"
		if n>=controlInfo["end"]  then
			casttime = 0
		else
			casttime = controlInfo["end"] - CONTROL_END_TIME_OFFSET
		end
	end
	return control,casttime
end

function checkEnergyRecover(beginTime,endTime)
	local energyRecover=0
	if beginTime<endTime then
		local lastRecoveryTime = energyRecoveryTime+math.floor(math.floor(beginTime-energyRecoveryTime)/2)*2
		energyRecover=math.floor(math.floor(endTime - lastRecoveryTime)/2)*20
	end
	if energyRecover<0 then
		energyRecover = 0
	end
	return energyRecover
end