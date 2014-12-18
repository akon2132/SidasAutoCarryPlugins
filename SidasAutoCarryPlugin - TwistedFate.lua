local selected = "goldcardlock"
local lastUse, lastUse2 = 0,0

function PluginOnLoad()
	mainLoad()
	mainMenu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	WREADY = (myHero:CanUseSpell(_W) == READY)

	if WREADY and GetTickCount()-lastUse <= 2300 then
		if myHero:GetSpellData(_W).name == selected then CastSpell(_W) end
	end

	if WREADY and GetTickCount() - lastUse >= 2400 and GetTickCount() - lastUse >= 500 then
		if Menu.selectgold then 
			selected = "goldcardlock"
		elseif Menu.selectblue then 
			selected = "bluecardlock"
		elseif Menu.selectred then 
			selected = "redcardlock"
		else 
			return 
		end	
		CastSpellEx(_W)
		lastUse = GetTickCount()
	end
end

function mainLoad()
    Menu = AutoCarry.PluginMenu
    Menu2 = AutoCarry.MainMenu
    AutoCarry.SkillsCrosshair.range = 1250
	WREADY = false
	WRange = 700 
end

function mainMenu()
	Menu:addParam("selectgold", "Select Gold", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Menu:addParam("selectblue", "Select Blue", SCRIPT_PARAM_ONKEYDOWN, false, 69)
	Menu:addParam("selectred", "Select Red", SCRIPT_PARAM_ONKEYDOWN, false, 84)
end

function OnProcessSpell(unit, spell)
	if unit.isMe and spell.name == "PickACard" then lastUse2 = GetTickCount() end
end