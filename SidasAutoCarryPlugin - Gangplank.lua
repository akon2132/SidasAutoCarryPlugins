SkillQ = {range = 625}

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

	if Menu.Harass.harassQ and Target then
		CastSpell(_Q, Target)
	end

	if Menu2.AutoCarry then
		if Target then
			if Menu.AutoCarry.useQ and QREADY and GetDistance(Target) <= SkillQ.range then
				CastSpell(_Q, Target)
			end
		end
	end

	if Menu.LastHit.lhQ and not Menu2.AutoCarry then
		for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
			if ValidTarget(minion) and GetDistance(minion) <= SkillQ.range and minion.health <= (getDmg("Q", minion, myHero) + myHero.damage) then
				CastSpell(_Q, minion)
			end
		end
	end

	if Menu.Killsteal.ksQ then
		for i, enemy in pairs(AutoCarry.EnemyTable) do
			if ValidTarget(enemy) and enemy.health <= (getDmg("Q", enemy, myHero) + myHero.damage) and GetDistance(enemy) <= SkillQ.range then
				CastSpell(_Q, enemy)
			end
		end
	end
end

function mainLoad()
    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = SkillQ.range
	QREADY = false
end

function mainMenu()
	-- AutoCarry
	Menu:addSubMenu("AutoCarry", "AutoCarry")
	Menu.AutoCarry:addParam("useQ", "Use Q with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.AutoCarry:addParam("useE", "Use E with AutoCarry", SCRIPT_PARAM_ONOFF, false)

	--Harass
	Menu:addSubMenu("Harass", "Harass")
	Menu.Harass:addParam("harassQ", "Harass with Q", SCRIPT_PARAM_ONOFF, true)

	--LastHit
	Menu:addSubMenu("Last Hit", "LastHit")
	Menu.LastHit:addParam("lhQ", "Last Hit with Q", SCRIPT_PARAM_ONOFF, true)

	--KillSteal
	Menu:addSubMenu("Killsteal", "Killsteal")
	Menu.Killsteal:addParam("ksQ", "KillSteal with Q", SCRIPT_PARAM_ONOFF, true)
end