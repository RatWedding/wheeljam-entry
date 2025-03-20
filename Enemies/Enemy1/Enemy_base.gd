class_name Enemy
#TODO fix endcheck to play correct aniation and sound when dying or taking damage, await until animation finished and play idle
extends Node3D 
@onready var wheel:Wheel = %Wheel
@onready var player:Node3D = %WheelJamHero
@onready var selector = wheel.find_child("selector")
@onready var timer:Timer = %AttackTimer
@onready var a_particle:Resource = load("uid://cegm30aclphpc")
@onready var h_particle:Resource = load("uid://ch8kgkpikkhoa")
@onready var vg_particle:Resource = load("uid://bkf3e5h364swb")
@onready var g_particle:Resource = load("uid://impa43b3wf45")
@onready var vb_particle:Resource = load("uid://cxuee3dml8k1v")
@onready var b_particle:Resource = load("uid://77s7r22n77j1")
 #variable for the selector, used in determining what state to show depedning on base values
@export var base_numbers:Array[int] = [-2,-1,2,1]
var total_value:int  #stores wheel values 
var select_sound:AudioStream = preload("uid://cxg4q58es2u77")
var death_sound:AudioStream = preload("uid://bdohayyimsato")
var rotate_sound:AudioStream = preload("uid://c43qhby2kqxxj")
@export var health:int= 9
var max_health:int = 9 #max health
@export var damage:int = 1 # damage enemy would deal
signal attack_start
#@export var model: = load("uid://bnw80nbdrql73") #model for character
func _process(delta):
	$Label3D.text = str(health)
func _ready():
	health = health + (LevelManager.prestige * 3)
	damage = damage + (LevelManager.prestige)
	hover()
	#add_child(model.instantiate())
	# connects the new dir chosen signal to a lambda function that plays the selector sound 
	var animation =  find_child("AnimationPlayer") # gets animation player. Getchild is used instead of accessing by unique name because we are going to swap out model
	animation.play("WizardIdle")
	
	wheel.new_dir_selected.connect(hover)
	# connects our new dir chosen signal to the update wheel value function
	wheel.new_dir_chosen.connect(update_wheel_value)
	wheel.clear_enemy_particles.connect(clear_hover_particles)
	timer.timeout.connect(enemy_attack)
	#wheel.puzzle_finished.connect(end_check) taken over by player,
	player.attack.connect(end_check)
func _play_sound(sound:AudioStream)->void:
	randomize()
	var player = AudioStreamPlayer.new()
	player.stream = sound
	player.pitch_scale = randf_range(0.95,1.05)
	self.add_child(player)
	player.play()
	player.finished.connect(func():player.queue_free())
func update_wheel_value(wp): #does the math when value is confirmed 

	match wheel.current_direction:
		0:
			
			total_value += base_numbers[0] * wp.slice_value

		90:

			total_value += base_numbers[1] * wp.slice_value

		180:

			total_value += base_numbers[2] * wp.slice_value

		270:

			total_value += base_numbers[3] * wp.slice_value
func end_check(): #after the puzzle is finished it takes damage
	var animation =  find_child("AnimationPlayer")
	

	health = clamp(health-total_value, 0, max_health)
	
	
	if health > 0:
		if total_value <= 0: 
			var heal_particle = h_particle.instantiate() #sets up attack animation
			heal_particle.position = $ParticleSpawners.position
			heal_particle.rotation = $ParticleSpawners.rotation #makes sure the ring is horizontal and not on the ground
	
		 # await for signal part way through attack animation
	
			add_child(heal_particle) #adds the animation
			heal_particle.set_deferred("emitting",true) #makes it emit
			animation.play("WizardYay")
			await animation.animation_finished
			animation.play("WizardIdle")
			hover()
		else:
			animation.play("WizardOof")
			await animation.animation_finished
			animation.play("WizardIdle")
			hover()
	else: #if its at 0 health it dies
		timer.paused == true
		_play_sound(death_sound)
		animation.play("WizardOof")
		await get_tree().create_timer(.75).timeout
		LevelManager.level_complete +=1
		LevelManager.complete_check()
		queue_free() 
		
	
	
	total_value = 0  #resets total value between puzzles
	
func hover(): #system to show base values 
	match int(selector.rotation_degrees): #takes the selector degrees (0,90,180,270) a
		0: #if its hovering north
			base_value_check(base_numbers[0]) #show the weakness/resistance for north
		90: #if its hovering east
			base_value_check(base_numbers[1]) #show the weakness/resistance for east
		180: #south
			base_value_check(base_numbers[2])
		270: #west
			base_value_check(base_numbers[3])
func base_value_check(base_number_value): #function that does the visual change to demonstrate the base value
		if $ParticleSpawners.get_child_count() >0:
			for i in $ParticleSpawners.get_child_count():
				$ParticleSpawners.get_child(i).queue_free()
		match base_number_value:
			-2: #Resistance, bad for player
				$ParticleSpawners.add_child(vb_particle.instantiate())
			-1: # resistance
				$ParticleSpawners.add_child(b_particle.instantiate())
			1: #weakness, good for player
				$ParticleSpawners.add_child(g_particle.instantiate())
			2: #weakness
				$ParticleSpawners.add_child(vg_particle.instantiate())
func enemy_attack():
	clear_hover_particles()

	var animation =  find_child("AnimationPlayer")
	animation.play("WizardAttack")

	
	var attack_particle = a_particle.instantiate() #sets up attack animation
	attack_particle.position = $ParticleSpawners.position
	attack_particle.rotation = $ParticleSpawners.rotation #makes sure the ring is horizontal and not on the ground

	await attack_start # await for signal part way through attack animation
	
	add_child(attack_particle) #adds the animation
	attack_particle.set_deferred("emitting",true) #makes it emit
	await get_tree().create_timer(.4).timeout
	LevelManager.player_take_damage(damage)
	if LevelManager.player_health ==0:
		return
	await get_tree().create_timer(1.5).timeout
	
	LevelManager.enemy_attack_over()
	hover()
	timer.start()
func attack_starting():
	emit_signal("attack_start")
func clear_hover_particles():
	if $ParticleSpawners.get_child_count() >0:
		for i in $ParticleSpawners.get_child_count():
			$ParticleSpawners.get_child(i).queue_free()
