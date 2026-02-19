extends Area2D

@onready var anim_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("revert"):
		for area in get_overlapping_areas():
			if area.is_in_group("player"):
				anim_player.play("default")
				area.hide_player()
		
