extends Control


@export var home_scene: PackedScene

func _ready():
	$Button.grab_focus()

func _on_home_pressed() -> void:
	SceneManager.switch_scene("res://Levels/title_screen.tscn")
