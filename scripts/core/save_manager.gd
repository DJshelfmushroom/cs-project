class_name save_manager extends Node

const save_path : String = "user://save_data.save"
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
var practice_hard: bool = false

var practice_array: Array = []
var addedxp
var firstTime = true

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
	file.store_var(firstTime)
	file.close();



func save_mouse_info(file):
	file.store_var(color)
	

static func write_setting(setting_name:StringName, value:Variant) -> bool:
	var file_text = FileAccess.get_file_as_string(settings_path);
	#print("file_text_w: ", file_text)
	if read_setting(setting_name, false) != "null":
		file_text = file_text.replace(setting_name + ':' + read_setting(setting_name), setting_name + ':' + str(value));
		var file_r = FileAccess.open(settings_path, FileAccess.WRITE);
		file_r.store_string(file_text);
		file_r.close();
		return true
	var file = FileAccess.open(settings_path, FileAccess.WRITE);
	file.store_string(file_text + setting_name + ':' + str(value) + delim);
	file.close();
	return file != null;

static func read_setting(setting_name:StringName, ignore_upper:bool = false) -> String: #string
	#settings_defaults()
	if !FileAccess.file_exists(settings_path):
		settings_defaults()
	var file_text = FileAccess.get_file_as_string(settings_path);
	var index;
	if ignore_upper:
		index = file_text.findn(setting_name);
	else:
		index = file_text.find(setting_name);
	if index == -1:
		return "null";
	index = file_text.find(":",index);
	file_text = file_text.substr(index + 1, file_text.find(delim, index) - (index + 1));
	return file_text;

static func settings_defaults():
	var settings_dir_path = "res://scripts/menus/settings/"
	var settings_dir = DirAccess.open(settings_dir_path)
	var settings_files = settings_dir.get_files()
	var settings_scripts : Array[Script]
	#print(0)
	for file in settings_files:
		if !file.contains("Settings") or !file.contains(".cs") or file.contains(".uid"):
			continue
		var to_path = load(settings_dir_path + "/" + file)
		settings_scripts.append(to_path)
	#print(1)
	for script in settings_scripts:
		#print(2)
		#Utils.GetSceneTree().current_scene.add_child()
		@warning_ignore("standalone_expression")
		var node = Control.new()
		var scene:Node = Utils.GetSceneTree().current_scene.get_children()[0]
		#print(str(scene))
		scene.add_child(node)
		node.set_script(script)
		script.new().LoadDefaults()
		#script.call("LoadDefaults")
		

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
	elif (color == "secret"):
		arrow = load("res://assets/cursor/Secret_RedWire_Cursor.png")
		hand = load("res://assets/cursor/Secret_RedWire_Hand.png")
	elif (color == "invisible"):
		arrow = load("res://assets/cursor/RedWire_Invisible.png")
		hand = load("res://assets/cursor/RedWire_Invisible.png")
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
		firstTime = file.get_var(firstTime)
	else:
		pack1owned = 0
		level = 0
		totalxp = 0
		arrow = load("res://assets/cursor/RedWire_Cursor.png")
		hand = load("res://assets/cursor/RedWire_Hand.png")
		color = "red"
		completedAchievements = []
		practice_array = []
		firstTime = true

func _input(_event):
	if (Utils.GetDebug()):
		if (Input.is_key_pressed(Key.KEY_SHIFT) && Input.is_key_pressed(Key.KEY_D) && Input.is_key_pressed(Key.KEY_C)):
			delete_save_data()

func delete_save_data():
	if (deleted == false):
			if FileAccess.file_exists(save_path):
				var dir = DirAccess.open("user://")
				dir.remove("save_data.save")
				dir.remove(settings_path)
				deleted = true
			Utils.LogGD("Deleting save data", self)

	#if (Input.is_key_pressed(Key.KEY_SHIFT) && Input.is_key_pressed(Key.KEY_D) && Input.is_key_pressed(Key.KEY_C)):
	#	print("check")

func get_save_path():
	return save_path;
