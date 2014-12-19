SkillQ = {range = 600}
SkillE = {range = 325}
SkillR = {range = 800}
local damageq
local damagee
local damager

function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	if Target then
		damageq = (getDmg("Q", Target, myHero) + (myHero.ap * 0.40))
		damagee = (getDmg("E", Target, myHero) + (myHero.ap * 0.30) + (myHero.damage * 0.60))
		damager = (getDmg("R", Target, myHero) + (myHero.ap * 0.50))
	end

	if Menu.Harass.harassQ and not Menu2.LastHit then
		if Target and QREADY and GetDistance(Target) <= SkillQ.range then
			CastSpell(_Q, Target)
		end
	end

	if (Menu2.LastHit or Menu2.LaneClear) and Menu.lasthit.lasthitq then
		for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
			if ValidTarget(minion) and GetDistance(minion) <= SkillQ.range and minion.health <= (getDmg("Q", minion, myHero) + (myHero.ap * 0.40)) then
				CastSpell(_Q, minion)
			end
		end
	end

	if Target and GetDistance(Target) <= SkillR.range and Menu.assassinate.killtarget then
		if isKillable(Target) then
			FullCombo(Target)
		end 
	end

	if Menu2.AutoCarry and Target then
		if Menu.autocarry.useq then
			CastSpell(_Q, Target)
		end

		if Menu.autocarry.usee and GetDistance(Target) <= SkillE.range then
			CastSpell(_E, Target)
		end

		if Menu.autocarry.user then
			CastSpell(_R, Target)
		end
	end
end

function mainLoad()
    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = SkillR.range
	QREADY, EREADY, RREADY = false, false, false
end

function mainMenu()
	-- AutoCarry
	Menu:addSubMenu("AutoCarry", "autocarry")
	Menu.autocarry:addParam("useq", "Use Q with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.autocarry:addParam("usee", "Use E with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.autocarry:addParam("user", "Use R with AutoCarry", SCRIPT_PARAM_ONOFF, true)

	-- Last Hit
	Menu:addSubMenu("LastHit", "lasthit")
	Menu.lasthit:addParam("lasthitq", "LastHit with Q", SCRIPT_PARAM_ONOFF, true)

	-- Harass
	Menu:addSubMenu("Harass", "Harass")
	Menu.Harass:addParam("harassQ", "Auto Harass with Q", SCRIPT_PARAM_ONOFF, true)

	-- Assassinate
	Menu:addSubMenu("Assassinate", "assassinate")
	Menu.assassinate:addParam("killtarget", "Full Combo on Killable", SCRIPT_PARAM_ONOFF, true)

	-- OnDraw
	Menu:addSubMenu("Drawing", "drawing")
	Menu.drawing:addParam("drawon", "Draw text over killable", SCRIPT_PARAM_ONOFF, true)
end

function FullCombo(unit)
	if GetDistance(unit) <= SkillQ.range then
		if QREADY then
			CastSpell(_Q, unit)
		end

		if RREADY then
			CastSpell(_R, unit)
		end

		if GetDistance(unit) <= SkillE.range and EREADY then
			CastSpell(_E)
		end

	elseif GetDistance(unit) <= SkillR.range then
		if RREADY then
			CastSpell(_R, unit)
		end

		if QREADY then
			CastSpell(_Q, unit)
		end

		if GetDistance(unit) <= SkillE.range and EREADY then
			CastSpell(_E)
		end
	end
end

function PluginOnDraw()
	if Menu.drawing.drawon then
		for i = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(i)
			if ValidTarget(hero, SkillR.range) and isKillable(hero) then
				DrawText3D("Killable", hero.x, hero.y, hero.z, 18, ARGB(255, 255, 255, 255), true)
			end
		end
	end
end

function isKillable(hero)
	if hero.health <= (damageq + damagee + damager) then
		return true
	else
		return false
	end
end