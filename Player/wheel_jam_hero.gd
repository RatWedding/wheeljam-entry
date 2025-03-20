extends Node3D
@onready var wheel:Wheel = %Wheel
@onready var animation:AnimationPlayer = $AnimationPlayer
@onready var attack_timer:Timer = %AttackTimer
@onready var particle:Resource = load("uid://cegm30aclphpc")

var select_sound:AudioStream = preload("uid://cxg4q58es2u77")
var rotate_sound:AudioStream = preload("uid://c43qhby2kqxxj")
var attack_sound:AudioStream = preload("uid://tij2t4x8snb7")
#TODO make vfx of attack change color based on relative powers of each quadrant
signal attack #when the puzzle is finished, this signal is sent out. connected by all enemies via code. it should cause the enemy to take damage
##the damage of the attack is already stored by the enemy due to their resistances.
signal attack_start

func _ready():
	#LevelManager.player_take_damage.connect(damaged)
	wheel.puzzle_finished.connect(attacking)
	animation.play("WizardIdle")
		#change_scene(0)
	LevelManager.player_attacked.connect(damaged)
	wheel.new_dir_selected.connect(func():if wheel.num_selections != wheel.target_selections: _play_sound(select_sound))
	# connects the dir confirmed signal to a lambda function that plays the confirm sound
	wheel.rotation_started.connect(func():_play_sound(rotate_sound))
func attacking():
	wheel.player_attack()
	animation.play("WizardAttack") #plays attack animation
	var attack_particle = particle.instantiate() #sets up attack animation
	attack_particle.position = $ParticleSpawners.position
	attack_particle.rotation = $ParticleSpawners.rotation #makes sure the ring is horizontal and not on the ground

	await attack_start # await for signal part way through attack animation
	
	add_child(attack_particle) #adds the animation
	attack_particle.set_deferred("emitting",true) #makes it emit
	_play_sound(attack_sound)
	await animation.animation_finished 
	emit_signal("attack") #at the end of the animation, signal enemies that they are attacked
	#gpu particle is removed on its own code
	wheel.player_attack_over()
func attack_starting(): #roundabout way of emitting a signal on annimation timeline. used to start the particle midwaythrough attack animation. 
	emit_signal("attack_start")
	
func _play_sound(sound:AudioStream)->void:
	randomize()
	var player = AudioStreamPlayer.new()
	player.stream = sound
	player.pitch_scale = randf_range(0.95,1.05)
	self.add_child(player)
	player.play()
	player.finished.connect(func():player.queue_free())
func damaged():
	animation.play("WizardOof")
	await animation.animation_finished
	if LevelManager.player_health != 0:
		animation.play("WizardIdle")
		wheel._state = wheel.WheelState.AWAITING_SELECTION
	else:
		return
	
