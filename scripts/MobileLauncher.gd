extends Control

# Mobile Launcher for AZAMANE - Moroccan Time Capsule
# Provides options to launch the game in different modes

@onready var title_label = $VBoxContainer/Title
@onready var normal_game_btn = $VBoxContainer/ButtonContainer/NormalGameBtn
@onready var mobile_preview_btn = $VBoxContainer/ButtonContainer/MobilePreviewBtn
@onready var description_label = $VBoxContainer/Description

func _ready():
	print("Mobile Launcher initialized")
	setup_ui()

func setup_ui():
	# Set up the launcher interface with error handling
	if title_label:
		title_label.text = "AZAMANE - Moroccan Time Capsule"
	else:
		print("Error: title_label not found")

	if description_label:
		description_label.text = "Choose how you want to experience the game:"
	else:
		print("Error: description_label not found")

	if normal_game_btn:
		normal_game_btn.text = "Play Normal Game"
		# Connect button signals
		normal_game_btn.pressed.connect(_on_normal_game_pressed)
	else:
		print("Error: normal_game_btn not found")

	if mobile_preview_btn:
		mobile_preview_btn.text = "Mobile Preview Mode"
		mobile_preview_btn.pressed.connect(_on_mobile_preview_pressed)
	else:
		print("Error: mobile_preview_btn not found")

func _on_normal_game_pressed():
	print("Starting normal game")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	# Add button feedback
	var tween = create_tween()
	tween.tween_property(normal_game_btn, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(normal_game_btn, "scale", Vector2(1.0, 1.0), 0.1)

	await tween.finished

	# Launch the normal game
	GameManager.change_scene("WelcomeScreen")

func _on_mobile_preview_pressed():
	print("Starting mobile preview mode")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	# Add button feedback
	var tween = create_tween()
	tween.tween_property(mobile_preview_btn, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(mobile_preview_btn, "scale", Vector2(1.0, 1.0), 0.1)

	await tween.finished

	# Launch the mobile preview
	get_tree().change_scene_to_file("res://scenes/MobilePreview.tscn")

func _input(event):
	# Quick keyboard shortcuts
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				_on_normal_game_pressed()
			KEY_2:
				_on_mobile_preview_pressed()
			KEY_ESCAPE:
				get_tree().quit()
