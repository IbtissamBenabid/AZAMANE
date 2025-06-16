extends Node

# Visual Effects Helper for AZAMANE
# Provides reusable visual effects and animations
# This is an autoload singleton

# Moroccan color palette
const COLORS = {
	"BLUE": Color("#2A3F7B"),
	"BROWN": Color("#8B5523"),
	"GOLD": Color("#D4A017"),
	"GREEN": Color("#355E3B")
}

# Button hover effect
func add_button_hover_effect(button: Button):
	if button != null:
		button.mouse_entered.connect(func(): _on_button_hover(button))
		button.mouse_exited.connect(func(): _on_button_unhover(button))
	else:
		print("Warning: Attempted to add hover effect to null button")

func _on_button_hover(button: Button):
	var tween = button.create_tween()
	tween.set_parallel(true)
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(button, "modulate", COLORS.GOLD * 1.2, 0.2)

func _on_button_unhover(button: Button):
	var tween = button.create_tween()
	tween.set_parallel(true)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)
	tween.tween_property(button, "modulate", Color.WHITE, 0.2)

# Fade in animation
func fade_in(node: Node, duration: float = 0.5):
	node.modulate.a = 0.0
	var tween = node.create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)

# Fade out animation
func fade_out(node: Node, duration: float = 0.5):
	var tween = node.create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)

# Scale bounce effect
func bounce_scale(node: Node, scale_factor: float = 1.2, duration: float = 0.3):
	var original_scale = node.scale
	var tween = node.create_tween()
	tween.tween_property(node, "scale", original_scale * scale_factor, duration / 2)
	tween.tween_property(node, "scale", original_scale, duration / 2)

# Shake effect
func shake(node: Node, intensity: float = 5.0, duration: float = 0.5):
	var original_pos = node.position
	var tween = node.create_tween()

	for i in range(int(duration * 20)):  # 20 shakes per second
		var offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		tween.tween_property(node, "position", original_pos + offset, 0.05)

	tween.tween_property(node, "position", original_pos, 0.1)

# Pulse effect
func pulse(node: Node, color: Color = COLORS.GOLD, duration: float = 1.0):
	var original_modulate = node.modulate
	var tween = node.create_tween()
	tween.set_loops()
	tween.tween_property(node, "modulate", color, duration / 2)
	tween.tween_property(node, "modulate", original_modulate, duration / 2)

# Slide in from direction
func slide_in(node: Node, direction: Vector2, distance: float = 100.0, duration: float = 0.5):
	var original_pos = node.position
	node.position = original_pos + direction * distance

	var tween = node.create_tween()
	tween.tween_property(node, "position", original_pos, duration)

# Typewriter text effect
func typewriter_text(label: Label, text: String, speed: float = 0.05):
	label.text = ""
	var tween = label.create_tween()

	for i in range(text.length()):
		tween.tween_callback(func(): label.text = text.substr(0, i + 1))
		tween.tween_delay(speed)

# Create floating particles
func create_desert_particles(parent: Node, position: Vector2, count: int = 30):
	var particles = CPUParticles2D.new()
	parent.add_child(particles)

	particles.position = position
	particles.amount = count
	particles.lifetime = 3.0
	particles.emission_rect_extents = Vector2(50, 20)
	particles.direction = Vector2(1, -0.5)
	particles.spread = 45.0
	particles.initial_velocity_min = 20.0
	particles.initial_velocity_max = 40.0
	particles.gravity = Vector2(0, 5)
	particles.scale_amount_min = 0.3
	particles.scale_amount_max = 0.8
	particles.color = COLORS.GOLD
	particles.color.a = 0.6

	particles.emitting = true

	# Auto-remove after emission
	var timer = Timer.new()
	parent.add_child(timer)
	timer.wait_time = particles.lifetime + 1.0
	timer.one_shot = true
	timer.timeout.connect(func():
		particles.queue_free()
		timer.queue_free()
	)
	timer.start()

# Screen transition effect
func screen_transition(from_scene: Node, to_scene_path: String, transition_type: String = "fade"):
	match transition_type:
		"fade":
			fade_out(from_scene, 0.5)
			await from_scene.create_tween().finished
			from_scene.get_tree().change_scene_to_file(to_scene_path)

		"slide_left":
			slide_in(from_scene, Vector2(-1, 0), 1000, 0.5)
			await from_scene.create_tween().finished
			from_scene.get_tree().change_scene_to_file(to_scene_path)

# Success celebration effect
func celebrate_success(node: Node):
	# Combination of effects for quest success
	bounce_scale(node, 1.3, 0.6)
	create_desert_particles(node.get_parent(), node.global_position + node.size / 2, 50)

	# Color flash
	var original_modulate = node.modulate
	var tween = node.create_tween()
	tween.tween_property(node, "modulate", COLORS.GOLD * 1.5, 0.2)
	tween.tween_property(node, "modulate", original_modulate, 0.4)
