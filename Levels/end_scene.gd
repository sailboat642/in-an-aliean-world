extends Control


@export var home_scene: PackedScene

func _on_home_pressed() -> void:
	SceneManager.switch_scene("res://Levels/title_screen.tscn")
