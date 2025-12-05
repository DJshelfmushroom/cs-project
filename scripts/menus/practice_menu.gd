extends Control

var puzzle_paths = ["res://scenes/puzzles/puzzle_1.tscn",
 "res://scenes/puzzles/puzzle_2.tscn", "res://scenes/puzzles/simon_says.tscn"]
var selected_puzzle = 0

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(puzzle_paths[selected_puzzle])
