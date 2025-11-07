extends Label

func _ready() -> void:
	position = Vector2(120,345)
	
	

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://tutorials.tscn")
