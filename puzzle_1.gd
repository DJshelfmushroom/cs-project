extends Control

var completed
var strikeable = true

func _ready() -> void:
	completed = false

func _process(delta: float) -> void:
	if (($EquationLabel/AnswerLabel/TextEdit1.text == str($EquationLabel.get_rand1()) && $EquationLabel/AnswerLabel/TextEdit2.text == str($EquationLabel.get_rand2())) \
	or ($EquationLabel/AnswerLabel/TextEdit1.text == str($EquationLabel.get_rand2()) && $EquationLabel/AnswerLabel/TextEdit2.text == str($EquationLabel.get_rand1()))):
		completed = true
	elif (not($EquationLabel/AnswerLabel/TextEdit1.text == "") && not($EquationLabel/AnswerLabel/TextEdit2.text == "") && strikeable == true):
		$EquationLabel/AnswerLabel/TextEdit1.editable = false
		$EquationLabel/AnswerLabel/TextEdit1.add_theme_color_override("font_readonly_color","red")
		$EquationLabel/AnswerLabel/TextEdit2.editable = false
		$EquationLabel/AnswerLabel/TextEdit2.add_theme_color_override("font_readonly_color", "red")
		$"..".strikes += 1
		strikeable = false
		await get_tree().create_timer(1.0).timeout
		$EquationLabel/AnswerLabel/TextEdit1.text = ""
		$EquationLabel/AnswerLabel/TextEdit2.text = ""
		$EquationLabel/AnswerLabel/TextEdit1.editable = true
		$EquationLabel/AnswerLabel/TextEdit1.add_theme_color_override("font_readonly_color","green")
		$EquationLabel/AnswerLabel/TextEdit2.editable = true
		$EquationLabel/AnswerLabel/TextEdit2.add_theme_color_override("font_readonly_color", "green")
		strikeable = true
