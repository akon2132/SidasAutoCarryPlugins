require "VPrediction"

SkillE = {delay = 0.50, radius = 160, range = 660, speed = 700}
SkillW = {range = 400}

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

	if Target then
		if EREADY and Menu2.AutoCarry and Menu.autocarry.useE then
			CastE(Target)
		end

		if WREADY and Menu2.AutoCarry and Menu.autocarry.useW and GetDistance(Target) <= SkillW.range then
			CastSpell(_W)
		end

		if Menu.autoks.ksE and EREADY then
			for _, enemy in pairs(AutoCarry.EnemyTable) do
				if ValidTarget(enemy) and GetDistance(enemy) <= SkillE.range and enemy.health <= calcDmgE(enemy) then
					CastE(enemy)
				end
			end
		end
	end

	if Menu.autoult.ulton and RREADY then
		autoUlt()
	end

	if Menu.autoheal.healQ then
		healme()
	end
end

function mainLoad()
	VP = VPrediction()
    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = SkillE.range
	QREADY, WREADY, EREADY, RREADY = false, false, false, false
end

function mainMenu()
	--AutoCarry
	Menu:addSubMenu("AutoCarry", "autocarry")
	Menu.autocarry:addParam("useW", "Use W with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.autocarry:addParam("useE", "Use E with AutoCarry", SCRIPT_PARAM_ONOFF, true)

	--AutoUlt
	Menu:addSubMenu("Auto Ult Options", "autoult")
	Menu.autoult:addParam("ulton", "Auto use ultimate", SCRIPT_PARAM_ONOFF, true)
	Menu.autoult:addParam("ultslice", "Min HP to Ult", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

	--Killsteal
	Menu:addSubMenu("Killsteal", "autoks")
	Menu.autoks:addParam("ksE", "Killsteal with E", SCRIPT_PARAM_ONOFF, true)

	--Autoheal
	Menu:addSubMenu("Auto Heal", "autoheal")
	Menu.autoheal:addParam("healQ", "Auto Heal with Q", SCRIPT_PARAM_ONOFF, false)
	Menu.autoheal:addParam("healslice", "Min HP to heal", SCRIPT_PARAM_SLICE, 75, 1, 100, 0)

end

function CastE(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillE.delay, SkillE.radius, SkillE.range, SkillE.speed, myHero, false)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillE.range then
		CastSpell(_E, CastPosition.x, CastPosition.z)
	end
end

function autoUlt()
	if myHero.health <= (myHero.maxHealth * (Menu.autoult.ultslice / 100)) then
		CastSpell(_R)
	end
end

function calcDmgE(unit)
	local totaldmg = (getDmg("E", unit, myHero) + (myHero.ap) + (myHero.damage * 1.2))
	return totaldmg
end

function healme()
	if myHero.health <= (myHero.maxHealth * (Menu.autoheal.healslice / 100)) then
		CastSpell(_Q)
	end
end