extends Node

## Main Scene Script
## Orchestrates the overall game flow

@onready var run_manager = $RunManager
@onready var world_manager = $WorldManager
@onready var player = $Player

func _ready():
	print("Game started!")
	_start_new_run()

func _start_new_run():
	"""Begin a fresh run"""
	world_manager.reset_world()
	player.reset_flight()
	run_manager.start_run()
	print("Ready to play!")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_player_died():
	"""Handle player death event"""
	run_manager.end_run_defeat()

func _on_run_ended(_score):
	"""Handle end of run - prepare for upgrade screen"""
	await get_tree().create_timer(2.0).timeout
	# TODO: Show upgrade screen
	print("Showing upgrade options...")
