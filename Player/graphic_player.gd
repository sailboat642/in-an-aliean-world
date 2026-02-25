extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle()
	
# tell if it is moving up or down the
func walk() -> void:
	$AnimationPlayer.reset_section()
	$AnimationPlayer.play("walk")
	
func idle() -> void:
	$AnimationPlayer.reset_section()
	$AnimationPlayer.play("idle")
	
func alarm() -> void:
	$AnimationPlayer.reset_section()
	$AnimationPlayer.play("alarm")

func get_animation_player() -> AnimationPlayer:
	return $AnimationPlayer
	
func play_fs(sound_name: String) -> void:
	AudioManager.play_sfx(sound_name)
	
func play_fs_player_l() ->void:
	AudioManager.play_random(
		[
			"sfx_fs_player_01",
			"sfx_fs_player_02",
			"sfx_fs_player_03",
			"sfx_fs_player_04"
		],
		-2.0,
		Vector2(0.93, 1.07),
		Vector2.ZERO
	)

func play_fs_player_r() ->void:
	AudioManager.play_random(
		[
			"sfx_fs_player_05",
			"sfx_fs_player_06",
			"sfx_fs_player_07",
			"sfx_fs_player_08"
		],
		-2.0,
		Vector2(0.93, 1.07),
		Vector2.ZERO
	)
	
#func play_fs(sound_name: String) -> void:
	#AudioManager.play_sfx(sound_name)
