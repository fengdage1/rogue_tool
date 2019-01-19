dragger_assassination={
	--目标在攻击范围内，能量小于40,装备有狡诈护符且冷却，使用狡诈护符
	--如果有冷血，且目标大于4星，使用冷血剔骨
	--有释放凿击条件，如果目标在控制中，且目标控制技能还有CONTROL_END_TIME_OFFSET秒结束，且不足5星，释放凿击，或目标不在控制中，不足5星，释放凿击
	--有释放肾击条件，如果目标两星以上，能量充足，且目标控制技能还有CONTROL_END_TIME_OFFSET秒结束,或目标不在控制中,两星以上，能量充足，使用肾击，
	--有释放背刺条件，如果目标不足5星，且目标控制技能还有CONTROL_END_TIME_OFFSET+1秒结束，1秒后有释放控制技能的条件，或
	--
	["Others"]=function()
		--如果被恐惧释放亡灵意志
		if isPlayerDebuffExist("Fear") or isPlayerDebuffExist("Psychic Scream") or isPlayerDebuffExist("Intimidating Shout") then
			if isSpellCooldown("Will of the Forsaken") then
				cs="Will of the Forsaken"
			end
		--如果身上潜行和消失同时存在，取消潜行
		elseif isPlayerBuffExist("Vanish") and isPlayerBuffExist("Stealth") then
			cs="Stealth"
		--如果可以潜行并且身上没有消失效果，潜行
		elseif IsUsableAction(spellSlots["Stealth"]) and isSpellCooldown("Stealth") and not isPlayerBuffExist("Vanish") then
			cs="Stealth"
		--如果偷袭可用，4星以下,使用偷袭
		elseif IsUsableAction(spellSlots["Cheap Shot"]) and energy>ENERGY_CAN_CHEAP and comboPoints<POINTS_CAN_CHEAP then
			cs="Cheap Shot"
		--如果三星以上，且能量充足使用肾击
		elseif (comboPoints>2 and energy>=100) or (comboPoints>3 and energy>=80) then
			cs="Kidney Shot"
		--如果背刺可用，使用背刺
		elseif energy>59 then
			cs="Backstab"
		else 
			cs=nil
		end
	end,
	["PVP"]=function()
		local item = nil
		--DEFAULT_CHAT_FRAME:AddMessage(range)
		--如果被恐惧释放亡灵意志
		if isPlayerDebuffExist("Fear") or isPlayerDebuffExist("Psychic Scream") or isPlayerDebuffExist("Intimidating Shout") or isPlayerDebuffExist("Seduction") then
			if isSpellCooldown("Will of the Forsaken") then
				cs="Will of the Forsaken"
			end
		--如果身上潜行和消失同时存在，取消潜行
		elseif isPlayerBuffExist("Vanish") and isPlayerBuffExist("Stealth") and range>3 then
			cs="Stealth"
		--如果可以潜行并且身上没有消失效果，潜行
		elseif IsUsableAction(spellSlots["Stealth"]) and isSpellCooldown("Stealth") and not isPlayerBuffExist("Vanish") then
			cs="Stealth"
		--如果偷袭可用，4星以下,使用偷袭
		elseif IsUsableAction(spellSlots["Cheap Shot"]) and energy>ENERGY_CAN_CHEAP and comboPoints<POINTS_CAN_CHEAP then
			cs="Cheap Shot"
		--目标在近战攻击范围内，能量小于40,装备有狡诈护符且冷却，使用狡诈护符
		elseif range==1 and energy < 40 and isSpellCooldown("Renataki's Charm of Trickery") and GetInventoryItemTexture("player",13) == spellIcons["Renataki's Charm of Trickery"] then
			item=13
		--如果冷血冷却结束，能量大于等于35，身上没有冷血效果，且目标5星，使用冷血
		elseif comboPoints==5 and energy>=35 and not isPlayerBuffExist("Cold Blood") and isSpellCooldown("Cold Blood") then
			cs="Cold Blood"
		--如果身上有冷血效果，能量大于等于35，目标5星，使用剔骨
		elseif comboPoints==5 and energy>=35 --[[and isPlayerBuffExist("Cold Blood")--]]then
			cs="Eviscerate"
		--如果背刺可用，使用背刺
		elseif energy>59 then
			cs="Backstab"
		else 
			cs=nil
		end
		tk = item
	end,
	["control"]=function()
		local now = GetTime()
		local control,casttime=checkNextControl(now,energy,comboPoints)
		local ctrAfterBackstab,ctAfterBackstab=checkNextControl(now,energy-60,comboPoints+1)
		if control and now > casttime then
			cs = control
		--elseif not IsCurrentAction(spellSlots["Attack"]) and (controlInfo["end"]+0.2< now or controlInfo["type"]~=INCAP)then
		--	cs ="Attack"
		--如果背刺可用，使用背刺
		elseif energy>59 and isPlayerBuffExist("Stealth")  and
		--[[如果目标在昏迷中，还有后续控制，在不影响后续控制的前提下释放背刺--]]
		((control ~= nil and controlInfo["end"]-CONTROL_END_TIME_OFFSET-now >GCD and controlInfo["type"]==STUN and control==ctrAfterBackstab and casttime== ctAfterBackstab) 
		--[[如果目标在昏迷中，无后续控制，释放背刺--]]
		or (control ==nil and controlInfo["type"]==STUN and now < controlInfo["end"])
		--[[如果目标在瘫痪中，无后续控制，最后时刻释放背刺--]]
		or (control ==nil and controlInfo["end"]-CONTROL_END_TIME_OFFSET<now and controlInfo["type"] == INCAP)
		--[[如果目标不在控制中，释放背刺--]]
		or (controlInfo["end"]-CONTROL_END_TIME_OFFSET<now))then
			cs = "Ambush"
		elseif energy>59  and
		--[[如果目标在昏迷中，还有后续控制，在不影响后续控制的前提下释放背刺--]]
		((control ~= nil and controlInfo["end"]-CONTROL_END_TIME_OFFSET-now >GCD and controlInfo["type"]==STUN and control==ctrAfterBackstab and casttime== ctAfterBackstab) 
		--[[如果目标在昏迷中，无后续控制，释放背刺--]]
		or (control ==nil and controlInfo["type"]==STUN and now < controlInfo["end"])
		--[[如果目标在瘫痪中，无后续控制，最后时刻释放背刺--]]
		or (control ==nil and controlInfo["end"]-CONTROL_END_TIME_OFFSET<now and controlInfo["type"] == INCAP)
		--[[如果目标不在控制中，释放背刺--]]
		or (controlInfo["end"]-CONTROL_END_TIME_OFFSET<now))then
			cs = "Backstab"
		else
			cs=nil
		end
		nextControl = control
	end,
	["damage"]=function()
	end,
}

function attack()
	
end