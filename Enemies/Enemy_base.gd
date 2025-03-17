@tool class_name Enemy

extends Node3D  
@onready var wheel:Wheel = %Wheel #accesss as uynique name doesnt work when node is generated with code
@onready var player:Node3D = %WheelJamHero
var selector = wheel.find_child("selector")
 #variable for the selector, used in determining what state to show depedning on base values
@export var base_numbers:Array[int] = [-2,-1,1,2]
var total_value:int  #stores wheel values 
@export var select_sound:AudioStream = preload("uid://cxg4q58es2u77")
@export var hurt_sound:AudioStream = preload("uid://tij2t4x8snb7")
@export var heal_sound:AudioStream = preload("uid://dmrf2ma7j0uam")
@export var death_sound:AudioStream = preload("uid://bdohayyimsato")
@export var rotate_sound:AudioStream = preload("uid://c43qhby2kqxxj")
@export var health:int= 10
@export var max_health:int = 10 #max health
@export var damage:int = 1 # damage enemy would deal

@export var model:Resource = load("uid://bnw80nbdrql73") #model for character

func _ready():

	hover()
	add_child(model.instantiate())
	# connects the new dir chosen signal to a lambda function that plays the selector sound 
	var animation =  get_child(-1).find_child("AnimationPlayer") # gets animation player. Getchild is used instead of accessing by unique name because we are going to swap out model
	animation.play("WizardIdle")
	wheel.new_dir_selected.connect(func():if wheel.num_selections != wheel.target_selections: _play_sound(select_sound))
	wheel.new_dir_selected.connect(hover)
	# connects our new dir chosen signal to the update wheel value function
	wheel.new_dir_chosen.connect(update_wheel_value)
	# connects the dir confirmed signal to a lambda function that plays the confirm sound
	wheel.rotation_started.connect(func():_play_sound(rotate_sound))
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
	var animation =  get_child(-1).find_child("AnimationPlayer")


	health = clamp(health-total_value, 0, max_health)
	
	
	if health > 0:
		if total_value <= 0: 
			_play_sound(heal_sound)
			animation.play("WizardYay")
			await animation.animation_finished
			animation.play("WizardIdle")
		else:
			_play_sound(hurt_sound)
			animation.play("WizardOof")
			await animation.animation_finished
			animation.play("WizardIdle")
	else: #if its at 0 health it dies
		_play_sound(death_sound)
		animation.play("WizardOof")
		await animation.animation_finished
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
		match base_number_value:
			-2: #Resistance, bad for player
				$TempLabel.text = str("[center]","very bad", "[/center]") #replace with shader or whatever else. 
			-1: # resistance
				$TempLabel.text = str("[center]"," bad", "[/center]")
			1: #weakness, good for player
				$TempLabel.text = str("[center]"," good", "[/center]")
			2: #weakness
				$TempLabel.text = str("[center]"," very good", "[/center]")
