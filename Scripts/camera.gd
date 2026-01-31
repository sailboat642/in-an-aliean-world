extends Camera2D

@export var zoom_speed := 3.0
@export var target_zoom := Vector2.ONE

var is_zooming := false

func _process(delta):
	if is_zooming:
		zoom = zoom.lerp(target_zoom, zoom_speed * delta)

func zoom_in(new_zoom: Vector2):
	target_zoom = new_zoom
	is_zooming = true
