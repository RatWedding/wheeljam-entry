extends Button

enum GameNav {MAIN_MENU, GAME}
@export var game_nav : GameNav

func _ready():
	pressed.connect(_on_button_pressed)
	
func _on_button_pressed():
	if game_nav == GameNav.GAME:
		get_tree().change_scene_to_file("res://Demo/demo.tscn")
	if game_nav == GameNav.MAIN_MENU:
		get_tree().change_scene_to_file("res://Menu.tscn")
