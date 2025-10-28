extends Control
# place objects

@export var margin_y : float
@export var button_padding : float
const BUTTON_HEIGHT : int = 48
var SCREEN_HEIGHT : float
var abs_max_height : float

var children : Array[Button]

func createChildren() -> void :
	var buttons : Array[String] = ["Main Menu", "Settings"]
	for i in range(len(buttons)):
		var child : Button = Button.new()
		child.text = buttons[i]
		child.add_theme_font_size_override("pause_button", 48)
		child.size += Vector2(20, 10)
		children.append(child)

		

func _ready() -> void:
	createChildren()
	margin_y += BUTTON_HEIGHT/2.0
	SCREEN_HEIGHT = get_viewport_rect().size.y
	abs_max_height = SCREEN_HEIGHT - margin_y

	for i in range(len(children)):
		var child : Button = children[i]
		child.position.x = get_viewport_rect().get_center().x
		child.position.y = (( abs_max_height / len(children) * (i+0) ) +  margin_y)
		child.position -= child.size / 2
		print(child.position)
	
