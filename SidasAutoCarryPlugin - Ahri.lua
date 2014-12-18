require "VPrediction"

local SkillQ = {delay = 0.25, radius = 113, range = 880, speed = 1100}
local SkillW = {range = 800}
local SkillE = {delay = 0.25, radius = 60, range = 975, speed = 1200}
local SkillR = {range = 533}

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



	if Menu.HarassMe.harassQ and Menu2.MixedMode then
		if Target and QREADY and GetDistance(Target) <= SkillQ.range then
			harassQ(Target)
		end
	end

	if Menu.CharmMe.castCharm then
		if Target and EREADY then
			CastE(Target)
		end
	end

	if Menu2.AutoCarry then
		if Menu.AutoCarry.useE and Target and EREADY then
			CastE(Target)
		end

		if Menu.AutoCarry.useQ and Target and QREADY then
			CastQ(Target)
		end

		if Menu.AutoCarry.useW and Target and WREADY and GetDistance(Target) <= SkillW.range then
			CastSpell(_W)
		end


	end

	-- if Menu2.MixedMode then
	-- 	if Menu.useQ and Target and QREADY then
	-- 		CastQ(Target)
	-- 	end
	-- end

	-- if Menu2.LaneClear and Menu.LaneClear.clearCastQ and QREADY then
	-- 	for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
	-- 		if ValidTarget(minion) and GetDistance(minion) <= SkillQ.range then
	-- 			clearCastQ(minion)
	-- 		end
	-- 	end
	-- end
end

function mainLoad()
	VP = VPrediction()

    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = SkillE.range
	QREADY, WREADY, EREADY, RREADY = false, false, false, false
end

function mainMenu()
	--[[ Auto Carry ]] --
	Menu:addSubMenu("AutoCarry", "AutoCarry")
	Menu.AutoCarry:addParam("useQ", "Use Q with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.AutoCarry:addParam("useW", "Use W with AutoCarry", SCRIPT_PARAM_ONOFF, true)
	Menu.AutoCarry:addParam("useE", "Use E with AutoCarry", SCRIPT_PARAM_ONOFF, true)

	-- [[ Charm ]] -- 
	Menu:addSubMenu("Charm", "CharmMe")
	Menu.CharmMe:addParam("castCharm", "Charm nearest enemy", SCRIPT_PARAM_ONKEYDOWN, false, 32)

	-- [[ Harass ]] -- 
	Menu:addSubMenu("Harass", "HarassMe")
	Menu.HarassMe:addParam("harassQ", "Auto Harass with Q", SCRIPT_PARAM_ONOFF, true)
	Menu.HarassMe:addParam("harassSliceQ", "Q minimum Mana", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
	-- Menu.Harass:addParam("harassW", "Harass with W", SCRIPT_PARAM_ONOFF, true)

	-- [[ Lane Clear ]] -- 
	-- Menu:addSubMenu("LaneClear", "LaneClear")
	-- Menu.LaneClear:addParam("clearCastQ", "Cast Q on minion wave", SCRIPT_PARAM_ONOFF, true)
	-- Menu.LaneClear:addParam("numHitQ", "Minimum number of hits", SCRIPT_PARAM_SLICE, 3, 1, 7, 0)
end

function CastQ(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero, false)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillQ.range then
		CastSpell(_Q, CastPosition.x, CastPosition.z)
		myHero:MoveTo(mousePos.x, mousePos.z)
	end
end

function CastE(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillE.delay, SkillE.radius, SkillE.range, SkillE.speed, myHero, true)
	if HitChance > 0 and GetDistance(CastPosition) <= SkillE.range then
		CastSpell(_E, CastPosition.x, CastPosition.z)
		myHero:MoveTo(mousePos.x, mousePos.z)
	end
end

-- function clearCastQ(unit)
-- 	local CastPosition, HitChance, MaxHit = VP:GetLineAOECastPosition(unit, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero)
-- 	if MaxHit >= Menu.LaneClear.numHitQ and GetDistance(CastPosition) <= SkillQ.range then 
-- 		CastSpell(_Q, CastPosition.x, CastPosition.z)
-- 	end
-- end

function harassQ(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.radius, SkillQ.range, SkillQ.speed, myHero, false)
	if myHero.mana >= (myHero.maxMana * (Menu.HarassMe.harassSliceQ / 100)) then
		if HitChance > 0 and GetDistance(CastPosition, myHero) <= SkillQ.range then
			CastSpell(_Q, CastPosition.x, CastPosition.z)
		end
	end
end