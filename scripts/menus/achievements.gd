extends Control
var achievementlistnum = 0

func _ready() -> void:
	achievementlistnum = 0
	for achievement in $"Achievement Buttons".get_children():
		if Achievements.check_achievement_completed(achievementlistnum):
			achievement.add_theme_color_override("font_color", "green")
		achievementlistnum += 1
	if !Achievements.check_achievement_completed(8):
		$"Achievement Buttons/ItsAMe".text = "Secret Achievement"
		$"Achievement Buttons/ItsAMe/ItsAMeText".text = "???"


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")




func _on_complete_tutorial_button_mouse_entered() -> void:
	$"Achievement Buttons/CompleteTutorialButton/CompleteTutorialText".show()
func _on_complete_tutorial_button_mouse_exited() -> void:
	$"Achievement Buttons/CompleteTutorialButton/CompleteTutorialText".hide()
func _on_reached_level_5_button_mouse_entered() -> void:
	$"Achievement Buttons/ReachedLevel5Button/PuzzlerText".show()
func _on_reached_level_5_button_mouse_exited() -> void:
	$"Achievement Buttons/ReachedLevel5Button/PuzzlerText".hide()
func _on_beat_game_under_90_mouse_entered() -> void:
	$"Achievement Buttons/BeatGameUnder90/SpeedText".show()
func _on_beat_game_under_90_mouse_exited() -> void:
	$"Achievement Buttons/BeatGameUnder90/SpeedText".hide()
func _on_beat_game_under_60_mouse_entered() -> void:
	$"Achievement Buttons/BeatGameUnder60/RapidText".show()
func _on_beat_game_under_60_mouse_exited() -> void:
	$"Achievement Buttons/BeatGameUnder60/RapidText".hide()
func _on_dont_disable_puzzle_mouse_entered() -> void:
	$"Achievement Buttons/DontDisablePuzzle/ForgetText".show()
func _on_dont_disable_puzzle_mouse_exited() -> void:
	$"Achievement Buttons/DontDisablePuzzle/ForgetText".hide()
func _on_dynamic_duo_mouse_entered() -> void:
	$"Achievement Buttons/DynamicDuo/DynamicDuoText".show()
func _on_dynamic_duo_mouse_exited() -> void:
	$"Achievement Buttons/DynamicDuo/DynamicDuoText".hide()
func _on_of_a_kind_mouse_entered() -> void:
	$"Achievement Buttons/3OfAKind/3OfAKindText".show()
func _on_of_a_kind_mouse_exited() -> void:
	$"Achievement Buttons/3OfAKind/3OfAKindText".hide()
func _on_its_a_me_mouse_entered() -> void:
	$"Achievement Buttons/ItsAMe/ItsAMeText".show()
func _on_its_a_me_mouse_exited() -> void:
	$"Achievement Buttons/ItsAMe/ItsAMeText".hide()
