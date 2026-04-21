extends Node

var level_xp_requirements = [0]
var current_xp = 0

func _ready() -> void:
	var y = 100
	for x in range(1, 150):
		level_xp_requirements.append(y)
		if (x % 5 == 0):
			y *= 2
			
func _process(_delta: float) -> void:
	while SaveManager.level > 0 and current_xp < 0:
		SaveManager.level -= 1
	
	var i = 0
	for x in range(0,SaveManager.level + 1):
		i += level_xp_requirements[x]
	current_xp = SaveManager.totalxp - i
	if (current_xp >= level_xp_requirements[SaveManager.level + 1]):
		SaveManager.level += 1
