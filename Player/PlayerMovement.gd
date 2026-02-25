extends Area2D

@export var speed := 200.0
@export var path_follow: PathFollow2D = null

@onready var lifeform_type = $PlayerForm
@onready var camera: Camera2D = $Camera2D
@onready var Mask: Node2D = $Mask
@export var current_lifeform_data: LifeForm

var original_texture: Texture2D
var original_scale: Vector2

var is_performing_action := false

func set_path_follow(pf: PathFollow2D):
	path_follow = pf

func _process(delta):
	if path_follow == null:
		return
		
	if is_performing_action:
		return
	# 1. Check for Alarm first
	if Input.is_action_just_pressed("alarm"):
		trigger_alarm()
		return # STOP here so idle() isn't reached this frame


	if Input.is_action_pressed("move_right"):
		lifeform_type.scale.x = abs(scale.x)
		lifeform_type.walk()
		path_follow.progress += delta * speed
		return
		
	elif Input.is_action_pressed("move_left"):
		lifeform_type.scale.x = -abs(scale.x)
		lifeform_type.walk()
		path_follow.progress -= delta * speed
		return

	# 3. Only idle if we didn't return from any of the above
	lifeform_type.idle()

func trigger_alarm():
	is_performing_action = true
	lifeform_type.alarm()
	# Using a dedicated function makes the await cleaner
	await lifeform_type.get_animation_player().animation_finished
	is_performing_action = false
	
	
func get_lifeform_data():
	return current_lifeform_data

func set_lifeform_data(lifeform_data: LifeForm):
	current_lifeform_data = lifeform_data

func hide_player():
	print("hiding player")
	is_performing_action = not is_performing_action
	monitorable = not monitorable
	visible = not visible

	
	
