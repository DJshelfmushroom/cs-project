extends Control

var puzzle_paths = ["res://scenes/puzzles/puzzle_one_3d.tscn",
 "res://scenes/puzzles/puzzle_two_3d.tscn", "res://scenes/puzzles/simon_puzzle_3d.tscn"]
var selected_puzzle = 0

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(puzzle_paths[selected_puzzle])
