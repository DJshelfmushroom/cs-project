extends Node3D

var strikes
var failed = false
var allcompleted = false
var fix = false
var disable_first = false

func _ready() -> void:
	strikes = 0
	$bomb_instance/Games/PuzzleOne3D.practice = false
	$bomb_instance/Games/PuzzleTwo3D.practice = false
	$bomb_instance/Games/SimonPuzzle3D.practice = false
	$bomb_instance/Games/NumerlePuzzle3D.practice = false

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
		$bomb_instance/Games/PuzzleOne3D/EquationLabel/AnswerLabel/Num1.editable = false
		$bomb_instance/Games/PuzzleOne3D/EquationLabel/AnswerLabel/Num2.editable = false
		$StrikesLabel.add_theme_color_override("font_color", "red")
		$TimerNode/Timer/TimeLabel.add_theme_color_override("font_color", "red")
		failed = true
		$bomb_instance/Games/PuzzleTwo3D.thisfailed = true
		$GameOverLabel.visible = true
		$ReturnButton.visible = true
		$Camera3D/roltateaxis2.hide()
	if $bomb_instance/Games/DisablePuzzle3D.completed:
		disable_first = true
	if (disable_consequence()) && !disable_first:
		strikes = 3
		failed = true

func puzzles_completed():
	if ($bomb_instance/Games/PuzzleOne3D.completed && $bomb_instance/Games/PuzzleTwo3D.completed && $bomb_instance/Games/SimonPuzzle3D.completed &&
	 $bomb_instance/Games/ReflexPuzzle3D.completed && $bomb_instance/Games/NumerlePuzzle3D.completed && $bomb_instance/Games/SegmentPuzzle3D.completed &&
	$bomb_instance/Games/DisablePuzzle3D.completed && $bomb_instance/Games/ColorsPuzzle3D.completed && $bomb_instance/Games/SwitchesPuzzle3D.completed):
		return true
	else:
		return false


func disable_consequence():
	for c in $bomb_instance/Games.get_children():
		if c.completed && c.name != "DisablePuzzle3D":
			return true
	return false



func _on_back_button_up() -> void:
	if (allcompleted):
		SaveManager.pack1owned += 1
		SaveManager.totalxp += 30
	else:
		SaveManager.totalxp += 8
	SaveManager.save()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
