extends Area2D

@export var nextLevel: String

func _on_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file", nextLevel)
