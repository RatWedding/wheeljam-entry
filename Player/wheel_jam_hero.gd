extends Node3D

@onready var wheel:Wheel = %Wheel
@onready var animation:AnimationPlayer = $AnimationPlayer
@onready var particle:Resource = load("uid://cegm30aclphpc")
#TODO make vfx of attack change color based on relative powers of each quadrant
signal attack #when the puzzle is finished, this signal is sent out. connected by all enemies via code. it should cause the enemy to take damage
##the damage of the attack is already stored by the enemy due to their resistances.
signal attack_start
func _ready():


	
	wheel.puzzle_finished.connect(attacking)
	animation.play("WizardIdle")
	
func attacking():
	wheel.set_deferred("visible", false)
	animation.play("WizardAttack") #plays attack animation
	var attack_particle = particle.instantiate() #sets up attack animation
	attack_particle.position = $ParticleSpawners.position
	attack_particle.rotation = $ParticleSpawners.rotation #makes sure the ring is horizontal and not on the ground

	await attack_start # await for signal part way through attack animation
	add_child(attack_particle) #adds the animation
	attack_particle.set_deferred("emitting",true) #makes it emit
	
	await animation.animation_finished 
	emit_signal("attack") #at the end of the animation, signal enemies that they are attacked
	#gpu particle is removed on its own code
	await get_tree().create_timer(1).timeout
	wheel.reset()
	wheel.set_deferred("visible", true)

func attack_starting(): #roundabout way of emitting a signal on annimation timeline. used to start the particle midwaythrough attack animation. 
	emit_signal("attack_start")
