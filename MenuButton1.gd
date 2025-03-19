extends GameButton

var shader : ShaderMaterial

func _ready():
	shader = get_parent().material

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
