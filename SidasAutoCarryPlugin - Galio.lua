require "VPrediction"

SkillQ = {delay = 0.25, radius = 200, range = 940, speed = 1300}
SkillE = {delay = 0.25, radius = 120, range = 1180, speed = 1200}
SkillR = {range = 600}

function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)

	if Target then

		if Menu2.AutoCarry then
			if Menu.AutoCarry.Ult.useR then
				local champCount = 0
				for i = 1, heroManager.iCount, 1 do
					local enemy = heroManager:getHero(i)
					if ValidTarget(enemy, SkillR.range) then
						champCount = champCount + 1
					end
				end

				if champCount >= Menu.AutoCarry.Ult.ultSlice then
					CastSpell(_R)
				end
			end

			if Menu.AutoCarry.useE and EREADY then
				CastE(Target)
			end

			if Menu.AutoCarry.useQ and QREADY then
				CastQ(Target)
			end

			
		end

	end
end

function mainLoad()
	VP = VPrediction()
    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = SkillE.range
	QREADY, EREADY = false, false
	lastAnimation = "Run"
end

function mainMenu()
	Menu:addSubMenu("AutoCarry", "AutoCarry")
	Menu.AutoCarry:addParam("useQ", "Use Q with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.AutoCarry:addParam("useE", "Use E with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.AutoCarry:addSubMenu("Ult Options", "Ult")
	Menu.AutoCarry.Ult:addParam("useR", "Use R with AutoCarry", SCRIPT_PARAM_ONOFF, false)
	Menu.AutoCarry.Ult:addParam("ultSlice", "Min champs", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
end

function CastQ(unit)
	local CastPosition, HitChance, Position = VP:GetCircularAOECastPosition(unit, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero, false)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillQ.range then
		CastSpell(_Q, CastPosition.x, CastPosition.z)
	end
end

function CastE(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillE.delay, SkillE.radius, SkillE.range, SkillE.speed, myHero, false)
	if HitChance > 0 and GetDistance (CastPosition) <= SkillE.range then
		CastSpell(_E, CastPosition.x, CastPosition.z)
	end
end

function PluginOnAnimation(unit, animationName)
	if unit.isMe and lastAnimation ~= animationName then lastAnimation = animationName end
end

function isChanneling(animationName)
	if lastAnimation == animationName then
		return true
	else
		return false
	end
end