local lib = loadstring(game:HttpGet("https://pastefy.app/cEN5rHRd/raw"))()

local players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")

local lp = players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
lp.CharacterAdded:Connect(function(c) char = c end)

local rmts = rs:WaitForChild("Remotes")
local knit = rs:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services")
local lassore = knit:WaitForChild("LassoService"):WaitForChild("RE")
local foodre = knit:WaitForChild("FoodService"):WaitForChild("RE")

local minigame = rmts:WaitForChild("minigameRequest")
local prog = rmts:WaitForChild("UpdateProgress")
local retrieve = rmts:WaitForChild("retrieveData")
local getidx = rmts:WaitForChild("getPlayerIndex")
local enchantr = rmts:WaitForChild("Enchant")
local buylasso = lassore:WaitForChild("BuyLasso")
local buyfood = foodre:WaitForChild("BuyFood")

local nan = 0/0
local step = 100/13
local lasso = "Inferno Lasso"
local food = "Pie"

local lassos = {
	"Rancher's Rope","Metal Lasso","Steelcoil Lasso","Stormwrangler",
	"Sunforged Lasso","Nightveil Lasso","Voidweave Lasso","Celestial Tether",
	"Nebula Lasso","Fragmented Lasso","Blackhole Lasso","Helion Lasso",
	"Stellar Lasso","Stormrend Lasso","Paradox Lasso","Royal Coil Lasso","Inferno Lasso",
}

local foods = {
	"Farmers Feed","Enriched Feed","Hay","Bone","Prime Feed",
	"Steak","Stew","Potato Bag","Pie",
}

local function trignan()
	pcall(function() minigame:InvokeServer(Instance.new("Model"), char:GetPivot()) end)
	task.wait(0.15)
	for i = 1, 14 do pcall(function() prog:FireServer(step) end); task.wait(0.03) end
	task.wait(0.2)
	pcall(function() getidx:InvokeServer() end)
	pcall(function() retrieve:InvokeServer() end)
	task.wait(0.3)
	pcall(function() buyfood:FireServer(food, nan) end)
	pcall(function() retrieve:InvokeServer() end)
end

local function bylasso()
	pcall(function() buylasso:FireServer(lasso) end)
	pcall(function() retrieve:InvokeServer() end)
end

local function byfood()
	pcall(function() buyfood:FireServer(food, nan) end)
	pcall(function() retrieve:InvokeServer() end)
end

local function ench()
	pcall(function() enchantr:FireServer(lasso) end)
	pcall(function() retrieve:InvokeServer() end)
end

lib.Folders.Directory = "NOX"
lib.Folders.Configs = "NOX/Configs"

local win = lib:Window({
	Logo = "108551171937093",
	FadeSpeed = 0.15,
	PagePadding = 19,
})

local pages = {
	money = win:Page({ Icon = "zap" }),
	shop  = win:Page({ Icon = "shopping-bag" }),
	sett  = win:Page({ Icon = "settings", Search = true }),
}

do
	local sub  = pages.money:SubPage({ Name = "NaN Money", Icon = "zap" })
	local trig = sub:Section({ Name = "Trigger", Icon = "zap",  Side = "Left" })
	local info = sub:Section({ Name = "Info",    Icon = "info", Side = "Right" })

	trig:Button({ Name = "Trigger NaN + Buy Food", Callback = function() task.spawn(trignan) end })
	trig:Label("Auto-buys selected food after NaN", "Left")

	info:Label("NaN = infinite cash", "Left")
	info:Label("Permanent on account", "Left")
	info:Label("Manual shop broken with NaN", "Left")
	info:Label("Use Shop tab buttons only", "Left")
	info:Label("Use at your own risk!", "Left")
end

do
	local lsub = pages.shop:SubPage({ Name = "Lasso", Icon = "target" })
	local fsub = pages.shop:SubPage({ Name = "Food",  Icon = "heart" })

	local lsec = lsub:Section({ Name = "Lasso Shop", Icon = "shopping-bag", Side = "Left" })
	lsec:Dropdown({ Name = "Select Lasso", Flag = "lassodd", Items = lassos, Default = lasso, Multi = false, MaxSize = 130, Callback = function(v) lasso = v end })
	lsec:Button({ Name = "Buy Lasso",    Callback = function() task.spawn(bylasso) end })
	lsec:Button({ Name = "Enchant Lasso", Callback = function() task.spawn(ench) end })

	local fsec = fsub:Section({ Name = "Food Shop", Icon = "heart", Side = "Left" })
	fsec:Dropdown({ Name = "Select Food", Flag = "fooddd", Items = foods, Default = food, Multi = false, MaxSize = 130, Callback = function(v) food = v end })
	fsec:Button({ Name = "Buy Food (NaN)", Callback = function() task.spawn(byfood) end })
end

do
	local csub = pages.sett:SubPage({ Name = "Config", Icon = "folder-cog" })
	local msub = pages.sett:SubPage({ Name = "Menu",   Icon = "settings" })

	local autopath = lib.Folders.Directory.."/autoload.json"

	local getauto = function()
		if not isfile(autopath) then return "" end
		local r = readfile(autopath)
		return r ~= "" and r or ""
	end

	local cfgname, cfgsel, autolbl
	local cfgsec = csub:Section({ Name = "Configs", Icon = "folder-cog", Side = "Left" })
	local actsec = csub:Section({ Name = "Actions", Icon = "save",       Side = "Right" })

	local cfgdd = cfgsec:Dropdown({ Name = "Configs", Flag = "cfglist", Items = {}, Multi = false, MaxSize = 85, Callback = function(v) cfgsel = v end })
	cfgsec:Textbox({ Name = "Config Name", Flag = "cfgname", Default = "", Placeholder = "...", Callback = function(v) cfgname = v end })

	local ok, ar = pcall(function() return lib.Theme.Accent end)
	local accenthex = "#a855f7"
	if ok and ar then
		accenthex = string.format("#%02x%02x%02x", math.floor(ar.R*255), math.floor(ar.G*255), math.floor(ar.B*255))
	end

	local fmtauto = function(n)
		if not n or n == "" then return "Autoload: <font color='#808080'>none</font>" end
		return "Autoload: <font color='"..accenthex.."'>"..n.."</font>"
	end

	actsec:Button({ Name = "Load", Callback = function()
		if not cfgsel then return end
		lib:LoadConfig(readfile(lib.Folders.Configs.."/"..cfgsel))
	end}):SubButton({ Name = "Save", Callback = function()
		if not cfgsel then return end
		lib:SaveConfig(cfgsel)
	end})

	actsec:Button({ Name = "Create", Callback = function()
		if not cfgname or cfgname == "" then return end
		if isfile(lib.Folders.Configs.."/"..cfgname..".json") then return end
		writefile(lib.Folders.Configs.."/"..cfgname..".json", lib:GetConfig())
		lib:RefreshConfigsList(cfgdd)
	end}):SubButton({ Name = "Delete", Callback = function()
		if not cfgsel then return end
		lib:DeleteConfig(cfgsel)
		lib:RefreshConfigsList(cfgdd)
		if getauto() == cfgsel and autolbl then
			writefile(autopath, "")
			autolbl:SetText(fmtauto(nil))
		end
	end})

	actsec:Button({ Name = "Set Autoload", Callback = function()
		if not cfgsel then return end
		writefile(autopath, cfgsel)
		if autolbl then autolbl:SetText(fmtauto(cfgsel)) end
	end}):SubButton({ Name = "Remove Autoload", Callback = function()
		writefile(autopath, "")
		if autolbl then autolbl:SetText(fmtauto(nil)) end
	end})

	autolbl = actsec:Label(fmtauto(getauto()), "Left")
	lib:RefreshConfigsList(cfgdd)

	local cur = getauto()
	if cur ~= "" and isfile(lib.Folders.Configs.."/"..cur) then
		task.spawn(function()
			task.wait(0.2)
			lib:LoadConfig(readfile(lib.Folders.Configs.."/"..cur))
		end)
	end

	local menusec = msub:Section({ Name = "Menu", Icon = "settings", Side = "Left" })

	lib.MenuKeybind = tostring(Enum.KeyCode.RightShift)
	menusec:Keybind({
		Name = "Menu Keybind", Flag = "menubind",
		Default = Enum.KeyCode.RightShift, Mode = "Always",
		Callback = function()
			local k = lib.Flags["menubind"] and lib.Flags["menubind"].Key
			if k and k ~= "None" then
				if not k:match("^Enum%.") then k = "Enum.KeyCode."..tostring(k) end
				lib.MenuKeybind = k
			end
		end,
	})

	local discsec = msub:Section({ Name = "Discord", Icon = "message-circle", Side = "Right" })
	discsec:Label("Bug? Open a ticket!", "Left")
	discsec:Button({ Name = "Join Discord", Callback = function()
		pcall(function() setclipboard("https://discord.gg/fxvxeVtqSw") end)
	end})

	menusec:Button({ Name = "Unload", Callback = function() lib:Unload() end })
end
