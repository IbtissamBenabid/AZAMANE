extends Control

# Test script to verify button functionality and GameManager

@onready var test_button = $VBoxContainer/TestButton
@onready var status_label = $VBoxContainer/StatusLabel

func _ready():
	print("=== BUTTON TEST SCENE ===")
	
	# Test GameManager availability
	if GameManager:
		print("✅ GameManager is available")
		status_label.text = "GameManager: OK"
	else:
		print("❌ GameManager is NOT available")
		status_label.text = "GameManager: MISSING"

func _on_test_button_pressed():
	print("Test button pressed!")
	status_label.text = "Button works!"
	
	# Test GameManager scene change
	if GameManager:
		print("Testing GameManager.change_scene...")
		status_label.text = "Testing scene change..."
		
		# Wait a moment then try to change scene
		await get_tree().create_timer(1.0).timeout
		GameManager.change_scene("GameDescriptionScreen")
	else:
		status_label.text = "GameManager missing!"
