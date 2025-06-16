extends Node

# Mobile UI Manager for Azamane - Moroccan Time Capsule
# Handles responsive design and mobile-specific UI adaptations

signal orientation_changed(new_orientation: int)
signal screen_size_changed(new_size: Vector2i)

# UI scaling constants
const MIN_BUTTON_SIZE = Vector2(80, 80)
const MOBILE_FONT_SCALE = 1.2
const TABLET_FONT_SCALE = 1.1
const MOBILE_MARGIN_SCALE = 1.5

# Screen size categories
enum ScreenSize {
	SMALL_PHONE,    # < 5 inches
	LARGE_PHONE,    # 5-6.5 inches  
	SMALL_TABLET,   # 7-9 inches
	LARGE_TABLET    # > 9 inches
}

var current_screen_size: ScreenSize
var current_orientation: int
var is_mobile: bool = false

func _ready():
	# Initialize mobile detection
	is_mobile = MobileInputHandler.is_mobile()
	
	# Get initial screen info
	update_screen_info()
	
	# Connect to screen changes
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	
	print("Mobile UI Manager initialized - Mobile: ", is_mobile, " Screen size: ", current_screen_size)

func update_screen_info():
	var screen_size = DisplayServer.screen_get_size()
	var old_orientation = current_orientation
	current_orientation = DisplayServer.screen_get_orientation()
	
	# Determine screen size category
	var diagonal_inches = calculate_screen_diagonal_inches(screen_size)
	
	if diagonal_inches < 5.0:
		current_screen_size = ScreenSize.SMALL_PHONE
	elif diagonal_inches < 6.5:
		current_screen_size = ScreenSize.LARGE_PHONE
	elif diagonal_inches < 9.0:
		current_screen_size = ScreenSize.SMALL_TABLET
	else:
		current_screen_size = ScreenSize.LARGE_TABLET
	
	# Emit signals if changed
	if old_orientation != current_orientation:
		orientation_changed.emit(current_orientation)
	
	screen_size_changed.emit(screen_size)

func calculate_screen_diagonal_inches(screen_size: Vector2i) -> float:
	# Rough calculation - assumes ~300 DPI for mobile devices
	var dpi = 300.0
	var width_inches = screen_size.x / dpi
	var height_inches = screen_size.y / dpi
	return sqrt(width_inches * width_inches + height_inches * height_inches)

func _on_viewport_size_changed():
	update_screen_info()

# UI Adaptation Functions

func adapt_control_for_mobile(control: Control):
	"""Adapt a control for mobile use"""
	if not is_mobile:
		return
	
	# Apply mobile-specific adaptations
	adapt_margins(control)
	adapt_fonts(control)
	adapt_buttons(control)
	adapt_layout(control)

func adapt_margins(control: Control):
	"""Increase margins for better touch interaction"""
	if control is Container:
		var container = control as Container
		
		# Add mobile-friendly margins
		if container.has_theme_constant_override("margin_left"):
			var current_margin = container.get_theme_constant("margin_left")
			container.add_theme_constant_override("margin_left", int(current_margin * MOBILE_MARGIN_SCALE))
		
		if container.has_theme_constant_override("margin_right"):
			var current_margin = container.get_theme_constant("margin_right")
			container.add_theme_constant_override("margin_right", int(current_margin * MOBILE_MARGIN_SCALE))
		
		if container.has_theme_constant_override("margin_top"):
			var current_margin = container.get_theme_constant("margin_top")
			container.add_theme_constant_override("margin_top", int(current_margin * MOBILE_MARGIN_SCALE))
		
		if container.has_theme_constant_override("margin_bottom"):
			var current_margin = container.get_theme_constant("margin_bottom")
			container.add_theme_constant_override("margin_bottom", int(current_margin * MOBILE_MARGIN_SCALE))

func adapt_fonts(control: Control):
	"""Scale fonts for mobile readability"""
	var font_scale = get_font_scale()
	
	if control is Label:
		var label = control as Label
		if label.has_theme_font_size_override("font_size"):
			var current_size = label.get_theme_font_size("font_size")
			label.add_theme_font_size_override("font_size", int(current_size * font_scale))
	
	elif control is Button:
		var button = control as Button
		if button.has_theme_font_size_override("font_size"):
			var current_size = button.get_theme_font_size("font_size")
			button.add_theme_font_size_override("font_size", int(current_size * font_scale))
	
	elif control is RichTextLabel:
		var rich_label = control as RichTextLabel
		if rich_label.has_theme_font_size_override("normal_font_size"):
			var current_size = rich_label.get_theme_font_size("normal_font_size")
			rich_label.add_theme_font_size_override("normal_font_size", int(current_size * font_scale))

func adapt_buttons(control: Control):
	"""Make buttons touch-friendly"""
	if control is Button:
		var button = control as Button
		
		# Ensure minimum touch size
		if button.custom_minimum_size.x < MIN_BUTTON_SIZE.x:
			button.custom_minimum_size.x = MIN_BUTTON_SIZE.x
		if button.custom_minimum_size.y < MIN_BUTTON_SIZE.y:
			button.custom_minimum_size.y = MIN_BUTTON_SIZE.y
		
		# Add touch feedback
		MobileInputHandler.make_button_touch_friendly(button)

func adapt_layout(control: Control):
	"""Adapt layout for mobile screens"""
	match current_screen_size:
		ScreenSize.SMALL_PHONE:
			adapt_for_small_phone(control)
		ScreenSize.LARGE_PHONE:
			adapt_for_large_phone(control)
		ScreenSize.SMALL_TABLET:
			adapt_for_small_tablet(control)
		ScreenSize.LARGE_TABLET:
			adapt_for_large_tablet(control)

func adapt_for_small_phone(control: Control):
	"""Adaptations for small phone screens"""
	# Reduce spacing in containers
	if control is VBoxContainer or control is HBoxContainer:
		var container = control as BoxContainer
		container.add_theme_constant_override("separation", 8)
	
	# Make text more compact
	if control is RichTextLabel:
		var rich_label = control as RichTextLabel
		rich_label.fit_content = true

func adapt_for_large_phone(_control: Control):
	"""Adaptations for large phone screens"""
	# Standard mobile adaptations
	pass

func adapt_for_small_tablet(control: Control):
	"""Adaptations for small tablet screens"""
	# Slightly larger spacing
	if control is VBoxContainer or control is HBoxContainer:
		var container = control as BoxContainer
		container.add_theme_constant_override("separation", 12)

func adapt_for_large_tablet(control: Control):
	"""Adaptations for large tablet screens"""
	# Larger spacing and elements
	if control is VBoxContainer or control is HBoxContainer:
		var container = control as BoxContainer
		container.add_theme_constant_override("separation", 16)

func get_font_scale() -> float:
	"""Get appropriate font scale for current device"""
	match current_screen_size:
		ScreenSize.SMALL_PHONE:
			return MOBILE_FONT_SCALE
		ScreenSize.LARGE_PHONE:
			return MOBILE_FONT_SCALE
		ScreenSize.SMALL_TABLET:
			return TABLET_FONT_SCALE
		ScreenSize.LARGE_TABLET:
			return TABLET_FONT_SCALE
		_:
			return 1.0

# Recursive adaptation for entire scene trees
func adapt_scene_for_mobile(scene_root: Node):
	"""Recursively adapt an entire scene for mobile"""
	if not is_mobile:
		return
	
	_adapt_node_recursive(scene_root)

func _adapt_node_recursive(node: Node):
	"""Recursively adapt nodes"""
	if node is Control:
		adapt_control_for_mobile(node as Control)
	
	# Process children
	for child in node.get_children():
		_adapt_node_recursive(child)

# Utility functions
func is_portrait() -> bool:
	return current_orientation == DisplayServer.SCREEN_PORTRAIT or current_orientation == DisplayServer.SCREEN_REVERSE_PORTRAIT

func is_landscape() -> bool:
	return current_orientation == DisplayServer.SCREEN_LANDSCAPE or current_orientation == DisplayServer.SCREEN_REVERSE_LANDSCAPE

func get_safe_area() -> Rect2i:
	return DisplayServer.get_display_safe_area()

func should_use_mobile_layout() -> bool:
	return is_mobile and (current_screen_size == ScreenSize.SMALL_PHONE or current_screen_size == ScreenSize.LARGE_PHONE)

func should_use_tablet_layout() -> bool:
	return is_mobile and (current_screen_size == ScreenSize.SMALL_TABLET or current_screen_size == ScreenSize.LARGE_TABLET)

# Screen orientation management
func lock_orientation(orientation: int):
	"""Lock screen to specific orientation"""
	if is_mobile:
		DisplayServer.screen_set_orientation(orientation)

func unlock_orientation():
	"""Allow all orientations"""
	if is_mobile:
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR)
