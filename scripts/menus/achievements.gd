extends Control
var achievementlistnum = 0

func _ready() -> void:
	achievementlistnum = 0
	for achievement in $"Achievement Buttons".get_children():
		if Achievements.check_achievement_completed(achievementlistnum):
			achievement.add_theme_color_override("font_color", "green")
		achievementlistnum += 1


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
