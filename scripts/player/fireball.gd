extends Area2D

# Fire projectile that travels toward the aimed point and damages the first enemy it touches.

var direction: Vector2 = Vector2.RIGHT
var speed: float = Constants.BULLET_SPEED
var damage: int = Constants.BULLET_DAMAGE
var max_distance: float = 900.0
var travelled: float = 0.0
var radius: float = 7.0
var time: float = 0.0

func _ready():
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = radius
	shape.shape = circle
	add_child(shape)
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	time += delta
	var step = speed * delta
	position += direction * step
	travelled += step
	if travelled >= max_distance:
		queue_free()
	queue_redraw()

func _on_body_entered(body):
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()

func _draw():
	var back = -direction
	for i in range(1, 5):
		var f = 1.0 - i / 5.0
		draw_circle(back * i * radius * 0.9, radius * f, Color(1.0, 0.4 + 0.1 * i, 0.1, 0.5 * f))
	var flicker = 1.0 + 0.15 * sin(time * 40.0)
	draw_circle(Vector2.ZERO, radius * 1.4 * flicker, Color(1.0, 0.3, 0.05, 0.4))
	draw_circle(Vector2.ZERO, radius * flicker, Color(1.0, 0.6, 0.1))
	draw_circle(Vector2.ZERO, radius * 0.5, Color(1.0, 0.95, 0.6))
