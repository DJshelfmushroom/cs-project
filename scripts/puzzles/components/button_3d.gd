extends MeshInstance3D

var text = ""
var disabled = false
var num

func set_text(new_text : String):
	text = new_text
	$button/Label3D.text = new_text
