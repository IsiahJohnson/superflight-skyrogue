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
│   ├── main.tscn              # Main game scene
│   ├── player/
│   │   ├── player.tscn        # Player ship/character
│   │   └── player.gd          # Player flight controller
│   ├── enemies/
│   │   ├── enemy_base.tscn    # Base enemy template
│   │   └── enemy.gd           # Enemy behavior
│   ├── world/
│   │   ├── terrain.tscn       # Terrain tiles/chunks
│   │   └── terrain.gd         # Terrain generation
│   └── ui/
│       ├── hud.tscn           # Heads-up display
│       ├── pause_menu.tscn    # Pause menu
│       └── upgrade_screen.tscn # Post-run upgrades
├── scripts/
│   ├── managers/
│   │   ├── run_manager.gd     # Run progression & permadeath
│   │   ├── world_manager.gd   # Procedural generation
│   │   └── upgrade_manager.gd # Upgrade system
│   ├── player/
│   │   ├── flight_controller.gd  # Flight physics
│   │   └── weapons.gd            # Weapon/combat system
│   └── utils/
│       ├── constants.gd        # Game constants
│       └── helpers.gd          # Utility functions
├── assets/
│   ├── sprites/                # 2D graphics (player, enemies, terrain)
│   ├── audio/                  # Music & SFX
│   │   ├── music/
│   │   └── sfx/
│   └── fonts/                  # Custom fonts
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
- [ ] Basic player sprite/shape
- [ ] Flight controller (up/down/left/right movement)
- [ ] Speed system (momentum-based)
- [ ] Dive mechanic (speed boost)
- [ ] Terrain collision detection

#### Phase 2: Combat
- [ ] Simple enemy spawning
- [ ] Enemy AI (chase/pattern)
- [ ] Bullet/weapon system
- [ ] Hit detection & damage

#### Phase 3: Procedural Generation
- [ ] Terrain chunk system
- [ ] Procedural spawning algorithms
- [ ] Wave-based enemy progression

#### Phase 4: Roguelike Progression
- [ ] Permadeath system
- [ ] Upgrade menu
- [ ] Run statistics tracking
- [ ] Unlock system

#### Phase 5: Polish & Balance
- [ ] SFX & Music
- [ ] Visual effects (particles, trails)
- [ ] Tutorial/UI improvements
- [ ] Performance optimization

## Key Scripts

### `flight_controller.gd`
Handles player flight physics:
- Acceleration/deceleration
- Momentum preservation
- Dive mechanics
- Terrain collision

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
