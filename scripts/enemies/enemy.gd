extends CharacterBody2D

signal defeated(enemy: Node)

@export var speed: float = Constants.ENEMY_BASE_SPEED
@export var max_health: float = Constants.ENEMY_BASE_HEALTH

var health: float
var target: Node2D
var run_manager: Node
var attack_cooldown: float = 0.0

func _ready():
	add_to_group("enemies")
	health = max_health
	if not has_node("CollisionShape2D"):
		var collision_shape = CollisionShape2D.new()
		var circle = CircleShape2D.new()
		circle.radius = 14.0
		collision_shape.shape = circle
		add_child(collision_shape)
	queue_redraw()

func _physics_process(delta):
	if not is_instance_valid(target):
		return

	attack_cooldown = maxf(0.0, attack_cooldown - delta)
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * speed
	move_and_slide()
	if attack_cooldown == 0.0 and global_position.distance_to(target.global_position) < 28.0:
		if target.has_method("take_damage"):
			target.take_damage(10.0)
			attack_cooldown = 0.8

func take_damage(amount: float):
	if amount <= 0.0 or health <= 0.0:
		return

	health = maxf(0.0, health - amount)
	if health == 0.0:
		defeated.emit(self)
		if is_instance_valid(run_manager):
			run_manager.enemy_defeated()
		queue_free()

func _draw():
	draw_colored_polygon(
		PackedVector2Array([Vector2(16, 0), Vector2(-12, -11), Vector2(-7, 0), Vector2(-12, 11)]),
		Color(0.9, 0.25, 0.22)
	)
