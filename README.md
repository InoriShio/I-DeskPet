<div align="Center">
 <h3> Pet March (Evernight) </h3>
 <p> My selfmade desktop pet using QT </p>
 <img src=./Assets/Evernight.gif style="margin: 0px 30px 0px 0px;" />
</div>

## Installation

```zsh
cargo run --bin ideskpet-installer
```

## Feature list

- [x] Binary for I-DeskPet (Branch Main)

# Config

Configuration is found at:

```zsh
~/.config/I-DeskPet
```

Options:

- gifFolder
- maxScaling

Example for config.json:

```json
{
  "gifFolder": "/home/inorishio/Pictures/Pets",
  "maxScaling": 1
}
```

# Hyprland keybinds

Toggle click through

```zsh
bind = CTRL, mouse:274, global, I-DeskPet:toggle-Region
```

Toggle between having your gif on your background vs foreground

```zsh
bind = SHIFT, mouse:274, global, I-DeskPet:toggle-Layer
```

Keybind for cycling through gif layering.
Hover over which gif you want to cycle it's layer for and use the keybind.

```zsh
bind = $mainMod, Z, global, I-DeskPet:cycle-zIndex
```

# Other keybinds

- Double click = Reset gif size to original
- Scroll = Scales the gif up and or down
