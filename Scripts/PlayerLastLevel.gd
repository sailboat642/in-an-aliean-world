extends Node2D

@export var speed := 200.0
var path_follow: PathFollow2D = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var camera: Camera2D = $Camera2D

var original_texture: Texture2D
var original_scale: Vector2

var base_texture_size: Vector2
var base_scale: Vector2
var base_offset: Vector2

var can_transform := false
var target_sprite: Sprite2D = null

var can_move := true

# Pre-filled transformations
#@onready var player_sprite: Sprite2D = $Sprite2D
@onready var slots := [
	$SlotLibrary/Slot_Alien,
	$SlotLibrary/Slot_Steel,
	$SlotLibrary/Slot_Random
]

var current_slot := -1

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
		
	if Input.is_action_pressed("slot_1"):
		transform_to_slot(0)

	elif Input.is_action_pressed("slot_2"):
		transform_to_slot(1)

	elif Input.is_action_pressed("slot_3"):
		transform_to_slot(2)
	elif Input.is_action_just_pressed("slot_0"):
		reset_to_original()
		
func _ready():
	original_texture = sprite.texture
	original_scale = self.scale
	base_texture_size = sprite.texture.get_size()
	base_scale = sprite.scale
	base_offset = sprite.offset

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
	
func transform_to_slot(slot_index: int):
	if slot_index < 0 or slot_index >= slots.size():
		return

	var slot_sprite: Sprite2D = slots[slot_index]
	
	# RESET FIRST (THIS IS THE KEY)
	sprite.scale = base_scale
	sprite.offset = base_offset

	sprite.texture = slot_sprite.texture
	sprite.offset = slot_sprite.offset
	sprite.scale = slot_sprite.scale
	sprite.rotation = slot_sprite.rotation
	sprite.flip_h = slot_sprite.flip_h
	sprite.flip_v = slot_sprite.flip_v
	sprite.centered = slot_sprite.centered
	
	# ---- SIZE MATCHING PART ----
	var new_size = slot_sprite.texture.get_size()

	var scale_x = (base_texture_size.x * base_scale.x) / new_size.x
	var scale_y = (base_texture_size.y * base_scale.y) / new_size.y

	sprite.scale = Vector2(scale_x, scale_y)
	
func reset_to_original():
	sprite.texture = original_texture
	self.scale = original_scale
	sprite.offset = base_offset
	print("Returned to original form")
