extends Control

# Character Selection Screen for Azamane - Moroccan Time Capsule
# Simple choice between Female or Male character - no customization

@onready var character_sprite = $UI/MainContainer/CharacterPreview/CharacterSprite
@onready var male_button = $UI/MainContainer/CustomizationPanel/MaleButton
@onready var female_button = $UI/MainContainer/CustomizationPanel/FemaleButton

# Current selection
var selected_character = "Male"  # Default to male

func _ready():
	print("Character Selection Screen loaded")

	# Start rehab background music
	if AudioManager:
		AudioManager.fade_in_background_music("rehab", 2.0)

	update_character_preview()

func update_character_preview():
	# Update GameManager with current selection
	GameManager.set_player_gender(selected_character)

	# Set appropriate clothing - no customization needed
	GameManager.set_player_clothing("djellaba", "green")

	# Load and display appropriate solo sprite
	var sprite_path = ""
	if selected_character == "Female":
		sprite_path = "res://assets/sprites/solo_red_female_player_standing_128x128.png"
	else:
		sprite_path = "res://assets/sprites/solo_blue_player_standing_128x128.png"

	var texture = load(sprite_path) if ResourceLoader.exists(sprite_path) else null

	if texture:
		character_sprite.texture = texture
		print("Updated character sprite: ", sprite_path)

		# Add preview animation
		animate_character_preview()
	else:
		print("Could not load sprite: ", sprite_path)
		# Try fallback sprite
		var fallback_path = GameManager.get_amziane_sprite_path()
		if ResourceLoader.exists(fallback_path):
			character_sprite.texture = load(fallback_path)
			print("Using fallback sprite: ", fallback_path)

func animate_character_preview():
	# Add a subtle scale animation to show the change
	var tween = create_tween()
	tween.tween_property(character_sprite, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(character_sprite, "scale", Vector2(1.0, 1.0), 0.2)

# Character button handlers - direct selection, no toggle
func _on_male_button_pressed():
	print("Male character selected")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	selected_character = "Male"
	update_character_preview()

	# Proceed directly to next screen
	proceed_to_next_screen()

func _on_female_button_pressed():
	print("Female character selected")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	selected_character = "Female"
	update_character_preview()

	# Proceed directly to next screen
	proceed_to_next_screen()

func proceed_to_next_screen():
	# Add button press feedback
	var tween = create_tween()
	tween.tween_property(character_sprite, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(character_sprite, "scale", Vector2(1.0, 1.0), 0.2)

	await tween.finished

	# Fade out background music before scene change
	if AudioManager:
		AudioManager.fade_out_background_music(1.0)

	# Transition to Rules Screen
	GameManager.change_scene("RulesScreen")
