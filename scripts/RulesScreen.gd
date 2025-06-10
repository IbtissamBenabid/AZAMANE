extends Control

# Rules Screen for Azamane - Moroccan Time Capsule
# Displays game mechanics and rules

@onready var next_button = $UI/ContentPanel/VBoxContainer/NextButton

func _ready():
	print("Rules Screen loaded")

func _on_next_button_pressed():
	print("Next button pressed - moving to Amziane Introduction")
	
	# Add button press feedback
	var tween = create_tween()
	tween.tween_property(next_button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(next_button, "scale", Vector2(1.0, 1.0), 0.1)
	
	await tween.finished
	
	# Transition to Amziane Introduction Screen
	GameManager.change_scene("AmzianeIntroScreen")
