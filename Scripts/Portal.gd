extends Area2D

@export var next_path: Path2D
var used := false

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if used:
		return

	var player = area.get_parent()
	if not player.is_in_group("player"):
		return

	used = true
	set_deferred("monitoring", false)  # 🔑 STOP signal recursion

	var old_pf := player.get_parent()
	if old_pf is PathFollow2D:
		call_deferred("switch_path", player, old_pf)

func switch_path(player: Node2D, old_pf: PathFollow2D):
	old_pf.remove_child(player)

	var new_pf := PathFollow2D.new()
	new_pf.loop = false
	next_path.add_child(new_pf)

	new_pf.progress = 0
	new_pf.add_child(player)
	player.position = Vector2.ZERO

	player.set_path_follow(new_pf)
