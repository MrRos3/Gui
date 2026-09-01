--[[
    Gui v0.1.0
    A customized WindUI derivative/bootstrap.

    WindUI is licensed under the MIT License.
    Original copyright and license are preserved in LICENSE.
]]

local UPSTREAM_VERSION = "1.6.66"
local UPSTREAM_URL = "https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua"

local ok, source = pcall(function()
    return game:HttpGet(UPSTREAM_URL)
end)

assert(ok and type(source) == "string", "[Gui] Failed to download the WindUI runtime")

local loader, loadError = loadstring(source)
assert(loader, "[Gui] Failed to compile the WindUI runtime: " .. tostring(loadError))

local Gui = loader()
assert(type(Gui) == "table", "[Gui] WindUI runtime returned an invalid value")

Gui.GuiInfo = {
    Name = "Gui",
    Version = "0.1.0",
    Upstream = "WindUI",
    UpstreamVersion = UPSTREAM_VERSION,
    Repository = "MrRos3/Gui",
}

Gui:AddTheme({
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
})

Gui:SetTheme("Gui Dark")

return Gui
