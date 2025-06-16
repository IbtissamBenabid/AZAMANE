extends Control

# Welcome Screen for Azamane - Moroccan Time Capsule
# Displays animated title and start button

@onready var title_label = $UI/TitleContainer/GameTitle
@onready var start_button = $UI/TitleContainer/StartButton
@onready var animation_player = $AnimationPlayer

var tween: Tween

func _ready():
	print("Welcome Screen loaded")

	# Apply mobile adaptations
	adapt_for_mobile()

	# Debug: Check if button exists and is connected
	if start_button:
		print("Start button found: ", start_button.name)
		print("Button text: ", start_button.text)
		print("Button disabled: ", start_button.disabled)
		print("Button visible: ", start_button.visible)
		print("Button mouse filter: ", start_button.mouse_filter)

		# Check if signal is connected
		if start_button.pressed.is_connected(_on_start_button_pressed):
			print("Button signal is connected")
		else:
			print("WARNING: Button signal is NOT connected")
			# Manually connect if needed
			start_button.pressed.connect(_on_start_button_pressed)
			print("Manually connected button signal")

		# Add additional signal connections for debugging
		start_button.button_down.connect(_on_button_down)
		start_button.button_up.connect(_on_button_up)
		print("Added debug signal connections")
	else:
		print("ERROR: Start button not found!")

	setup_animations()
	play_title_animation()

# Debug: Test if any input is being received
func _input(event):
	# Handle touch input for mobile
	if event is InputEventScreenTouch and event.pressed:
		print("DEBUG: Touch detected at: ", event.position)

		# Check if touch is near the button
		if start_button:
			var button_rect = Rect2(start_button.global_position, start_button.size)
			print("DEBUG: Button rect: ", button_rect)
			if button_rect.has_point(event.position):
				print("DEBUG: Touch is inside button area!")
				_on_start_button_pressed()
			else:
				print("DEBUG: Touch is outside button area")

	# Handle mouse input for desktop
	elif event is InputEventMouseButton and event.pressed:
		print("DEBUG: Mouse click detected at: ", event.position)

		# Check if click is near the button
		if start_button:
			var button_rect = Rect2(start_button.global_position, start_button.size)
			print("DEBUG: Button rect: ", button_rect)
			if button_rect.has_point(event.global_position):
				print("DEBUG: Click is inside button area!")
			else:
				print("DEBUG: Click is outside button area")

	# Fallback: Press SPACE to change scene
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		print("DEBUG: Space key pressed - manual scene change")
		if GameManager:
			GameManager.change_scene("GameDescriptionScreen")

func setup_animations():
	# Create pulsing animation for the title
	if animation_player:
		var animation = Animation.new()
		animation.length = 2.0
		animation.loop_mode = Animation.LOOP_LINEAR
		
		# Add track for title color modulation
		var track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(track_index, "UI/TitleContainer/GameTitle:modulate")
		
		# Keyframes for pulsing effect
		animation.track_insert_key(track_index, 0.0, Color(1, 1, 1, 1))
		animation.track_insert_key(track_index, 1.0, Color(1.2, 1.2, 0.8, 1))
		animation.track_insert_key(track_index, 2.0, Color(1, 1, 1, 1))
		
		var library = AnimationLibrary.new()
		library.add_animation("title_pulse", animation)
		animation_player.add_animation_library("default", library)

func play_title_animation():
	if animation_player and animation_player.has_animation("default/title_pulse"):
		animation_player.play("default/title_pulse")

func _on_start_button_pressed():
	print("Start button pressed")

	# Debug: Check if GameManager exists
	if GameManager:
		print("GameManager found")
	else:
		print("ERROR: GameManager not found!")
		return

	# Add button press feedback
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(start_button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(start_button, "scale", Vector2(1.0, 1.0), 0.1)

	# Wait for animation then change scene
	await tween.finished

	print("About to change scene to GameDescriptionScreen")

	# Transition to Game Description Screen
	GameManager.change_scene("GameDescriptionScreen")

# Optional: Add hover effects for the button
func _on_start_button_mouse_entered():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(start_button, "scale", Vector2(1.05, 1.05), 0.2)

func _on_start_button_mouse_exited():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(start_button, "scale", Vector2(1.0, 1.0), 0.2)

# Debug functions for button testing
func _on_button_down():
	print("DEBUG: Button down detected!")

func _on_button_up():
	print("DEBUG: Button up detected!")

# Mobile adaptation function
func adapt_for_mobile():
	print("Adapting Welcome Screen for mobile")

	# Check if we're on mobile platform
	var is_mobile = OS.get_name() in ["Android", "iOS"] or DisplayServer.is_touchscreen_available()

	if not is_mobile:
		return

	# Specific adaptations for welcome screen
	if start_button:
		# Increase font size for mobile
		start_button.add_theme_font_size_override("font_size", 20)

	# Adapt title for mobile
	if title_label:
		# Increase title font size
		title_label.add_theme_font_size_override("font_size", 32)

# Connect hover signals if needed
func _enter_tree():
	if start_button != null:
		start_button.mouse_entered.connect(_on_start_button_mouse_entered)
		start_button.mouse_exited.connect(_on_start_button_mouse_exited)
