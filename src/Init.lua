local Gui = {
	Name = "Gui",
	Window = nil,
	Theme = nil,
	Creator = require("./modules/Creator"),
	LocalizationModule = require("./modules/Localization"),
	NotificationModule = require("./components/Notification"),
	Themes = nil,
	Transparent = false,

	TransparencyValue = 0.12,

	UIScale = 1,

	ConfigManager = nil,
	Version = "0.0.0",

	Services = require("./utils/services/Init"),

	OnThemeChangeFunction = nil,

	cloneref = nil,
	UIScaleObj = nil,

	CreateWindow = nil,

	CurrentInput = nil,
}

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

Gui.cloneref = cloneref

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))

function Gui.GenerateGUID()
	return HttpService:GenerateGUID(false)
end

local CurInput = Gui.GenerateGUID()

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	--[[if GameProcessed then
		return
	end]]

	task.defer(function()
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			if Gui.CurrentInput and Gui.CurrentInput ~= CurInput then
				return
			end

			Gui.CurrentInput = CurInput
			--print(CurInput)
			--Gui.InputStartedOnUI = false
		end
	end)
end)
UserInputService.InputEnded:Connect(function(Input, GameProcessed)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		if Gui.CurrentInput and Gui.CurrentInput ~= CurInput then
			return
		end

		Gui.CurrentInput = nil
	end
end)

local LocalPlayer = Players.LocalPlayer or nil

local Package = HttpService:JSONDecode(require("../build/package"))
if Package then
	Gui.Version = Package.version
end

local KeySystem = require("./components/KeySystem")

local Creator = Gui.Creator

local New = Creator.New

--local Tween = Creator.Tween
--local ServicesModule = Gui.Services

local Acrylic = require("./utils/Acrylic/Init")

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local GUIParent = gethui and gethui() or (CoreGui or LocalPlayer:WaitForChild("PlayerGui"))

local UIScaleObj = New("UIScale", {
	Scale = Gui.UIScale,
})

Gui.UIScaleObj = UIScaleObj

Gui.ScreenGui = New("ScreenGui", {
	Name = "Gui",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	ScreenInsets = "None",
	DisplayOrder = -99999,
}, {

	New("Folder", {
		Name = "Window",
	}),
	-- New("Folder", {
	--     Name = "Notifications"
	-- }),
	-- New("Folder", {
	--     Name = "Dropdowns"
	-- }),
	New("Folder", {
		Name = "KeySystem",
	}),
	New("Folder", {
		Name = "Popups",
	}),
	New("Folder", {
		Name = "ToolTips",
	}),
})

Gui.NotificationGui = New("ScreenGui", {
	Name = "Gui/Notifications",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
Gui.DropdownGui = New("ScreenGui", {
	Name = "Gui/Dropdowns",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
Gui.TooltipGui = New("ScreenGui", {
	Name = "Gui/Tooltips",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
ProtectGui(Gui.ScreenGui)
ProtectGui(Gui.NotificationGui)
ProtectGui(Gui.DropdownGui)
ProtectGui(Gui.TooltipGui)

Creator.Init(Gui)

function Gui:SetParent(parent)
	if Gui.ScreenGui then
		Gui.ScreenGui.Parent = parent
	end
	if Gui.NotificationGui then
		Gui.NotificationGui.Parent = parent
	end
	if Gui.DropdownGui then
		Gui.DropdownGui.Parent = parent
	end
	if Gui.TooltipGui then
		Gui.TooltipGui.Parent = parent
	end
end
math.clamp(Gui.TransparencyValue, 0, 1)

local Holder = Gui.NotificationModule.Init(Gui.NotificationGui)

function Gui:Notify(Config)
	Config.Holder = Holder.Frame
	Config.Window = Gui.Window
	--Config.Gui = Gui
	return Gui.NotificationModule.New(Config)
end

function Gui:SetNotificationLower(Val)
	Holder.SetLower(Val)
end

function Gui:SetFont(FontId)
	Creator.UpdateFont(FontId)
end

function Gui:OnThemeChange(func)
	Gui.OnThemeChangeFunction = func
end

function Gui:AddTheme(LTheme)
	Gui.Themes[LTheme.Name] = LTheme
	return LTheme
end

function Gui:SetTheme(Value)
	if Gui.Themes[Value] then
		Gui.Theme = Gui.Themes[Value]
		Creator.SetTheme(Gui.Themes[Value])

		if Gui.OnThemeChangeFunction then
			Gui.OnThemeChangeFunction(Value)
		end

		return Gui.Themes[Value]
	end
	return nil
end

function Gui:GetThemes()
	return Gui.Themes
end
function Gui:GetCurrentTheme()
	return Gui.Theme.Name
end
function Gui:GetTransparency()
	return Gui.Transparent or false
end
function Gui:GetWindowSize()
	return Gui.Window.UIElements.Main.Size
end
function Gui:Localization(LocalizationConfig)
	return Gui.LocalizationModule:New(LocalizationConfig, Creator)
end

function Gui:SetLanguage(Value)
	if Creator.Localization then
		return Creator.SetLanguage(Value)
	end
	return false
end

function Gui:ToggleAcrylic(Value)
	if Gui.Window and Gui.Window.AcrylicPaint and Gui.Window.AcrylicPaint.Model then
		Gui.Window.Acrylic = Value
		Gui.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
		if Value then
			Acrylic.Enable()
		else
			Acrylic.Disable()
		end
	end
end

function Gui:Gradient(stops, props)
	local colorSequence = {}
	local transparencySequence = {}

	for posStr, stop in next, stops do
		local position = tonumber(posStr)
		if position then
			position = math.clamp(position / 100, 0, 1)

			local color = stop.Color
			if typeof(color) == "string" and string.sub(color, 1, 1) == "#" then
				color = Color3.fromHex(color)
			end

			local transparency = stop.Transparency or 0

			table.insert(colorSequence, ColorSequenceKeypoint.new(position, color))
			table.insert(transparencySequence, NumberSequenceKeypoint.new(position, transparency))
		end
	end

	table.sort(colorSequence, function(a, b)
		return a.Time < b.Time
	end)
	table.sort(transparencySequence, function(a, b)
		return a.Time < b.Time
	end)

	if #colorSequence < 2 then
		table.insert(colorSequence, ColorSequenceKeypoint.new(1, colorSequence[1].Value))
		table.insert(transparencySequence, NumberSequenceKeypoint.new(1, transparencySequence[1].Value))
	end

	local gradientData = {
		Color = ColorSequence.new(colorSequence),
		Transparency = NumberSequence.new(transparencySequence),
	}

	if props then
		for k, v in pairs(props) do
			gradientData[k] = v
		end
	end

	return gradientData
end

function Gui:Popup(PopupConfig)
	PopupConfig.Gui = Gui
	return require("./components/popup/Init").new(PopupConfig, Gui.ScreenGui.Popups)
end

Gui.Themes = require("./themes/Init")(Gui, Creator)

Gui.Themes["Gui Dark"] = {
	Name = "Gui Dark",
	Accent = Color3.fromHex("#151923"),
	Dialog = Color3.fromHex("#11141C"),
	Outline = Color3.fromHex("#FFFFFF"),
	Text = Color3.fromHex("#F7F9FF"),
	Placeholder = Color3.fromHex("#98A1B3"),
	Background = Color3.fromHex("#0B0E14"),
	Button = Color3.fromHex("#242B3A"),
	Icon = Color3.fromHex("#AEB7C8"),
	Toggle = Color3.fromHex("#5DE7FF"),
	Slider = Color3.fromHex("#7C8CFF"),
	Checkbox = Color3.fromHex("#7C8CFF"),
	Primary = Color3.fromHex("#7C8CFF"),
	SliderIcon = Color3.fromHex("#A9B2C4"),
	PanelBackground = Color3.fromHex("#FFFFFF"),
	PanelBackgroundTransparency = 0.96,
	LabelBackground = Color3.fromHex("#000000"),
	LabelBackgroundTransparency = 0.82,
	ElementBackground = Color3.fromHex("#171C27"),
	ElementBackgroundTransparency = 0,
}

Gui.Themes["Gui AMOLED"] = {
	Name = "Gui AMOLED",
	Accent = Color3.fromHex("#0A0A0D"),
	Dialog = Color3.fromHex("#08090C"),
	Outline = Color3.fromHex("#FFFFFF"),
	Text = Color3.fromHex("#FFFFFF"),
	Placeholder = Color3.fromHex("#858B98"),
	Background = Color3.fromHex("#000000"),
	Button = Color3.fromHex("#17191F"),
	Icon = Color3.fromHex("#A8AFBC"),
	Toggle = Color3.fromHex("#55F1D6"),
	Slider = Color3.fromHex("#5DE7FF"),
	Checkbox = Color3.fromHex("#5DE7FF"),
	Primary = Color3.fromHex("#5DE7FF"),
	SliderIcon = Color3.fromHex("#C4CAD4"),
	PanelBackground = Color3.fromHex("#FFFFFF"),
	PanelBackgroundTransparency = 0.975,
	LabelBackground = Color3.fromHex("#090A0C"),
	LabelBackgroundTransparency = 0.12,
	ElementBackground = Color3.fromHex("#0D0F14"),
	ElementBackgroundTransparency = 0,
}

Gui.Themes["Gui Violet"] = {
	Name = "Gui Violet",
	Accent = Color3.fromHex("#211B35"),
	Dialog = Color3.fromHex("#171323"),
	Outline = Color3.fromHex("#FFFFFF"),
	Text = Color3.fromHex("#FCF9FF"),
	Placeholder = Color3.fromHex("#A49AB5"),
	Background = Color3.fromHex("#0D0A13"),
	Button = Color3.fromHex("#2C2440"),
	Icon = Color3.fromHex("#C5B8D8"),
	Toggle = Color3.fromHex("#A98BFF"),
	Slider = Color3.fromHex("#A98BFF"),
	Checkbox = Color3.fromHex("#D47CFF"),
	Primary = Color3.fromHex("#A98BFF"),
	SliderIcon = Color3.fromHex("#D7CCEA"),
	PanelBackground = Color3.fromHex("#FFFFFF"),
	PanelBackgroundTransparency = 0.965,
	LabelBackground = Color3.fromHex("#120E1B"),
	LabelBackgroundTransparency = 0.12,
	ElementBackground = Color3.fromHex("#1B1628"),
	ElementBackgroundTransparency = 0,
}

Creator.Themes = Gui.Themes

Gui:SetTheme("Gui Dark")
Gui:SetLanguage(Creator.Language)

function Gui:CreateWindow(Config)
	local CreateWindow = require("./components/window/Init")

	if not RunService:IsStudio() and writefile then
		if not isfolder("Gui") then
			makefolder("Gui")
		end
		if Config.Folder then
			makefolder(Config.Folder)
		else
			makefolder(Config.Title)
		end
	end

	Config.Gui = Gui
	Config.Window = Gui.Window
	Config.Parent = Gui.ScreenGui.Window

	if Gui.Window then
		warn("[Gui] You cannot create more than one window")
		return
	end

	local CanLoadWindow = true

	local Theme = Gui.Themes[Config.Theme or "Gui Dark"]

	--Gui.Theme = Theme
	Creator.SetTheme(Theme)

	local hwid = gethwid or function()
		return Players.LocalPlayer.UserId
	end

	local Filename = hwid()

	if Config.KeySystem then
		CanLoadWindow = false

		local function loadKeysystem()
			KeySystem.new(Config, Filename, function(c)
				CanLoadWindow = c
			end)
		end

		local keyPath = (Config.Folder or "Temp") .. "/" .. Filename .. ".key"

		if Config.KeySystem.KeyValidator then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local savedKey = readfile(keyPath)
				local isValid = Config.KeySystem.KeyValidator(savedKey)

				if isValid then
					CanLoadWindow = true
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		elseif not Config.KeySystem.API then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local savedKey = readfile(keyPath)
				local isKey = (type(Config.KeySystem.Key) == "table") and table.find(Config.KeySystem.Key, savedKey)
					or tostring(Config.KeySystem.Key) == tostring(savedKey)

				if isKey then
					CanLoadWindow = true
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		else
			if isfile(keyPath) then
				local fileKey = readfile(keyPath)
				local isSuccess = false

				for _, i in next, Config.KeySystem.API do
					local serviceData = Gui.Services[i.Type]
					if serviceData then
						local args = {}
						for _, argName in next, serviceData.Args do
							table.insert(args, i[argName])
						end

						local service = serviceData.New(table.unpack(args))
						local success = service.Verify(fileKey)
						if success then
							isSuccess = true
							break
						end
					end
				end

				CanLoadWindow = isSuccess
				if not isSuccess then
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		end

		repeat
			task.wait()
		until CanLoadWindow
	end

	local Window = CreateWindow(Config)

	Gui.Transparent = Config.Transparent
	Gui.Window = Window

	if Config.Acrylic then
		Acrylic.init()
	end

	-- function Window:ToggleTransparency(Value)
	--     Gui.Transparent = Value
	--     Gui.Window.Transparent = Value

	--     Window.UIElements.Main.Background.BackgroundTransparency = Value and Gui.TransparencyValue or 0
	--     Window.UIElements.Main.Background.ImageLabel.ImageTransparency = Value and Gui.TransparencyValue or 0
	--     Window.UIElements.Main.Gradient.UIGradient.Transparency = NumberSequence.new{
	--         NumberSequenceKeypoint.new(0, 1),
	--         NumberSequenceKeypoint.new(1, Value and 0.85 or 0.7),
	--     }
	-- end

	return Window
end

return Gui
