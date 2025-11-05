extends Control

func _on_pack_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://pack_open.tscn") 


func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
