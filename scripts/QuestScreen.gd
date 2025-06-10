extends Control

# Quest Screen for Azamane - Moroccan Time Capsule
# Handles individual quest interactions and riddles

@onready var quest_title = $UI/QuestPanel/VBoxContainer/QuestTitle
@onready var quest_description = $UI/QuestPanel/VBoxContainer/QuestDescription
@onready var riddle_text = $UI/QuestPanel/VBoxContainer/RiddleText
@onready var option_a = $UI/QuestPanel/VBoxContainer/OptionsContainer/OptionA
@onready var option_b = $UI/QuestPanel/VBoxContainer/OptionsContainer/OptionB
@onready var option_c = $UI/QuestPanel/VBoxContainer/OptionsContainer/OptionC
@onready var back_button = $UI/QuestPanel/VBoxContainer/ButtonContainer/BackButton
@onready var submit_button = $UI/QuestPanel/VBoxContainer/ButtonContainer/SubmitButton

var current_quest_id: String = ""
var current_riddle: Dictionary = {}
var selected_option: int = -1

func _ready():
	print("Quest Screen loaded")
	load_current_quest()

func load_current_quest():
	# Get the current quest from GameManager
	current_quest_id = GameManager.game_state.get("current_quest", "")
	
	if current_quest_id.is_empty():
		print("No current quest found, returning to map")
		GameManager.change_scene("MapScreen")
		return
	
	# Get quest data and riddle
	current_riddle = GameManager.start_quest(current_quest_id)
	setup_quest_ui()

func setup_quest_ui():
	# Set quest title and description based on quest ID
	match current_quest_id:
		"traders_riddle":
			quest_title.text = "Trader's Riddle"
			quest_description.text = "[center]A wise trader at the stall poses a riddle to test your knowledge of the desert.[/center]"
		"camel_track":
			quest_title.text = "Camel Track"
			quest_description.text = "[center]A camel has wandered off. Use the mystical clue to track it down.[/center]"
		"berber_tale":
			quest_title.text = "Berber Tale"
			quest_description.text = "[center]The elders at the caravan camp want to hear a traditional Berber tale.[/center]"
		_:
			quest_title.text = "Unknown Quest"
			quest_description.text = "[center]Quest details not found.[/center]"
	
	# Set riddle text and options
	riddle_text.text = current_riddle.question
	option_a.text = "A) " + current_riddle.options[0]
	option_b.text = "B) " + current_riddle.options[1]
	option_c.text = "C) " + current_riddle.options[2]
	
	# Reset selection
	selected_option = -1
	submit_button.disabled = true
	reset_option_styles()

func reset_option_styles():
	# Reset all option button styles with animation
	var buttons = [option_a, option_b, option_c]

	for button in buttons:
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(button, "modulate", Color.WHITE, 0.2)
		tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)
		button.remove_theme_color_override("font_color")

func highlight_selected_option(option_index: int):
	reset_option_styles()

	# Highlight the selected option with animation
	var selected_button: Button
	match option_index:
		0:
			selected_button = option_a
		1:
			selected_button = option_b
		2:
			selected_button = option_c

	if selected_button:
		# Animate selection
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(selected_button, "modulate", Color(1.3, 1.3, 0.7), 0.3)
		tween.tween_property(selected_button, "scale", Vector2(1.05, 1.05), 0.3)

		# Add glow effect
		selected_button.add_theme_color_override("font_color", Color(0.831, 0.627, 0.09))

	selected_option = option_index
	submit_button.disabled = false

	# Animate submit button becoming available
	var submit_tween = create_tween()
	submit_tween.tween_property(submit_button, "modulate", Color(1.2, 1.2, 0.8), 0.3)

# Option button handlers
func _on_option_a_pressed():
	print("Option A selected")
	highlight_selected_option(0)

func _on_option_b_pressed():
	print("Option B selected")
	highlight_selected_option(1)

func _on_option_c_pressed():
	print("Option C selected")
	highlight_selected_option(2)

func _on_submit_button_pressed():
	if selected_option == -1:
		return
	
	print("Submitting answer: ", selected_option)
	
	# Disable buttons during processing
	submit_button.disabled = true
	option_a.disabled = true
	option_b.disabled = true
	option_c.disabled = true
	
	# Process the answer
	var result = GameManager.answer_quest(current_quest_id, selected_option)
	show_quest_result(result)

func show_quest_result(result: Dictionary):
	# Create result popup
	var popup = AcceptDialog.new()
	
	if result.success:
		popup.title = "Quest Completed! ✅"
		var content = "Correct! Well done, Amziane!\n\n"
		content += "Cultural Insight: " + result.lore + "\n\n"
		
		if result.has("collectible"):
			content += "You received: " + result.collectible + "\n"
			content += "Added to your time capsule!"
		
		popup.dialog_text = content
	else:
		popup.title = "Try Again 🤔"
		popup.dialog_text = "That's not quite right. Think about the desert and its mysteries...\n\nCultural Insight: " + result.lore
	
	popup.size = Vector2(500, 300)
	add_child(popup)
	popup.popup_centered()
	
	# Handle popup closure
	if result.success:
		popup.confirmed.connect(_on_quest_completed)
	else:
		popup.confirmed.connect(_on_quest_retry)

func _on_quest_completed():
	# Quest was successful, return to map
	print("Quest completed successfully, returning to map")
	GameManager.change_scene("MapScreen")

func _on_quest_retry():
	# Allow player to try again
	print("Allowing quest retry")
	selected_option = -1
	submit_button.disabled = true
	option_a.disabled = false
	option_b.disabled = false
	option_c.disabled = false
	reset_option_styles()

func _on_back_button_pressed():
	print("Back button pressed")
	
	# Add button press feedback
	var tween = create_tween()
	tween.tween_property(back_button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(back_button, "scale", Vector2(1.0, 1.0), 0.1)
	
	await tween.finished
	
	# Return to map without completing quest
	GameManager.change_scene("MapScreen")
