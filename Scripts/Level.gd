extends Node2D

@onready var player := $Path2D/PathFollow2D/Player
@onready var path_follow := $Path2D/PathFollow2D

func _ready():
	player.set_path_follow(path_follow)
