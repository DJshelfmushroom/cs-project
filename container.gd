extends Control
# place objects

@export var margin_y : float
var SCREEN_HEIGHT : int
var CENTER_LINE : float
var abs_max_height : float


func _ready() -> void:
	SCREEN_HEIGHT = get_viewport_rect().size.y
	CENTER_LINE  = get_viewport_rect().get_center().y

	
	print("Center line: " + str(CENTER_LINE))
	abs_max_height = SCREEN_HEIGHT - margin_y
	var _children : Array[Node] = self.get_children()
	
	pass
	
func organizeChildren(children : Array[Node]):
	for child in children:
		
		pass
	pass
