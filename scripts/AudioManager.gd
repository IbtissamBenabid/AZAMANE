extends Node

# AudioManager for AZAMANE - Moroccan Time Capsule
# Handles all audio functionality including background music and sound effects
# This is an autoload singleton

# Audio resources
var desert_wind_audio: AudioStream
var click_sound_audio: AudioStream
var rehab_audio: AudioStream
var correct_answer_audio: AudioStream

# Audio players for different types of audio
var background_music_player: AudioStreamPlayer
var sound_effects_player: AudioStreamPlayer

# Audio settings
var master_volume: float = 1.0
var music_volume: float = 0.7
var sfx_volume: float = 0.8

func _ready():
	print("AudioManager initialized")
	
	# Create audio players
	setup_audio_players()
	
	# Load audio resources
	load_audio_resources()

func setup_audio_players():
	# Background music player
	background_music_player = AudioStreamPlayer.new()
	background_music_player.name = "BackgroundMusicPlayer"
	background_music_player.volume_db = linear_to_db(music_volume * master_volume)
	add_child(background_music_player)
	
	# Sound effects player
	sound_effects_player = AudioStreamPlayer.new()
	sound_effects_player.name = "SoundEffectsPlayer"
	sound_effects_player.volume_db = linear_to_db(sfx_volume * master_volume)
	add_child(sound_effects_player)
	
	print("Audio players created")

func load_audio_resources():
	# Load desert wind audio
	var desert_path = "res://assets/audio/desert-wind-1-350398.mp3"
	if ResourceLoader.exists(desert_path):
		desert_wind_audio = load(desert_path)
		print("Loaded desert wind audio")
	else:
		print("ERROR: Could not find desert wind audio at: ", desert_path)
	
	# Load click sound audio
	var click_path = "res://assets/audio/click-234708.mp3"
	if ResourceLoader.exists(click_path):
		click_sound_audio = load(click_path)
		print("Loaded click sound audio")
	else:
		print("ERROR: Could not find click sound audio at: ", click_path)
	
	# Load rehab audio
	var rehab_path = "res://assets/audio/rebab-72605.mp3"
	if ResourceLoader.exists(rehab_path):
		rehab_audio = load(rehab_path)
		print("Loaded rehab audio")
	else:
		print("ERROR: Could not find rehab audio at: ", rehab_path)

	# Load correct answer audio
	var correct_path = "res://assets/audio/correct.mp3"
	if ResourceLoader.exists(correct_path):
		correct_answer_audio = load(correct_path)
		print("Loaded correct answer audio")
	else:
		print("ERROR: Could not find correct answer audio at: ", correct_path)

# Play background music
func play_background_music(audio_type: String, loop: bool = true):
	var audio_stream: AudioStream = null

	match audio_type:
		"desert":
			audio_stream = desert_wind_audio
		"rehab":
			audio_stream = rehab_audio
		_:
			print("Unknown audio type: ", audio_type)
			return

	if audio_stream and background_music_player:
		background_music_player.stream = audio_stream

		# For MP3 streams in Godot 4, we need to handle looping differently
		if loop and background_music_player.stream:
			# Connect to the finished signal to restart the audio for looping
			if not background_music_player.finished.is_connected(_on_background_music_finished):
				background_music_player.finished.connect(_on_background_music_finished)
		else:
			# Disconnect the signal if we don't want looping
			if background_music_player.finished.is_connected(_on_background_music_finished):
				background_music_player.finished.disconnect(_on_background_music_finished)

		background_music_player.play()
		print("Playing background music: ", audio_type)
	else:
		print("Could not play background music: ", audio_type)

# Handle background music looping
func _on_background_music_finished():
	if background_music_player and background_music_player.stream:
		background_music_player.play()

# Stop background music
func stop_background_music():
	if background_music_player:
		# Disconnect the looping signal
		if background_music_player.finished.is_connected(_on_background_music_finished):
			background_music_player.finished.disconnect(_on_background_music_finished)

		background_music_player.stop()
		print("Background music stopped")

# Play sound effect
func play_sound_effect(audio_type: String):
	var audio_stream: AudioStream = null

	match audio_type:
		"click":
			audio_stream = click_sound_audio
		"correct":
			audio_stream = correct_answer_audio
		_:
			print("Unknown sound effect type: ", audio_type)
			return

	if audio_stream and sound_effects_player:
		sound_effects_player.stream = audio_stream
		sound_effects_player.play()
		print("Playing sound effect: ", audio_type)
	else:
		print("Could not play sound effect: ", audio_type)

# Play click sound - convenience function for buttons
func play_click_sound():
	play_sound_effect("click")

# Play correct answer sound - convenience function for correct answers
func play_correct_answer_sound():
	play_sound_effect("correct")

# Volume control functions
func set_master_volume(volume: float):
	master_volume = clamp(volume, 0.0, 1.0)
	update_audio_volumes()

func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)
	update_audio_volumes()

func set_sfx_volume(volume: float):
	sfx_volume = clamp(volume, 0.0, 1.0)
	update_audio_volumes()

func update_audio_volumes():
	if background_music_player:
		background_music_player.volume_db = linear_to_db(music_volume * master_volume)
	
	if sound_effects_player:
		sound_effects_player.volume_db = linear_to_db(sfx_volume * master_volume)

# Check if background music is playing
func is_background_music_playing() -> bool:
	return background_music_player and background_music_player.playing

# Fade in/out functions for smooth transitions
func fade_in_background_music(audio_type: String, duration: float = 1.0):
	play_background_music(audio_type, true)  # Always loop background music
	if background_music_player:
		background_music_player.volume_db = -80.0  # Start silent
		var tween = create_tween()
		tween.tween_property(background_music_player, "volume_db", linear_to_db(music_volume * master_volume), duration)

func fade_out_background_music(duration: float = 1.0):
	if background_music_player and background_music_player.playing:
		var tween = create_tween()
		tween.tween_property(background_music_player, "volume_db", -80.0, duration)
		tween.tween_callback(stop_background_music)
