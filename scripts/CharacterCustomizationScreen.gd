extends Control

# Character Customization Screen for Azamane - Moroccan Time Capsule
# Allows player to customize gender and clothing with real-time preview

@onready var character_sprite = $UI/MainContainer/CharacterPreview/VBoxContainer/CharacterSprite
@onready var male_button = $UI/MainContainer/CustomizationPanel/VBoxContainer/GenderSection/GenderButtons/MaleButton
@onready var female_button = $UI/MainContainer/CustomizationPanel/VBoxContainer/GenderSection/GenderButtons/FemaleButton
@onready var indigo_button = $UI/MainContainer/CustomizationPanel/VBoxContainer/ClothingSection/ClothingButtons/IndigoDjellabaButton
@onready var brown_button = $UI/MainContainer/CustomizationPanel/VBoxContainer/ClothingSection/ClothingButtons/BrownRobeButton
@onready var blue_button = $UI/MainContainer/CustomizationPanel/VBoxContainer/ClothingSection/ClothingButtons/BlueTunicButton
@onready var start_button = $UI/MainContainer/CustomizationPanel/VBoxContainer/StartButton

# Button groups for exclusive selection
var gender_group: ButtonGroup
var clothing_group: ButtonGroup

func _ready():
	print("Character Customization Screen loaded")
	setup_button_groups()
	update_character_preview()

func setup_button_groups():
	# Create button groups for exclusive selection
	gender_group = ButtonGroup.new()
	male_button.button_group = gender_group
	female_button.button_group = gender_group
	
	clothing_group = ButtonGroup.new()
	indigo_button.button_group = clothing_group
	brown_button.button_group = clothing_group
	blue_button.button_group = clothing_group

func update_character_preview():
	# Get current selections
	var gender = "Male" if male_button.button_pressed else "Female"
	var clothing = get_selected_clothing()
	var color = get_selected_color()

	# Update GameManager
	GameManager.set_player_gender(gender)
	GameManager.set_player_clothing(clothing, color)

	# Load and display sprite
	var sprite_path = GameManager.get_player_sprite_path()
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

func get_selected_clothing() -> String:
	if indigo_button.button_pressed:
		return "djellaba"
	elif brown_button.button_pressed:
		return "djellaba"
	elif blue_button.button_pressed:
		return "tunic"
	else:
		return "djellaba"  # Default

func get_selected_color() -> String:
	if indigo_button.button_pressed:
		return "blue"
	elif brown_button.button_pressed:
		return "green"
	elif blue_button.button_pressed:
		return "blue"
	else:
		return "blue"  # Default

# Gender button handlers
func _on_male_button_pressed():
	print("Male selected")
	update_character_preview()

func _on_female_button_pressed():
	print("Female selected")
	update_character_preview()

# Clothing button handlers
func _on_indigo_djellaba_button_pressed():
	print("Indigo djellaba selected")
	update_character_preview()

func _on_brown_robe_button_pressed():
	print("Brown robe selected")
	update_character_preview()

func _on_blue_tunic_button_pressed():
	print("Blue tunic selected")
	update_character_preview()

func _on_start_button_pressed():
	print("Start Adventure button pressed")
	
	# Add button press feedback
	var tween = create_tween()
	tween.tween_property(start_button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(start_button, "scale", Vector2(1.0, 1.0), 0.1)
	
	await tween.finished
	
	# Transition to Rules Screen
	GameManager.change_scene("RulesScreen")
