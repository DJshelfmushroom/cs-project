extends MeshInstance3D

var text = ""
var disabled = false
var num = 0
var index = 0

func set_text(new_text : String):
	text = new_text
	$button/Label3D.text = new_text
	
func set_color(color : Color):
	$button/Label3D.modulate = color

func on() -> void:
	disabled = true
	set_text(str(num))
	
func off() -> void:
	disabled = false
	set_text("")
