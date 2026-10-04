extends Node

# Game Constants - Adjust these for balance and performance

## Player Movement
const PLAYER_MAX_SPEED = 500.0
const PLAYER_ACCELERATION = 800.0
const PLAYER_DRAG = 0.12  # Air resistance per second
const PLAYER_DIVE_MULTIPLIER = 1.5  # Speed boost when diving
const PLAYER_TURN_SPEED = 5.0  # Rotation speed

## World
const WORLD_WIDTH = 1280
const WORLD_HEIGHT = 720
const TERRAIN_CHUNK_SIZE = 256
const GRAVITY = 0.0  # 0 for space/flight, adjust if needed

## Combat
const PLAYER_HEALTH = 100
const PLAYER_FIRE_RATE = 0.2  # Seconds between shots
const BULLET_SPEED = 600.0
const BULLET_DAMAGE = 10

## Enemies
const ENEMY_SPAWN_RATE = 2.0  # Enemies per second
const ENEMY_BASE_SPEED = 200.0
const ENEMY_BASE_HEALTH = 20
const ENEMY_DETECTION_RANGE = 500.0

## Roguelike Progression
const BASE_RUN_SCORE_MULTIPLIER = 1.0
const UPGRADE_CHOICES_PER_RUN = 3
const STARTING_CREDITS = 0

## Performance
const TARGET_FPS = 60
const MAX_ENEMIES_ON_SCREEN = 50
const MAX_BULLETS_ON_SCREEN = 200
const USE_VSYNC = true
const PHYSICS_FPS = 60

## Debug
const DEBUG_MODE = false
const SHOW_COLLISION_SHAPES = false
const SHOW_HITBOXES = false
