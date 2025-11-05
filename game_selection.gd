extends Control

var strikes
var failed = false
var allcompleted = false

func _ready() -> void:
	strikes = 0

func _process(_delta: float) -> void:
	if ($Puzzle1.completed == true && $Puzzle2.completed == true):
		$TimerNode.stop_timer()
		$TimerNode/Timer/TimeLabel.add_theme_color_override("font_color", "green")
		$StrikesLabel.add_theme_color_override("font_color", "green")
		allcompleted = true
		$RedWireButton.visible = true
		
	if (strikes >= 3):
		$Puzzle1/EquationLabel/AnswerLabel/TextEdit1.editable = false
		$Puzzle1/EquationLabel/AnswerLabel/TextEdit2.editable = false
		$StrikesLabel.add_theme_color_override("font_color", "red")
		$TimerNode/Timer/TimeLabel.add_theme_color_override("font_color", "red")
		failed = true

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
