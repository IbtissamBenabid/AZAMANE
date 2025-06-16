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

func get_quest_riddle(quest_id: String) -> Dictionary:
	match quest_id:
		"traders_riddle":
			return get_trade_stall_riddles()
		"camel_track":
			return get_oasis_path_riddles()
		"berber_tale":
			return get_caravan_camp_riddles()
		_:
			return get_random_riddle()

func get_trade_stall_riddles() -> Dictionary:
	var riddles = [
		{
			"question": "I am precious yet common, white as bone, traded for gold across the Sahara. What am I?",
			"options": ["Salt", "Sand", "Ivory"],
			"correct": 0,
			"lore": "Salt was more valuable than gold in ancient Berber trade! It preserved food and was essential for life in the desert."
		},
		{
			"question": "I flow without water, guide without feet, and whisper secrets of distant markets. What am I?",
			"options": ["River", "Wind", "Caravan"],
			"correct": 1,
			"lore": "Desert winds carried news between trading posts, helping merchants know which routes were safe and profitable."
		},
		{
			"question": "In the souk, I am weighed but never eaten, valued but never worn, traded but never owned. What am I?",
			"options": ["Spices", "Trust", "Gold"],
			"correct": 1,
			"lore": "Trust was the most valuable currency in Berber trade. A merchant's word was their bond across the vast desert."
		}
	]
	return riddles[randi() % riddles.size()]

func get_oasis_path_riddles() -> Dictionary:
	var riddles = [
		{
			"question": "I leave marks in sand but make no sound, I point the way but have no voice. Follow my trail to find what's lost. What am I?",
			"options": ["Footprints", "Stars", "Wind"],
			"correct": 0,
			"lore": "Berber trackers could read animal footprints like books, determining age, health, and direction from subtle signs in the sand."
		},
		{
			"question": "I am green in the golden sea, life in the land of death, hope where there is none. Travelers seek me desperately. What am I?",
			"options": ["Mirage", "Oasis", "Cactus"],
			"correct": 1,
			"lore": "Oases were sacred places in Berber culture, often protected by ancient laws and shared peacefully between tribes."
		},
		{
			"question": "I drink much but am never full, I carry heavy loads but never tire, my bells announce arrivals from afar. What am I?",
			"options": ["Well", "Camel", "Donkey"],
			"correct": 1,
			"lore": "Camels can drink up to 40 gallons of water at once and survive weeks without drinking again - perfect for desert travel."
		}
	]
	return riddles[randi() % riddles.size()]

func get_caravan_camp_riddles() -> Dictionary:
	var riddles = [
		{
			"question": "Complete this ancient Berber proverb: 'The one who tells stories rules the world, for they control...'",
			"options": ["The past", "The future", "The hearts of people"],
			"correct": 2,
			"lore": "Berber storytellers (imdyazn) were highly respected, preserving history and wisdom through oral tradition across generations."
		},
		{
			"question": "In Berber tales, what creature is said to guard the desert's greatest treasures and test the worthy?",
			"options": ["Djinn", "Eagle", "Serpent"],
			"correct": 0,
			"lore": "Djinn in Berber folklore were complex beings - sometimes helpful, sometimes dangerous, always testing human character and wisdom."
		},
		{
			"question": "According to Berber tradition, what must a storyteller always do before beginning an important tale?",
			"options": ["Light incense", "Ask permission from the ancestors", "Share tea with listeners"],
			"correct": 1,
			"lore": "Berber storytellers honored their ancestors before sharing sacred stories, believing the spirits guided their words and memory."
		}
	]
	return riddles[randi() % riddles.size()]

func get_random_riddle():
	# Fallback riddles for any unspecified quests
	var riddles = [
		{
			"question": "I flow without water, guide without feet—what am I?",
			"options": ["Wind", "Sand", "Gold"],
			"correct": 0,
			"lore": "Tamazight riddles shaped Berber trade wisdom!"
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
	# Return the appropriate solo sprite based on gender selection
	# Use solo PNG sprites for better visual consistency on the map
	if player_data.gender == "Female":
		return "res://assets/sprites/solo_red_female_player_standing_128x128.png"
	else:
		return "res://assets/sprites/solo_blue_player_standing_128x128.png"

func get_amziane_sprite_path() -> String:
	# Return Amziane sprite - use solo sprites for consistency
	if player_data.gender == "Female":
		return "res://assets/sprites/solo_red_female_player_standing_128x128.png"
	else:
		return "res://assets/sprites/solo_blue_player_standing_128x128.png"

# Quest system
func start_quest(quest_id: String) -> Dictionary:
	var riddle = get_quest_riddle(quest_id)

	# Store the riddle for validation when answering
	current_riddles[quest_id] = riddle

	return {
		"id": quest_id,
		"question": riddle.question,
		"options": riddle.options,
		"correct": riddle.correct,
		"lore": riddle.lore
	}

# Store current riddles for validation
var current_riddles = {}

func answer_quest(quest_id: String, answer_index: int) -> Dictionary:
	# Get the riddle that was presented for this quest
	var riddle = current_riddles.get(quest_id, get_quest_riddle(quest_id))
	var is_correct = (answer_index == riddle.correct)

	var result = {
		"success": is_correct,
		"lore": riddle.lore
	}

	if is_correct:
		# Award different points based on difficulty
		var points = get_quest_difficulty_points(quest_id)
		add_culture_points(points)
		complete_quest(quest_id)

		# Add appropriate collectible based on quest
		var collectible_data = get_quest_collectible(quest_id)
		if collectible_data.name:
			add_to_time_capsule(collectible_data.name, collectible_data.lore)
			result["collectible"] = collectible_data.name

		# Clear the stored riddle
		current_riddles.erase(quest_id)

	return result

func get_quest_difficulty_points(quest_id: String) -> int:
	match quest_id:
		"camel_track":  # Easy
			return 1
		"traders_riddle":  # Medium
			return 2
		"berber_tale":  # Hard
			return 3
		_:
			return 2

func get_quest_collectible(quest_id: String) -> Dictionary:
	match quest_id:
		"traders_riddle":
			return {
				"name": "Desert Veil",
				"lore": "A flowing fabric that protects against desert winds and sandstorms, woven with traditional Berber patterns."
			}
		"camel_track":
			return {
				"name": "Sacred Compass",
				"lore": "An ancient navigation tool used by desert nomads, its mystical properties help travelers find their way through endless dunes."
			}
		"berber_tale":
			return {
				"name": "Storyteller's Token",
				"lore": "A ceremonial marker passed down through generations of Berber storytellers, symbolizing the keeper of ancient tales."
			}
		_:
			return {"name": "", "lore": ""}
