# Superflight Sky Rogue

A flying roguelike hybrid combining **Superflight's** physics-based gliding mechanics with **Sky Rogue's** procedural combat and progression systems.

## Project Overview

### Gameplay Concept
- **Flight Mechanics:** Smooth, physics-based gliding with momentum management
- **Combat:** Procedurally generated enemies and terrain encounters
- **Progression:** Permadeath roguelike loop with between-run upgrades
- **Risk/Reward:** Terrain-hugging flight for speed boosts, but crashes cause damage

### Target Platform
- **Engine:** Godot 4.2+
- **Target Hardware:** Low-end PCs (HP 15-fd0xxx and similar integrated GPU machines)
- **Resolution:** 1280x720 (scalable)
- **FPS Target:** 60 FPS

## Project Structure

```
superflight-skyrogue/
├── scenes/
│   ├── main.tscn              # Playable game scene
│   └── main.gd                # Game loop and HUD
├── scripts/
│   ├── enemies/
│   │   └── enemy.gd           # Enemy chase AI, health, and damage
│   ├── managers/
│   │   ├── run_manager.gd     # Run progression & permadeath
│   │   ├── world_manager.gd   # Procedural generation
│   │   └── upgrade_manager.gd # Upgrade selection and persistence
│   ├── player/
│   │   ├── flight_controller.gd  # Flight physics
│   │   └── weapons.gd            # Weapon/combat system
│   └── utils/
│       ├── constants.gd        # Game constants
├── project.godot               # Godot project config
└── README.md                   # This file
```

## Quick Start

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/IsiahJohnson/superflight-skyrogue.git
   cd superflight-skyrogue
   ```

2. Open in Godot 4.2+:
   - Download [Godot Engine](https://godotengine.org/download)
   - Open Godot, click "Open Project"
   - Navigate to the `superflight-skyrogue` folder

3. Run the game:
   - Press `F5` or click the "Play" button in the editor

### Development Checklist

#### Phase 1: Flight Mechanics (MVP)
- [x] Basic player sprite/shape
- [x] Flight controller (up/down/left/right movement)
- [x] Speed system (momentum-based)
- [x] Dive mechanic (speed boost)
- [ ] Terrain collision detection

#### Phase 2: Combat
- [x] Simple enemy spawning
- [x] Enemy AI (chase/pattern)
- [x] Weapon system
- [x] Hit detection & damage

#### Phase 3: Procedural Generation
- [x] Terrain chunk system
- [ ] Procedural spawning algorithms
- [ ] Wave-based enemy progression

#### Phase 4: Roguelike Progression
- [x] Permadeath system
- [x] Upgrade menu
- [x] Run statistics tracking
- [x] Persistent upgrade progression

#### Phase 5: Polish & Balance
- [ ] SFX & Music
- [ ] Visual effects (particles, trails)
- [ ] Tutorial/UI improvements
- [ ] Performance optimization

## Key Scripts

### `flight_controller.gd`
Handles inertial player flight:
- Directional input accelerates and steers the player while preserving existing momentum
- Releasing directional input lets the player glide, with gradual air resistance
- Holding Space accelerates along the current flight path and raises the speed limit
- Character-body movement handles collision response

### `run_manager.gd`
Manages the run loop:
- Run start/end
- Permadeath
- Score & stats tracking
- Upgrade persistence

### `world_manager.gd`
Procedural generation:
- Terrain chunk generation
- Enemy wave spawning
- Loot distribution

### `upgrade_manager.gd`
Offers up to three upgrades after each run and saves selected upgrade levels in `user://progress.cfg`.

The main scene includes a lightweight player, enemy spawner, HUD, and keyboard-selectable upgrade loop. Aim with the mouse and hold the left mouse button to fire.

## Performance Tips for Low-End Hardware

- Keep particle count low (~50 max on screen)
- Use simple 2D shapes before detailed sprites
- Disable shadows and fancy effects
- Test frequently on target hardware
- Limit active physics bodies per scene

## Controls

| Action | Input |
|--------|-------|
| Move Up | W / ↑ |
| Move Down | S / ↓ |
| Move Left | A / ← |
| Move Right | D / → |
| Dive/Boost | SPACE |
| Shoot | Left Mouse Button |
| Pause | ESC |

## License

MIT License - Feel free to use this as a template for your own projects!

## Contributing

This is a solo dev project, but feel free to fork and experiment!

## Resources

- [Godot Documentation](https://docs.godotengine.org/)
- [GDScript Language](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html)
- [2D Physics in Godot](https://docs.godotengine.org/en/stable/tutorials/physics/using_2d_characters/index.html)

## Status

**Early Development** - Currently building core flight mechanics and player controller.

Last Updated: 2026-10-04
