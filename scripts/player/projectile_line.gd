extends Node2D

# Draws the aim line(s) for the player's shots. Style follows the active weapon
# upgrades and eases toward its target values for smooth transitions.

const BASE_COLOR = Color(1.0, 1.0, 1.0, 0.8)
const SPREAD_COLOR = Color(0.3, 0.9, 1.0, 0.8)
const RAPID_COLOR = Color(1.0, 0.85, 0.2, 0.85)
const HEAVY_COLOR = Color(1.0, 0.45, 0.2, 0.85)
const LASER_COLOR = Color(1.0, 0.2, 0.3, 0.9)
const BLEND_SPEED = 8.0

@onready var weapons = get_parent().get_node_or_null("Weapons")

var color: Color = BASE_COLOR
var width: float = 2.5
var spread_angle: float = 0.0
var glow: float = 0.0
var pulse_time: float = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _exit_tree():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	if weapons == null:
		return
	pulse_time += delta
	var t = clampf(delta * BLEND_SPEED, 0.0, 1.0)

	var target_color = BASE_COLOR
	var target_width = 2.5
	var target_glow = 0.0
	if weapons.spread_level > 0:
		target_color = SPREAD_COLOR
	if weapons.rapid_level > 0:
		target_color = RAPID_COLOR
		target_width = 2.5 + minf(weapons.rapid_level, 5) * 0.3
	if weapons.heavy_level > 0:
		target_color = HEAVY_COLOR
		target_width = 3.0 + minf(weapons.heavy_level, 5) * 0.5
		target_glow = 1.0
	if weapons.laser_level > 0:
		target_color = LASER_COLOR
		target_width = 4.0
		target_glow = 1.0

	color = color.lerp(target_color, t)
	width = lerpf(width, target_width, t)
	glow = lerpf(glow, target_glow, t)
	var count = weapons.get_shot_count()
	spread_angle = lerpf(spread_angle, weapons.SPREAD_STEP if count > 1 else 0.0, t)
	queue_redraw()

func _draw():
	if weapons == null:
		return
	# Reticle at the mouse position (aim point), in local space
	var center = to_local(get_global_mouse_position())
	var reticle_color = color
	var r = 14.0 + width
	if weapons.rapid_level > 0:
		r += 2.0 * sin(pulse_time * TAU * 4.0)
	if glow > 0.01:
		var glow_color = reticle_color
		glow_color.a *= 0.35 * glow
		draw_arc(center, r, 0.0, TAU, 32, glow_color, width * 3.0)
	draw_arc(center, r, 0.0, TAU, 32, reticle_color, width)
	for dir in [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]:
		var rotated = get_global_transform().basis_xform_inv(dir).normalized()
		draw_line(center + rotated * (r - 5.0), center + rotated * (r + 6.0), reticle_color, width)
	draw_circle(center, 1.5, reticle_color)
