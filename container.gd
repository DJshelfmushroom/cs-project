extends Control
# place objects

@export var margin_y : float
@export var button_padding : float
const BUTTON_HEIGHT : int = 48
var SCREEN_HEIGHT : float
var abs_max_height : float

var children : Array[Button]

enum butValTypes { MENU, SETTINGS, RETURN }

const butVals : Dictionary = {
	butValTypes.MENU: "Main Menu",
	butValTypes.SETTINGS: "Settings",
	butValTypes.RETURN: "Return to Game"
}

func createChildren() -> void :
	var buttons : Array[String] = []
	for key in butVals.keys():
		buttons.append(butVals.get(key))
	for i in range(len(buttons)):
		var child : Button = Button.new()
		child.text = buttons[i]
		child.name = child.text
		child.add_theme_font_size_override("font_size", 96)
		self.add_child(child)
		child.size += Vector2(get_viewport_rect().size.x / 2, 20)
		children.append(child)

func _ready() -> void:
	print(SceneManager.call("ChangeScene", "res://main_menu.tscn"))
	print(get_tree().current_scene.scene_file_path)
	createChildren()
	margin_y += BUTTON_HEIGHT/2.0
	SCREEN_HEIGHT = get_viewport_rect().size.y
	abs_max_height = SCREEN_HEIGHT - margin_y
	for i in range(len(children)):
		var child : Button = children[i]
		child.position.x = get_viewport_rect().get_center().x
		child.position.y = (( abs_max_height / len(children) * (i+0) ) +  margin_y)
		child.position -= child.size / 2
		child.pressed.connect(menu_press.bind(child.name))
			
func menu_press(but: StringName) -> void:
	print(but)
	var butIsVal = func (val : butValTypes) -> bool:
		return but == butVals.get(val)
	
	var tree = get_tree()
	
	
	
	if butIsVal.call(butValTypes.MENU):
		tree.change_scene_to_file("res://main_menu.tscn")
	elif butIsVal.call(butValTypes.RETURN):
		tree.change_scene_to_file("res://game.tscn")
		
