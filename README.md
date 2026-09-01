# Gui

A customized Roblox UI library derived from WindUI, maintained in `MrRos3/Gui`.

## Loader

```lua
local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/main.lua"))()
```

## v0.3.0

- Public loader now runs the **customized build from `dist/main.lua`**
- `vendor/windui.lua` is retained only as an emergency fallback
- Editable WindUI-derived source lives directly under `src/`
- Runtime ScreenGui names are rebranded to `Gui`
- Config storage moved from `WindUI/...` to `Gui/...`
- Default source theme is now **Gui Dark**
- Added **Gui Dark**, **Gui AMOLED**, and **Gui Violet**
- Default topbar uses the Mac-style controls with a 44px height
- Notifications default to the `Gui` title when one is not supplied
- Package/build metadata now points to `MrRos3/Gui`
- Automatic GitHub Actions build regenerates `dist/main.lua` when source files change
- The build header identifies the project as **Gui by MrRos3** while preserving WindUI attribution

## Example

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/example.lua"))()
```

The example includes a home page, runtime info, and buttons for switching between all three Gui themes.

## Project layout

- `main.lua` — stable public loader and compatibility layer
- `dist/main.lua` — compiled customized Gui runtime
- `src/` — editable UI source
- `build/` — build tooling
- `vendor/windui.lua` — pinned upstream fallback runtime
- `example.lua` — showcase/test script
- `.github/workflows/build-gui.yml` — automatic source build

## Compatibility

Gui intentionally keeps the familiar WindUI API shape so scripts can be migrated with minimal changes while the visuals and internals are gradually customized.

## License and attribution

This project is a modified derivative of [WindUI](https://github.com/Footagesus/WindUI), originally created by Footages and distributed under the MIT License.

The original MIT copyright and permission notice is preserved in [`LICENSE`](./LICENSE). See [`NOTICE.md`](./NOTICE.md) for attribution details.
