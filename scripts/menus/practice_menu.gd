extends Control

var selected_puzzle = 0

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_start_button_pressed() -> void:
	SaveManager.practice = true
	SaveManager.practice_puzzle_index = selected_puzzle
	if !SaveManager.practice_array.has(SaveManager.practice_puzzle_index):
		SaveManager.practice_array.append(SaveManager.practice_puzzle_index)
		print(SaveManager.practice_array)
		SaveManager.save()
	SceneManager.ChangeScene(self, "res://bomb/Game3d.tscn")
