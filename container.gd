extends Control
# place objects

@export var margin_y : float
const BUTTON_HEIGHT : int = 48
var SCREEN_HEIGHT : float
var CENTER_LINE : float
var abs_max_height : float


func _ready() -> void:
	SCREEN_HEIGHT = get_viewport_rect().size.y
	CENTER_LINE  = get_viewport_rect().get_center().y
	print("Center line: " + str(CENTER_LINE))
	abs_max_height = SCREEN_HEIGHT - margin_y
	var children : Array[Node] = self.get_children()
	var padding = (abs_max_height / len(children)) - (BUTTON_HEIGHT *  len(children))
	for i in range(len(children)):
		var child = children[i] 
		child.position.x = get_viewport_rect().get_center().x
		child.position.y = (CENTER_LINE + .5 * BUTTON_HEIGHT) - (padding * i)
		print(child.position)
	
