require "VPrediction"

SkillW = {delay = 0.85, radius = 60, range = 1450, speed = 1200}
SkillE = {delay = 0.25, radius = 45, range = 900, speed = 1200}

function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)

	if Target then
		if Menu2.AutoCarry then
			if Menu.autocarry.useW and WREADY then
				CastW(Target)
			end

			if Menu.autocarry.useE and EREADY then
				CastE(Target)
			end
		end
	end
end

function mainLoad()
	VP = VPrediction()
    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = SkillW.range
	WREADY, EREADY = false, false
end

function mainMenu()
	Menu:addSubMenu("AutoCarry", "autocarry")
	Menu.autocarry:addParam("useW", "Use W with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.autocarry:addParam("useE", "Use E with AutoCarry", SCRIPT_PARAM_ONOFF, true)
end

function CastW(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillW.delay, SkillW.radius, SkillW.range, SkillW.speed, myHero, true)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillW.range then
		CastSpell(_W, CastPosition.x, CastPosition.z)
	end
end

function CastE(unit)
	local CastPosition, HitChance, Position = VP:GetCircularCastPosition(unit, SkillE.delay, SkillE.radius, SkillE.range, SkillE.speed, myHero, false)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillE.range then
		CastSpell(_E, CastPosition.x, CastPosition.z)
	end
end