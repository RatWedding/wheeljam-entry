extends Node
var current_scene: int


func change_scene(scene_id):
	match scene_id:
		0:
			exit_scene(current_scene)
			current_scene = scene_id
			enter_scene(scene_id)
	
func enter_scene(scene_id):
	match scene_id:
		0:
			pass
			#add stuff
func exit_scene(scene_id):
	match scene_id:
		0:
			pass
			#clear stuff
