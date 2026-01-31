extends PathFollow2D

var speed = 90

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("ui_right")):
		progress += delta * speed
	if (Input.is_action_pressed("ui_left")):
		progress -= delta * speed
		
