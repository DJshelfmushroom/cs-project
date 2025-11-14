extends Control

var strikes
var failed = false
var allcompleted = false
var fix = false

func _ready() -> void:
	strikes = 0

func _process(_delta: float) -> void:
	if (fix == false):
		if ($Puzzle1.completed == true && $Puzzle2.completed == true && $"Simon Says".Completed == true):
			$TimerNode.stop_timer()
			$TimerNode/Timer/TimeLabel.add_theme_color_override("font_color", "green")
			$StrikesLabel.add_theme_color_override("font_color", "green")
			allcompleted = true
			$RedWireButton.visible = true
		
	if (strikes >= 3 || ($TimerNode/Timer.time_left <= 0 && allcompleted == false)):
		$Puzzle1/EquationLabel/AnswerLabel/TextEdit1.editable = false
		$Puzzle1/EquationLabel/AnswerLabel/TextEdit2.editable = false
		$StrikesLabel.add_theme_color_override("font_color", "red")
		$TimerNode/Timer/TimeLabel.add_theme_color_override("font_color", "red")
		failed = true
		$GameOverLabel.visible = true
		$ReturnButton.visible = true

func _on_back_button_up() -> void:
	SaveManager.pack1owned += 1
	SaveManager.save()
	get_tree().change_scene_to_file("res://main_menu.tscn")
