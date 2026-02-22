extends Node

# This function ensures the game is ALWAYS clean before switching
func switch_scene(target_scene_path: String):
	# 1. Unpause the engine so the next scene can actually run
	get_tree().paused = false
	
	# 2. Change the scene
	var error = get_tree().change_scene_to_file(target_scene_path)
	
	if error != OK:
		print("Error: Could not load scene at ", target_scene_path)

# If you prefer using PackedScenes:
func switch_to_packed(target_scene: PackedScene):
	get_tree().paused = false
	get_tree().change_scene_to_packed(target_scene)
