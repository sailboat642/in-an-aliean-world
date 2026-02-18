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
	
func play_fs(sound_name: String) -> void:
	AudioManager.play_sfx(sound_name)
	
#func play_fs(sound_name: String) -> void:
	#AudioManager.play_sfx(sound_name)
