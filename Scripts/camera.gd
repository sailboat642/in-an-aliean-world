extends Camera2D

@export var zoom_speed := 3.0
@export var target_zoom := Vector2.ONE

@export var target: Node2D
var is_zooming := false

func _process(delta):
	if is_zooming:
		zoom = zoom.lerp(target_zoom, zoom_speed * delta)
		
	if target: 
		global_position = target.global_position

func zoom_in(new_zoom: Vector2):
	target_zoom = new_zoom
	is_zooming = true

func set_target(new_target):
	target = new_target
