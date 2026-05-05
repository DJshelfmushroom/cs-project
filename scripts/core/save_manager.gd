class_name save_manager extends Node

const save_path : String = "user://save_data.save"
# TODO: add settings_path
const settings_path : String = "user://settings.sav"
const delim : String = "|"


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

var practice_array = []

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
	file.store_var(practice_array)
	file.close();
	

func save_mouse_info(file):
	file.store_var(color)
	

static func write_setting(setting_name:StringName, value:Variant) -> bool: #TODO: make this work (How does it get read?)
	print(FileAccess.get_file_as_string(settings_path))
	#print(1)
	var file_text = FileAccess.get_file_as_string(settings_path);
	var file = FileAccess.open(settings_path, FileAccess.WRITE);
	if read_setting(setting_name) != "null":
		#file.close();
		file_text.replace(setting_name + ':' + read_setting(setting_name), setting_name + ':' + str(value));
		#file = FileAccess.open(settings_path, FileAccess.WRITE);
		file.store_string(file_text);
		file.close();
		#print(FileAccess.get_file_as_string(settings_path))
		return true
	file.store_string(file_text + setting_name + ':' + str(value) + delim);
	#print(file_text)
	#print(2)
	file.close();
	return file != null;

static func read_setting(setting_name:StringName, ignore_upper:bool = false) -> String: #string
	#var file = FileAccess.open(settings_path, FileAccess.READ);
	var file : String = FileAccess.get_file_as_string(settings_path);
	var index;
	if ignore_upper:
		index = file.findn(setting_name);
	else:
		index = file.find(setting_name);
	#print("settings index " + str(index));
	if index == -1:
		return "null";
	index = file.find(":",index);
	#print("ff: ", file.find(delim, index) - 1, ", len: ", len(file));
	file = file.substr(index + 1, file.find(delim, index) - (index + 1));
	#print("file: ", file)
	return file;

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
	elif (color == "inverse"):
		arrow = load("res://assets/cursor/Inverse_RedWire_Cursor.png")
		hand = load("res://assets/cursor/Inverse_RedWire_Hand.png")
	elif (color == "hand"):
		arrow = load("res://assets/cursor/Hand_RedWire_Cursor.png")
		hand = load("res://assets/cursor/Hand_RedWire_Hand.png")
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
		practice_array = file.get_var()
	else:
		pack1owned = 0
		level = 0
		totalxp = 0
		arrow = load("res://assets/cursor/RedWire_Cursor.png")
		hand = load("res://assets/cursor/RedWire_Hand.png")
		color = "red"
		completedAchievements = []
		practice_array = []

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
