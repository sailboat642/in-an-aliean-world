extends Node2D

@export var speed := 200.0
var path_follow: PathFollow2D = null

func set_path_follow(pf: PathFollow2D):
	path_follow = pf

func _process(delta):
	if path_follow == null:
		print ("No path")
		return

	if (Input.is_action_pressed("ui_right")):
		path_follow.progress += delta * speed
	if (Input.is_action_pressed("ui_left")):
		path_follow.progress -= delta * speed
