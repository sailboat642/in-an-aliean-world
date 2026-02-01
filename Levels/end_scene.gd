extends Control


@export var home_scene: PackedScene

func _on_home_pressed() -> void:
	get_tree().change_scene_to_packed(home_scene)
