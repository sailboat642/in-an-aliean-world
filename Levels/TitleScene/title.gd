extends Control

@export var level_one: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.stop_all_audio()
	AudioManager.play_music("mx_menu")
	#AudioManager.set_loop(stream, true)




func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(level_one)
