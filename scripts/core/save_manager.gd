class_name save_manager extends Node

const save_path : String = "user://save_data.save"
# TODO: add settings_path


var pack1owned : int = 0
var level : int = 0
static var totalxp : int = 0

var arrow
var hand
var color : String = "red"

var completedAchievements = []
var deleted = false

var practice: bool = false
var practice_puzzle_index: int = 0

func _ready() -> void:
	load_data()


func save():
	deleted = false
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(pack1owned)
	file.store_var(level)
	file.store_var(totalxp)
	save_mouse_info(file)
	completedAchievements = file.store_var(Achievements.completedAchievements)
	file.close();
	
	
func save_mouse_info(file):
	file.store_var(color)
	

static func write(variable:Variant): #TODO: make this work (How does it get read?)
	var file = FileAccess.open(save_path, FileAccess.WRITE);
	file.store_var(variable);
	file.close();

func load_mouse_info(file):
	var loaded_color = file.get_var()
	if loaded_color == null:
		loaded_color = "red"

	color = str(loaded_color)
	
	if (color == "red"):
		arrow = load("res://assets/cursor/RedWire_Cursor.png")
		hand = load("res://assets/cursor/RedWire_Hand.png")
	elif (color == "green"):
		arrow = load("res://assets/cursor/Green_RedWire_Cursor.png")
		hand = load("res://assets/cursor/Green_RedWire_Hand.png")
	elif (color == "black"):
		arrow = load("res://assets/cursor/Black_RedWire_Cursor.png")
		hand = load("res://assets/cursor/Black_RedWire_Hand.png")
	elif (color == "silver"):
		arrow = load("res://assets/cursor/Silver_RedWire_Cursor.png")
		hand = load("res://assets/cursor/Silver_RedWire_Hand.png")
	elif (color == "quick"):
		arrow = load("res://assets/cursor/Quick_RedWire_Cursor.png")
		hand = load("res://assets/cursor/Quick_RedWire_Hand.png")
	elif (color == "glitched"):
		arrow = load("res://assets/cursor/Glitched_RedWire_Cursor.png")
		hand = load("res://assets/cursor/Glitched_RedWire_Hand.png")
	elif (color == "inverted"):
		arrow = load("res://assets/cursor/Inverted_RedWire_Cursor.png")
		hand = load("res://assets/cursor/Inverted_RedWire_Hand.png")
	else:
		pass


func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		pack1owned = file.get_var(pack1owned)
		level = file.get_var(level)
		totalxp = file.get_var(totalxp)
		load_mouse_info(file)
		Achievements.load_achievements(file.get_var())
	else:
		pack1owned = 0
		level = 0
		totalxp = 0
		arrow = load("res://assets/cursor/RedWire_Cursor.png")
		hand = load("res://assets/cursor/RedWire_Hand.png")
		color = "red"
		completedAchievements = []

func _input(_event):
	if (Utils.GetDebug()):
		if (Input.is_key_pressed(Key.KEY_SHIFT) && Input.is_key_pressed(Key.KEY_D) && Input.is_key_pressed(Key.KEY_C)):
			if (deleted == false):
				if FileAccess.file_exists(save_path):
					var dir = DirAccess.open("user://")
					dir.remove("save_data.save")
					deleted = true
			Utils.LogGD("Deleting save data", self)
				
	#if (Input.is_key_pressed(Key.KEY_SHIFT) && Input.is_key_pressed(Key.KEY_D) && Input.is_key_pressed(Key.KEY_C)):
	#	print("check")

func get_save_path():
	return save_path;
