extends CanvasLayer

var pause_toggle = false

func  _ready() -> void:
	self.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Pause_and_Unpause()
		
func Pause_and_Unpause():
	pause_toggle = !pause_toggle
	get_tree().paused = pause_toggle
	self.visible = pause_toggle

func _on_restart_pressed() -> void:
	get_tree().paused = false 
	get_tree().reload_current_scene()


func _on_resume_pressed() -> void:
	pause_toggle = !pause_toggle
	get_tree().paused = pause_toggle
	self.visible = pause_toggle

func _on_quit_pressed() -> void:
	get_tree().quit()
