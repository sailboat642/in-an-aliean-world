extends Control

@export var level_one: PackedScene

func _ready() -> void:
	var stream = AudioManager.play_music("mx_menu")
	$VBoxContainer/Button.grab_focus()



func _on_play_pressed() -> void:
	SceneManager.switch_scene("res://Levels/StartScene/walk.tscn")
	

func _on_controls_pressed() -> void:
	SceneManager.switch_scene("res://Levels/controls.tscn")
	pass
