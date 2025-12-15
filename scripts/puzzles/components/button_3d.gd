extends MeshInstance3D

var text = ""
var disabled = false

func set_text(new_text : String):
	text = new_text
	$Label3D.text = new_text
