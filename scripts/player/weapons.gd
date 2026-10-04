extends Node

@export var fire_rate: float = Constants.PLAYER_FIRE_RATE
@export var damage: int = Constants.BULLET_DAMAGE
@export var range: float = 900.0

# Upgrade levels, read by the projectile line so it mirrors the actual shot pattern
var spread_level: int = 0
var rapid_level: int = 0
var heavy_level: int = 0
var laser_level: int = 0

const SPREAD_STEP: float = deg_to_rad(10.0)
const LASER_RANGE_BONUS: float = 400.0

var cooldown: float = 0.0
@onready var player: CharacterBody2D = get_parent()

func _process(delta):
	cooldown = maxf(0.0, cooldown - delta)
	if Input.is_action_pressed("shoot") and cooldown == 0.0:
		_fire()

func get_shot_count() -> int:
	return 1 + spread_level * 2

func get_effective_range() -> float:
	return range + (LASER_RANGE_BONUS if laser_level > 0 else 0.0)

func get_aim_direction() -> Vector2:
	return player.global_position.direction_to(player.get_global_mouse_position())

func _fire():
	cooldown = fire_rate
	var direction = get_aim_direction()
	if direction == Vector2.ZERO:
		return

	var count = get_shot_count()
	for index in range(count):
		var angle = (index - (count - 1) / 2.0) * SPREAD_STEP
		_fire_ray(direction.rotated(angle))

func _fire_ray(direction: Vector2):
	var fireball = preload("res://scripts/player/fireball.gd").new()
	fireball.direction = direction
	fireball.damage = damage
	fireball.max_distance = get_effective_range()
	player.get_parent().add_child(fireball)
	fireball.global_position = player.global_position
