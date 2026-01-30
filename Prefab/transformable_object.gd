extends Area2D

@onready var object_sprite: Sprite2D = $Sprite2D

var player_in_range := false
var player_ref: PathFollow2D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		player_ref = body

func _on_body_exited(body):
	if body == player_ref:
		player_in_range = false
		player_ref = null

func _input_event(viewport, event, shape_idx):
	if not player_in_range:
		return
	
	if event is InputEventMouseButton and event.pressed:
		player_ref.transform2D(
			object_sprite.texture,
			object_sprite.scale
		)
