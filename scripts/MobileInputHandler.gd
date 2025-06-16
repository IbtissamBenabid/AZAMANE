extends Node

# Mobile Input Handler for Azamane - Moroccan Time Capsule
# Handles touch input, gestures, and mobile-specific interactions

signal touch_started(position: Vector2)
signal touch_ended(position: Vector2)
signal touch_moved(position: Vector2, relative: Vector2)
signal swipe_detected(direction: Vector2, strength: float)
signal long_press_detected(position: Vector2)

# Touch tracking variables
var touch_start_position: Vector2
var touch_start_time: float
var is_touching: bool = false
var touch_moved_threshold: float = 50.0  # Minimum distance for swipe detection
var long_press_duration: float = 0.8     # Time for long press detection
var swipe_min_velocity: float = 300.0    # Minimum velocity for swipe

# Mobile device detection
var is_mobile_device: bool = false

func _ready():
	# Detect if running on mobile device
	detect_mobile_device()
	
	# Enable touch input processing
	set_process_input(true)
	
	print("Mobile Input Handler initialized - Mobile device: ", is_mobile_device)

func detect_mobile_device() -> bool:
	# Check if running on mobile platform
	var platform = OS.get_name()
	is_mobile_device = platform in ["Android", "iOS"]
	
	# Also check for touch capability
	if not is_mobile_device:
		# Check if touch input is available (for web on mobile)
		is_mobile_device = DisplayServer.is_touchscreen_available()
	
	return is_mobile_device

func _input(event):
	# Handle touch input events
	if event is InputEventScreenTouch:
		handle_touch_event(event)
	elif event is InputEventScreenDrag:
		handle_drag_event(event)

func handle_touch_event(event: InputEventScreenTouch):
	if event.pressed:
		# Touch started
		touch_start_position = event.position
		touch_start_time = Time.get_ticks_msec() / 1000.0
		is_touching = true

		# Start long press timer
		start_long_press_timer()

		touch_started.emit(event.position)
		print("Touch started at: ", event.position)
	else:
		# Touch ended
		is_touching = false

		# Cancel long press timer
		cancel_long_press_timer()

		# Check for swipe
		var touch_end_position = event.position
		var swipe_vector = touch_end_position - touch_start_position
		var swipe_distance = swipe_vector.length()

		if swipe_distance > touch_moved_threshold:
			var touch_duration = (Time.get_ticks_msec() / 1000.0) - touch_start_time
			var swipe_velocity = swipe_distance / max(touch_duration, 0.1)

			if swipe_velocity > swipe_min_velocity:
				var swipe_direction = swipe_vector.normalized()
				swipe_detected.emit(swipe_direction, swipe_velocity)
				print("Swipe detected - Direction: ", swipe_direction, " Velocity: ", swipe_velocity)

		touch_ended.emit(event.position)
		print("Touch ended at: ", event.position)

func handle_drag_event(event: InputEventScreenDrag):
	if is_touching:
		touch_moved.emit(event.position, event.relative)

var long_press_timer: Timer

func start_long_press_timer():
	if long_press_timer:
		long_press_timer.queue_free()
	
	long_press_timer = Timer.new()
	add_child(long_press_timer)
	long_press_timer.wait_time = long_press_duration
	long_press_timer.one_shot = true
	long_press_timer.timeout.connect(_on_long_press_timeout)
	long_press_timer.start()

func cancel_long_press_timer():
	if long_press_timer:
		long_press_timer.queue_free()
		long_press_timer = null

func _on_long_press_timeout():
	if is_touching:
		long_press_detected.emit(touch_start_position)
		print("Long press detected at: ", touch_start_position)

# Utility functions for mobile UI
func is_mobile() -> bool:
	return is_mobile_device

func get_safe_area_insets() -> Rect2i:
	# Get safe area for devices with notches/rounded corners
	return DisplayServer.get_display_safe_area()

func enable_haptic_feedback():
	# Enable haptic feedback for supported devices
	if is_mobile_device and OS.get_name() == "Android":
		# Android haptic feedback would be implemented here
		pass
	elif is_mobile_device and OS.get_name() == "iOS":
		# iOS haptic feedback would be implemented here
		pass

func trigger_haptic_feedback(intensity: float = 1.0):
	# Trigger haptic feedback
	if is_mobile_device:
		# Platform-specific haptic feedback implementation
		print("Haptic feedback triggered with intensity: ", intensity)

# Screen orientation utilities
func set_screen_orientation(orientation: int):
	# Set screen orientation
	# 0 = landscape, 1 = portrait, 2 = reverse landscape, 3 = reverse portrait
	if is_mobile_device:
		DisplayServer.screen_set_orientation(orientation)

func get_screen_orientation() -> int:
	return DisplayServer.screen_get_orientation()

# Virtual keyboard utilities
func show_virtual_keyboard():
	if is_mobile_device:
		DisplayServer.virtual_keyboard_show("", Rect2(), DisplayServer.KEYBOARD_TYPE_DEFAULT, -1, -1)

func hide_virtual_keyboard():
	if is_mobile_device:
		DisplayServer.virtual_keyboard_hide()

# Touch-friendly button utilities
func make_button_touch_friendly(button: Button, min_size: Vector2 = Vector2(80, 80)):
	# Ensure button is large enough for touch interaction
	if button.custom_minimum_size.x < min_size.x:
		button.custom_minimum_size.x = min_size.x
	if button.custom_minimum_size.y < min_size.y:
		button.custom_minimum_size.y = min_size.y
	
	# Add touch feedback
	if not button.pressed.is_connected(_on_button_touch_feedback):
		button.pressed.connect(_on_button_touch_feedback.bind(button))

func _on_button_touch_feedback(button: Button):
	# Provide visual and haptic feedback for button press
	trigger_haptic_feedback(0.5)
	
	# Visual feedback animation
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

# Screen size utilities
func get_screen_size() -> Vector2i:
	return DisplayServer.screen_get_size()

func is_small_screen() -> bool:
	var screen_size = get_screen_size()
	return screen_size.x < 800 or screen_size.y < 600

func is_tablet_size() -> bool:
	var screen_size = get_screen_size()
	var diagonal = sqrt(screen_size.x * screen_size.x + screen_size.y * screen_size.y)
	return diagonal > 1200  # Rough tablet size threshold
