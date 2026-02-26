extends Control

@export_file("*.tscn") var level_one: String = "res://Levels/LandingScene/landing_site.tscn"

func _ready() -> void:
	var stream = AudioManager.play_music("mx_menu")
	$VBoxContainer/Button.grab_focus()



func _on_play_pressed() -> void:
	SceneManager.switch_scene(level_one)
	

func _on_controls_pressed() -> void:
	SceneManager.switch_scene("res://Levels/controls.tscn")
	pass
	
func _on_quit_pressed() -> void:
	get_tree().quit()
