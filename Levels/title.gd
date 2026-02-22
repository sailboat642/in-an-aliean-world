extends Control

@export var level_one: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stream = AudioManager.play_music("mx_menu")



func _on_play_pressed() -> void:
	SceneManager.switch_scene("res://Levels/StartScene/walk.tscn")
	

func _on_controls_pressed() -> void:
	#show controls
	pass
