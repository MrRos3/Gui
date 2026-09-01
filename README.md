# Gui

A customized Roblox UI library derived from WindUI.

## Loader

```lua
local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/main.lua"))()
```

## v0.2.0

- WindUI `1.6.66` source is now vendored directly in this repository under `src/`
- Built runtime is stored at `vendor/windui.lua`, so the public loader no longer downloads code from the WindUI repository
- Own `MrRos3/Gui` loader URL
- Custom **Gui Dark** theme enabled by default
- Darker background and element surfaces
- Blue/cyan controls and accents
- Project metadata exposed through `Gui.GuiInfo`
- Build files are included so future changes can be made directly to the library source

## Example

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/example.lua"))()
```

## Project layout

- `main.lua` — stable public loader and our customizations
- `vendor/windui.lua` — vendored WindUI runtime
- `src/` — editable UI source
- `build/` — upstream build tooling
- `example.lua` — quick test GUI

## License and attribution

This project is a modified derivative of [WindUI](https://github.com/Footagesus/WindUI), originally created by Footages and distributed under the MIT License.

The original MIT copyright and permission notice is preserved in [`LICENSE`](./LICENSE). See [`NOTICE.md`](./NOTICE.md) for attribution details.
