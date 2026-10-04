extends CharacterBody2D

## Flight Controller Script
## Handles all player movement, momentum, and flight physics

signal died

@export var max_speed: float = 500.0
@export var acceleration: float = 800.0
@export var drag: float = 0.12  # Air resistance per second
@export var dive_multiplier: float = 1.5
@export var turn_speed: float = 5.0

var current_speed: float = 0.0
var is_diving: bool = false
var health: float = 100.0
var max_health: float = 100.0

# Input handling
var input_vector: Vector2 = Vector2.ZERO

func _ready():
	# Initialize with constants if needed
	max_speed = Constants.PLAYER_MAX_SPEED
	acceleration = Constants.PLAYER_ACCELERATION
	drag = Constants.PLAYER_DRAG
	dive_multiplier = Constants.PLAYER_DIVE_MULTIPLIER
	turn_speed = Constants.PLAYER_TURN_SPEED
	
	# Set up physics
	if has_node("CollisionShape2D"):
		pass  # Collision shape already set up in scene
	queue_redraw()

func _physics_process(delta):
	_handle_input()
	_update_flight_physics(delta)
	_update_position(delta)
	_clamp_to_world()

func _handle_input():
	input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	
	input_vector = input_vector.normalized()
	
	# Dive mechanic
	is_diving = Input.is_action_pressed("dive")

func _update_flight_physics(delta):
	var target_speed = max_speed
	if is_diving:
		target_speed *= dive_multiplier

	velocity += Vector2.RIGHT.rotated(rotation) * acceleration * delta
	velocity += input_vector * acceleration * delta
	if is_diving and velocity.length_squared() > 0.0:
		velocity += velocity.normalized() * acceleration * (dive_multiplier - 1.0) * delta

	velocity *= exp(-drag * delta)
	if velocity.length() > target_speed:
		velocity = velocity.normalized() * target_speed
	current_speed = velocity.length()

func _update_position(delta):
	if velocity.length_squared() > 0.0:
		var target_rotation = velocity.angle()
		rotation = lerp_angle(rotation, target_rotation, turn_speed * delta)

	move_and_slide()

func _clamp_to_world():
	"""Keep player within world bounds"""
	if position.x < 0.0 or position.x > Constants.WORLD_WIDTH:
		velocity.x = 0.0
	if position.y < 0.0 or position.y > Constants.WORLD_HEIGHT:
		velocity.y = 0.0
	position.x = clampf(position.x, 0.0, Constants.WORLD_WIDTH)
	position.y = clampf(position.y, 0.0, Constants.WORLD_HEIGHT)
	current_speed = velocity.length()

func take_damage(amount: float):
	"""Handle damage to player"""
	if amount <= 0.0 or health <= 0.0:
		return

	health -= amount
	health = max(0, health)
	
	if health <= 0:
		_on_death()

func _on_death():
	"""Handle player death"""
	print("Player died!")
	set_physics_process(false)
	died.emit()

func reset_flight():
	"""Reset flight state (useful for new runs)"""
	velocity = Vector2.ZERO
	current_speed = 0.0
	is_diving = false
	health = max_health

func get_speed_ratio() -> float:
	"""Return speed as ratio of max speed (0.0 to 1.0)"""
	return clampf(current_speed / max_speed, 0.0, 1.0)

func _draw():
	draw_colored_polygon(
		PackedVector2Array([Vector2(16, 0), Vector2(-12, -10), Vector2(-7, 0), Vector2(-12, 10)]),
		Color(0.25, 0.8, 1.0)
	)
