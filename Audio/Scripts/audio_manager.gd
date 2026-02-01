extends Node

# CONFIG
const SFX_POOL_SIZE := 6  # how many simultaneous non-positional sfx voices to preallocate
const SFX_2D_POOL_SIZE := 6

# asp pools
var sfx_pool: Array[AudioStreamPlayer] = []
var sfx_2d_pool: Array[AudioStreamPlayer2D] = []


# Dictionary to hold preloaded sounds for easy access
var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var sounds = {
	"sfx_amb_forest": preload("res://Audio/Assets/Environment/sfx_amb_forest.wav"),
	"sfx_fs_circle_01": preload("res://Audio/Assets/Sfx/sfx_fs_circle_01.wav"),
	"sfx_fs_circle_02": preload("res://Audio/Assets/Sfx/sfx_fs_circle_02.wav"),
	"sfx_fs_circle_03": preload("res://Audio/Assets/Sfx/sfx_fs_circle_03.wav"),
	"sfx_fs_circle_04": preload("res://Audio/Assets/Sfx/sfx_fs_circle_04.wav"),
	"sfx_fs_square_01": preload("res://Audio/Assets/Sfx/sfx_fs_square_01.wav"),
	"sfx_fs_square_02": preload("res://Audio/Assets/Sfx/sfx_fs_square_02.wav"),
	"sfx_fs_square_03": preload("res://Audio/Assets/Sfx/sfx_fs_square_03.wav"),
	"sfx_fs_square_04": preload("res://Audio/Assets/Sfx/sfx_fs_square_04.wav"),
	"sfx_fs_triangle_01": preload("res://Audio/Assets/Sfx/sfx_fs_triangle_01.wav"),
	"sfx_fs_triangle_02": preload("res://Audio/Assets/Sfx/sfx_fs_triangle_02.wav"),
	"sfx_fs_triangle_03": preload("res://Audio/Assets/Sfx/sfx_fs_triangle_03.wav"),
	"sfx_fs_triangle_04": preload("res://Audio/Assets/Sfx/sfx_fs_triangle_04.wav"),
	"sfx_hide_01": preload("res://Audio/Assets/Sfx/sfx_hide_01.wav"),
	"sfx_hide_02": preload("res://Audio/Assets/Sfx/sfx_hide_02.wav"),
	"sfx_transform": preload("res://Audio/Assets/Sfx/sfx_transform.wav"),
	"sfx_ui_click": preload("res://Audio/Assets/Sfx/sfx_ui_click.wav"),
	"sfx_ui_hover": preload("res://Audio/Assets/Sfx/sfx_ui_hover.wav"),
	"mx_menu": preload("res://Audio/Assets/Music/mx_menu.wav"),
	"mx_gameplay": preload("res://Audio/Assets/Music/mx_gameplay.wav"),
	"mx_tutorial": preload("res://Audio/Assets/Music/mx_tutorial.wav"),
	
}


func _ready():
	# Music
	add_child(music_player)
	music_player.bus = "Music"

	# Non-positional SFX pool (UI / global)
	for i in SFX_POOL_SIZE:
		var p := AudioStreamPlayer.new()
		p.bus = "UI"
		add_child(p)
		sfx_pool.append(p)

	# Positional SFX pool (world sounds)
	for i in SFX_2D_POOL_SIZE:
		var p2 := AudioStreamPlayer2D.new()
		p2.bus = "SFX"
		add_child(p2)
		sfx_2d_pool.append(p2)
		
		
func _get_free_sfx_player() -> AudioStreamPlayer:
	for p in sfx_pool:
		if not p.playing:
			return p
	return sfx_pool[0] # voice stealing fallback


func _get_free_sfx_2d_player() -> AudioStreamPlayer2D:
	for p in sfx_2d_pool:
		if not p.playing:
			return p
	return sfx_2d_pool[0]

	
	
	
func play_music(song_name: String):
	
	var track = sounds[song_name]
	if track == null: return
	
	if music_player.stream == track and music_player.playing:
		return # Don't restart if the same track is already playing
	
	music_player.stream = track
	music_player.play()

func play_sfx(
	sound_name: String,
	volume_db: float = 0.0,
	pitch_range: Vector2 = Vector2(1, 1),
	position: Vector2 = Vector2.ZERO
):
	if not sounds.has(sound_name):
		return null

	var stream: AudioStream = sounds[sound_name]
	var pitch := randf_range(pitch_range.x, pitch_range.y)

	if position == Vector2.ZERO:
		var p := _get_free_sfx_player()
		p.stream = stream
		p.pitch_scale = pitch
		p.volume_db = volume_db
		p.play()
		return p
	else:
		var p2 := _get_free_sfx_2d_player()
		p2.stream = stream
		p2.pitch_scale = pitch
		p2.volume_db = volume_db
		p2.global_position = position
		p2.play()
		return p2
		
func play_random(names: Array, 
	volume_db: float = 0.0,
	pitch_range: Vector2 = Vector2(1, 1),
	position: Vector2 = Vector2.ZERO
	):
		
	var soundName = names.pick_random()
	play_sfx(soundName,volume_db,pitch_range, position)

func stop_all_sfx() -> void:
	for p in sfx_pool:
		p.stop()

	for p2 in sfx_2d_pool:
		p2.stop()

func stop_music() -> void:
	if music_player.playing:
		music_player.stop()

func stop_all_audio() -> void:
	stop_music()
	stop_all_sfx()

func set_loop(player: Node, enable: bool) -> void:
	if player == null:
		return

	if player is AudioStreamPlayer or player is AudioStreamPlayer2D:
		player.loop = enable


		
