extends CanvasLayer

var is_paused = false

func  _ready() -> void:
	self.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		TogglePause()
		
func TogglePause():
	is_paused = not is_paused
	get_tree().paused = is_paused
	self.visible = is_paused

func _on_restart_pressed() -> void:
	get_tree().paused = false 
	get_tree().reload_current_scene()


func _on_resume_pressed() -> void:
	self.visible = false
	is_paused = false
	get_tree().paused = false
	

func _on_quit_pressed() -> void:
	get_tree().quit()
