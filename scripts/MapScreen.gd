extends Control

# Map Screen for Azamane - Moroccan Time Capsule
# Interactive map with quest locations and game status

@onready var culture_points_label = $UI/TopPanel/HBoxContainer/StatsContainer/CulturePoints
@onready var trust_level_label = $UI/TopPanel/HBoxContainer/StatsContainer/TrustLevel
@onready var player_character = $UI/CharacterLayer/PlayerCharacter
@onready var trade_stall_button = $UI/QuestHotspots/TradeStallButton
@onready var trade_stall_label = $UI/QuestHotspots/TradeStallButton/ButtonLabel
@onready var oasis_path_button = $UI/QuestHotspots/OasisPathButton
@onready var oasis_path_label = $UI/QuestHotspots/OasisPathButton/ButtonLabel
@onready var caravan_camp_button = $UI/QuestHotspots/CaravanCampButton
@onready var caravan_camp_label = $UI/QuestHotspots/CaravanCampButton/ButtonLabel
@onready var time_capsule_button = $UI/BottomPanel/VBoxContainer/TimeCapsuleButton
@onready var time_capsule_label = $UI/BottomPanel/VBoxContainer/TimeCapsuleButton/ButtonLabel
@onready var trade_stall_panel = $UI/TradeStallPanel
@onready var oasis_path_panel = $UI/OasisPathPanel
@onready var caravan_camp_panel = $UI/CaravanCampPanel
@onready var time_capsule_panel = $UI/TimeCapsulePanel
@onready var treasures_list = $UI/TimeCapsulePanel/PanelContent/ScrollContainer/TreasuresList

# Character movement variables
var character_tween: Tween
var is_moving: bool = false
var base_character_position: Vector2

func _ready():
	print("Map Screen loaded")

	# Start desert wind background music
	if AudioManager:
		AudioManager.fade_in_background_music("desert", 2.0)

	adapt_for_mobile()
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

func setup_button_hover_effects(button: BaseButton):
	# Connect hover signals for interactive feedback
	if button != null:
		button.mouse_entered.connect(func(): _on_button_hover(button))
		button.mouse_exited.connect(func(): _on_button_unhover(button))
	else:
		print("Warning: Attempted to setup hover effects on null button")

func _on_button_hover(button: BaseButton):
	# Scale up button on hover
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(button, "modulate", Color(1.2, 1.2, 0.8), 0.2)

func _on_button_unhover(button: BaseButton):
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
	if culture_points_label != null:
		culture_points_label.text = "Culture Points: " + str(GameManager.get_culture_points())
	if trust_level_label != null:
		trust_level_label.text = "Trust Level: " + GameManager.get_trust_level()

	# Update quest button states based on completion
	update_quest_buttons()

func update_quest_buttons():
	# Check which quests are completed and update button text
	var completed_quests = GameManager.game_state.quests_completed

	if trade_stall_label != null and trade_stall_button != null:
		if "traders_riddle" in completed_quests:
			trade_stall_label.text = "✅ Trade Stall (Completed)"
			trade_stall_button.disabled = true
		else:
			trade_stall_label.text = "🏪 Trade Stall"
			trade_stall_button.disabled = false

	if oasis_path_label != null and oasis_path_button != null:
		if "camel_track" in completed_quests:
			oasis_path_label.text = "✅ Oasis Path (Completed)"
			oasis_path_button.disabled = true
		else:
			oasis_path_label.text = "🌴 Oasis Path"
			oasis_path_button.disabled = false

	if caravan_camp_label != null and caravan_camp_button != null:
		if "berber_tale" in completed_quests:
			caravan_camp_label.text = "✅ Caravan Camp (Completed)"
			caravan_camp_button.disabled = true
		else:
			caravan_camp_label.text = "🏕️ Caravan Camp"
			caravan_camp_button.disabled = false

# Signal handlers
func _on_culture_points_changed(new_points: int):
	if culture_points_label != null:
		culture_points_label.text = "Culture Points: " + str(new_points)

func _on_trust_level_changed(new_level: String):
	if trust_level_label != null:
		trust_level_label.text = "Trust Level: " + new_level

# Quest button handlers
func _on_trade_stall_button_pressed():
	print("Trade Stall button pressed - showing panel")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	show_trade_stall_panel()

func _on_oasis_path_button_pressed():
	print("Oasis Path button pressed - showing panel")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	show_oasis_path_panel()

func _on_caravan_camp_button_pressed():
	print("Caravan Camp button pressed - showing panel")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	show_caravan_camp_panel()

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

	# Fade out background music before scene change
	if AudioManager:
		AudioManager.fade_out_background_music(1.0)

	GameManager.change_scene("QuestScreen")

func move_character_to_quest(target_button: BaseButton):
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

func get_quest_button(quest_id: String) -> BaseButton:
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
	print("Time Capsule button pressed - showing panel")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	show_time_capsule_panel()

# Mobile adaptation function
func adapt_for_mobile():
	print("Adapting Map Screen for mobile")

	# Check if we're on mobile platform
	var is_mobile = OS.get_name() in ["Android", "iOS"] or DisplayServer.is_touchscreen_available()

	if not is_mobile:
		return

	# Make quest buttons touch-friendly
	var quest_buttons = [trade_stall_button, oasis_path_button, caravan_camp_button, time_capsule_button]

	for button in quest_buttons:
		if button != null:
			# Increase button size for touch
			button.custom_minimum_size = Vector2(100, 50)

			# All buttons are now TextureButtons, so no font size override needed here
			pass
		else:
			print("Warning: Found null button in quest_buttons array")

	# Handle TextureButton labels separately
	if trade_stall_label != null:
		trade_stall_label.add_theme_font_size_override("font_size", 16)
	if oasis_path_label != null:
		oasis_path_label.add_theme_font_size_override("font_size", 16)
	if caravan_camp_label != null:
		caravan_camp_label.add_theme_font_size_override("font_size", 16)
	if time_capsule_label != null:
		time_capsule_label.add_theme_font_size_override("font_size", 16)

	# Adapt UI labels for mobile
	if culture_points_label:
		culture_points_label.add_theme_font_size_override("font_size", 16)

	if trust_level_label:
		trust_level_label.add_theme_font_size_override("font_size", 16)

# Time Capsule Panel handlers
func show_time_capsule_panel():
	if time_capsule_panel:
		# Update the treasures list content
		update_treasures_list()

		time_capsule_panel.visible = true

		# Add panel entrance animation
		time_capsule_panel.scale = Vector2(0.8, 0.8)
		time_capsule_panel.modulate.a = 0.0

		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(time_capsule_panel, "scale", Vector2(1.0, 1.0), 0.3)
		tween.tween_property(time_capsule_panel, "modulate:a", 1.0, 0.3)

func hide_time_capsule_panel():
	if time_capsule_panel:
		# Add panel exit animation
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(time_capsule_panel, "scale", Vector2(0.8, 0.8), 0.2)
		tween.tween_property(time_capsule_panel, "modulate:a", 0.0, 0.2)

		await tween.finished
		time_capsule_panel.visible = false

func update_treasures_list():
	if not treasures_list:
		return

	# Clear existing content
	for child in treasures_list.get_parent().get_children():
		if child != treasures_list:
			child.queue_free()

	if GameManager.time_capsule.is_empty():
		var content = "[center][color=#D4A017]Your collected treasures will appear here...[/color][/center]\n\n"
		content += "[center]Complete quests to add items to your time capsule![/center]"
		treasures_list.text = content
	else:
		# Create a container for collectibles with images
		create_visual_treasures_display()

func create_visual_treasures_display():
	# Hide the default text display
	treasures_list.visible = false

	# Create a new container for visual display
	var scroll_container = treasures_list.get_parent()
	var visual_container = VBoxContainer.new()
	visual_container.name = "VisualTreasuresContainer"
	scroll_container.add_child(visual_container)

	# Add title
	var title_label = Label.new()
	title_label.text = "Your Collected Treasures"
	title_label.add_theme_color_override("font_color", Color("#D4A017"))  # Gold
	title_label.add_theme_font_size_override("font_size", 20)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	visual_container.add_child(title_label)

	# Add spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	visual_container.add_child(spacer)

	# Add each collectible with image and description
	for item_name in GameManager.time_capsule:
		var lore = GameManager.time_capsule[item_name]
		create_collectible_entry(visual_container, item_name, lore)

func create_collectible_entry(container: VBoxContainer, item_name: String, lore: String):
	# Create horizontal container for image and text
	var item_container = HBoxContainer.new()
	item_container.add_theme_constant_override("separation", 15)
	container.add_child(item_container)

	# Add collectible image
	var image_rect = TextureRect.new()
	image_rect.custom_minimum_size = Vector2(64, 64)
	image_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	image_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Load appropriate texture based on item name
	image_rect.texture = get_collectible_texture(item_name)

	item_container.add_child(image_rect)

	# Add text container
	var text_container = VBoxContainer.new()
	text_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_container.add_child(text_container)

	# Add item name
	var name_label = Label.new()
	name_label.text = item_name
	name_label.add_theme_color_override("font_color", Color("#2A3F7B"))  # Blue
	name_label.add_theme_font_size_override("font_size", 18)
	text_container.add_child(name_label)

	# Add lore description
	var lore_label = Label.new()
	lore_label.text = lore
	lore_label.add_theme_color_override("font_color", Color("#355E3B"))  # Green
	lore_label.add_theme_font_size_override("font_size", 14)
	lore_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_container.add_child(lore_label)

	# Add spacer between items
	var item_spacer = Control.new()
	item_spacer.custom_minimum_size = Vector2(0, 15)
	container.add_child(item_spacer)

func get_collectible_image_path(item_name: String) -> String:
	# Map collectible names to their image paths
	match item_name:
		"Desert Veil":
			return "res://assets/collectibles/desert_veil_64x64.png"
		"Sacred Compass":
			return "res://assets/collectibles/hotspot_marker_64x64.png"
		"Storyteller's Token":
			# Create a unique visual for the storyteller's token
			return create_storyteller_token_texture()
		_:
			return ""

func create_storyteller_token_texture() -> String:
	# Create a unique texture for the storyteller's token
	# This will be a golden circular token with Berber-inspired patterns
	var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)

	# Fill with transparent background
	image.fill(Color(0, 0, 0, 0))

	# Draw a golden circle (simplified)
	var center = Vector2(32, 32)
	var radius = 28

	for x in range(64):
		for y in range(64):
			var distance = Vector2(x, y).distance_to(center)
			if distance <= radius:
				# Create a golden gradient effect
				var alpha = 1.0 - (distance / radius) * 0.3
				var gold_color = Color("#D4A017")  # Moroccan gold
				if distance <= radius - 4:
					# Inner circle - brighter gold
					gold_color = Color("#F4C430")
				elif distance >= radius - 2:
					# Border - darker gold
					gold_color = Color("#B8860B")

				gold_color.a = alpha
				image.set_pixel(x, y, gold_color)

	# Create texture from image
	var texture = ImageTexture.new()
	texture.set_image(image)

	# Store the texture in a temporary variable for reuse
	if not has_meta("storyteller_token_texture"):
		set_meta("storyteller_token_texture", texture)

	return "storyteller_token_generated"  # Special identifier

func get_collectible_texture(item_name: String) -> Texture2D:
	# Get the actual texture for collectibles
	var image_path = get_collectible_image_path(item_name)

	if image_path == "storyteller_token_generated":
		# Return the generated texture
		if has_meta("storyteller_token_texture"):
			return get_meta("storyteller_token_texture")
		else:
			# Fallback to creating it again
			create_storyteller_token_texture()
			return get_meta("storyteller_token_texture")
	elif ResourceLoader.exists(image_path):
		return load(image_path)
	else:
		# Create a simple fallback texture
		var fallback_texture = ImageTexture.new()
		var image = Image.create(64, 64, false, Image.FORMAT_RGB8)
		image.fill(Color("#D4A017"))  # Gold color as fallback
		fallback_texture.set_image(image)
		return fallback_texture

func _on_time_capsule_panel_close_pressed():
	print("Time Capsule panel close button pressed")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	hide_time_capsule_panel()

# Trade Stall Panel handlers
func show_trade_stall_panel():
	if trade_stall_panel:
		trade_stall_panel.visible = true

		# Add panel entrance animation
		trade_stall_panel.scale = Vector2(0.8, 0.8)
		trade_stall_panel.modulate.a = 0.0

		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(trade_stall_panel, "scale", Vector2(1.0, 1.0), 0.3)
		tween.tween_property(trade_stall_panel, "modulate:a", 1.0, 0.3)

func hide_trade_stall_panel():
	if trade_stall_panel:
		# Add panel exit animation
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(trade_stall_panel, "scale", Vector2(0.8, 0.8), 0.2)
		tween.tween_property(trade_stall_panel, "modulate:a", 0.0, 0.2)

		await tween.finished
		trade_stall_panel.visible = false

func _on_trade_stall_panel_close_pressed():
	print("Trade Stall panel close button pressed")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	hide_trade_stall_panel()

func _on_trade_stall_quest_start_pressed():
	print("Trade Stall quest start button pressed")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	hide_trade_stall_panel()
	await get_tree().create_timer(0.3).timeout  # Wait for panel to close
	start_quest("traders_riddle", "Trade Stall")

# Oasis Path Panel handlers
func show_oasis_path_panel():
	if oasis_path_panel:
		oasis_path_panel.visible = true

		# Add panel entrance animation
		oasis_path_panel.scale = Vector2(0.8, 0.8)
		oasis_path_panel.modulate.a = 0.0

		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(oasis_path_panel, "scale", Vector2(1.0, 1.0), 0.3)
		tween.tween_property(oasis_path_panel, "modulate:a", 1.0, 0.3)

func hide_oasis_path_panel():
	if oasis_path_panel:
		# Add panel exit animation
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(oasis_path_panel, "scale", Vector2(0.8, 0.8), 0.2)
		tween.tween_property(oasis_path_panel, "modulate:a", 0.0, 0.2)

		await tween.finished
		oasis_path_panel.visible = false

func _on_oasis_path_panel_close_pressed():
	print("Oasis Path panel close button pressed")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	hide_oasis_path_panel()

func _on_oasis_path_quest_start_pressed():
	print("Oasis Path quest start button pressed")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	hide_oasis_path_panel()
	await get_tree().create_timer(0.3).timeout  # Wait for panel to close
	start_quest("camel_track", "Oasis Path")

# Caravan Camp Panel handlers
func show_caravan_camp_panel():
	if caravan_camp_panel:
		caravan_camp_panel.visible = true

		# Add panel entrance animation
		caravan_camp_panel.scale = Vector2(0.8, 0.8)
		caravan_camp_panel.modulate.a = 0.0

		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(caravan_camp_panel, "scale", Vector2(1.0, 1.0), 0.3)
		tween.tween_property(caravan_camp_panel, "modulate:a", 1.0, 0.3)

func hide_caravan_camp_panel():
	if caravan_camp_panel:
		# Add panel exit animation
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(caravan_camp_panel, "scale", Vector2(0.8, 0.8), 0.2)
		tween.tween_property(caravan_camp_panel, "modulate:a", 0.0, 0.2)

		await tween.finished
		caravan_camp_panel.visible = false

func _on_caravan_camp_panel_close_pressed():
	print("Caravan Camp panel close button pressed")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	hide_caravan_camp_panel()

func _on_caravan_camp_quest_start_pressed():
	print("Caravan Camp quest start button pressed")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	hide_caravan_camp_panel()
	await get_tree().create_timer(0.3).timeout  # Wait for panel to close
	start_quest("berber_tale", "Caravan Camp")
