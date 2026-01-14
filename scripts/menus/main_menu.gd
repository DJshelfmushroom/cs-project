extends Control


func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://bomb/Game3d.tscn")

func _on_tutorials_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/tutorials.tscn")


func _on_packs_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/packs.tscn")


func _on_practice_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/practice_menu.tscn")
