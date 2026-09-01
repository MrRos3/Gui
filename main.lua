--[[
    Gui v0.2.0
    Customized WindUI derivative.

    The runtime and editable source are now vendored in this repository.
    WindUI is licensed under the MIT License. See LICENSE and NOTICE.md.
]]

local UPSTREAM_VERSION = "1.6.66"
local RUNTIME_URL = "https://raw.githubusercontent.com/MrRos3/Gui/main/vendor/windui.lua"

local ok, source = pcall(function()
    return game:HttpGet(RUNTIME_URL)
end)

assert(ok and type(source) == "string", "[Gui] Failed to download the vendored UI runtime")

local loader, loadError = loadstring(source)
assert(loader, "[Gui] Failed to compile the UI runtime: " .. tostring(loadError))

local Gui = loader()
assert(type(Gui) == "table", "[Gui] UI runtime returned an invalid value")

Gui.GuiInfo = {
    Name = "Gui",
    Version = "0.2.0",
    Upstream = "WindUI",
    UpstreamVersion = UPSTREAM_VERSION,
    Repository = "MrRos3/Gui",
    Runtime = "vendor/windui.lua",
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
