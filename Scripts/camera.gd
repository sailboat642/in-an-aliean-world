extends Camera2D

@export var zoom_speed := 2.0
@export var follow_speed := 5.0
@export var target_zoom := Vector2.ONE

@export var target: Node2D
var is_zooming := false

func _ready():
	zoom = Vector2(0.4, 0.4)

func _process(delta):
	if is_zooming:
		zoom = zoom.lerp(target_zoom, zoom_speed * delta)
		if zoom.distance_to(target_zoom) < 0.001:
			zoom = target_zoom
			is_zooming = false
		
	if target: 
		global_position = global_position.lerp(target.global_position, follow_speed * delta)

func zoom_in(new_zoom: Vector2):
	offset = offset * (zoom/new_zoom)
	target_zoom = new_zoom
	is_zooming = true

func set_target(new_target):
	target = new_target
