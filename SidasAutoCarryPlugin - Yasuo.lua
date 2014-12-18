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

	if Menu.lastHitQ and Menu2.LastHit then
		for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
			if ValidTarget(minion) and QREADY and GetDistance(minion) < 475 then
				if minion.health <= getDmg("Q", minion, myHero) then
					CastSpell(_Q, minion.x, minion.z)
				end
			end
		end
	end

	if Menu.lastHitE and Menu2.LastHit then
		for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
			if ValidTarget(minion) and EREADY and GetDistance(minion) <= ERange and not TargetHaveBuff("YasuoDashWrapper", minion) then
				if minion.health <= getDmg("E", minion, myHero) then
					CastSpell(_E, minion)
				end
			end
		end
	end

	if Menu2.LaneClear then
		if Menu.laneclearQ then
			for k, minion in pairs(AutoCarry.EnemyMinions().objects) do
				if ValidTarget(minion) and QREADY and GetDistance(minion) <= 475 then
					CastSpell(_Q, minion.x, minion.z)
				end
			end
		end
		
		if Menu.laneclearE then
			for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
				if ValidTarget(minion) and EREADY and GetDistance(minion) <= ERange and not TargetHaveBuff("YasuoDashWrapper", minion) then
					CastSpell(_E, minion)
				end
			end
		end


	end
end

function mainLoad()
	AutoCarry.SkillsCrosshair.range = 475
	Menu = AutoCarry.PluginMenu
	Menu2 = AutoCarry.MainMenu
	WRange, ERange, RRange = 400, 475, 1200
	QREADY, WREADY, EREADY, RREADY = false, false, false, false
end

function mainMenu()
	Menu:addParam("lastHitE", "Last hit with E", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("lastHitQ", "Last hit with Q", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("laneclearE", "Spam E on Lane Clear", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("laneclearQ", "Spam Q on Lane Clear", SCRIPT_PARAM_ONOFF, true)
end