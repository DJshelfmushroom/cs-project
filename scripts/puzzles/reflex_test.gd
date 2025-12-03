extends Control

var GameStart = false
var Labels = [$Up, $Down, $Left, $Right]


func _ready():
	if (GameStart == false):
		$StartButton.show()
		hideLabels()
		
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
	_ready()
