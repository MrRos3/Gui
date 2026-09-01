# Gui

A customized Roblox UI library based on WindUI.

## Loader

```lua
local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/main.lua"))()
```

## Current changes

- Own `MrRos3/Gui` loader URL
- Custom **Gui Dark** theme enabled by default
- Darker background and element surfaces
- Blue/cyan controls and accents
- Project metadata exposed through `Gui.GuiInfo`
- WindUI version pinned to `1.6.66` while the source is migrated into this repository

## Example

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/Gui/main/example.lua"))()
```

## License and attribution

This project is a modified derivative of [WindUI](https://github.com/Footagesus/WindUI), originally created by Footages and distributed under the MIT License.

The original MIT copyright and permission notice is preserved in [`LICENSE`](./LICENSE). See [`NOTICE.md`](./NOTICE.md) for attribution details.
