extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle()
	
# tell if it is moving up or down the
func walk() -> void:
	$AnimationPlayer.reset_section()
	$AnimationPlayer.play("walk")
	
func idle() -> void:
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("idle")
	
func alarm() -> void:
	$AnimationPlayer.reset_section()
	$AnimationPlayer.play("alarm")

func get_animation_player() -> AnimationPlayer:
	return $AnimationPlayer
	
func play_fs_prey_l() ->void:
	AudioManager.play_random(
		[
			"sfx_fs_prey_01",
			"sfx_fs_prey_02",
			"sfx_fs_prey_03",
			"sfx_fs_prey_04"
		],
		-2.0,
		Vector2(0.93, 1.07),
		Vector2.ONE
	)

func play_fs_prey_r() ->void:
	AudioManager.play_random(
		[
			"sfx_fs_prey_05",
			"sfx_fs_prey_06",
			"sfx_fs_prey_07",
			"sfx_fs_prey_08"
		],
		-2.0,
		Vector2(0.93, 1.07),
		Vector2.ONE
	)
	
func play_fs_square_l() ->void:
	AudioManager.play_random(
		[
			"sfx_fs_square_01",
			"sfx_fs_square_02",
			"sfx_fs_square_03",
			"sfx_fs_square_04"
		],
		-2.0,
		Vector2(0.93, 1.07),
		Vector2.ONE
	)

func play_fs_square_r() ->void:
	AudioManager.play_random(
		[
			"sfx_fs_square_05",
			"sfx_fs_square_06",
			"sfx_fs_square_07",
			"sfx_fs_square_08"
		],
		-2.0,
		Vector2(0.93, 1.07),
		Vector2.ONE
	)
	
#func play_fs(sound_name: String) -> void:
	#AudioManager.play_sfx(sound_name)
