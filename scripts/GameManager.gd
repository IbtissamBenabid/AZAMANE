extends Node

# AZAMANE - Moroccan Time Capsule
# Global Game Manager - Handles game state, progression, and data persistence

# Game Colors (Moroccan palette)
const COLORS = {
	"BLUE": Color("#2A3F7B"),      # Deep blue
	"BROWN": Color("#8B5523"),     # Desert brown
	"GOLD": Color("#D4A017"),      # Moroccan gold
	"GREEN": Color("#355E3B")      # Oasis green
}

signal culture_points_changed(new_points)
signal trust_level_changed(new_level)
signal collectible_added(item_name, lore)

# Player Data
var player_data = {
	"name": "Amziane",
	"gender": "Male",  # Male or Female
	"clothing": "djellaba",  # djellaba or tunic
	"clothing_color": "blue", # blue or green
	"accessory": "satchel",  # satchel or staff
	"accessory_color": "gold" # gold or brown
}

# Game Progress
var game_state = {
	"culture_points": 0,
	"trust_level": "Low",  # Low, Medium, High
	"current_scene": "welcome",
	"current_quest": "",
	"quests_completed": []
}

# Time Capsule - Collectibles with lore
var time_capsule = {}

# Quest flags
var quest_flags = {
	"trade_completed": false,
	"riddle_completed": false,
	"amziane_met": false
}

func add_to_time_capsule(item_name: String, lore: String):
	time_capsule[item_name] = lore
	collectible_added.emit(item_name, lore)
	print("Added to time capsule: ", item_name)

func complete_quest(quest_name: String):
	if quest_name not in game_state.quests_completed:
		game_state.quests_completed.append(quest_name)
		print("Quest completed: ", quest_name)

func get_random_riddle():
	var riddles = [
		{
			"question": "I flow without water, guide without feet—what am I?",
			"options": ["Wind", "Sand", "Gold"],
			"correct": 0,
			"lore": "Tamazight riddles shaped Berber trade wisdom!"
		},
		{
			"question": "I am precious yet common, white as bone, traded for gold—what am I?",
			"options": ["Salt", "Sand", "Cloth"],
			"correct": 0,
			"lore": "Salt was the foundation of Berber trade routes!"
		},
		{
			"question": "I carry burdens across endless dunes, my bells sing of distant lands—what am I?",
			"options": ["Horse", "Camel", "Donkey"],
			"correct": 1,
			"lore": "Camels were the ships of the Sahara desert!"
		}
	]
	return riddles[randi() % riddles.size()]

func change_scene(scene_name: String):
	var scene_path = "res://scenes/" + scene_name + ".tscn"
	print("Changing scene to: ", scene_path)

	# Check if scene file exists
	if not ResourceLoader.exists(scene_path):
		print("ERROR: Scene file not found: ", scene_path)
		return

	game_state.current_scene = scene_name
	var result = get_tree().change_scene_to_file(scene_path)

	if result != OK:
		print("ERROR: Failed to change scene. Error code: ", result)
	else:
		print("Scene change successful!")

func _ready():
	# Initialize game
	print("AZAMANE - Moroccan Time Capsule initialized")

# Culture Points management
func add_culture_points(points: int):
	game_state.culture_points += points
	culture_points_changed.emit(game_state.culture_points)
	_update_trust_level()
	print("Culture points increased by ", points, ". Total: ", game_state.culture_points)

func get_culture_points() -> int:
	return game_state.culture_points

# Trust Level management
func _update_trust_level():
	var old_level = game_state.trust_level
	if game_state.culture_points >= 6:
		game_state.trust_level = "High"
	elif game_state.culture_points >= 3:
		game_state.trust_level = "Medium"
	else:
		game_state.trust_level = "Low"

	if old_level != game_state.trust_level:
		trust_level_changed.emit(game_state.trust_level)
		print("Trust level increased to: ", game_state.trust_level)

func get_trust_level() -> String:
	return game_state.trust_level

# Character customization
func set_player_gender(gender: String):
	player_data.gender = gender
	player_data.name = "Amziane"  # Character is always Amziane
	print("Player gender set to: ", gender)

func set_player_clothing(clothing: String, color: String = "blue"):
	player_data.clothing = clothing
	player_data.clothing_color = color
	print("Player clothing set to: ", clothing, " (", color, ")")

func set_player_accessory(accessory: String, color: String = "gold"):
	player_data.accessory = accessory
	player_data.accessory_color = color
	print("Player accessory set to: ", accessory, " (", color, ")")

func get_player_sprite_path() -> String:
	# Return the appropriate sprite based on gender and clothing selection
	var gender_prefix = "female_" if player_data.gender == "Female" else ""

	if player_data.clothing == "tunic":
		return "res://assets/sprites/player_" + gender_prefix + "tunic_blue_32x32.svg"
	elif player_data.clothing_color == "green":
		return "res://assets/sprites/player_" + gender_prefix + "djellaba_green_32x32.svg"
	else:
		return "res://assets/sprites/player_" + gender_prefix + "base_32x32.svg"

func get_amziane_sprite_path() -> String:
	# Return Amziane sprite based on selected gender
	if player_data.gender == "Female":
		return "res://assets/sprites/amziane_female_32x32.svg"
	else:
		return "res://assets/sprites/amziane_128x128.png"

# Quest system
func start_quest(quest_id: String) -> Dictionary:
	var riddle = get_random_riddle()
	return {
		"id": quest_id,
		"question": riddle.question,
		"options": riddle.options,
		"correct": riddle.correct,
		"lore": riddle.lore
	}

func answer_quest(quest_id: String, answer_index: int) -> Dictionary:
	var riddle = get_random_riddle()  # In a real implementation, store the current riddle
	var is_correct = (answer_index == riddle.correct)

	var result = {
		"success": is_correct,
		"lore": riddle.lore
	}

	if is_correct:
		add_culture_points(2)
		complete_quest(quest_id)

		# Add appropriate collectible based on quest
		var collectible_name = ""
		var collectible_lore = ""

		match quest_id:
			"traders_riddle":
				collectible_name = "Desert Veil"
				collectible_lore = "A flowing fabric that protects against desert winds"
			"camel_track":
				collectible_name = "Salt Crystal"
				collectible_lore = "A precious trade gem of the Sahara"
			"berber_tale":
				collectible_name = "Carved Staff"
				collectible_lore = "A wooden staff with ancient Berber symbols"

		if collectible_name:
			add_to_time_capsule(collectible_name, collectible_lore)
			result["collectible"] = collectible_name

	return result
