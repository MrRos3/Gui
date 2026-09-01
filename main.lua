--[[
    Gui v0.3.0
    Customized WindUI derivative.

    The public loader now runs the customized runtime built from src/ in this repository.
    WindUI is licensed under the MIT License. See LICENSE and NOTICE.md.
]]

local PROJECT_VERSION = "0.3.0"
local UPSTREAM_VERSION = "1.6.66"
local RUNTIME_URL = "https://raw.githubusercontent.com/MrRos3/Gui/main/dist/main.lua"
local FALLBACK_RUNTIME_URL = "https://raw.githubusercontent.com/MrRos3/Gui/main/vendor/windui.lua"

local function download(url)
    local ok, source = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and type(source) == "string" and #source > 0 then
        return source
    end
    return nil
end

local source = download(RUNTIME_URL)
local runtimePath = "dist/main.lua"

if not source then
    source = download(FALLBACK_RUNTIME_URL)
    runtimePath = "vendor/windui.lua (fallback)"
end

assert(source, "[Gui] Failed to download the UI runtime")

local loader, loadError = loadstring(source)
assert(loader, "[Gui] Failed to compile the UI runtime: " .. tostring(loadError))

local Gui = loader()
assert(type(Gui) == "table", "[Gui] UI runtime returned an invalid value")

Gui.RuntimeVersion = tostring(Gui.Version or PROJECT_VERSION)
Gui.WindUIVersion = UPSTREAM_VERSION
Gui.Version = PROJECT_VERSION
Gui.Name = "Gui"
Gui.DefaultTheme = "Gui Dark"
Gui.TransparencyValue = 0.12

Gui.GuiInfo = {
    Name = "Gui",
    Version = PROJECT_VERSION,
    Owner = "MrRos3",
    Repository = "MrRos3/Gui",
    Runtime = runtimePath,
    Upstream = "WindUI",
    UpstreamVersion = UPSTREAM_VERSION,
}

Gui.Brand = {
    Name = "Gui",
    Owner = "MrRos3",
    Accent = Color3.fromHex("#7C8CFF"),
    Cyan = Color3.fromHex("#5DE7FF"),
}

local GuiThemes = {
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
    return { "Gui Dark", "Gui AMOLED", "Gui Violet" }
end

function Gui:GetInfo()
    return Gui.GuiInfo
end

return Gui
