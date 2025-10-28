extends Control

var completed
var failed

func _ready() -> void:
	completed = false
	failed = false
	position = Vector2(0,0)

func _process(delta: float) -> void:
	if (($EquationLabel/AnswerLabel/TextEdit1.text == str($EquationLabel.get_rand1()) && $EquationLabel/AnswerLabel/TextEdit2.text == str($EquationLabel.get_rand2())) \
	or ($EquationLabel/AnswerLabel/TextEdit1.text == str($EquationLabel.get_rand2()) && $EquationLabel/AnswerLabel/TextEdit2.text == str($EquationLabel.get_rand1()))):
		completed = true
	elif (not($EquationLabel/AnswerLabel/TextEdit1.text == "") && not($EquationLabel/AnswerLabel/TextEdit2.text == "")):
		$EquationLabel/AnswerLabel/TextEdit1.text = ""
		$EquationLabel/AnswerLabel/TextEdit2.text = ""
		$"..".strikes += 1
		
