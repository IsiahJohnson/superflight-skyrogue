extends Node3D

const START_POSITION = Vector3(0.0, 75.0, 30.0)
const TERRAIN_START_Z = -180.0
const TERRAIN_END_Z = -2600.0
const MOUNTAIN_SPACING = 85.0

@onready var player: CharacterBody3D = $Player
@onready var status_label: Label = $HUD/Status

var run_over: bool = false

func _ready():
	player.crashed.connect(_on_player_crashed)
	_create_environment()
	_create_terrain()

func _process(_delta: float):
	if run_over:
		return
	status_label.text = "A / D: turn   W / S: pitch   SPACE: dive boost   R: restart\nSpeed: %d   Altitude: %d" % [
		int(player.current_speed), int(player.global_position.y)
	]

func _unhandled_key_input(event: InputEvent):
	if run_over and event is InputEventKey and event.pressed and event.keycode == KEY_R:
		_restart_flight()

func _create_environment():
	var world_environment = WorldEnvironment.new()
	var environment = Environment.new()
	environment.background_mode = Environment.BG_SKY
	var sky = Sky.new()
	var sky_material = ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color("#183454")
	sky_material.sky_horizon_color = Color("#b4c8d9")
	sky_material.ground_bottom_color = Color("#172331")
	sky_material.ground_horizon_color = Color("#71899c")
	sky.sky_material = sky_material
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	environment.ambient_light_energy = 0.65
	world_environment.environment = environment
	add_child(world_environment)

	var sunlight = DirectionalLight3D.new()
	sunlight.rotation_degrees = Vector3(-35.0, -25.0, 0.0)
	sunlight.light_energy = 1.4
	add_child(sunlight)

func _create_terrain():
	var ground = StaticBody3D.new()
	ground.position = Vector3(0.0, -50.0, -1200.0)
	var ground_shape = CollisionShape3D.new()
	var ground_box = BoxShape3D.new()
	ground_box.size = Vector3(3000.0, 10.0, 3200.0)
	ground_shape.shape = ground_box
	ground.add_child(ground_shape)
	var ground_mesh = MeshInstance3D.new()
	var ground_box_mesh = BoxMesh.new()
	ground_box_mesh.size = ground_box.size
	ground_mesh.mesh = ground_box_mesh
	ground_mesh.material_override = _make_material(Color("#476451"))
	ground.add_child(ground_mesh)
	add_child(ground)

	for index in range(int((TERRAIN_START_Z - TERRAIN_END_Z) / MOUNTAIN_SPACING)):
		var z = TERRAIN_START_Z - index * MOUNTAIN_SPACING
		for side in [-1.0, 1.0]:
			var x = side * randf_range(35.0, 145.0)
			var height = randf_range(28.0, 75.0)
			var radius = randf_range(25.0, 65.0)
			_create_mountain(Vector3(x, -45.0 + height * 0.5, z + randf_range(-35.0, 35.0)), radius, height)

func _create_mountain(center: Vector3, radius: float, height: float):
	var mountain = StaticBody3D.new()
	mountain.position = center

	var collision = CollisionShape3D.new()
	var cone_shape = ConvexPolygonShape3D.new()
	var points = PackedVector3Array()
	for index in range(8):
		var angle = TAU * index / 8.0
		points.append(Vector3(cos(angle) * radius, -height * 0.5, sin(angle) * radius))
	points.append(Vector3(0.0, height * 0.5, 0.0))
	cone_shape.points = points
	collision.shape = cone_shape
	mountain.add_child(collision)

	var mesh_instance = MeshInstance3D.new()
	var cone_mesh = CylinderMesh.new()
	cone_mesh.top_radius = 0.0
	cone_mesh.bottom_radius = radius
	cone_mesh.height = height
	cone_mesh.radial_segments = 8
	mesh_instance.mesh = cone_mesh
	mesh_instance.material_override = _make_material(Color("#557960") if randf() > 0.5 else Color("#637c65"))
	mountain.add_child(mesh_instance)
	add_child(mountain)

func _make_material(color: Color) -> StandardMaterial3D:
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	return material

func _on_player_crashed():
	run_over = true
	status_label.text = "CRASHED! Press R to fly again."

func _restart_flight():
	player.global_position = START_POSITION
	player.reset_flight()
	run_over = false
