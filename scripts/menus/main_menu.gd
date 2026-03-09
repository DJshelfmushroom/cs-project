extends Control

func _ready() -> void:
	$CustomCursor.set_mouse_cursor(SaveManager.arrow, SaveManager.hand, SaveManager.color)
	if (SaveManager.level >= 5):
		Achievements.completed_achievement("Reached Level 5")
	print(Achievements.completedAchievements)

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
