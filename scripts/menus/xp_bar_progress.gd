extends ColorRect

func _process(_delta: float) -> void:
	size.x = (float(LevelManager.current_xp) / LevelManager.level_xp_requirements[SaveManager.level + 1]) * 300
