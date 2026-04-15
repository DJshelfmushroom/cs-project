class_name Containter
extends Control
# place objects

@export var margin_y : float
@export var button_padding : float
const BUTTON_HEIGHT : int = 48
var SCREEN_HEIGHT : float
var abs_max_height : float

var children : Array[Button]
var scenes : Array[Resource]

#enum butValTypes { MENU, SETTINGS, RETURN }

#const butVals : Dictionary = {
	#butValTypes.MENU: "Quit",
	#butValTypes.SETTINGS: "Settings",
	#butValTypes.RETURN: "Back"
#}

@export var button_values : Dictionary[StringName, PackedScene]
@export var button_order : Array[int]

func createChildren() -> void :
	var buttons : Array[String] = []
	#for key in butVals.keys():
		#buttons.append(butVals.get(key))
	buttons.append_array(button_values.keys())
	for i in range(len(buttons)):
		var child : Button = Button.new()
		child.text = buttons[button_order[i]]
		child.name = child.text
		child.add_theme_font_size_override("font_size", 96)
		self.add_child(child)
		child.size += Vector2(get_viewport_rect().size.x / 2, 20)
		children.append(child)

func _ready() -> void:
	#SceneManager.ChangeScene(self, "res://scenes/menus/main_menu.tscn")
	for i in button_values.values():
		Utils.LogGD(str(i), self)
		scenes.append(load(str(i)))
	createChildren()
	margin_y += BUTTON_HEIGHT/2.0
	SCREEN_HEIGHT = get_viewport_rect().size.y
	abs_max_height = SCREEN_HEIGHT - margin_y
	for i in range(len(children)):
		var child : Button = children[i]
		child.position.x = get_viewport_rect().get_center().x
		child.position.y = (( abs_max_height / len(children) * (i+0) ) +  margin_y)
		child.position -= child.size / 2
		Utils.LogGD("Created child at: " + str(child.position), self);
		child.pressed.connect(menu_press.bind(child.name))

func menu_press(but: StringName) -> void:
	SceneManager.ChangeScene(self, button_values.get(but).resource_path)
