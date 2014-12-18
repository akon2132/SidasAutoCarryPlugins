require "VPrediction"

local SkillQ = {delay = 0.25, radius = 80, range = 725, speed = 1200}
local SkillW = {range = 450}
local SkillR = {range = 550}

function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)

	if Menu2.AutoCarry then
		if Target and WREADY and GetDistance(Target) <= SkillW.range and Menu.AutoCarry.useW then
			CastSpell(_W)
		end

		if Target and QREADY then
			CastQ(Target)
		end
	end

	if Menu.Harass.harQ then
		if QREADY and Target and GetDistance(Target) <= SkillQ.range and Menu.AutoCarry.useQ then
			CastQ(Target)
		end
	end

	if Menu.ksR then
		for _, enemy in pairs(AutoCarry.EnemyTable) do
			if ValidTarget(enemy) and GetDistance(enemy) <= SkillR.range and enemy.health <= getDmg("R", enemy, myHero) then
				CastSpell(_R, enemy)
			end
		end
	end
end

function mainLoad()
	VP = VPrediction()

    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = 825
	QREADY, WREADY, RREADY = false, false, false
end

function mainMenu()
	--[[ AutoCarry ]] --
	Menu:addSubMenu("AutoCarry", "AutoCarry")
	Menu.AutoCarry:addParam("useQ", "Use Q with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.AutoCarry:addParam("useW", "Use W with AutoCarry", SCRIPT_PARAM_ONOFF, true)

	-- Harass
	Menu:addSubMenu("Harass", "Harass")
	Menu.Harass:addParam("harQ", "Harass with Q", SCRIPT_PARAM_ONOFF, true)

	Menu:addParam("ksR", "Killsteal with Ult", SCRIPT_PARAM_ONOFF, true)
end

function CastQ(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero, false)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillQ.range then
		CastSpell(_Q, CastPosition.x, CastPosition.z)
	end
end