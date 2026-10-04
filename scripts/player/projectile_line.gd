extends Node2D

# Draws the aim line(s) for the player's shots. Style follows the active weapon
# upgrades and eases toward its target values for smooth transitions.

const BASE_COLOR = Color(1.0, 1.0, 1.0, 0.35)
const SPREAD_COLOR = Color(0.3, 0.9, 1.0, 0.4)
const RAPID_COLOR = Color(1.0, 0.85, 0.2, 0.45)
const HEAVY_COLOR = Color(1.0, 0.45, 0.2, 0.45)
const LASER_COLOR = Color(1.0, 0.2, 0.3, 0.55)
const BLEND_SPEED = 8.0

@onready var weapons = get_parent().get_node_or_null("Weapons")

var color: Color = BASE_COLOR
var width: float = 1.5
var spread_angle: float = 0.0
var glow: float = 0.0
var pulse_time: float = 0.0

func _process(delta):
	if weapons == null:
		return
	pulse_time += delta
	var t = clampf(delta * BLEND_SPEED, 0.0, 1.0)

	var target_color = BASE_COLOR
	var target_width = 1.5
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
	var aim = weapons.get_aim_direction()
	if aim == Vector2.ZERO:
		return
	var local_aim = get_global_transform().basis_xform_inv(aim).normalized()
	var length = weapons.get_effective_range()
	var count = weapons.get_shot_count()

	var line_color = color
	var line_width = width
	if weapons.rapid_level > 0:
		line_width *= 1.0 + 0.2 * sin(pulse_time * TAU * 4.0)
		line_color.a *= 0.85 + 0.15 * sin(pulse_time * TAU * 4.0)

	for index in range(count):
		var angle = (index - (count - 1) / 2.0) * spread_angle
		var end = local_aim.rotated(angle) * length
		if glow > 0.01:
			var glow_color = line_color
			glow_color.a *= 0.35 * glow
			draw_line(Vector2.ZERO, end, glow_color, line_width * 3.0)
		draw_line(Vector2.ZERO, end, line_color, line_width)
		if weapons.laser_level > 0:
			draw_line(Vector2.ZERO, end, Color(1, 1, 1, 0.7 * line_color.a / 0.55), maxf(1.0, line_width * 0.3))
