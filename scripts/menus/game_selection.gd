extends Node3D

var puzzles = [preload("res://scenes/puzzles/puzzle_one_3d.tscn"), preload("res://scenes/puzzles/puzzle_two_3d.tscn"), preload("res://scenes/puzzles/simon_puzzle_3d.tscn"),
preload("res://reflex_puzzle_3d.gd"), preload("res://scenes/puzzles/numerle_puzzle_3d.tscn"), preload("res://scenes/puzzles/segment_puzzle_3d.tscn"), 
preload("res://scenes/puzzles/disable_puzzle_3d.tscn"), preload("res://scenes/puzzles/colors_puzzle_3d.tscn"), preload("res://scenes/puzzles/switches_puzzle_3d.tscn"),
preload("res://scenes/puzzles/yes_no_puzzle_3d.tscn")]

var puzzle_scales = [0.45,0.4,0.5,0.5,0.4,0.4,0.2,0.6,0.08,0.17]

var possible_positions = [
	Vector3(0.5,0.25,0.5),Vector3(0.5,0.25,-0.5),Vector3(0.5,-0.25,0.5),Vector3(0.5,-0.25,-0.5),
	Vector3(-0.5,0.25,0.5),Vector3(-0.5,0.25,-0.5),Vector3(-0.5,-0.25,0.5),Vector3(-0.5,-0.25,-0.5),
	Vector3(0.25,-0.5,0.5),Vector3(0.25,-0.5,-0.5),Vector3(-0.25,-0.5,0.5),Vector3(-0.25,-0.5,-0.5),
	Vector3(0.25,0.5,0.5),Vector3(0.25,0.5,-0.5),Vector3(-0.25,0.5,0.5),Vector3(-0.25,0.5,-0.5),
	Vector3(0.0,0.25,1.0),Vector3(0.0,-0.25,1.0),
	Vector3(0.0,0.25,-1.0),Vector3(0.0,-0.25,-1.0)
]
	
var rotations = [
	Vector3(0.0, 90.0, 0.0), Vector3(0.0, -90.0, 0.0),
	Vector3(90.0, 90.0, 0), Vector3(-90.0, 90.0, 0.0),
	Vector3(0.0, 0.0, 0.0), Vector3(0.0, 180.0, 0.0)
]

var strikes
var failed = false
var allcompleted = false
var fix = false
var disable_first = false

var current_puzzles = []


func _ready() -> void:
	
	strikes = 0

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
	$bomb_instance/Games/DisablePuzzle3D.completed && $bomb_instance/Games/ColorsPuzzle3D.completed && $bomb_instance/Games/SwitchesPuzzle3D.completed &&
	 $bomb_instance/Games/YesNoPuzzle3D.completed):
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
