extends Control

# Quest Screen for Azamane - Moroccan Time Capsule
# Handles individual quest interactions and riddles

@onready var quest_title = $UI/QuestPanel/QuestTitle
@onready var quest_description = $UI/QuestPanel/QuestDescription
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

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	highlight_selected_option(0)

func _on_option_b_pressed():
	print("Option B selected")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	highlight_selected_option(1)

func _on_option_c_pressed():
	print("Option C selected")

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	highlight_selected_option(2)

func _on_submit_button_pressed():
	if selected_option == -1:
		return

	print("Submitting answer: ", selected_option)

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	# Disable buttons during processing
	submit_button.disabled = true
	option_a.disabled = true
	option_b.disabled = true
	option_c.disabled = true

	# Process the answer
	var result = GameManager.answer_quest(current_quest_id, selected_option)
	show_quest_result(result)

func show_quest_result(result: Dictionary):
	# Play correct answer sound if the answer was correct
	if result.success and AudioManager:
		AudioManager.play_correct_answer_sound()

	# Create custom styled result panel
	create_custom_result_panel(result)

func create_custom_result_panel(result: Dictionary):
	# Create overlay background
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.7)  # Semi-transparent black
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP  # Block input to background
	add_child(overlay)

	# Create main panel using game assets
	var panel = NinePatchRect.new()
	var panel_texture = load("res://assets/sprites/largel_panel_256x128.png")
	if panel_texture:
		panel.texture = panel_texture
		panel.patch_margin_left = 32
		panel.patch_margin_top = 32
		panel.patch_margin_right = 32
		panel.patch_margin_bottom = 32

	# Center the panel
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.size = Vector2(600, 400)
	panel.position = Vector2(-300, -200)  # Center it
	overlay.add_child(panel)

	# Create content container
	var content_container = VBoxContainer.new()
	content_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content_container.add_theme_constant_override("separation", 20)
	content_container.offset_left = 40
	content_container.offset_top = 40
	content_container.offset_right = -40
	content_container.offset_bottom = -40
	panel.add_child(content_container)

	# Add title
	var title_label = Label.new()
	if result.success:
		title_label.text = "Quest Completed! ✅"
		title_label.add_theme_color_override("font_color", Color("#D4A017"))  # Gold
	else:
		title_label.text = "Try Again 🤔"
		title_label.add_theme_color_override("font_color", Color("#8B5523"))  # Brown

	title_label.add_theme_font_size_override("font_size", 28)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content_container.add_child(title_label)

	# Add spacer
	var spacer1 = Control.new()
	spacer1.custom_minimum_size = Vector2(0, 20)
	content_container.add_child(spacer1)

	# Add main content
	var content_label = RichTextLabel.new()
	content_label.bbcode_enabled = true
	content_label.fit_content = true
	content_label.add_theme_color_override("default_color", Color("#2A3F7B"))  # Blue
	content_label.add_theme_font_size_override("normal_font_size", 18)

	var content_text = ""
	if result.success:
		content_text = "[center]Correct! Well done, Amziane![/center]\n\n"
		content_text += "[color=#355E3B]Cultural Insight:[/color] " + result.lore + "\n\n"

		if result.has("collectible"):
			content_text += "[color=#D4A017]You received: " + result.collectible + "[/color]\n"
			content_text += "[center][i]Added to your time capsule![/i][/center]"
	else:
		content_text = "[center]That's not quite right. Think about the desert and its mysteries...[/center]\n\n"
		content_text += "[color=#355E3B]Cultural Insight:[/color] " + result.lore

	content_label.text = content_text
	content_container.add_child(content_label)

	# Add spacer
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 20)
	content_container.add_child(spacer2)

	# Add continue button
	var continue_button = Button.new()
	if result.success:
		continue_button.text = "Continue to Map"
	else:
		continue_button.text = "Try Again"

	continue_button.add_theme_color_override("font_color", Color("#2A3F7B"))  # Blue
	continue_button.add_theme_font_size_override("font_size", 20)
	continue_button.custom_minimum_size = Vector2(200, 50)
	continue_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	content_container.add_child(continue_button)

	# Add panel entrance animation
	panel.scale = Vector2(0.8, 0.8)
	panel.modulate.a = 0.0
	overlay.modulate.a = 0.0

	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(overlay, "modulate:a", 1.0, 0.3)
	tween.tween_property(panel, "scale", Vector2(1.0, 1.0), 0.3)
	tween.tween_property(panel, "modulate:a", 1.0, 0.3)

	# Connect button signal
	if result.success:
		continue_button.pressed.connect(func(): _close_result_panel(overlay, true))
	else:
		continue_button.pressed.connect(func(): _close_result_panel(overlay, false))

func _close_result_panel(overlay: Control, success: bool):
	# Add exit animation
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(overlay, "modulate:a", 0.0, 0.2)

	await tween.finished
	overlay.queue_free()

	# Handle next action
	if success:
		_on_quest_completed()
	else:
		_on_quest_retry()

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

	# Play click sound
	if AudioManager:
		AudioManager.play_click_sound()

	# Add button press feedback
	var tween = create_tween()
	tween.tween_property(back_button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(back_button, "scale", Vector2(1.0, 1.0), 0.1)

	await tween.finished

	# Return to map without completing quest
	GameManager.change_scene("MapScreen")
