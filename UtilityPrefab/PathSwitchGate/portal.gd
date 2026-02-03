extends Area2D

@export var current_path: PathFollow2D
@export var next_path: PathFollow2D
var used := false

#func _ready():
	#area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if used:
		return
		
	if not area.is_in_group("player"):
		return
		
		print("switching path")
	used = true
	set_deferred("monitoring", false)  # 🔑 STOP signal recursion

	var old_pf := area.get_parent()
	if old_pf is PathFollow2D:
		call_deferred("switch_path", area, old_pf)

func switch_path(player: Area2D, old_pf: PathFollow2D):
	old_pf.remove_child(player)
	
	next_path.add_child(player)
	player.position = Vector2.ZERO

	player.set_path_follow(next_path)
