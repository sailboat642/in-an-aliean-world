extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

#func _ready():
	#area_entered.connect(_on_area_entered)
	#area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
	var player = area.get_parent()
	if player.is_in_group("player"):
		player.set_transform_target(sprite)
		#sprite.modulate = Color(1, 1, 0.6) # highlight

func _on_area_exited(area: Area2D):
	var player = area.get_parent()
	if player.is_in_group("player"):
		player.clear_transform_target()
		#sprite.modulate = Color.WHITE
