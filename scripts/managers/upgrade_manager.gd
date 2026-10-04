extends Node

const SAVE_PATH = "user://progress.cfg"
const MAX_UPGRADE_LEVEL = 5
const UPGRADE_DEFINITIONS = {
	"reinforced_hull": {"name": "Reinforced Hull", "description": "+20 maximum health"},
	"light_frame": {"name": "Light Frame", "description": "+10% flight speed"},
	"rapid_fire": {"name": "Rapid Fire", "description": "20% faster firing"},
	"heavy_rounds": {"name": "Heavy Rounds", "description": "+5 weapon damage"}
}

var upgrade_levels: Dictionary = {}

func _ready():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		upgrade_levels = config.get_value("progress", "upgrade_levels", {})

func get_upgrade_choices(count: int = Constants.UPGRADE_CHOICES_PER_RUN) -> Array[String]:
	var available: Array[String] = []
	for upgrade_id in UPGRADE_DEFINITIONS:
		if int(upgrade_levels.get(upgrade_id, 0)) < MAX_UPGRADE_LEVEL:
			available.append(upgrade_id)

	available.shuffle()
	available.resize(maxi(0, mini(count, available.size())))
	return available

func get_upgrade_description(upgrade_id: String) -> String:
	var definition: Dictionary = UPGRADE_DEFINITIONS.get(upgrade_id, {})
	if definition.is_empty():
		return "Unknown upgrade"

	var level = int(upgrade_levels.get(upgrade_id, 0)) + 1
	return "%s — %s (Lv. %d)" % [definition["name"], definition["description"], level]

func apply_upgrade(upgrade_id: String, player: Node) -> bool:
	if not UPGRADE_DEFINITIONS.has(upgrade_id):
		return false
	if int(upgrade_levels.get(upgrade_id, 0)) >= MAX_UPGRADE_LEVEL:
		return false

	upgrade_levels[upgrade_id] = int(upgrade_levels.get(upgrade_id, 0)) + 1
	_apply_effect(upgrade_id, player)
	_save_game_data()
	return true

func apply_saved_upgrades(player: Node):
	for upgrade_id in upgrade_levels:
		for _level in range(int(upgrade_levels[upgrade_id])):
			_apply_effect(upgrade_id, player)

func _apply_effect(upgrade_id: String, player: Node):
	match upgrade_id:
		"reinforced_hull":
			player.max_health += 20.0
			player.health = player.max_health
		"light_frame":
			player.max_speed *= 1.1
		"rapid_fire":
			var weapons = player.get_node_or_null("Weapons")
			if weapons:
				weapons.fire_rate = maxf(0.05, weapons.fire_rate * 0.8)
		"heavy_rounds":
			var weapons = player.get_node_or_null("Weapons")
			if weapons:
				weapons.damage += 5

func _save_game_data():
	var config = ConfigFile.new()
	config.set_value("progress", "upgrade_levels", upgrade_levels)
	config.save(SAVE_PATH)
