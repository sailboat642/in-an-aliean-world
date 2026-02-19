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
	if is_waiting or not path_follow:
		return

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
		area.get_lifeform_data()
		
	if area.is_in_group("player"):
		print("player detected")
		var player_formdata = area.get_lifeform_data()
		if (player_formdata.form_name == LifeForm.Species.PLAYER):
			behaviour.alarm()
			print("That is susupicious")
		else:
			print("Hmm..seems okay!")

func react(species, action):
	# if species in table
	# species.get action
	# if or species action All
		#flee
	# else if species action pair matches
		# flee
	pass

func flee():
	behaviour.alarm()
	# point away from antagonist
	# run for 6 seconds
	# destroy
	pass
	
func chase():
	pass

func on_area_exited_fov(area):
	if area.is_in_group("aliens"):
		print("lifeform lost")
	if area.is_in_group("player"):
		print("player lost")
	pass
