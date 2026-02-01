extends Area2D

@export var zoom_value := Vector2(2, 2)

@onready var camera := get_viewport().get_camera_2d()
@onready var popUp = $"../PopUp"
@export var can_move = true

var used := false

func _on_area_entered(area: Area2D):
	if used:
		return

	var player = area.get_parent()
	if not player.is_in_group("player"):
		return

	used = true
	camera.zoom_in(zoom_value)
	
	if !can_move:
		popUp.show()
		player.lock_movement()


func _on_area_exited(area: Area2D) -> void:
	popUp.hide()
	await get_tree().create_timer(2.0).timeout
	camera.zoom_in(Vector2.ONE)
