extends ProgressBar
@onready var timer  = %AttackTimer
func _ready():
	
	max_value = timer.wait_time
	
func _process(delta):
	value = timer.time_left
   
