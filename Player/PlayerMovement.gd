extends Node2D

@export var speed := 200.0
@export var path_follow: PathFollow2D = null

@onready var player_graphics = $PlayerGraphics
@onready var camera: Camera2D = $Camera2D

var original_texture: Texture2D
var original_scale: Vector2

var can_transform := false
var target_sprite: Sprite2D = null

var can_move := true

func set_path_follow(pf: PathFollow2D):
	path_follow = pf

func _process(delta):
	if path_follow == null:
		print ("No path")
		return

	if (Input.is_action_pressed("move_right") and can_move):
		player_graphics.scale.x = abs(scale.x)
		player_graphics.walk()
		
		path_follow.progress += delta * speed
	if (Input.is_action_pressed("move_left") and can_move):
		player_graphics.scale.x = -abs(scale.x)
		player_graphics.walk()
		path_follow.progress -= delta * speed
		
	if can_transform and Input.is_action_just_pressed("transform") and not can_move:
		#transform_into_target()
		#unlock_movement()
		camera.zoom_in(Vector2.ONE)
		
	if not Input.is_anything_pressed():
		player_graphics.idle()

	#if Input.is_action_just_pressed("revert"):
		#revert()	
		
#func _ready():
	#original_texture = sprite.texture
	#original_scale = sprite.scale
#
#func set_transform_target(obj_sprite: Sprite2D):
	#can_transform = true
	#target_sprite = obj_sprite
#
#func clear_transform_target():
	#can_transform = false
	#target_sprite = null
#
#func transform_into_target():
	#if target_sprite == null:
		#return
	#
	#sprite.texture = target_sprite.texture
	#sprite.scale = target_sprite.scale
#
#func revert():
	#sprite.texture = original_texture
	#sprite.scale = original_scale
	#
#func lock_movement():
	#can_move = false
	#print("Player locked")
#
#func unlock_movement():
	#can_move = true
	#print("Player unlocked")
