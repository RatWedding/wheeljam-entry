extends Node
var storyMode : bool
var level: int = 0
var player_health:int= 25
var max_health: int = 25
var level_complete = 0 #if it hits 5, level changes
var free_spins = 10
var max_spins = 10
var prestige = 0 #how many cycles were completed
signal dead
signal attack_over
signal player_attacked
#var current_scene:int = -1
func _ready():
	pass
	##change_scene(0)
#func change_scene(scene_id):
	#exit_scene(current_scene)
	#current_scene = scene_id
	#enter_scene(scene_id)
	#
#func enter_scene(scene_id):
	#match scene_id:
#
		#1: # starts level
			#get_tree().get_root().get_child(-1).get_child(0).find_child("Wheel").set_deferred("visible", true)
			#get_tree().get_root().get_child(-1).get_child(0).find_child("Wheel").reset()
			#get_tree().get_root().get_child(-1).get_child(0).find_child("WheelJamHero").set_deferred("visible", true)
			#level_process(0)
			##makes wheel and player visible as well as start the wheel
			#
#func exit_scene(scene_id):
	#match scene_id:#clear stuff
		#1:
			#pass
	prestige_cal()
func player_take_damage(num):
	player_health = clamp(player_health-num,0,max_health)
	emit_signal("player_attacked")
	if player_health == 0:
		emit_signal("dead")
		get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("uid://cbjc8sbpva7d1") #UID for main menu
func enemy_attack_over():
	emit_signal("attack_over")
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

func complete_check():
	if level_complete >= 5:
		next_level()
	else:
		pass
func next_level(): #keeps track of when it should change level
		level = level+1
		var next_level = (level%5)
		match next_level:
			0:
				prestige += 1
				prestige_cal()
				level_complete = 0
				level_complete = 4
				#player_health = clamp(player_health +(3*prestige), 0, max_health)
				get_tree().change_scene_to_file("uid://csr42cxjucp2s") #level 1 UID
				
			1:
				level_complete = 0
				level_complete = 3
				#player_health = clamp(player_health +(3*prestige), 0, max_health)
				get_tree().change_scene_to_file("uid://cqpitkkcbjncx") #level 2 UID
				
			2:
				level_complete = 0
				level_complete = 3
				#player_health = clamp(player_health +(3*prestige), 0, max_health)
				get_tree().change_scene_to_file("uid://d0e3n3ligb2vo") #level 3 UID
				
			3:
				level_complete = 0
				level_complete = 2
				#player_health = clamp(player_health +(3*prestige), 0, max_health)
				get_tree().change_scene_to_file("uid://bu6o4wm4p4hm5") #level  4UID
				
			4:
				level_complete = 0
				
				level_complete = 0
				
				
				get_tree().change_scene_to_file("uid://dnptvkgqfrb65") #level 5 UID
func reset_var():
	level = 0
	player_health = 25
	max_health = 25
	level_complete = 0 #if it hits 5, level changes
	free_spins = 10
	max_spins = 10
	prestige = 0
func prestige_cal():
	max_health = max_health + (prestige * 3)
	player_health = max_health
	max_spins += (prestige * 5)
	free_spins = max_spins
	
	
	
