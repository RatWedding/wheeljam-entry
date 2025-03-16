extends Button

enum GameNav {MAIN_MENU, FREE_PLAY, STORY, RESTART}
@export var game_nav : GameNav

func _ready():
	pressed.connect(_on_button_pressed)
	
func _on_button_pressed():
	if game_nav == GameNav.FREE_PLAY:
		get_tree().change_scene_to_file("res://Demo/demo.tscn")
	if game_nav == GameNav.MAIN_MENU:
		get_tree().change_scene_to_file("res://Menu.tscn")
	if game_nav == GameNav.STORY:
		pass
	if game_nav == GameNav.RESTART:
		if LevelManager.storyMode:
			pass
		else:
			get_tree().change_scene_to_file("res://Demo/demo.tscn")
