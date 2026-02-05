extends Area2D

@export var next_scene: PackedScene

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") and Input.is_action_just_pressed("change_path"):
		get_tree().paused = true
		if next_scene == null:
			print("Warning: No scene assigned to exit gate!")
			return
		get_tree().change_scene_to_packed(next_scene)
