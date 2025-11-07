extends Control



func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn") # Replace with function body.


func _on_puzzle_1_tutorial_button_up() -> void:
	get_tree().change_scene_to_file("res://puzzle_1_tutorial.tscn")
