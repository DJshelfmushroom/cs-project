extends Node3D

var strikes
var failed = false
var allcompleted = false
var fix = false

func _ready() -> void:
	strikes = 0
	$bomb_instance/PuzzleOne3D.practice = false
	$bomb_instance/PuzzleTwo3D.practice = false
	$bomb_instance/SimonPuzzle3D.practice = false
	$bomb_instance/NumerlePuzzle3D.practice = false

func _process(_delta: float) -> void:
	if (fix == false):
		if (puzzles_completed() && !failed):
			$TimerNode.stop_timer()
			$TimerNode/Timer/TimeLabel.add_theme_color_override("font_color", "green")
			$StrikesLabel.add_theme_color_override("font_color", "green")
			allcompleted = true
			$RedWireButton.visible = true
	else:
		fix = false
		
	if (strikes >= 3 || ($TimerNode/Timer.time_left <= 0 && !allcompleted)):
		$bomb_instance/PuzzleOne3D/EquationLabel/AnswerLabel/Num1.editable = false
		$bomb_instance/PuzzleOne3D/EquationLabel/AnswerLabel/Num2.editable = false
		$StrikesLabel.add_theme_color_override("font_color", "red")
		$TimerNode/Timer/TimeLabel.add_theme_color_override("font_color", "red")
		failed = true
		$bomb_instance/PuzzleTwo3D.thisfailed = true
		$GameOverLabel.visible = true
		$ReturnButton.visible = true

func puzzles_completed():
	if ($bomb_instance/PuzzleOne3D.completed && $bomb_instance/PuzzleTwo3D.completed && $bomb_instance/SimonPuzzle3D.completed && $bomb_instance/ReflexPuzzle3D.completed):
		return true
	else:
		return false

func _on_back_button_up() -> void:
	if (allcompleted):
		SaveManager.pack1owned += 1
		SaveManager.totalxp += 15
	else:
		SaveManager.totalxp += 5
	SaveManager.save()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
