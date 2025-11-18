extends Node

var save_path = "user://save_data.save"

var pack1owned = 0

func _ready() -> void:
	load_data()

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(pack1owned)
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		pack1owned = file.get_var(pack1owned)
	else:
		pack1owned = 0
