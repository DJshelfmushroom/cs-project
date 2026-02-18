extends Node

var save_path = "user://save_data.save"
var cursor = preload("res://scenes/menus/custom_cursor.tscn").instantiate()

var pack1owned : int = 0
var level : int = 0
var totalxp : int = 0

var arrow = cursor.call("get_mouse_arrow")
var hand = cursor.call("get_mouse_hand")
var color = cursor.call("get_mouse_color")


func _ready() -> void:
	load_data()


func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(pack1owned)
	file.store_var(level)
	file.store_var(totalxp)
	save_mouse_info(file)
	
	
func save_mouse_info(file):
	file.store_var(arrow)
	file.store_var(hand)
	file.store_var(color)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		pack1owned = file.get_var(pack1owned)
		level = file.get_var(level)
		totalxp = file.get_var(totalxp)
		#arrow = file.getvar(arrow)
		#hand = file.get_var(hand)
		#color = file.get_var(color)
	else:
		pack1owned = 0
		level = 0
		totalxp = 0
		arrow = load("res://assets/cursor/RedWire_Cursor.png")
		hand = load("res://assets/cursor/RedWire_Hand.png")
		color = "red"
