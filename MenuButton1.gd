extends GameButton
var menu_music = load("uid://41ef5s8wq3qh")
var shader : ShaderMaterial

func _ready():
	shader = get_parent().material
	_play_sound(menu_music)
	grab_focus()
func _process(delta : float) -> void:
	update_box()
	if is_hovered():
		shader.set_shader_parameter("button1Hover", true)
	else:
		shader.set_shader_parameter("button1Hover", false)

func update_box():
	shader.set_shader_parameter("xExtent1", size.x/2)
	shader.set_shader_parameter("yExtent1", size.y/2)
	var xPos:float = position.x - DisplayServer.window_get_size().x/2 + size.x/2
	var yPos:float = position.y - DisplayServer.window_get_size().y/2 + size.y/2
	shader.set_shader_parameter("xPos1", xPos) 
	shader.set_shader_parameter("yPos1", yPos)


func _on_pressed():
	LevelManager.reset_var()
	LevelManager.level_complete = 4
	get_tree().change_scene_to_file("uid://csr42cxjucp2s") #level 1 UID
func _play_sound(sound:AudioStream)->void:
	randomize()
	var player = AudioStreamPlayer.new()
	player.stream = sound
	player.volume_db = -30

	self.add_child(player)
	player.play()
