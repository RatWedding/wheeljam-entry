extends ProgressBar
func _ready():
	
	max_value = LevelManager.max_spins
	
func _process(delta):
	value = LevelManager.free_spins
   
