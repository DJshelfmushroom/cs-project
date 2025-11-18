extends Control


func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://game.tscn")

func _on_tutorials_button_up() -> void:
	get_tree().change_scene_to_file("res://tutorials.tscn")
	
func _on_packs_button_button_up() -> void:
	get_tree().change_scene_to_file("res://packs.tscn")
