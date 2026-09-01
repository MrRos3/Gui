local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/main.lua"))()

local Window = Gui:CreateWindow({
    Title = "Gui Showcase",
    Icon = "sparkles",
    HideSearchBar = false,
    OpenButton = {
        Title = "Open Gui",
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
    },
})

Window:Tag({
    Title = "v" .. Gui.Version,
    Icon = "github",
    Color = Color3.fromHex("#171C27"),
    Border = true,
})

local Home = Window:Tab({
    Title = "Home",
    Icon = "house",
})

local Themes = Window:Tab({
    Title = "Themes",
    Icon = "palette",
})

local About = Window:Tab({
    Title = "About",
    Icon = "info",
})

Home:Button({
    Title = "Gui is alive",
    Desc = "This window is loaded from MrRos3/Gui.",
    Icon = "sparkles",
    Callback = function()
        Gui:Notify({
            Content = "Gui v" .. Gui.Version .. " is running 🎉",
            Icon = "sparkles",
        })
    end,
})

Home:Button({
    Title = "Runtime info",
    Desc = "Shows the current Gui runtime version.",
    Icon = "package",
    Callback = function()
        local info = Gui:GetInfo()
        Gui:Notify({
            Title = "Gui Runtime",
            Content = "Gui " .. tostring(info.Version) .. " • runtime " .. tostring(Gui.RuntimeVersion or info.Version),
            Icon = "package",
        })
    end,
})

local function addThemeButton(themeName, icon)
    Themes:Button({
        Title = themeName,
        Desc = "Switch the whole interface to " .. themeName .. ".",
        Icon = icon,
        Callback = function()
            Gui:SetTheme(themeName)
            Gui:Notify({
                Content = "Theme changed to " .. themeName,
                Icon = icon,
            })
        end,
    })
end

addThemeButton("Gui Dark", "moon")
addThemeButton("Gui AMOLED", "circle-dot")
addThemeButton("Gui Violet", "wand-sparkles")

About:Button({
    Title = "MrRos3/Gui",
    Desc = "Custom Gui library with its own loader, branding and themes.",
    Icon = "github",
    Callback = function()
        Gui:Notify({
            Content = "Built from your own GitHub repository 🩵",
            Icon = "heart",
        })
    end,
})
