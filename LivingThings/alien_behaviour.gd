extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle()
	
# tell if it is moving up or down the
func walk() -> void:
	$AnimationPlayer.play("walk")
	
func idle() -> void:
	play_safe("idle")
	
func alarm() -> void:
	play_safe("alarm")

# Inside alien_behaviour.gd
func play_safe(anim_name: String):
	# Snap everything to rest pose first
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.advance(0) # Force the reset to apply immediately
	$AnimationPlayer.play(anim_name)

func get_animation_player() -> AnimationPlayer:
	return $AnimationPlayer
	
func play_fs(sound_name: String) -> void:
	AudioManager.play_sfx(sound_name)
	
#func play_fs(sound_name: String) -> void:
	#AudioManager.play_sfx(sound_name)
