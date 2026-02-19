extends Area2D

@export var lifeform_data:LifeForm 
# this variable controls the graphics and animations
@onready var behaviour = $AlienPreyBehaviour
@onready var path_follow: PathFollow2D = get_parent() as PathFollow2D
@onready var detectable_area: Area2D = $DetectableArea

# Movement
@export var speed: float = 300.0
@export var idle_time: float = 5.0
@export var stop_stations: Array[float]= [0.0, 1.0]

enum State {PATROL, CHASE, FLEE, DEAD}
var current_state: State = State.PATROL
var target_node: Node2D = null

# PATROL var
var moving_forward: bool = true
var is_waiting: bool = false
var current_station_idx: int = 0

# Alien Response System
@export var disposition_table: Dictionary[LifeForm.Species, LifeForm.Action] = {
	LifeForm.Species.PLAYER	: LifeForm.Action.ALL,
	LifeForm.Species.ALIEN_PREY: LifeForm.Action.ALARM,
	LifeForm.Species.ALIEN_PREDATOR: LifeForm.Action.ALARM
}


func _ready() -> void:
	if not path_follow:
		print("Npc does not have path follow parent")
		return
		
	stop_stations.sort()
	path_follow.rotates = false
	path_follow.loop = false

func _process(delta: float) -> void:
	match current_state:
		State.PATROL:
			_process_patrol(delta)
		State.CHASE:
			_process_chase(delta)
		State.FLEE:
			_process_flee(delta)

func _process_patrol(delta: float) -> void:
	if is_waiting or not path_follow: return

	if stop_stations.size() < 1:
		print("stop stations not defined")
		return

	# 1. Determine target station
	var target_ratio = stop_stations[current_station_idx]
	
	# 2. Move toward the station ratio
	path_follow.progress_ratio = move_toward(path_follow.progress_ratio, target_ratio, (speed / get_path_length()) * delta)
	behaviour.walk()

	# 3. Update Facing based on Path Slope (Tangent)
	_update_facing_via_tangent()

	# 4. Check for arrival
	if abs(path_follow.progress_ratio - target_ratio) < 0.001:
		start_idle_timer()

func start_idle_timer() -> void:
	is_waiting = true
	behaviour.idle()
	
	
	await get_tree().create_timer(idle_time).timeout
	
	# Switch direction and start moving again
	current_station_idx = (current_station_idx + 1) % stop_stations.size()
	is_waiting = false

	
func get_lifeform_data()->LifeForm:
	return lifeform_data
	



func _update_facing_via_tangent():
	var curve = path_follow.get_parent().curve
	var current_offset = path_follow.progress
	
	# We look a tiny bit ahead (1 pixel) to see where the path is going
	var look_ahead_offset = current_offset + 1.0
	
	# If we are at the very end of the path, look backward instead
	if look_ahead_offset > get_path_length():
		look_ahead_offset = current_offset - 1.0
		
	var current_pos = curve.sample_baked(current_offset)
	var next_pos = curve.sample_baked(look_ahead_offset)
	
	# Calculate the horizontal difference in world space
	var diff_x = next_pos.x - current_pos.x
	
	# If we are moving 'backwards' along the path index, flip the logic
	var target_ratio = stop_stations[current_station_idx]
	if target_ratio < path_follow.progress_ratio:
		diff_x *= -1

	if diff_x > 0:
		scale.x = abs(scale.x) # Face Right
	elif diff_x < 0:
		scale.x = -abs(scale.x) # Face Left



func get_path_length() -> float:
	return path_follow.get_parent().curve.get_baked_length()
	
func on_area_entered_fov(area):
	if area.is_in_group("aliens"):
		print("lifeform detected")
		var lifeform_data = area.get_lifeform_data()
		react(area, lifeform_data.form_name, LifeForm.Action.ALL)
		
	if area.is_in_group("player"):	
		print("player detected")
		var player_formdata = area.get_lifeform_data() as LifeForm
		react(area, player_formdata.form_name, LifeForm.Action.ALL)
		

func react(character, species: LifeForm.Species, action: LifeForm.Action):
	if disposition_table.has(species):
		if disposition_table[species] == action:
			flee(character)
			return
	print("seems okay")


func flee(antagonizer: Node2D) -> void:
	if current_state == State.FLEE: return
	
	target_node = antagonizer
	current_state = State.FLEE
	behaviour.alarm() # Trigger animation [cite: 2]
	
	# Emit signal with name for the UI/Log
	# behaviour.action_performed.emit(LifeForm.Action.ALARM, lifeform_data.form_name)
	
	# Wait 6 seconds, then vanish
	await get_tree().create_timer(6.0).timeout
	queue_free()

func _process_flee(delta: float) -> void:
	if not target_node: return
	
	# Calculate direction away from target
	var dir = (global_position - target_node.global_position).normalized()
	global_position = Vector2(global_position.x + dir.x * (speed * 1.5) * delta, global_position.y) # Run faster than walk speed
	
	# Update Facing
	scale.x = abs(scale.x) if dir.x > 0 else -abs(scale.x)

func chase(target: Node2D) -> void:
	target_node = target
	current_state = State.CHASE
	behaviour.alarm() # Or a specific ACTION_A for aggressive [cite: 2]

func _process_chase(delta: float) -> void:
	if not target_node: return
	
	var dir = (target_node.global_position - global_position).normalized()
	global_position += dir * speed * delta
	
	# Update Facing
	scale.x = abs(scale.x) if dir.x > 0 else -abs(scale.x)
	
	# Check for 'Lose' condition (Simple distance check or use a hit Area2D)
	if global_position.distance_to(target_node.global_position) < 20.0:
		handle_player_loss()

func handle_player_loss():
	current_state = State.DEAD
	print("Game Over: Caught by ", LifeForm.Species.find_key(lifeform_data.form_name))
	# SceneTree.change_scene_to_file("res://game_over.tscn")

func on_area_exited_fov(area):
	if area.is_in_group("aliens"):
		print("lifeform lost")
	if area.is_in_group("player"):
		print("player lost")
	pass
