extends Node

var save_path = "user://save_data.save"

var pack1owned : int = 0
var level : int = 0
var totalxp : int = 0

func _ready() -> void:
	load_data()
	

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(pack1owned)
	file.store_var(level)
	file.store_var(totalxp)
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		pack1owned = file.get_var(pack1owned)
		#level = file.get_var(level)
		#totalxp = file.get_var(totalxp)
	else:
		pack1owned = 0
		level = 0
		totalxp = 0
