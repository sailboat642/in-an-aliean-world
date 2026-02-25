extends Area2D

@export var zone_zoom := Vector2(1.0, 1.0) # Slightly zoomed out to see more
@export var focus_target: Node2D            # If null, it stays on the player
@export var preview_target: Node2D
@export var return_zoom := Vector2(0.4, 0.4)

var camera

func _ready():
	# Find the camera similarly to your start_scene.gd logic [cite: 10]
	camera = get_viewport().get_camera_2d()
	area_entered.connect(_on_body_entered)
	area_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if focus_target and preview_target:
			body.lock_input()
			camera.zoom_speed = 2.0
			camera.zoom_in(Vector2(0.1, 0.1))
			await get_tree().create_timer(3.0).timeout
			camera.set_target(focus_target)
			await get_tree().create_timer(2.0).timeout
			camera.zoom_in(zone_zoom)
			body.unlock_input()
		else:
			# Fallback if only one target is defined
			camera.set_target(focus_target if focus_target else body)
			camera.zoom_in(zone_zoom)

func _on_body_exited(body):
	if body.is_in_group("player"):
		camera.set_target(body)             # Return focus to player 
		camera.zoom_in(return_zoom)         # Return to default zoom
