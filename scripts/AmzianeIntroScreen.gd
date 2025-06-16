extends Control

# Amziane Introduction Screen for Azamane - Moroccan Time Capsule
# Displays character card with Amziane's details

@onready var character_sprite = $UI/MainContainer/CharacterPreview/CharacterSprite
@onready var next_button = $UI/MainContainer/InfoPanel/NextButton

func _ready():
	print("Amziane Introduction Screen loaded")
	load_character_sprite()

func load_character_sprite():
	# Always load the Amziane PNG sprite for this introduction screen
	var sprite_path = "res://assets/sprites/amziane_128x128.png"

	if ResourceLoader.exists(sprite_path):
		var texture = load(sprite_path)
		character_sprite.texture = texture
		print("Loaded Amziane sprite: ", sprite_path)

		# Add entrance animation
		animate_character_entrance()
	else:
		print("ERROR: Could not find Amziane sprite at: ", sprite_path)
		# Try alternative path just in case
		var alt_path = GameManager.get_amziane_sprite_path()
		if ResourceLoader.exists(alt_path):
			character_sprite.texture = load(alt_path)
			print("Using alternative Amziane sprite: ", alt_path)
			animate_character_entrance()

func animate_character_entrance():
	# Start with character scaled down and fade in
	character_sprite.scale = Vector2(0.5, 0.5)
	character_sprite.modulate.a = 0.0

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(character_sprite, "scale", Vector2(1.0, 1.0), 0.8)
	tween.tween_property(character_sprite, "modulate:a", 1.0, 0.8)

	# Add a subtle bounce at the end
	await tween.finished
	var bounce_tween = create_tween()
	bounce_tween.tween_property(character_sprite, "scale", Vector2(1.05, 1.05), 0.2)
	bounce_tween.tween_property(character_sprite, "scale", Vector2(1.0, 1.0), 0.2)

func _on_next_button_pressed():
	print("Next button pressed - moving to Map Screen")

	# Add button press feedback
	var tween = create_tween()
	tween.tween_property(next_button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(next_button, "scale", Vector2(1.0, 1.0), 0.1)

	await tween.finished

	# Transition to Map Screen
	GameManager.change_scene("MapScreen")
