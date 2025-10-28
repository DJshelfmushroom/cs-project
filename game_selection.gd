extends Control

var strikes

func _ready() -> void:
	strikes = 0

func _process(delta: float) -> void:
	if ($Puzzle1.completed == true):
		$TimerNode.stop_timer()
	if (strikes >= 3):
		$Puzzle1/EquationLabel/AnswerLabel/TextEdit1.editable = false
		$Puzzle1/EquationLabel/AnswerLabel/TextEdit2.editable = false
		$StrikesLabel.add_theme_color_override("font_color", "red")
		$Puzzle1.failed = true

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn") # Replace with function body.
