extends Node2D

## World Manager Script
## Handles procedural terrain generation and enemy spawning

const ENEMY_SCRIPT = preload("res://scripts/enemies/enemy.gd")

@export var chunk_size: int = 256
@export var enemy_spawn_rate: float = 2.0

var terrain_chunks: Dictionary = {}
var current_wave: int = 0
var enemies_spawned: int = 0
var spawn_timer: float = 0.0
var player: Node2D

func _ready():
	chunk_size = Constants.TERRAIN_CHUNK_SIZE
	enemy_spawn_rate = Constants.ENEMY_SPAWN_RATE
	player = get_parent().get_node_or_null("Player")

func _process(delta):
	_update_spawning(delta)

func generate_terrain():
	"""Generate or regenerate terrain for new run"""
	terrain_chunks.clear()
	_generate_world_chunks()
	print("Terrain generated")

func _generate_world_chunks():
	"""Create procedural terrain chunks"""
	# TODO: Implement Perlin noise or procedural chunk generation
	# For now, create a simple grid of chunks
	
	var chunks_x = int(Constants.WORLD_WIDTH / chunk_size) + 1
	var chunks_y = int(Constants.WORLD_HEIGHT / chunk_size) + 1
	
	for x in range(chunks_x):
		for y in range(chunks_y):
			var chunk_pos = Vector2(x * chunk_size, y * chunk_size)
			_create_terrain_chunk(chunk_pos)

func _create_terrain_chunk(position: Vector2):
	"""Create a single terrain chunk at position"""
	var chunk_key = str(int(position.x / chunk_size)) + "_" + str(int(position.y / chunk_size))
	
	# TODO: Create actual terrain visuals
	# For prototype, just track chunk positions
	terrain_chunks[chunk_key] = {
		"position": position,
		"obstacles": []
	}

func _update_spawning(delta):
	"""Handle enemy wave spawning"""
	spawn_timer -= delta
	
	if spawn_timer <= 0:
		spawn_timer = 1.0 / enemy_spawn_rate
		_spawn_enemy_wave()

func _spawn_enemy_wave():
	"""Spawn enemies based on current wave"""
	var enemies_to_spawn = mini(1 + current_wave, Constants.MAX_ENEMIES_ON_SCREEN - get_tree().get_nodes_in_group("enemies").size())
	
	for i in range(enemies_to_spawn):
		_spawn_single_enemy()

func _spawn_single_enemy():
	"""Spawn a single enemy at random location"""
	if not is_instance_valid(player):
		return

	var enemy = ENEMY_SCRIPT.new()
	enemy.target = player
	enemy.run_manager = get_parent().get_node_or_null("RunManager")
	enemy.global_position = Vector2(randf_range(0.0, Constants.WORLD_WIDTH), randf_range(0.0, Constants.WORLD_HEIGHT))
	add_child(enemy)
	enemies_spawned += 1

func progress_wave():
	"""Move to next wave"""
	current_wave += 1
	print("Wave %d" % current_wave)

func get_terrain_at(world_pos: Vector2) -> Dictionary:
	"""Get terrain data at world position"""
	var chunk_x = int(world_pos.x / chunk_size)
	var chunk_y = int(world_pos.y / chunk_size)
	var chunk_key = str(chunk_x) + "_" + str(chunk_y)
	
	if chunk_key in terrain_chunks:
		return terrain_chunks[chunk_key]
	return {}

func reset_world():
	"""Reset world for new run"""
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	terrain_chunks.clear()
	current_wave = 0
	enemies_spawned = 0
	spawn_timer = 0.0
	generate_terrain()
