extends Node2D

@export var speed := 200.0
var path_follow: PathFollow2D = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D

var original_texture: Texture2D
var original_scale: Vector2

var can_transform := false
var target_sprite: Sprite2D = null

var can_move := true

# Pre-filled transformations
var transformations = [
	{
		"name": "Alien",
		"texture": preload("res://Sprites/Alien.png"),
		"scale": Vector2(0.5, 0.5)
	},
	{
		"name": "Steel",
		"texture": preload("res://Sprites/Branch.png"),
		"scale": Vector2(1.2, 1.2)
	},
	{
		"name": "Moving",
		"texture": preload("res://Sprites/Tree.png"),
		"scale": Vector2(1.5, 1.5)
	}
]

var current_index := 0

func set_path_follow(pf: PathFollow2D):
	path_follow = pf

func _process(delta):
	if path_follow == null:
		print ("No path")
		return

	if (Input.is_action_pressed("ui_right") and can_move):
		path_follow.progress += delta * speed
	if (Input.is_action_pressed("ui_left") and can_move):
		path_follow.progress -= delta * speed
		
	if can_transform and Input.is_action_just_pressed("transform") and not can_move:
		transform_into_target()
		unlock_movement()
		camera.zoom_in(Vector2.ONE)

	if Input.is_action_just_pressed("revert"):
		revert()	
		
	if Input.is_action_just_pressed("slot_1"):
		apply_transformation(0)
	elif Input.is_action_just_pressed("slot_2"):
		apply_transformation(1)
	elif Input.is_action_just_pressed("slot_3"):
		apply_transformation(2)
	elif Input.is_action_just_pressed("slot_0"):
		reset_to_original()
		
func _ready():
	original_texture = sprite.texture
	original_scale = self.scale

func set_transform_target(obj_sprite: Sprite2D):
	can_transform = true
	target_sprite = obj_sprite

func clear_transform_target():
	can_transform = false
	target_sprite = null

func transform_into_target():
	if target_sprite == null:
		return
	
	sprite.texture = target_sprite.texture
	sprite.scale = target_sprite.scale

func revert():
	sprite.texture = original_texture
	sprite.scale = original_scale
	
func lock_movement():
	can_move = false
	print("Player locked")

func unlock_movement():
	can_move = true
	print("Player unlocked")
	
func apply_transformation(index: int):
	current_index = index
	sprite.texture = transformations[index]["texture"]
	self.scale = transformations[index]["scale"]
	print("Transformed into", transformations[index]["name"])
	
func reset_to_original():
	sprite.texture = original_texture
	self.scale = original_scale
	print("Returned to original form")
