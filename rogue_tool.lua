function errorMessage(self, msg, ...)
	--DEFAULT_CHAT_FRAME:AddMessage(msg)
	if string.find(msg,"behind") then
		position["at"]=FRONT
		position["time"]=GetTime()
	elseif string.find(msg,"front") then
		position["at"]=BEHIND
		position["time"]=GetTime()
	end
end

function onLoad()
	SlashCmdList["TESTONE"] = test1Command
	SLASH_TESTONE1 = "/testone"
	SlashCmdList["TESTTWO"] = test2Command
	SLASH_TESTTWO1 = "/testtwo"
	SlashCmdList["ATTACK"] = attackCommand
	SLASH_ATTACK1 = "/attack"
	SlashCmdList["DAMAGE"] = damageCommand
	SLASH_DAMAGE1 = "/damage"
	----------------------------------
	UIErrorsFrame.AddMessage = errorMessage
	----------------------------------
	MAIN_FRAME = getglobal("mainFrame")
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	this:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	this:RegisterEvent("UNIT_ENERGY")
	this:RegisterEvent("UNIT_MAXENERGY")
	this:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA")
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	--this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
	----------------------------------
	initIconSpells()
	initCooldownSpells()
	----------------------------------
	this:SetWidth(MAIN_FRAME_WIDTH)
	this:SetHeight(MAIN_FRAME_HEIGHT)
	this:SetBackdropColor(1,1,1)
	this.texture = this:CreateTexture()
	this.texture:SetAllPoints(this)
	this.texture:SetTexture(1,1,1)
	this:SetPoint("CENTER", UIParent, "CENTER",MAIN_FRAME_OFFSET_X, MAIN_FRAME_OFFSET_Y)
	this.FontString = this:CreateFontString(nil,"ARTWORK")
	this.FontString:SetFontObject(GameFontNormal)
	this.FontString:SetFont("Fonts\\FRIZQT__.TTF", 25,"outline")
	this.FontString:SetTextColor(1,0,0,1)
	this.FontString:SetPoint("CENTER",this,"CENTER",0,0)
	----------------------------------
	DEFAULT_CHAT_FRAME:AddMessage("rogue tool is Loaded")
	DEFAULT_CHAT_FRAME:AddMessage("author voodoodog")
end 

function onEvent()
	--DEFAULT_CHAT_FRAME:AddMessage(event)
	if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
		for name, spell in string.gfind( arg1, "(.+) is afflicted by (.+).") do
			--DEFAULT_CHAT_FRAME:AddMessage(name)
			--DEFAULT_CHAT_FRAME:AddMessage(spell)
			if controlType[spell] ~= nil and playerControl[name] ~= nil then		
					--凿击
				if controlType[spell]=="Gouge" then
					playerControl[name]["Gouge"]["start"]=GetTime()
					if GetTime()>playerControl[name]["Gouge"]["reset"] then
						playerControl[name]["Gouge"]["cnt"]=1
						playerControl[name]["Gouge"]["end"]=playerControl[name]["Gouge"]["start"]+GOUGE
					else
						playerControl[name]["Gouge"]["cnt"]=playerControl[name]["Gouge"]["cnt"]+1
						playerControl[name]["Gouge"]["end"]=playerControl[name]["Gouge"]["start"]+GOUGE/playerControl[name]["Gouge"]["cnt"]
					end
					playerControl[name]["Gouge"]["reset"]=playerControl[name]["Gouge"]["start"]+CONTROL_REST_TIME
					--肾击
				elseif controlType[spell] == "Kidney Shot" then
					local now = GetTime()
					local dur = now - usedComboPoints["time"]
					local kidneyDur = KIDNEY_SHOT
					if dur <KIDNEY_SUB_TIME and dur>=0 then
						kidneyDur = usedComboPoints["used"]+1
					end
					playerControl[name]["Kidney Shot"]["start"]=now
					if GetTime()>playerControl[name]["Kidney Shot"]["reset"] then
						playerControl[name]["Kidney Shot"]["cnt"]=1
						playerControl[name]["Kidney Shot"]["end"]=playerControl[name]["Kidney Shot"]["start"]+kidneyDur
					else
						playerControl[name]["Kidney Shot"]["cnt"]=playerControl[name]["Kidney Shot"]["cnt"]+1
						playerControl[name]["Kidney Shot"]["end"]=playerControl[name]["Kidney Shot"]["start"]+kidneyDur/playerControl[name]["Kidney Shot"]["cnt"]
					end
					playerControl[name]["Kidney Shot"]["reset"]=playerControl[name]["Kidney Shot"]["start"]+CONTROL_REST_TIME
					--偷袭
				elseif controlType[spell]=="Cheap Shot" then
					playerControl[name]["Cheap Shot"]["start"]=GetTime()
					if GetTime()>playerControl[name]["Cheap Shot"]["reset"] then
						playerControl[name]["Cheap Shot"]["cnt"]=1
						playerControl[name]["Cheap Shot"]["end"]=playerControl[name]["Cheap Shot"]["start"]+CHEAP_SHOT
					else
						playerControl[name]["Cheap Shot"]["cnt"]=playerControl[name]["Cheap Shot"]["cnt"]+1
						playerControl[name]["Cheap Shot"]["end"]=playerControl[name]["Cheap Shot"]["start"]+CHEAP_SHOT/playerControl[name]["Cheap Shot"]["cnt"]
					end
					playerControl[name]["Cheap Shot"]["reset"]=playerControl[name]["Cheap Shot"]["start"]+CONTROL_REST_TIME
					--致盲
				elseif controlType[spell]=="Blind" then
					playerControl[name]["Blind"]["start"]=GetTime()
					if GetTime()>playerControl[name]["Blind"]["reset"] then
						playerControl[name]["Blind"]["cnt"]=1
						playerControl[name]["Blind"]["end"]=playerControl[name]["Blind"]["start"]+BLIND
					else
						playerControl[name]["Blind"]["cnt"]=playerControl[name]["Blind"]["cnt"]+1
						playerControl[name]["Blind"]["end"]=playerControl[name]["Blind"]["start"]+BLIND/playerControl[name]["Blind"]["cnt"]
					end
					playerControl[name]["Blind"]["reset"]=playerControl[name]["Blind"]["start"]+CONTROL_REST_TIME
				end		
				if ctrType[controlType[spell]] ~= nil then
					controlInfo["type"]=ctrType[controlType[spell]]
					controlInfo["spell"]=controlType[spell]
					controlInfo["end"] = playerControl[name][controlType[spell]]["end"]
					controlInfo["start"] = playerControl[name][controlType[spell]]["start"]
				end
			end
		end
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
		for spell, name in string.gfind( arg1, "(.+) fades from (.+).") do
			if playerControl[name]~= nil and controlType[spell]~= nil then
				local now = GetTime()
				playerControl[name][controlType[spell]]["reset"]=now+CONTROL_REST_TIME
				if controlType[spell] == controlInfo["spell"] then
					controlInfo["end"]= now
				end
			end
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" then
		for name, spell in string.gfind( arg1, "(.+) is afflicted by (.+).") do
			--DEFAULT_CHAT_FRAME:AddMessage(name)
			--DEFAULT_CHAT_FRAME:AddMessage(spell)
			if controlType[spell] ~= nil and playerControl[name] ~= nil then		
					--凿击
				local now = GetTime()
				if controlType[spell]=="Gouge" then
					playerControl[name]["Gouge"]["start"]=now
					if now>playerControl[name]["Gouge"]["reset"] then
						playerControl[name]["Gouge"]["cnt"]=1
						playerControl[name]["Gouge"]["end"]=playerControl[name]["Gouge"]["start"]+GOUGE
					else
						playerControl[name]["Gouge"]["cnt"]=playerControl[name]["Gouge"]["cnt"]+1
						playerControl[name]["Gouge"]["end"]=playerControl[name]["Gouge"]["start"]+GOUGE/playerControl[name]["Gouge"]["cnt"]
					end
					playerControl[name]["Gouge"]["reset"]=playerControl[name]["Gouge"]["start"]+CONTROL_REST_TIME
					--肾击
				elseif controlType[spell] == "Kidney Shot" then
					local dur = now - usedComboPoints["time"]
					local kidneyDur = KIDNEY_SHOT
					if dur <KIDNEY_SUB_TIME and dur>=0 then
						kidneyDur = usedComboPoints["used"]+1
					end
					playerControl[name]["Kidney Shot"]["start"]=now
					if now>playerControl[name]["Kidney Shot"]["reset"] then
						playerControl[name]["Kidney Shot"]["cnt"]=1
						playerControl[name]["Kidney Shot"]["end"]=playerControl[name]["Kidney Shot"]["start"]+kidneyDur
					else
						playerControl[name]["Kidney Shot"]["cnt"]=playerControl[name]["Kidney Shot"]["cnt"]+1
						playerControl[name]["Kidney Shot"]["end"]=playerControl[name]["Kidney Shot"]["start"]+kidneyDur/playerControl[name]["Kidney Shot"]["cnt"]
					end
					playerControl[name]["Kidney Shot"]["reset"]=playerControl[name]["Kidney Shot"]["start"]+CONTROL_REST_TIME
					--偷袭
				elseif controlType[spell]=="Cheap Shot" then
					playerControl[name]["Cheap Shot"]["start"]=now
					if now>playerControl[name]["Cheap Shot"]["reset"] then
						playerControl[name]["Cheap Shot"]["cnt"]=1
						playerControl[name]["Cheap Shot"]["end"]=playerControl[name]["Cheap Shot"]["start"]+CHEAP_SHOT
					else
						playerControl[name]["Cheap Shot"]["cnt"]=playerControl[name]["Cheap Shot"]["cnt"]+1
						playerControl[name]["Cheap Shot"]["end"]=playerControl[name]["Cheap Shot"]["start"]+CHEAP_SHOT/playerControl[name]["Cheap Shot"]["cnt"]
					end
					playerControl[name]["Cheap Shot"]["reset"]=playerControl[name]["Cheap Shot"]["start"]+CONTROL_REST_TIME
					--致盲
				elseif controlType[spell]=="Blind" then
					playerControl[name]["Blind"]["start"]=now
					if now>playerControl[name]["Blind"]["reset"] then
						playerControl[name]["Blind"]["cnt"]=1
						playerControl[name]["Blind"]["end"]=playerControl[name]["Blind"]["start"]+BLIND
					else
						playerControl[name]["Blind"]["cnt"]=playerControl[name]["Blind"]["cnt"]+1
						playerControl[name]["Blind"]["end"]=playerControl[name]["Blind"]["start"]+BLIND/playerControl[name]["Blind"]["cnt"]
					end
					playerControl[name]["Blind"]["reset"]=playerControl[name]["Blind"]["start"]+CONTROL_REST_TIME
				end		
				if ctrType[controlType[spell]] ~= nil then
					controlInfo["type"]=ctrType[controlType[spell]]
					controlInfo["spell"]=controlType[spell]
					controlInfo["end"] = playerControl[name][controlType[spell]]["end"]
					controlInfo["start"] = playerControl[name][controlType[spell]]["start"]
				end
			end
		end
	elseif event == "CHAT_MSG_SPELL_BREAK_AURA" then
		--Micropenix's Winter's Chill is removed
		for name, spell in string.gfind( arg1, "(.+)'s (.+) is removed") do
			if playerControl[name]~= nil and controlType[spell]~= nil then
				local now = GetTime()
				playerControl[name][controlType[spell]]["reset"]=now+CONTROL_REST_TIME
				if controlType[spell] == controlInfo["spell"] then
					controlInfo["end"]= now
				end
			end
		end
	elseif event == "CHAT_MSG_COMBAT_SELF_HITS" then
		if string.find(arg1,"Backstab") then
			position["at"]=BEHIND
			position["time"]=GetTime()
		elseif string.find(arg1,"Gouge") then
			position["at"]=FRONT
			position["time"]=GetTime()
		end
	elseif event == "UNIT_ENERGY" then
		local e = UnitMana("player")
		local now = GetTime()
		if arg1 == "player" and e-energyLast == 20 then
			energyRecoveryTime=now+ENERGY_CHANGE_TIME_OFFSET
		end
		energyLast = e
		if e == MAX_ENERGY then
			energyFullTime=now
		end
		energy = e
	elseif event == "UNIT_MAXENERGY" then
		
	end
end

function mainFrameUpdate()
	updatePlayerBuff()
	updatePlayerDebuff()
	updateCooldown()
	if(not UnitExists("target")) or UnitIsFriend("player", "target")then
		this:SetAlpha(0)
		--if isPlayerBuffExist("Vanish") and isPlayerBuffExist("Stealth") then
		--	cs="Stealth"
		--如果可以潜行并且身上没有消失效果，潜行
		--elseif IsUsableAction(spellSlots["Stealth"]) and isSpellCooldown("Stealth") and not isPlayerBuffExist("Vanish") then
		--	cs="Stealth"
		--else 
		--	cs=nil
		--end
		--tk=nil
	else
		--updatePlayerDebuff()
		--updateTargetDebuff()
		updateRange()
		--if UnitIsPlayer("target") then
			playerName=UnitName("target")
			playerClass = UnitClass("target")
			if playerControl[playerName] == nil then
				nameCache[table.getn(nameCache)+1]=playerName
				playerControl[playerName]={
					["Gouge"]={
						["start"]=0,
						["end"]=0,
						["reset"]=0,
						["cnt"]=1,
					},
					["Kidney Shot"]={
						["start"]=0,
						["end"]=0,
						["reset"]=0,
						["cnt"]=1,
					},
					["Cheap Shot"]={
						["start"]=0,
						["end"]=0,
						["reset"]=0,
						["cnt"]=1,
					},
					["Blind"]={
						["start"]=0,
						["end"]=0,
						["reset"]=0,
						["cnt"]=1,
					}
				}
				if table.getn(nameCache) > nameCacheMaxLen then
					playerControl[nameCache[1]]=nil
					table.remove(nameCache,1)
				end
			end
		--end
		energy=UnitMana("player")
		comboPoints=GetComboPoints()
		if comboPointsOld>comboPoints then
			if playerControl[playerName] ~= nil then
				local dur = GetTime()-playerControl[playerName]["Kidney Shot"]["start"]
				if dur<KIDNEY_SUB_TIME and dur >= 0  then
					playerControl[playerName]["Kidney Shot"]["end"]=playerControl[playerName]["Kidney Shot"]["start"]+comboPointsOld+1
					controlInfo["end"] = playerControl[playerName]["Kidney Shot"]["end"]
				else
					usedComboPoints["used"]=comboPointsOld
					usedComboPoints["time"]=GetTime()
				end
			else
				usedComboPoints["used"]=comboPointsOld
				usedComboPoints["time"]=GetTime()
			end
		end
		comboPointsOld=comboPoints
		dragger_assassination["control"]()
		--updateControlInfo()
		--DEFAULT_CHAT_FRAME:AddMessage(controlInfo["type"])
		--DEFAULT_CHAT_FRAME:AddMessage(controlInfo["end"])
		--dragger_assassination["control"]()
		updateMainframe()
		this:SetAlpha(1)
	end
end