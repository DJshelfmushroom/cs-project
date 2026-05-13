class_name main_menu
extends Node3D

func _ready() -> void:
	#load_settings(self)
	$Control/CustomCursor.set_mouse_cursor(SaveManager.arrow, SaveManager.hand, SaveManager.color)
	SaveManager.save()
	if (SaveManager.level >= 5):
		Achievements.completed_achievement("Reached Level 5")
	if (SaveManager.level >= 10):
		Achievements.completed_achievement("Dynamic Duo")
	if (SaveManager.level >= 15):
		Achievements.completed_achievement("Complete the Triumvirate")

static func load_settings(caller:Node) -> void:
	var settings_path = "res://scenes/menus/SettingsSub/"
	var settings_dir = DirAccess.open(settings_path)
	var settings_files = settings_dir.get_files()
	var settings_scripts : Array[PackedScene]
	for file in settings_files:
		if !file.contains("Settings") or !file.contains("tscn"):
			continue
		var to_path = load(settings_path + "/" + file)
		settings_scripts.append(to_path)
	for script in settings_scripts:
		ResourceLoader.load_threaded_request(script.resource_path)
		var scene = ResourceLoader.load_threaded_get(script.resource_path)
		var instantiated = scene.instantiate()
		instantiated.visible = false
		caller.add_child(instantiated)
		caller.remove_child(instantiated)
		instantiated.queue_free()
	

func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://bomb/Game3d.tscn")

func _on_tutorials_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/tutorials.tscn")


func _on_packs_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/packs.tscn")


func _on_practice_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")

func _on_mouse_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Mouse_options.tscn")

func _on_achievements_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Achievements.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Settings.tscn");
	pass # Replace with function body.
