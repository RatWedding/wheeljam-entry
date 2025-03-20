extends Enemy

func _ready():
	health = (health + (LevelManager.prestige * 3)) * 3
	damage = damage + (LevelManager.prestige)
	hover()
	#add_child(model.instantiate())
	## connects the new dir chosen signal to a lambda function that plays the selector sound 
	var animation =  find_child("AnimationPlayer") # gets animation player. Getchild is used instead of accessing by unique name because we are going to swap out model
	animation.play("WizardIdle")
	
	wheel.new_dir_selected.connect(hover)
	## connects our new dir chosen signal to the update wheel value function
	wheel.new_dir_chosen.connect(update_wheel_value)
	wheel.clear_enemy_particles.connect(clear_hover_particles)
	timer.timeout.connect(enemy_attack)
	##wheel.puzzle_finished.connect(end_check) taken over by player,
	player.attack.connect(end_check)
