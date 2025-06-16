extends Control

# Mobile Preview Tool for AZAMANE - Moroccan Time Capsule
# Simulates different mobile devices and orientations

@onready var device_frame = $DeviceFrame
@onready var game_viewport = $DeviceFrame/GameViewport
@onready var device_selector = $Controls/DeviceSelector
@onready var device_label = $Controls/DeviceLabel
@onready var touch_sim_btn = $Controls/TouchSimBtn
@onready var portrait_btn = $Controls/OrientationButtons/PortraitBtn
@onready var landscape_btn = $Controls/OrientationButtons/LandscapeBtn

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

var current_device = 0
var is_portrait = true
var touch_simulation_enabled = false
var game_scene = null

func _ready():
	setup_device_selector()
	apply_device_preset(0)
	
	# Enable touch simulation by default
	touch_sim_btn.button_pressed = true
	touch_simulation_enabled = true
	
	print("Mobile Preview initialized")

func setup_device_selector():
	device_selector.clear()
	for preset in device_presets:
		device_selector.add_item(preset.name)

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

func _on_load_game_pressed():
	load_azamane_game()

func load_azamane_game():
	# Load the main game scene
	var welcome_scene = preload("res://scenes/WelcomeScreen.tscn")
	if welcome_scene:
		# Clear existing game scene
		if game_scene:
			game_scene.queue_free()
		
		# Instantiate and add to viewport
		game_scene = welcome_scene.instantiate()
		game_viewport.add_child(game_scene)
		
		# Apply mobile adaptations
		if MobileUIManager:
			MobileUIManager.adapt_scene_for_mobile(game_scene)
		
		print("AZAMANE game loaded in mobile preview")
	else:
		print("Error: Could not load WelcomeScreen.tscn")

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
