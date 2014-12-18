require "VPrediction"

SkillQ = {delay = 0.125, radius = 60, range = 1500, speed = 1300}

function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)

	if Menu.poke.pokenow then
		if Target and QREADY then
			CastQ(Target)
		end
	end

	if Menu.heal.h
end

function mainLoad()
	VP = VPrediction()
    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = 1500
	QREADY = false
end

function mainMenu()
	Menu:addSubMenu("Poke", "poke")
	Menu.poke:addParam("pokenow", "Poke with Q", SCRIPT_PARAM_ONKEYDOWN, false, 32)

	Menu:addSubMenu("Healing", "heal")
	Menu.heal:addParam("useE", "Use E to heal", SCRIPT_PARAM_ONOFF, false)
	Menu.heal:addParam("healPercent", "Percent of ally hp or you to heal", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
end

function CastQ(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero, true)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillQ.range then
		CastSpell(_Q, CastPosition.x, CastPosition.z)
	end
end