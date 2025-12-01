extends Label

func _process(_delta: float) -> void:
	text = str(LevelManager.current_xp) + "/" + str(LevelManager.level_xp_requirements[SaveManager.level + 1])
