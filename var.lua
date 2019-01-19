TEST_VER = true
TEST_CONTROL = nil
MAIN_FRAME_WIDTH=30
MAIN_FRAME_HEIGHT=35
MAIN_FRAME_OFFSET_X=0
MAIN_FRAME_OFFSET_Y=120
MAIN_FRAME=nil

FRONT=1
BEHIND=0

GCD=1

position={
	["at"]=BEHIND,
	["time"]=0,
}

nameCacheMaxLen = 10
nameCache={

}

GOUGE=5.5
CHEAP_SHOT=4
KIDNEY_SHOT=5
BLIND=10
CONTROL_REST_TIME = 15
CONTROL_END_TIME_OFFSET=1
KIDNEY_SUB_TIME = 0.3

MAX_ENERGY=110
ENERGY_CHANGE_TIME_OFFSET=0.1
energy=0
energyLast = MAX_ENERGY
energyRecoveryTime=0
energyFullTime=0
comboPoints=0
comboPointsOld=0

usedComboPoints={
	["used"]=0,
	["time"]=0
}

STUN=1
INCAP=2

controlType={
	["Gouge"]="Gouge",
	["Kidney Shot"]="Kidney Shot",
	["Cheap Shot"]="Cheap Shot",
	["Blind"]="Blind",
	["Sap"]="Gouge",
}

ctrType={
	["Gouge"]=INCAP,
	["Kidney Shot"]=STUN,
	["Cheap Shot"]=STUN,
	["Blind"]=INCAP,
}

controlInfo={
	["type"] = nil,
	["spell"] = nil,
	["end"] = 0,
}

controlPreview=nil

playerControl={
	
}

debuffCnt=16
buffCnt=16

POINTS_CAN_CHEAP=4 --低于这个星优先使用偷袭
ENERGY_CAN_CHEAP=39 --高于这个能量可使用偷袭
ENERGY_CAN_BACKSTAB=59 --高于这个能量可使用背刺
ENERGY_CAN_AMBUSH=59 --高于这个能量可以使用伏击
ENERGY_CAN_GOUGE=44 --高于这个能量可以使用凿击
ENERGY_CAN_BLIND = 29 --高于这个能量可以使用致盲

playerDebuffs={

}

playerBuffs={

}

targetDebuffs={

}

spellSlots={
	["Attack"]=62,
	["Renataki's Charm of Trickery"]=63,
	["Cheap Shot"]=70,
	["Stealth"]=68,
	["Vanish"]=51,
	["Blind"]=69,
	["Kidney Shot"]=71,
	["Gouge"]=72,
	["Kick"]=49,
	["Evasion"]=50,
	["Sprint"]=52,
	["Cold Blood"]=52,
	["Sinister Strike"]=65,
	["Shoot Bow"]=66,
	["Preparation"]=67,
	["Will of the Forsaken"]=53,
}

spellCooldownSlots={
	["Renataki's Charm of Trickery"]=63,
	["Stealth"]=68,
	["Vanish"]=51,
	["Blind"]=69,
	["Kidney Shot"]=71,
	["Gouge"]=72,
	["Kick"]=49,
	["Evasion"]=50,
	["Sprint"]=52,
	["Cold Blood"]=52,
	["Preparation"]=67,
	["Will of the Forsaken"]=53,
}

coolDownSpell={

}

spellIcons={
	["Will of the Forsaken"]="Inferface\\Icons\\Spell_Shadow_RaiseDead",--亡灵意志
	["Fear"]="Interface\\Icons\\Spell_Shadow_Possession",--恐惧
	["Psychic Scream"]="Interface\\Icons\\Spell_Shadow_PsychicScream",--心灵尖啸
	["Intimidating Shout"]="Interface\\Icons\\Ability_GolemThunderClap",--破胆怒吼
	["Stealth"]="Interface\\Icons\\Ability_Stealth",--潜行
	["Vanish"]="Interface\\Icons\\Ability_Vanish",--消失
	["Renataki's Charm of Trickery"]="Interface\\Icons\\INV_Jewelry_Necklace_19",--狡诈护符
	["Cold Blood"]="Interface\\Icons\\Spell_Ice_Lament", --冷血
	["Preparation"]="Interface\\Icons\\Spell_Shadow_AntiShadow",--伺机待发
	["Blind"]="Interface\\Icons\\Spell_Shadow_MindSteal",--致盲
	["Seduction"]="Interface\\Icons\\Spell_Shadow_MindSteal",--魅惑
	["Gouge"]="Interface\\Icons\\Ability_Gouge",--凿击
	["Eviscerate"]="Interface\\Icons\\Ability_Rogue_Eviscerate",--剔骨
	["Cheap Shot"]="Interface\\Icons\\Ability_CheapShot",--偷袭
	["Kidney Shot"]="Interface\\Icons\\Ability_Rogue_KidneyShot",--肾击
	["Vanish"]="Interface\\Icons\\Ability_Vanish",--消失
	["Sprint"]="Interface\\Icons\\Ability_Rogue_Sprint",--疾跑
	["Evasion"]="Interface\\Icons\\Spell_Shadow_ShadowWard",--闪避
	["Ambush"]="Interface\\Icons\\Ability_Rogue_Ambush",--伏击
	["Backstab"]="Interface\\Icons\\Ability_BackStab",--背刺
	["Sinister Strike"]="Interface\\Icons\\Spell_Shadow_RitualOfSacrifice",--邪恶攻击
	["Faerie Fire"]="Interface\\Icons\\Spell_Nature_FaerieFire",--精灵之火
}

iconSpells={

}


playerName=""
playerClass=""

range=0
cs=nil
nextControl = nil
tk=nil