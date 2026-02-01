extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle()
	
# tell if it is moving up or down the
func walk() -> void:
	$AnimationPlayer.reset_section()
	$AnimationPlayer.play("walk")
	
func idle() -> void:
	$AnimationPlayer.play("idle")
	
func alarm() -> void:
	$AnimationPlayer.reset_section()
	$AnimationPlayer.play("alarm")

func get_animation_player() -> AnimationPlayer:
	return $AnimationPlayer
	


func play_fs_triangle_l() ->void:
	AudioManager.play_random(
		[
			"sfx_fs_triangle_01",
			"sfx_fs_triangle_02",
			"sfx_fs_triangle_03",
			"sfx_fs_triangle_04"
		],
		-2.0,
		Vector2(0.93, 1.07),
		Vector2.ZERO
	)
	
func play_fs_triangle_r() ->void:
	AudioManager.play_random(
		[
			"sfx_fs_triangle_05",
			"sfx_fs_triangle_06",
			"sfx_fs_triangle_07",
			"sfx_fs_triangle_08"
		],
		-2.0,
		Vector2(0.93, 1.07),
		Vector2.ZERO
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
		Vector2.ZERO
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
		Vector2.ZERO
	)
	
func play_fs_circle() ->void:
	AudioManager.play_random(
		[
			"sfx_fs_circle_01",
			"sfx_fs_circle_02",
			"sfx_fs_circle_03",
			"sfx_fs_circle_04"
		],
		-2.0,
		Vector2(0.93, 1.07),
		Vector2.ZERO
	)
func play_circle_alarm() -> void:
	AudioManager.play_sfx("sfx_circle_alarm")
	
func play_square_alarm() -> void:
	AudioManager.play_sfx("sfx_square_alarm")
	
func play_triangle_alarm() -> void:
	AudioManager.play_sfx("sfx_triangle_alarm")
