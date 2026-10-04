extends Node

## Run Manager Script
## Handles roguelike run progression, permadeath, and upgrades

signal run_started
signal run_ended(final_score: int)
signal upgrade_menu_opened
signal upgrade_applied(upgrade_name: String)

var current_run_score: int = 0
var current_wave: int = 0
var enemies_defeated: int = 0
var max_wave: int = 10
var player: CharacterBody2D

# Persistent data between runs (roguelite elements)
var total_runs: int = 0
var best_score: int = 0
var unlocked_upgrades: Array = []

func _ready():
	# Load persistent data if it exists
	_load_game_data()

func start_run():
	"""Initialize a new run"""
	current_run_score = 0
	current_wave = 0
	enemies_defeated = 0
	total_runs += 1
	
	print("Run #%d started!" % total_runs)
	run_started.emit()

func add_score(points: int):
	"""Add points to current run score"""
	current_score += points

func enemy_defeated(enemy_value: int = 10):
	"""Called when player defeats an enemy"""
	enemies_defeated += 1
	add_score(enemy_value)

func next_wave():
	"""Progress to next wave"""
	current_wave += 1
	if current_wave >= max_wave:
		end_run_victory()
	else:
		print("Wave %d/%d" % [current_wave, max_wave])

func end_run_victory():
	"""Player successfully completed the run"""
	print("Run completed! Final score: %d" % current_run_score)
	_handle_run_end()

func end_run_defeat():
	"""Player died - run ended"""
	print("Run failed! Final score: %d" % current_run_score)
	_handle_run_end()

func _handle_run_end():
	"""Common end-of-run logic"""
	if current_run_score > best_score:
		best_score = current_run_score
	
	run_ended.emit(current_run_score)
	upgrade_menu_opened.emit()
	_show_upgrade_screen()

func _show_upgrade_screen():
	"""Display upgrade/powerup selection screen"""
	print("Opening upgrade menu...")
	# TODO: Instantiate upgrade UI scene

func apply_upgrade(upgrade_name: String):
	"""Apply an upgrade to persistent progression"""
	unlocked_upgrades.append(upgrade_name)
	upgrade_applied.emit(upgrade_name)
	print("Upgrade applied: %s" % upgrade_name)

func _load_game_data():
	"""Load persistent progression data"""
	# TODO: Implement save/load system
	pass

func _save_game_data():
	"""Save persistent progression data"""
	# TODO: Implement save/load system
	pass

func get_run_stats() -> Dictionary:
	"""Return current run statistics"""
	return {
		"run_number": total_runs,
		"current_score": current_run_score,
		"wave": current_wave,
		"enemies_defeated": enemies_defeated,
		"best_score": best_score
	}
