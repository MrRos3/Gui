# VantaUI

A polished AMOLED-first Roblox UI library by **MrRos3**.

## Loader

```lua
local VantaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/VantaUI/main/main.lua"))()
```

## Minimal interface sounds

VantaUI v0.3.1 enables the selected **Minimal** sound style by default. Buttons, tabs, toggles, dropdowns, sliders, inputs, notifications, and window opening or closing use the small original sounds hosted in `assets/sounds`.

Supported executors cache the sounds in `WindUI/<folder>/sounds` and load them through `getcustomasset` or `getsynasset`. Executors without downloadable asset support use a built-in Roblox fallback. Sounds can be adjusted per window:

```lua
Sounds = {
    Enabled = true,
    Volume = 0.45,
    Pitch = 1,
}
```

Set `Sounds = false` to mute a window. The runtime also exposes `SetSoundEnabled`, `SetSoundVolume`, `SetSoundPitch`, and `SetSoundForEvent` for live changes.

## v0.3.1

- Minimal GUI sound style enabled by default
- Separate cues for clicks, tabs, toggles, dropdowns, sliders, inputs, notifications, and window state
- Per-window mute, volume, pitch, and event override controls

## v0.3.0

- Public brand is **VantaUI**
- Default theme is **Vanta AMOLED**
- Startup tab defaults to **Home**
- Includes **Vanta Smoked**, **Vanta Dark**, **Vanta AMOLED**, and **Vanta Violet**
- ON toggles stay green across all built-in themes
- Compact capsule toggles and fixed dropdown second-click closing
- Runtime GUI names use the `VantaUI` brand
- Config storage defaults to `VantaUI/...`
- Notifications default to the `VantaUI` title
- Legacy theme aliases remain supported for compatibility
- GitHub Actions automatically regenerates `dist/main.lua` when source files change

## Example

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MrRos3/VantaUI/main/example.lua"))()
```

## Project layout

- `main.lua` - stable VantaUI public loader and customization layer
- `dist/main.lua` - compiled runtime
- `src/` - editable UI source
- `build/` - build tooling
- `example.lua` - showcase and test script
- `.github/workflows/build-gui.yml` - automatic source build

## License

VantaUI is released under the MIT License, Copyright (c) 2026 MrRos3. See [`LICENSE`](./LICENSE).

Required notices for inherited permissively licensed portions are preserved separately in [`THIRD_PARTY_NOTICES`](./THIRD_PARTY_NOTICES).
