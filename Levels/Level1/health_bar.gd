extends ProgressBar
func _ready():
	
	max_value = LevelManager.max_health
	
func _process(delta):
	value = LevelManager.player_health
   
