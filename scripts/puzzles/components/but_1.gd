extends Button

var num
var index
var timer = Timer.new()
	
func on() -> void:
	disabled = true
	text = str(num)
	
func off() -> void:
	disabled = false
	text = ""

func _pressed() -> void:
	get_parent()._on_but_pressed(index)
