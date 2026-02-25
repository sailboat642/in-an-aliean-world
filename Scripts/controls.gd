extends Control


func _ready() -> void:
	var stream = AudioManager.play_music("mx_menu")
	$Button.grab_focus()



func _on_play_pressed() -> void:
	SceneManager.switch_scene("res://Levels/title_screen.tscn")
