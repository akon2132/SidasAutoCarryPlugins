require "VPrediction"

local SkillQ = {delay = 0.25, radius = 40, range = 1150, speed = 1200}

function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)

	--Auto KS
	if Menu.ksE and Target and EREADY and GetDistance(Target) <= ERange then
		if (getDmg("E", Target, myHero) + (myHero.damage / 1.66)) >= Target.health then
			CastSpell(_E)
		end
	end

	if Menu2.AutoCarry then
		if Menu.useQ and QREADY and Target and GetDistance(Target) <= 1450 then
			CastQ(Target)
		end
	end
end

function mainLoad()
    VP = VPrediction()

    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = QRange
	QREADY, EREADY = false, false
	QRange, ERange = 1450, 1000
end

function mainMenu()
	Menu:addParam("useQ", "Use Q with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("ksE", "Auto KS with E", SCRIPT_PARAM_ONOFF, true)
end

function CastQ(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero, true)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillQ.range then
		CastSpell(_Q, CastPosition.x, CastPosition.z)
		myHero:MoveTo(mousePos.x, mousePos.z)
	end
end