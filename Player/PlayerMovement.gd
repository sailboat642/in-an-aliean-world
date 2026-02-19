extends Node2D

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
	
func load_lifeform(lifeform_data: LifeForm) -> void:
	# 1. Create the new instance from your Resource
	var new_form = lifeform_data.form_behaviour.instantiate()
	current_lifeform_data = lifeform_data
	# 2. Remove the OLD node from the scene
	# We use lifeform_type because it currently points to the $PlayerForm node
	if lifeform_type and lifeform_type.get_parent():
		var parent = lifeform_type.get_parent()
		parent.remove_child(lifeform_type)
		lifeform_type.queue_free() # Delete the old one to save memory
	
	# 3. Add the NEW node to the scene
	# Since your script is on the Player, we add it as a child here
	add_child(new_form)
	
	# 4. Update the reference so your _process functions control the new node
	lifeform_type = new_form
	
	# Optional: Match the name so $PlayerForm calls don't break elsewhere
	new_form.name = "PlayerForm"
	
	print("Transformed into new lifeform!")
	
func get_lifeform_data():
	return current_lifeform_data

func set_lifeform_data(lifeform_data: LifeForm):
	current_lifeform_data = lifeform_data
