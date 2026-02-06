extends Node2D

# Setup
@export var detection_area: Area2D
@onready var Player = $".."
@export var charge_texture: Texture

# detection UI
@onready var detection_vbox = $MaskUI/Control/DetectionUI/Vbox/VBoxContainer
@export var detection_icon_scene: PackedScene
var save_focus_index: int = 0
@onready var world_arrow = $WorldArrow

# resource UI
@onready var stored_forms_box = $MaskUI/Control/PrimaryUi/Hbox/control/LifForms
@onready var charges_box = $MaskUI/Control/PrimaryUi/Hbox/control/Charges

@export var max_charges: int = 3
var charges: int
@export var player_lifeform_data: LifeForm
@export var max_slots: int = 1 # This can be upgraded later to 3+
var stored_forms: Array[LifeForm] = []

var aliens_detected: Array[LifeForm] = []
var detected_areas: Array[Area2D] = []

var is_player_disguised = false


func _ready():
	charges = max_charges
	update_ui()

func _process(delta)->void:
	update_world_arrow()
	world_arrow.position.y += sin(Time.get_ticks_msec() * 0.01) * 0.5
	
	if (Input.is_action_just_pressed("transform") and not is_player_disguised):
		if (charges > 0):
			load_lifeform(stored_forms[0])
			is_player_disguised = true
			charges -= 1
			_update_resource_ui()
		
	elif (Input.is_action_just_pressed("revert") and is_player_disguised):
		load_lifeform(player_lifeform_data)
		is_player_disguised = false
		
	if aliens_detected.is_empty():
		return

	# Iterate through the list with Space
	if Input.is_action_just_pressed("choose_primary"): # "Space" by default
		save_focus_index = (save_focus_index + 1) % aliens_detected.size()
		_update_detection_ui()

	# Lock in the form with Enter
	if Input.is_action_just_pressed("save_form"): # "Enter" by default
		store_new_form(aliens_detected[save_focus_index])
	
	
func load_lifeform(lifeform_data: LifeForm) -> void:
	var new_form = lifeform_data.form_behaviour.instantiate()
	
	if Player.lifeform_type and Player:
		Player.remove_child(Player.lifeform_type)
		Player.lifeform_type.queue_free() 
		
	Player.add_child(new_form)
	Player.lifeform_type = new_form
	
	# Optional: Match the name so $PlayerForm calls don't break elsewhere
	new_form.name = "PlayerForm"
	
	print("Transformed into new lifeform!")


func update_ui():
	_update_detection_ui()
	_update_resource_ui()
	pass
	
func _update_detection_ui() -> void:
	var container = detection_vbox
	# 1. Clear existing icons
	for child in container.get_children():
		child.queue_free()
	
	# 2. Add new icons based on current count
	for i in range(aliens_detected.size()):
		var icon = detection_icon_scene.instantiate()
		icon.get_node("HBoxContainer/IconTexture").texture = aliens_detected[i].UI_Icon
		if save_focus_index == i:
			icon.get_node("HBoxContainer/SelectorArrow").visible = true
		container.add_child(icon)
		
func _update_resource_ui() -> void:
	var container = stored_forms_box
	# 1. Clear existing icons
	for child in container.get_children():
		child.queue_free()
	
	# 2. Add new icons based on current count
	for form in stored_forms:
		var icon = TextureRect.new()
		icon.texture = form.UI_Icon
		# Set expand mode so icons don't look stretched or huge
		icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE 
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		container.add_child(icon)
	
	var charge_container = charges_box
	# 1. Clear existing icons
	for child in charge_container.get_children():
		child.queue_free()
	
	# 2. Add new icons based on current count
	for i in range(charges):
		var icon = TextureRect.new()
		icon.texture = charge_texture
		# Set expand mode so icons don't look stretched or huge
		icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE 
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		container.add_child(icon)




func update_world_arrow():
	if aliens_detected.is_empty():
		world_arrow.visible = false
		return
	
	world_arrow.visible = true
	# We need the Area2D reference to know where the alien is in the world
	var target_area = detected_areas[save_focus_index]
	
	# Position the arrow slightly above the alien
	world_arrow.global_position = target_area.global_position + Vector2(0, -600)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("aliens") and not detected_areas.has(area):
		# 1. Store the area so we can track it
		detected_areas.push_back(area)
		
		# 2. Get the data (assuming your Alien Area has a get_lifeform_data method)
		var data = area.get_lifeform_data()
		aliens_detected.push_back(data)
		
		update_ui()

func _on_area_2d_area_exited(area: Area2D) -> void:
	# Find where this specific area is in our tracking list
	var index = detected_areas.find(area)
	
	if index != -1:
		# Remove from both lists using the same index
		if save_focus_index >= index and save_focus_index > 0:
			save_focus_index -= 1
		detected_areas.remove_at(index)
		aliens_detected.remove_at(index)
		
		update_ui()

func store_new_form(new_data: LifeForm):
	# 1. Add the new form to the end of the list
	stored_forms.append(new_data)
	
	# 2. Check if we've exceeded our current mask capacity
	while stored_forms.size() > max_slots:
		# Remove the oldest form (the one at index 0)
		stored_forms.pop_front()
		
	
	_update_resource_ui()
	print("Forms currently in mask: ", stored_forms.size())
