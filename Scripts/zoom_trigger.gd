extends Area2D

@export var zoom_value := Vector2(2, 2)

@onready var camera := get_viewport().get_camera_2d()

var used := false

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if used:
		return

	var player = area.get_parent()
	if not player.is_in_group("player"):
		return

	used = true
	camera.zoom_in(zoom_value)
	player.lock_movement()
