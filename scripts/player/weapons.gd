extends Node

@export var fire_rate: float = Constants.PLAYER_FIRE_RATE
@export var damage: int = Constants.BULLET_DAMAGE
@export var range: float = 900.0

var cooldown: float = 0.0
@onready var player: CharacterBody2D = get_parent()

func _process(delta):
	cooldown = maxf(0.0, cooldown - delta)
	if Input.is_action_pressed("shoot") and cooldown == 0.0:
		_fire()

func _fire():
	cooldown = fire_rate
	var direction = player.global_position.direction_to(player.get_global_mouse_position())
	if direction == Vector2.ZERO:
		return

	var query = PhysicsRayQueryParameters2D.create(
		player.global_position,
		player.global_position + direction * range
	)
	query.exclude = [player.get_rid()]
	var hit = player.get_world_2d().direct_space_state.intersect_ray(query)
	if hit and hit.collider.is_in_group("enemies") and hit.collider.has_method("take_damage"):
		hit.collider.take_damage(damage)
