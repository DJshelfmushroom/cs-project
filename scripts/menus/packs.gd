extends Control

func _on_pack_1_button_pressed() -> void:
	if (SaveManager.pack1owned > 0):
		get_tree().change_scene_to_file("res://scenes/menus/pack_open.tscn") 
		SaveManager.pack1owned -= 1
	


func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _process(_delta: float) -> void:
	$P1OwnedLabel.text = "OWNED: " + str(SaveManager.pack1owned)
