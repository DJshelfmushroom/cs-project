extends Node3D

func _ready() -> void:
	$Control/CustomCursor.set_mouse_cursor(SaveManager.arrow, SaveManager.hand, SaveManager.color)
	SaveManager.save()
	if (SaveManager.level >= 5):
		Achievements.completed_achievement("Reached Level 5")
	if (SaveManager.level >= 10):
		Achievements.completed_achievement("Dynamic Duo")
	if (SaveManager.level >= 15):
		Achievements.completed_achievement("Complete the Triumvirate")

func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://bomb/Game3d.tscn")

func _on_tutorials_button_up() -> void:
	var sound = AudioStreamPlayer.new()
	sound.set_stream(load("res://silence_please.mp3"))
	get_tree().root.add_child(sound)
	sound.play()
	get_tree().change_scene_to_file("res://scenes/menus/tutorials.tscn")
	sound.finished.connect(sound.queue_free)


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
