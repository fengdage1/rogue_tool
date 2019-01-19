function test1Command(arg)
	DEFAULT_CHAT_FRAME:AddMessage(IsActionInRange(spellSlots["Sinister Strike"]))
end

function test2Command(arg)
	if IsUsableAction(spellSlots["Stealth"])  then
		DEFAULT_CHAT_FRAME:AddMessage(GetActionTexture(1))
	end
end

function attackCommand(arg)
	--如果被恐惧释放亡灵意志
	local now = GetTime()
	if isSpellCooldown("Will of the Forsaken") and (isPlayerDebuffExist("Fear") or isPlayerDebuffExist("Psychic Scream") or isPlayerDebuffExist("Intimidating Shout") or isPlayerDebuffExist("Seduction")) then
		CastSpellByName("Will of the Forsaken")
		--如果身上潜行和消失同时存在,并且目标距离大于10，取消潜行
		--elseif isPlayerBuffExist("Vanish") and isPlayerBuffExist("Stealth") and range>3 then
		--	cs="Stealth"
		--	DEFAULT_CHAT_FRAME:AddMessage(1)
		--如果可以潜行并且身上没有消失效果，潜行
	elseif IsUsableAction(spellSlots["Stealth"]) and isSpellCooldown("Stealth") and not isPlayerBuffExist("Stealth") and not isPlayerBuffExist("Vanish") and not isPlayerBuffExist("Faerie Fire") then
		CastSpellByName("Stealth")
		--目标在近战攻击范围内，能量小于40,装备有狡诈护符且冷却，使用狡诈护符
	elseif range==1 and energy < 40 and isSpellCooldown("Renataki's Charm of Trickery") and GetInventoryItemTexture("player",13) == spellIcons["Renataki's Charm of Trickery"] 
	and controlInfo["type"]==STUN and controlInfo["end"] - now > CONTROL_END_TIME_OFFSET then
		UseInventoryItem(13)
	end
	if cs then
		CastSpellByName(cs)
		--if TEST_CONTROL ~= cs and (cs == "Kidney Shot" or cs == "Gouge") then
			--DEFAULT_CHAT_FRAME:AddMessage("技能:"..cs)
			--DEFAULT_CHAT_FRAME:AddMessage("释放时间:"..GetTime())
			--DEFAULT_CHAT_FRAME:AddMessage("########################")				
		--end
		--TEST_CONTROL = cs
		if cs == "Kidney Shot" and IsCurrentAction(spellSlots["Attack"]) then
			CastSpellByName("Attack")
		end
	end
	updateTargetDebuff()
	if IsCurrentAction(spellSlots["Attack"]) and (isPlayerBuffExist("Stealth") or isTargetDebuffExist("Gouge") or isTargetDebuffExist("Blind")) then
		CastSpellByName("Attack")
	elseif not IsCurrentAction(spellSlots["Attack"]) and (not isTargetDebuffExist("Gouge") and  not isTargetDebuffExist("Blind")) and not isPlayerBuffExist("Stealth")then
		local gs,_=GetActionCooldown(spellCooldownSlots["Gouge"])
		local bs,_ = GetActionCooldown(spellCooldownSlots["Blind"])
		if GetTime()-gs>0.2 and GetTime()-bs>0.2then
			CastSpellByName("Attack")
		end
	end
end

function damageCommand(arg)
	local now = GetTime()
	if isSpellCooldown("Will of the Forsaken") and (isPlayerDebuffExist("Fear") or isPlayerDebuffExist("Psychic Scream") or isPlayerDebuffExist("Intimidating Shout") or isPlayerDebuffExist("Seduction")) then
		CastSpellByName("Will of the Forsaken")
		--如果身上潜行和消失同时存在,并且目标距离大于10，取消潜行
		--elseif isPlayerBuffExist("Vanish") and isPlayerBuffExist("Stealth") and range>3 then
		--	cs="Stealth"
		--	DEFAULT_CHAT_FRAME:AddMessage(1)
		--如果可以潜行并且身上没有消失效果，潜行
	elseif IsUsableAction(spellSlots["Stealth"]) and isSpellCooldown("Stealth") and not isPlayerBuffExist("Stealth") and not isPlayerBuffExist("Vanish") and not isPlayerBuffExist("Faerie Fire") then
		CastSpellByName("Stealth")
		--目标在近战攻击范围内，能量小于40,装备有狡诈护符且冷却，使用狡诈护符
	elseif range==1 and energy < 40 and isSpellCooldown("Renataki's Charm of Trickery") and GetInventoryItemTexture("player",13) == spellIcons["Renataki's Charm of Trickery"] 
	then
		UseInventoryItem(13)
	end
	if range ~= 1 and not isPlayerBuffExist("Stealth") and isSpellCooldown("Sprint") then
		CastSpellByName("Sprint")
	elseif energy>59 and isPlayerBuffExist("Stealth") then
		CastSpellByName("Ambush")
	elseif energy>34 and comboPoints==5 then
		CastSpellByName("Eviscerate")
	elseif energy>59 then
		CastSpellByName("Backstab")
	elseif not IsCurrentAction(spellSlots["Attack"]) then
		CastSpellByName("Attack")
	end
end