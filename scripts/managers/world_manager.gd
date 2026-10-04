extends Node2D

## World Manager Script
## Handles procedural terrain generation and enemy spawning

@export var chunk_size: int = 256
@export var enemy_spawn_rate: float = 2.0

var terrain_chunks: Dictionary = {}
var current_wave: int = 0
var enemies_spawned: int = 0
var spawn_timer: float = 0.0

func _ready():
	chunk_size = Constants.TERRAIN_CHUNK_SIZE
	enemy_spawn_rate = Constants.ENEMY_SPAWN_RATE

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
	var enemies_to_spawn = 1 + current_wave
	
	for i in range(enemies_to_spawn):
		_spawn_single_enemy()

func _spawn_single_enemy():
	"""Spawn a single enemy at random location"""
	# TODO: Implement enemy spawning
	# For now, just track it
	enemies_spawned += 1
	print("Enemy spawned #%d" % enemies_spawned)

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
	terrain_chunks.clear()
	current_wave = 0
	enemies_spawned = 0
	spawn_timer = 0.0
	generate_terrain()
