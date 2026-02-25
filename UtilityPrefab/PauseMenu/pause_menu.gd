extends CanvasLayer


func  _ready() -> void:
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	# Check if the action was JUST pressed (not held or released)
	if event.is_action_pressed("pause"):
		TogglePause()
		# This tells Godot "I'm done with this event, don't pass it to anyone else"
		get_viewport().set_input_as_handled()
		
func TogglePause():
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused
	if visible:
		$Control/VBoxContainer/Resume.grab_focus()

func _on_restart_pressed() -> void:
	get_tree().paused = false 
	get_tree().reload_current_scene()


func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false
	

func _on_quit_pressed() -> void:
	get_tree().quit()
