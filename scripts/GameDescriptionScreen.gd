extends Control

# Game Description Screen for Azamane - Moroccan Time Capsule
# Displays game overview and introduction

@onready var next_button = $UI/NextButton
@onready var button_label = $UI/NextButton/ButtonLabel

func _ready():
	print("Game Description Screen loaded")

func _on_next_button_pressed():
	print("Next button pressed - moving to Character Customization")
	
	# Add button press feedback
	var tween = create_tween()
	tween.tween_property(next_button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(next_button, "scale", Vector2(1.0, 1.0), 0.1)
	
	await tween.finished
	
	# Transition to Character Customization Screen
	GameManager.change_scene("CharacterCustomizationScreen")
