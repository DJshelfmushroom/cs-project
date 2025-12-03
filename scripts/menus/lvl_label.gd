extends Label

func _process(_delta: float) -> void:
	text = "LVL " + str(SaveManager.level)
