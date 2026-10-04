extends CharacterBody2D

## Flight Controller Script
## Handles all player movement, momentum, and flight physics

@export var max_speed: float = 500.0
@export var acceleration: float = 800.0
@export var drag: float = 0.95  # Friction/air resistance
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
	# Determine target speed based on dive state
	var target_speed = max_speed
	if is_diving:
		target_speed *= dive_multiplier
	
	# Apply acceleration towards target speed if moving
	if input_vector.length() > 0:
		current_speed = move_toward(current_speed, target_speed, acceleration * delta)
	else:
		# Gradual deceleration when no input
		current_speed = move_toward(current_speed, 0, acceleration * delta * 0.5)
	
	# Apply drag to current speed (realistic friction)
	current_speed *= drag

func _update_position(delta):
	if input_vector.length() > 0:
		# Move in direction player is pointing
		var direction = input_vector
		
		# Rotate player towards movement direction
		var target_rotation = direction.angle()
		rotation = lerp_angle(rotation, target_rotation, turn_speed * delta)
		
		# Move forward based on current speed
		position += direction * current_speed * delta
	
	# Update velocity for CharacterBody2D (for collision detection)
	velocity = (input_vector * current_speed).normalized() * current_speed

func _clamp_to_world():
	"""Keep player within world bounds"""
	position.x = clamp(position.x, 0, Constants.WORLD_WIDTH)
	position.y = clamp(position.y, 0, Constants.WORLD_HEIGHT)

func take_damage(amount: float):
	"""Handle damage to player"""
	health -= amount
	health = max(0, health)
	
	if health <= 0:
		_on_death()

func _on_death():
	"""Handle player death"""
	print("Player died!")
	# Emit signal or notify run manager
	queue_free()

func reset_flight():
	"""Reset flight state (useful for new runs)"""
	current_speed = 0.0
	is_diving = false
	health = max_health

func get_speed_ratio() -> float:
	"""Return speed as ratio of max speed (0.0 to 1.0)"""
	return current_speed / max_speed
