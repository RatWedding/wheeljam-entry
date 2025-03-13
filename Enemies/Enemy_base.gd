@tool class_name Enemy
extends Node2D 
@onready var wheel:Wheel = %Wheel
@onready var  selector:Control = wheel.find_child("selector") #variable for the selector, used in determining what state to show depedning on base values
@export var base_numbers:Array[int] = [-2,-1,1,2]
var total_value:int  #stores wheel values 
var select_sound:AudioStream = preload("uid://cxg4q58es2u77")
var rotate_sound:AudioStream = preload("uid://c43qhby2kqxxj")
var health:int= 10
var max_health:int = 10 #max health
var damage:int # damage enemy would deal
var sprite:Texture2D = load("uid://daf1bsgp2pj46") #sprite for character
func _ready():
	# connects the new dir chosen signal to a lambda function that plays the selector sound 
	wheel.new_dir_selected.connect(func():if wheel.num_selections != wheel.target_selections: _play_sound(select_sound))
	wheel.new_dir_selected.connect(hover)
	# connects our new dir chosen signal to the update wheel value function
	wheel.new_dir_chosen.connect(update_wheel_value)
	# connects the dir confirmed signal to a lambda function that plays the confirm sound
	wheel.rotation_started.connect(func():_play_sound(rotate_sound))
	wheel.puzzle_finished.connect(end_check)
	$Sprite2D.texture = sprite
func _play_sound(sound:AudioStream)->void:
	randomize()
	var player = AudioStreamPlayer.new()
	player.stream = sound
	player.pitch_scale = randf_range(0.95,1.05)
	self.add_child(player)
	player.play()
	player.finished.connect(func():player.queue_free())
func update_wheel_value(wp):

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
	health = clamp(health-total_value, 0, max_health)
	if health == 0: #if its at 0 health it dies
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
