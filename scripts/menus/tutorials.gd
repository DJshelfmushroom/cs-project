extends Control



func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn") # Replace with function body.


func _on_puzzle_1_tutorial_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzles/tutorials/puzzle_1_tutorial.tscn")


func _on_puzzle_2_tutorial_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzles/tutorials/puzzle_2_tutorial.tscn")
	#SceneManager.ChangeScene(self, "res://scenes/puzzles/tutorials/puzzle_2_tutorial.tscn")


func _on_puzzle_3_tutorial_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzles/tutorials/puzzle_3_tutorial.tscn")

func _on_puzzle_4_tutorial_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzles/tutorials/puzzle_4_tutorial.tscn")
	
func _on_puzzle_5_tutorial_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzles/tutorials/puzzle_5_tutorial.tscn")

func _on_puzzle_6_tutorial_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzles/tutorials/puzzle_6_tutorial.tscn")

func _on_puzzle_7_tutorial_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzles/tutorials/puzzle_7_tutorial.tscn")


func _on_puzzle_8_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/puzzles/tutorials/puzzle_8_tutorial.tscn")
