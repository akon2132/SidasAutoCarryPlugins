require "VPrediction"

SkillQ = {delay = 0.25, radius = 80, range = 1150, speed = 1200}
SkillW = {delay = 0.25, radius = 80, range = 1000, speed = 1200}

function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)

	if Target then
		if Menu2.AutoCarry then
			if Menu.AutoCarry.useQ then
				CastQ(Target)
				myHero:Attack(Target)
			end

			if Menu.AutoCarry.useW then
				CastW(Target)
				myHero:Attack(Target)
			end
		end
		
		if Menu.Harass.harQ then
			CastQ(Target)
		end

		if Menu.Harass.harW then
			CastW(Target)
		end
	end

	if Menu.LastHit.lhQ and not Menu2.LastHit then
		for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
			if ValidTarget(minion) then
				castLHQ(minion)
			end
		end
	end
end

function mainLoad()
	VP = VPrediction()
    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = SkillQ.range
	QREADY, WREADY = false, false
end

function mainMenu()
	Menu:addSubMenu("AutoCarry", "AutoCarry")
	Menu.AutoCarry:addParam("useQ", "Use Q with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.AutoCarry:addParam("useW", "Use W with AutoCarry", SCRIPT_PARAM_ONOFF, true)

	Menu:addSubMenu("LastHit", "LastHit")
	Menu.LastHit:addParam("lhQ", "Auto Last Hit with Q", SCRIPT_PARAM_ONOFF, false)

	Menu:addSubMenu("Harass", "Harass")
	Menu.Harass:addParam("harQ", "Harass with Q", SCRIPT_PARAM_ONOFF, true)
	Menu.Harass:addParam("harW", "Harass with W", SCRIPT_PARAM_ONOFF, true)

end

function CastQ(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero, true)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillQ.range then
		CastSpell(_Q, CastPosition.x, CastPosition.z)
	end
end

function CastW(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero, false)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillW.range then
		CastSpell(_W, CastPosition.x, CastPosition.z)
	end
end

function castLHQ(minion)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(minion, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero, true)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillQ.range then
		if minion.health <= (getDmg("Q", minion, myHero) + (myHero.damage * 1.1)) then
			if not minion.dead then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end