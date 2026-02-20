extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.stop_all_audio()
	
	var music = AudioManager.play_music("mx_gameplay", -3.0)
	#AudioManager.set_loop(music, true)
	
	var amb_forest = AudioManager.play_env("sfx_amb_forest", 0)
	#AudioManager.set_loop(amb_forest, true)
	
