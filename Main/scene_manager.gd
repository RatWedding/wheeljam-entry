extends Node
var current_scene: int= -1

func _ready():
	change_scene(0)
func change_scene(scene_id):
	exit_scene(current_scene)
	current_scene = scene_id
	enter_scene(scene_id)
	
func enter_scene(scene_id):
	match scene_id:
		0:#add stuff
			var main_menu = load("uid://ckswpyc7lks0n") #main menu uid
			
			get_tree().get_root().get_child(-1).get_child(1).add_child(main_menu.instantiate())
		1: # starts level
			get_tree().get_root().get_child(-1).get_child(0).find_child("Wheel").set_deferred("visible", true)
			get_tree().get_root().get_child(-1).get_child(0).find_child("Wheel").reset()
			get_tree().get_root().get_child(-1).get_child(0).find_child("WheelJamHero").set_deferred("visible", true)

			#makes wheel and player visible as well as start the wheel
			
func exit_scene(scene_id):
	match scene_id:#clear stuff
		0:
			get_tree().get_root().get_child(-1).get_child(1).get_child(-1).queue_free()
			#get root, getchild-1 is main, 1 is UI holder, -1 is mainmenu removes main menu
		1:
			pass

#func level_process(level):
	#print(level % 5)
	#match (level % 5):
		#0: #level 0,5, etc
			#var enemy_holder = get_tree().get_root().get_child(-1).get_child(2)
			#var enemy_1 = load("uid://3jnhd5p0dc3x") #uid for enemy 1
			#var enemies = [enemy_1.instantiate()]
			#for i in enemies.size():
				#for j in 4:
					#if enemy_holder.get_child(j).get_child_count() < 1:
						#enemy_holder.get_child(j).add_child(enemies[i]) #this should add a child to every spawnpoint
