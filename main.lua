--[[
    Gui v0.3.0
    Roblox UI library by MrRos3.

    Source: https://github.com/MrRos3/Gui
    License: MIT
]]

local PROJECT_VERSION = "0.3.0"
local RUNTIME_URL = "https://raw.githubusercontent.com/MrRos3/Gui/main/dist/main.lua"

local ok, source = pcall(function()
    return game:HttpGet(RUNTIME_URL)
end)

assert(ok and type(source) == "string" and #source > 0, "[Gui] Failed to download the UI runtime")

local loader, loadError = loadstring(source)
assert(loader, "[Gui] Failed to compile the UI runtime: " .. tostring(loadError))

local Gui = loader()
assert(type(Gui) == "table", "[Gui] UI runtime returned an invalid value")

Gui.RuntimeVersion = tostring(Gui.Version or PROJECT_VERSION)
Gui.Version = PROJECT_VERSION
Gui.Name = "Gui"
Gui.DefaultTheme = "Gui AMOLED"
Gui.TransparencyValue = 0.1

Gui.GuiInfo = {
    Name = "Gui",
    Version = PROJECT_VERSION,
    Owner = "MrRos3",
    Repository = "MrRos3/Gui",
    Runtime = "dist/main.lua",
    License = "MIT",
}

Gui.Brand = {
    Name = "Gui",
    Owner = "MrRos3",
    Accent = Color3.fromHex("#929AA7"),
    Cyan = Color3.fromHex("#5DE7FF"),
}

local GuiThemes = {
    {
        Name = "Gui Smoked",
        Accent = Color3.fromHex("#171A20"),
        Dialog = Color3.fromHex("#121419"),
        Outline = Color3.fromHex("#FFFFFF"),
        Text = Color3.fromHex("#F5F7FA"),
        Placeholder = Color3.fromHex("#8B919C"),
        Background = Color3.fromHex("#0B0D10"),
        Button = Color3.fromHex("#282D35"),
        Icon = Color3.fromHex("#B1B7C1"),
        Toggle = Color3.fromHex("#60CDFF"),
        Slider = Color3.fromHex("#7C8CFF"),
        Checkbox = Color3.fromHex("#929AA7"),
        Primary = Color3.fromHex("#929AA7"),
        SliderIcon = Color3.fromHex("#B8BEC8"),
        PanelBackground = Color3.fromHex("#FFFFFF"),
        PanelBackgroundTransparency = 0.975,
        LabelBackground = Color3.fromHex("#0A0C0F"),
        LabelBackgroundTransparency = 0.16,
        ElementBackground = Color3.fromHex("#1C2027"),
        ElementBackgroundTransparency = 0,
    },
    {
        Name = "Gui Dark",
        Accent = Color3.fromHex("#151923"),
        Dialog = Color3.fromHex("#11141C"),
        Outline = Color3.fromHex("#FFFFFF"),
        Text = Color3.fromHex("#F7F9FF"),
        Placeholder = Color3.fromHex("#98A1B3"),
        Background = Color3.fromHex("#0B0E14"),
        Button = Color3.fromHex("#242B3A"),
        Icon = Color3.fromHex("#AEB7C8"),
        Toggle = Color3.fromHex("#60CDFF"),
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
    },
    {
        Name = "Gui AMOLED",
        Accent = Color3.fromHex("#0A0A0D"),
        Dialog = Color3.fromHex("#08090C"),
        Outline = Color3.fromHex("#FFFFFF"),
        Text = Color3.fromHex("#FFFFFF"),
        Placeholder = Color3.fromHex("#858B98"),
        Background = Color3.fromHex("#000000"),
        Button = Color3.fromHex("#17191F"),
        Icon = Color3.fromHex("#A8AFBC"),
        Toggle = Color3.fromHex("#60CDFF"),
        Slider = Color3.fromHex("#7C8CFF"),
        Checkbox = Color3.fromHex("#5DE7FF"),
        Primary = Color3.fromHex("#5DE7FF"),
        SliderIcon = Color3.fromHex("#C4CAD4"),
        PanelBackground = Color3.fromHex("#FFFFFF"),
        PanelBackgroundTransparency = 0.975,
        LabelBackground = Color3.fromHex("#090A0C"),
        LabelBackgroundTransparency = 0.12,
        ElementBackground = Color3.fromHex("#0D0F14"),
        ElementBackgroundTransparency = 0,
    },
    {
        Name = "Gui Violet",
        Accent = Color3.fromHex("#211B35"),
        Dialog = Color3.fromHex("#171323"),
        Outline = Color3.fromHex("#FFFFFF"),
        Text = Color3.fromHex("#FCF9FF"),
        Placeholder = Color3.fromHex("#A49AB5"),
        Background = Color3.fromHex("#0D0A13"),
        Button = Color3.fromHex("#2C2440"),
        Icon = Color3.fromHex("#C5B8D8"),
        Toggle = Color3.fromHex("#60CDFF"),
        Slider = Color3.fromHex("#7C8CFF"),
        Checkbox = Color3.fromHex("#D47CFF"),
        Primary = Color3.fromHex("#A98BFF"),
        SliderIcon = Color3.fromHex("#D7CCEA"),
        PanelBackground = Color3.fromHex("#FFFFFF"),
        PanelBackgroundTransparency = 0.965,
        LabelBackground = Color3.fromHex("#120E1B"),
        LabelBackgroundTransparency = 0.12,
        ElementBackground = Color3.fromHex("#1B1628"),
        ElementBackgroundTransparency = 0,
    },
}

for _, theme in ipairs(GuiThemes) do
    Gui:AddTheme(theme)
end

local function renameRuntimeGui()
    if Gui.ScreenGui then
        Gui.ScreenGui.Name = "Gui"
    end
    if Gui.NotificationGui then
        Gui.NotificationGui.Name = "Gui/Notifications"
    end
    if Gui.DropdownGui then
        Gui.DropdownGui.Name = "Gui/Dropdowns"
    end
    if Gui.TooltipGui then
        Gui.TooltipGui.Name = "Gui/Tooltips"
    end
end

renameRuntimeGui()
Gui:SetTheme(Gui.DefaultTheme)

local BaseCreateWindow = Gui.CreateWindow
function Gui:CreateWindow(config)
    config = config or {}

    if config.Theme == nil then
        config.Theme = Gui.DefaultTheme
    end
    if config.Folder == nil then
        config.Folder = "Gui"
    end
    if config.NewElements == nil then
        config.NewElements = true
    end

    config.Topbar = config.Topbar or {}
    if config.Topbar.Height == nil then
        config.Topbar.Height = 44
    end
    if config.Topbar.ButtonsType == nil then
        config.Topbar.ButtonsType = "Mac"
    end

    local window = BaseCreateWindow(self, config)
    renameRuntimeGui()
    return window
end

local BaseNotify = Gui.Notify
function Gui:Notify(config)
    config = config or {}
    if config.Title == nil then
        config.Title = "Gui"
    end
    return BaseNotify(self, config)
end

function Gui:GetGuiThemes()
    return { "Gui Smoked", "Gui Dark", "Gui AMOLED", "Gui Violet" }
end

function Gui:GetInfo()
    return Gui.GuiInfo
end

return Gui
