extends Control

var GameStart = false
@onready var Labels = [$Up, $Down, $Left, $Right]


func _ready():
	$StartButton.show()
	hideLabels()
		
func _startGame():
	if (GameStart == true):
		(Labels.pick_random()).show()
	
	
func hideLabels():
	$Up.hide()
	$Down.hide()
	$Left.hide()
	$Right.hide()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$StartButton.disabled = true
	GameStart = true
	_startGame()
