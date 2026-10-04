extends Node2D

## Main Scene Script
## Orchestrates the overall game flow

@onready var run_manager = $RunManager
@onready var world_manager = $WorldManager
@onready var player = $Player
@onready var upgrade_manager = $UpgradeManager
@onready var status_label = $HUD/Status

var upgrade_choices: Array[String] = []
var run_over: bool = false

func _ready():
	player.died.connect(_on_player_died)
	run_manager.run_ended.connect(_on_run_ended)
	upgrade_manager.apply_saved_upgrades(player)
	_start_new_run()

func _start_new_run():
	"""Begin a fresh run"""
	world_manager.reset_world()
	player.reset_flight()
	player.position = Vector2(Constants.WORLD_WIDTH / 2.0, Constants.WORLD_HEIGHT / 2.0)
	player.set_physics_process(true)
	run_manager.start_run()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if not run_over:
		status_label.text = "WASD / Arrows: fly   Space: dive   Mouse: aim   Left click: fire\nHealth: %d   Score: %d   Wave: %d" % [
			int(player.health), run_manager.current_run_score, run_manager.current_wave
		]

func _on_player_died():
	"""Handle player death event"""
	run_manager.end_run_defeat()

func _on_run_ended(_score):
	"""Handle end of run - prepare for upgrade screen"""
	run_over = true
	upgrade_choices = upgrade_manager.get_upgrade_choices()
	if upgrade_choices.is_empty():
		status_label.text = "Run over — all upgrades maxed. Press Enter to start a new run."
		return

	var menu_text = "Run over — choose an upgrade (1–3):"
	for index in range(upgrade_choices.size()):
		menu_text += "\n%d. %s" % [index + 1, upgrade_manager.get_upgrade_description(upgrade_choices[index])]
	status_label.text = menu_text

func _unhandled_key_input(event: InputEvent):
	if not run_over or not event is InputEventKey or not event.pressed:
		return

	if upgrade_choices.is_empty():
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			run_over = false
			_start_new_run()
		return

	var choice_index = event.keycode - KEY_1
	if choice_index < 0 or choice_index >= upgrade_choices.size():
		return

	upgrade_manager.apply_upgrade(upgrade_choices[choice_index], player)
	upgrade_choices.clear()
	run_over = false
	_start_new_run()

func _draw():
	draw_rect(Rect2(Vector2.ZERO, Vector2(Constants.WORLD_WIDTH, Constants.WORLD_HEIGHT)), Color("#101a2b"))
	for x in range(0, Constants.WORLD_WIDTH, Constants.TERRAIN_CHUNK_SIZE):
		draw_line(Vector2(x, 0), Vector2(x, Constants.WORLD_HEIGHT), Color("#1a2a3d"), 1.0)
	for y in range(0, Constants.WORLD_HEIGHT, Constants.TERRAIN_CHUNK_SIZE):
		draw_line(Vector2(0, y), Vector2(Constants.WORLD_WIDTH, y), Color("#1a2a3d"), 1.0)
