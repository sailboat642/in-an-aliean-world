extends Area2D

var pulse_tween: Tween
@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	start_pulse_animation()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print("You have Completed The Objective!")
		get_tree().paused = true
	pass # Replace with function body.

func start_pulse_animation():
	# Create a tween that loops infinitely
	pulse_tween = create_tween().set_loops()
	
	# 1. Scale up slightly over 0.6 seconds
	pulse_tween.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.6).set_trans(Tween.TRANS_SINE)
	
	# 2. Scale back down to original size
	pulse_tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.6).set_trans(Tween.TRANS_SINE)
