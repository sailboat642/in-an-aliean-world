extends Area2D

@onready var anim_player = $AnimationPlayer
@export var zoom := .2
var camera
var is_hiding = false
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_2d()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("revert"):
		if player:
			toggle_hide(player)
		else:
			for area in get_overlapping_areas():
				if area.is_in_group("player"):
					toggle_hide(area)
		
func on_hide():
	anim_player.play("default")
	

func toggle_hide(player):
	
	is_hiding = not is_hiding
	if is_hiding:
		camera.zoom_in(Vector2(0.2, 0.2))
	else:
		camera.zoom_in(Vector2(0.4, 0.4))
	anim_player.play("default")
	player.hide_player()
