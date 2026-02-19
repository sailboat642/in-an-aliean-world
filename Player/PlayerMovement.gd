extends Area2D

@export var speed := 200.0
@export var path_follow: PathFollow2D = null

@onready var lifeform_type = $PlayerForm
@onready var camera: Camera2D = $Camera2D
@onready var Mask: Node2D = $Mask
@export var current_lifeform_data: LifeForm

var original_texture: Texture2D
var original_scale: Vector2

var can_move := true

func set_path_follow(pf: PathFollow2D):
	path_follow = pf

func _process(delta):
	if path_follow == null:
		print ("No path")
		return

	if (Input.is_action_pressed("move_right") and can_move):
		lifeform_type.scale.x = abs(scale.x)
		lifeform_type.walk()
		path_follow.progress += delta * speed
		return
		
	if (Input.is_action_pressed("move_left") and can_move):
		lifeform_type.scale.x = -abs(scale.x)
		lifeform_type.walk()
		path_follow.progress -= delta * speed
		return
		
	
	
	lifeform_type.idle()
	
	
func get_lifeform_data():
	return current_lifeform_data

func set_lifeform_data(lifeform_data: LifeForm):
	current_lifeform_data = lifeform_data

func hide_player():
	print("hiding player")
	can_move = not can_move
	monitorable = not monitorable
	visible = not visible

	
	
