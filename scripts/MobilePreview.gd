extends Control

# Mobile Preview Tool for AZAMANE - Moroccan Time Capsule
# Simulates different mobile devices and orientations with full game navigation

@onready var device_frame = $DeviceFrame
@onready var game_viewport = $DeviceFrame/GameViewport
@onready var device_selector = $Controls/DeviceContainer/DeviceSelector
@onready var device_label = $DeviceLabel
@onready var touch_sim_btn = $Controls/OptionsContainer/TouchSimBtn
@onready var portrait_btn = $Controls/OrientationButtons/PortraitBtn
@onready var landscape_btn = $Controls/OrientationButtons/LandscapeBtn
@onready var scene_selector = $Controls/SceneContainer/SceneSelector
@onready var scene_label = $SceneStatusLabel
@onready var auto_adapt_btn = $Controls/OptionsContainer/AutoAdaptBtn
@onready var reset_btn = $Controls/ButtonsContainer/ResetBtn

# Device presets (width, height, name)
var device_presets = [
	{"name": "iPhone 12 (390x844)", "width": 390, "height": 844},
	{"name": "iPhone 12 Pro Max (428x926)", "width": 428, "height": 926},
	{"name": "Samsung Galaxy S21 (360x800)", "width": 360, "height": 800},
	{"name": "Samsung Galaxy S21+ (384x854)", "width": 384, "height": 854},
	{"name": "Google Pixel 6 (393x851)", "width": 393, "height": 851},
	{"name": "iPad (768x1024)", "width": 768, "height": 1024},
	{"name": "iPad Pro 11 (834x1194)", "width": 834, "height": 1194},
	{"name": "Small Phone (320x568)", "width": 320, "height": 568},
	{"name": "Large Phone (414x896)", "width": 414, "height": 896}
]

# Game scenes for preview - using mobile-optimized versions with fallbacks
var game_scenes = [
	{"name": "Welcome Screen", "path": "res://scenes/mobile/WelcomeScreenMobile.tscn", "fallback": "res://scenes/WelcomeScreen.tscn"},
	{"name": "Game Description", "path": "res://scenes/mobile/GameDescriptionScreenMobile.tscn", "fallback": "res://scenes/GameDescriptionScreen.tscn"},
	{"name": "Character Customization", "path": "res://scenes/mobile/CharacterCustomizationScreenMobile.tscn", "fallback": "res://scenes/CharacterCustomizationScreen.tscn"},
	{"name": "Rules Screen", "path": "res://scenes/mobile/RulesScreenMobile.tscn", "fallback": "res://scenes/RulesScreen.tscn"},
	{"name": "Amziane Intro", "path": "res://scenes/mobile/AmzianeIntroScreenMobile.tscn", "fallback": "res://scenes/AmzianeIntroScreen.tscn"},
	{"name": "Map Screen", "path": "res://scenes/mobile/MapScreenMobile.tscn", "fallback": "res://scenes/MapScreen.tscn"},
	{"name": "Quest Screen", "path": "res://scenes/mobile/QuestScreenMobile.tscn", "fallback": "res://scenes/QuestScreen.tscn"}
]

var current_device = 0
var current_scene = 0
var is_portrait = true
var touch_simulation_enabled = false
var auto_adapt_enabled = true
var game_scene = null

func _ready():
	print("Mobile Preview starting initialization...")

	# Check all required nodes
	print("Checking required nodes...")
	print("device_frame: ", device_frame != null)
	print("game_viewport: ", game_viewport != null)
	print("device_selector: ", device_selector != null)
	print("scene_selector: ", scene_selector != null)

	setup_device_selector()
	setup_scene_selector()
	apply_device_preset(0)

	# Enable touch simulation and auto-adapt by default
	if touch_sim_btn:
		touch_sim_btn.button_pressed = true
		touch_simulation_enabled = true
	else:
		print("Warning: touch_sim_btn not found")

	if auto_adapt_btn:
		auto_adapt_btn.button_pressed = true
		auto_adapt_enabled = true
	else:
		print("Warning: auto_adapt_btn not found")

	# Load the first scene by default
	print("Loading first scene...")
	load_game_scene(0)

	print("Mobile Preview initialized with full AZAMANE game support")

func setup_device_selector():
	if device_selector:
		device_selector.clear()
		for preset in device_presets:
			device_selector.add_item(preset.name)
	else:
		print("Error: device_selector not found")

func setup_scene_selector():
	if scene_selector:
		scene_selector.clear()
		for scene_data in game_scenes:
			scene_selector.add_item(scene_data.name)
	else:
		print("Error: scene_selector not found")

func apply_device_preset(index: int):
	if index < 0 or index >= device_presets.size():
		return
	
	current_device = index
	var preset = device_presets[index]
	
	var width = preset.width
	var height = preset.height
	
	if not is_portrait:
		# Swap dimensions for landscape
		var temp = width
		width = height
		height = temp
	
	# Update device frame size
	device_frame.size = Vector2(width + 20, height + 20)  # Add padding for frame
	device_frame.position = Vector2(
		(get_viewport().size.x - device_frame.size.x) / 2,
		(get_viewport().size.y - device_frame.size.y) / 2
	)
	
	# Update viewport size
	game_viewport.size = Vector2i(width, height)
	
	# Update label
	var orientation_text = "Portrait" if is_portrait else "Landscape"
	device_label.text = "Device: %s (%s)" % [preset.name, orientation_text]
	
	print("Applied device preset: ", preset.name, " Size: ", width, "x", height)

func _on_device_selected(index: int):
	apply_device_preset(index)

func _on_portrait_pressed():
	is_portrait = true
	portrait_btn.disabled = true
	landscape_btn.disabled = false
	apply_device_preset(current_device)

func _on_landscape_pressed():
	is_portrait = false
	portrait_btn.disabled = false
	landscape_btn.disabled = true
	apply_device_preset(current_device)

func _on_touch_sim_toggled(enabled: bool):
	touch_simulation_enabled = enabled
	if enabled:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		print("Touch simulation enabled")
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		print("Touch simulation disabled")

func load_game_scene(scene_index: int):
	print("Attempting to load scene index: ", scene_index)

	if scene_index < 0 or scene_index >= game_scenes.size():
		print("Error: Invalid scene index: ", scene_index)
		return

	current_scene = scene_index
	var scene_data = game_scenes[scene_index]
	print("Loading scene: ", scene_data.name, " from path: ", scene_data.path)

	# Check if game_viewport exists
	if not game_viewport:
		print("Error: game_viewport is null!")
		return

	# Load the scene (try mobile version first, then fallback)
	var scene_resource = null

	# Check if the file exists first
	if ResourceLoader.exists(scene_data.path):
		print("Loading scene from: ", scene_data.path)
		scene_resource = load(scene_data.path)
	else:
		print("Scene file not found: ", scene_data.path)

	if not scene_resource and scene_data.has("fallback"):
		print("Mobile scene failed, trying fallback: ", scene_data.fallback)
		if ResourceLoader.exists(scene_data.fallback):
			scene_resource = load(scene_data.fallback)
		else:
			print("Fallback scene file not found: ", scene_data.fallback)

	if scene_resource:
		print("Scene resource loaded successfully")

		# Clear existing game scene
		if game_scene:
			print("Removing existing game scene")
			game_scene.queue_free()
			await game_scene.tree_exited  # Wait for cleanup

		# Instantiate and add to viewport
		print("Instantiating new scene")
		game_scene = scene_resource.instantiate()

		if game_scene:
			print("Adding scene to viewport")
			game_viewport.add_child(game_scene)

			# Make sure the scene is visible
			game_scene.visible = true

			# Apply mobile adaptations if enabled (skip for now to test)
			# if auto_adapt_enabled and MobileUIManager:
			#	MobileUIManager.adapt_scene_for_mobile(game_scene)

			# Update scene label
			if scene_label:
				scene_label.text = "Scene: " + scene_data.name

			# Special setup for certain scenes
			setup_scene_specific_features(scene_index)

			print("Successfully loaded scene: ", scene_data.name)
		else:
			print("Error: Failed to instantiate scene")
	else:
		print("Error: Could not load any scene resource")
		# Create a simple fallback scene
		create_fallback_scene(scene_data.name)

func create_fallback_scene(scene_name: String):
	print("Creating fallback scene for: ", scene_name)

	# Create a simple scene with just a label
	var fallback_scene = Control.new()
	fallback_scene.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bg = ColorRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.165, 0.247, 0.482, 1)  # Blue background
	fallback_scene.add_child(bg)

	var label = Label.new()
	label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	label.text = "Scene: " + scene_name + "\n\n(Fallback - Scene file not found)"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_font_size_override("font_size", 24)
	fallback_scene.add_child(label)

	# Clear existing game scene
	if game_scene:
		game_scene.queue_free()

	game_scene = fallback_scene
	game_viewport.add_child(game_scene)

	# Update scene label
	if scene_label:
		scene_label.text = "Scene: " + scene_name + " (Fallback)"

	print("Fallback scene created successfully")

func setup_scene_specific_features(scene_index: int):
	# Handle special setup for specific scenes
	match scene_index:
		2:  # Character Customization
			# Set a default character selection for preview
			if game_scene.has_method("_on_male_button_pressed"):
				# Simulate character selection without proceeding
				game_scene.selected_character = "Male"
				if game_scene.has_method("update_character_preview"):
					game_scene.update_character_preview()
		5:  # Map Screen
			# Initialize with some sample data for preview
			if GameManager:
				GameManager.add_culture_points(2)  # Show some progress
		6:  # Quest Screen
			# Set up a sample quest for preview
			if GameManager:
				GameManager.game_state.current_quest = "traders_riddle"
				if game_scene.has_method("load_current_quest"):
					game_scene.load_current_quest()

func _on_scene_selected(index: int):
	load_game_scene(index)

func _on_auto_adapt_toggled(enabled: bool):
	auto_adapt_enabled = enabled
	if enabled and game_scene and MobileUIManager:
		MobileUIManager.adapt_scene_for_mobile(game_scene)
	print("Auto-adapt ", "enabled" if enabled else "disabled")

func _on_reset_pressed():
	# Reset to welcome screen and default device
	current_device = 0
	current_scene = 0
	is_portrait = true

	# Reset UI
	device_selector.selected = 0
	scene_selector.selected = 0
	portrait_btn.disabled = true
	landscape_btn.disabled = false

	# Apply changes
	apply_device_preset(0)
	load_game_scene(0)

	print("Mobile preview reset to defaults")

func _input(event):
	if not touch_simulation_enabled:
		return
	
	# Convert mouse events to touch events for simulation
	if event is InputEventMouseButton:
		var touch_event = InputEventScreenTouch.new()
		touch_event.position = event.position
		touch_event.pressed = event.pressed
		touch_event.index = 0
		
		# Forward to game viewport if it exists
		if game_scene:
			game_scene._input(touch_event)
	
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var drag_event = InputEventScreenDrag.new()
		drag_event.position = event.position
		drag_event.relative = event.relative
		drag_event.index = 0
		
		# Forward to game viewport if it exists
		if game_scene:
			game_scene._input(drag_event)

func _on_viewport_size_changed():
	# Reposition device frame when window is resized
	if device_frame:
		device_frame.position = Vector2(
			(get_viewport().size.x - device_frame.size.x) / 2,
			(get_viewport().size.y - device_frame.size.y) / 2
		)
