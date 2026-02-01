extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stream = AudioManager.play_music("mx_tutorial")
	AudioManager.set_loop(stream, true)
	
