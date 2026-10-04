extends CharacterBody3D

signal crashed

@export var max_speed: float = 45.0
@export var acceleration: float = 7.0
@export var drag: float = 0.16
@export var dive_speed_multiplier: float = 1.65
@export var pitch_speed: float = 0.8
@export var turn_speed: float = 0.9
@export var max_pitch: float = 0.65
@export var max_bank: float = 0.55
@export var lift_coefficient: float = 0.025
@export var gravity: float = 9.8

@onready var camera: Camera3D = $Camera3D

var current_speed: float = 18.0
var is_diving: bool = false
var has_crashed: bool = false
var _pitch_input: float = 0.0
var _turn_input: float = 0.0

func _ready():
	velocity = -global_transform.basis.z * current_speed

func _physics_process(delta: float):
	if has_crashed:
		return

	_handle_input(delta)
	_update_flight_physics(delta)
	_update_camera(delta)
	move_and_slide()

	if get_slide_collision_count() > 0:
		_crash()

func _handle_input(delta: float):
	_turn_input = Input.get_axis("move_left", "move_right")
	_pitch_input = Input.get_axis("move_down", "move_up")
	is_diving = Input.is_action_pressed("dive")

	rotation.y += _turn_input * turn_speed * delta
	if _pitch_input != 0.0:
		rotation.x += _pitch_input * pitch_speed * delta
	else:
		rotation.x = move_toward(rotation.x, 0.0, pitch_speed * 0.35 * delta)
	rotation.x = clampf(rotation.x, -max_pitch, max_pitch)
	rotation.z = lerpf(rotation.z, -_turn_input * max_bank, 3.0 * delta)

func _update_flight_physics(delta: float):
	var forward = -global_transform.basis.z
	var lift_axis = global_transform.basis.y
	var speed_limit = max_speed * (dive_speed_multiplier if is_diving else 1.0)
	var thrust = acceleration * (dive_speed_multiplier if is_diving else 1.0)

	velocity += forward * thrust * delta
	velocity.y -= gravity * delta
	var lift = minf(velocity.length_squared() * lift_coefficient, gravity * 1.1)
	velocity += lift_axis * lift * delta
	velocity *= exp(-drag * (0.6 if is_diving else 1.0) * delta)

	if velocity.length() > speed_limit:
		velocity = velocity.normalized() * speed_limit
	current_speed = velocity.length()

func _update_camera(delta: float):
	var forward = -global_transform.basis.z
	var desired_position = global_position - forward * 12.0 + Vector3.UP * 4.0
	camera.global_position = camera.global_position.lerp(desired_position, 1.0 - exp(-4.0 * delta))
	camera.look_at(global_position + forward * 18.0, Vector3.UP)

func _crash():
	if has_crashed:
		return
	has_crashed = true
	crashed.emit()

func reset_flight():
	has_crashed = false
	velocity = Vector3(0.0, 0.0, -18.0)
	current_speed = velocity.length()
	rotation = Vector3.ZERO
	camera.global_position = global_position - global_transform.basis.z * 12.0 + Vector3.UP * 4.0
	camera.look_at(global_position - global_transform.basis.z * 18.0, Vector3.UP)
