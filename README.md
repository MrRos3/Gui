# Gui

A polished Roblox UI library by **MrRos3**.

## Loader

```lua
local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/main.lua"))()
```

## v0.3.0

- Public loader runs the customized build from `dist/main.lua`
- Runtime ScreenGui names use the `Gui` brand
- Config storage uses `Gui/...`
- Default theme is **Gui Dark**
- Includes **Gui Dark**, **Gui AMOLED**, and **Gui Violet**
- Default topbar uses Mac-style controls with a 44px height
- Notifications default to the `Gui` title
- Package and build metadata point to `MrRos3/Gui`
- GitHub Actions automatically regenerates the runtime when source files change
- Refined open button, dialogs, spacing, colors, and motion

## Example

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/example.lua"))()
```

## Project layout

- `main.lua` - stable public loader and Gui customization layer
- `dist/main.lua` - compiled Gui runtime
- `src/` - editable UI source
- `build/` - build tooling
- `example.lua` - showcase and test script
- `.github/workflows/build-gui.yml` - automatic source build

## License

MIT License. See [`LICENSE`](./LICENSE).
