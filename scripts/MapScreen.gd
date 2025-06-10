extends Control

# Map Screen for Azamane - Moroccan Time Capsule
# Interactive map with quest locations and game status

@onready var culture_points_label = $UI/TopPanel/HBoxContainer/StatsContainer/CulturePoints
@onready var trust_level_label = $UI/TopPanel/HBoxContainer/StatsContainer/TrustLevel
@onready var player_character = $UI/CharacterLayer/PlayerCharacter
@onready var trade_stall_button = $UI/QuestHotspots/TradeStallButton
@onready var oasis_path_button = $UI/QuestHotspots/OasisPathButton
@onready var caravan_camp_button = $UI/QuestHotspots/CaravanCampButton
@onready var time_capsule_button = $UI/BottomPanel/VBoxContainer/TimeCapsuleButton

# Character movement variables
var character_tween: Tween
var is_moving: bool = false
var base_character_position: Vector2

func _ready():
	print("Map Screen loaded")
	setup_character()
	update_ui()
	connect_signals()
	setup_interactive_elements()

func setup_character():
	# Load and display the player character sprite
	var sprite_path = GameManager.get_player_sprite_path()
	var texture = load(sprite_path) if ResourceLoader.exists(sprite_path) else null

	if texture:
		player_character.texture = texture
		print("Loaded player character: ", sprite_path)
	else:
		# Fallback to Amziane sprite
		var fallback_path = GameManager.get_amziane_sprite_path()
		if ResourceLoader.exists(fallback_path):
			player_character.texture = load(fallback_path)
			print("Using fallback character: ", fallback_path)

	# Add idle animation
	create_idle_animation()

func create_idle_animation():
	# Create subtle breathing/idle animation
	if character_tween:
		character_tween.kill()

	character_tween = create_tween()
	character_tween.set_loops()
	character_tween.tween_property(player_character, "scale", Vector2(1.05, 0.98), 2.0)
	character_tween.tween_property(player_character, "scale", Vector2(0.98, 1.05), 2.0)

func setup_interactive_elements():
	# Add hover effects to quest buttons
	setup_button_hover_effects(trade_stall_button)
	setup_button_hover_effects(oasis_path_button)
	setup_button_hover_effects(caravan_camp_button)
	setup_button_hover_effects(time_capsule_button)

func setup_button_hover_effects(button: Button):
	# Connect hover signals for interactive feedback
	button.mouse_entered.connect(func(): _on_button_hover(button))
	button.mouse_exited.connect(func(): _on_button_unhover(button))

func _on_button_hover(button: Button):
	# Scale up button on hover
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(button, "modulate", Color(1.2, 1.2, 0.8), 0.2)

func _on_button_unhover(button: Button):
	# Scale down button when not hovering
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)
	tween.tween_property(button, "modulate", Color.WHITE, 0.2)

func connect_signals():
	# Connect to GameManager signals
	GameManager.culture_points_changed.connect(_on_culture_points_changed)
	GameManager.trust_level_changed.connect(_on_trust_level_changed)

func update_ui():
	# Update culture points and trust level display
	culture_points_label.text = "Culture Points: " + str(GameManager.get_culture_points())
	trust_level_label.text = "Trust Level: " + GameManager.get_trust_level()
	
	# Update quest button states based on completion
	update_quest_buttons()

func update_quest_buttons():
	# Check which quests are completed and update button text
	var completed_quests = GameManager.game_state.quests_completed
	
	if "traders_riddle" in completed_quests:
		trade_stall_button.text = "✅ Trade Stall (Completed)"
		trade_stall_button.disabled = true
	else:
		trade_stall_button.text = "🏪 Trade Stall"
		trade_stall_button.disabled = false
	
	if "camel_track" in completed_quests:
		oasis_path_button.text = "✅ Oasis Path (Completed)"
		oasis_path_button.disabled = true
	else:
		oasis_path_button.text = "🌴 Oasis Path"
		oasis_path_button.disabled = false
	
	if "berber_tale" in completed_quests:
		caravan_camp_button.text = "✅ Caravan Camp (Completed)"
		caravan_camp_button.disabled = true
	else:
		caravan_camp_button.text = "🏕️ Caravan Camp"
		caravan_camp_button.disabled = false

# Signal handlers
func _on_culture_points_changed(new_points: int):
	culture_points_label.text = "Culture Points: " + str(new_points)

func _on_trust_level_changed(new_level: String):
	trust_level_label.text = "Trust Level: " + new_level

# Quest button handlers
func _on_trade_stall_button_pressed():
	print("Trade Stall quest selected")
	start_quest("traders_riddle", "Trade Stall")

func _on_oasis_path_button_pressed():
	print("Oasis Path quest selected")
	start_quest("camel_track", "Oasis Path")

func _on_caravan_camp_button_pressed():
	print("Caravan Camp quest selected")
	start_quest("berber_tale", "Caravan Camp")

func start_quest(quest_id: String, _location_name: String):
	if is_moving:
		return  # Prevent multiple movements

	is_moving = true

	# Get button and its position for character movement
	var button = get_quest_button(quest_id)
	if button:
		# Button press feedback
		var button_tween = create_tween()
		button_tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
		button_tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

		# Move character to quest location
		await move_character_to_quest(button)

	# Store current quest info and transition to quest scene
	GameManager.game_state.current_quest = quest_id
	GameManager.change_scene("QuestScreen")

func move_character_to_quest(target_button: Button):
	# Calculate target position (near the button)
	var button_center = target_button.global_position + target_button.size / 2
	var target_pos = button_center - player_character.size / 2

	# Store the base position for walking animation
	base_character_position = player_character.global_position

	# Stop idle animation
	if character_tween:
		character_tween.kill()

	# Create movement animation
	character_tween = create_tween()
	character_tween.set_parallel(true)

	# Move to target
	character_tween.tween_property(player_character, "global_position", target_pos, 1.0)

	# Add walking animation (slight bounce) - using a separate tween
	var bounce_tween = create_tween()
	bounce_tween.tween_method(_animate_walking, 0.0, 1.0, 1.0)

	# Wait for movement to complete
	await character_tween.finished

	# Brief pause at destination
	await get_tree().create_timer(0.5).timeout

func _animate_walking(progress: float):
	# Create walking bounce effect using scale instead of position
	var bounce_scale = 1.0 + sin(progress * PI * 6) * 0.1  # 6 steps during movement
	player_character.scale.y = bounce_scale

func get_quest_button(quest_id: String) -> Button:
	match quest_id:
		"traders_riddle":
			return trade_stall_button
		"camel_track":
			return oasis_path_button
		"berber_tale":
			return caravan_camp_button
		_:
			return null

func _on_time_capsule_button_pressed():
	print("Time Capsule button pressed")
	show_time_capsule()

func show_time_capsule():
	# Create a simple popup to show collected items
	var popup = AcceptDialog.new()
	popup.title = "Time Capsule - Collected Treasures"
	
	var content = "Your collected treasures:\n\n"
	
	if GameManager.time_capsule.is_empty():
		content += "No treasures collected yet.\nComplete quests to add items to your time capsule!"
	else:
		for item_name in GameManager.time_capsule:
			var lore = GameManager.time_capsule[item_name]
			content += "• " + item_name + "\n  " + lore + "\n\n"
	
	popup.dialog_text = content
	popup.size = Vector2(500, 400)
	
	add_child(popup)
	popup.popup_centered()
	
	# Remove popup when closed
	popup.confirmed.connect(func(): popup.queue_free())
	popup.canceled.connect(func(): popup.queue_free())
