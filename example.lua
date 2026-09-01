local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/main.lua"))()

local Window = Gui:CreateWindow({
    Title = "Gui Demo",
    Folder = "Gui",
    Icon = "sparkles",
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Open Gui",
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
    },
})

local Home = Window:Tab({
    Title = "Home",
    Icon = "house",
})

Home:Button({
    Title = "Hello",
    Desc = "Gui is running from your repository.",
    Callback = function()
        Gui:Notify({
            Title = "Gui",
            Content = "Everything is working 🎉",
        })
    end,
})
