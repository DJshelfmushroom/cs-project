extends MeshInstance3D

var text = "1"
var disabled = false

func _ready() -> void:
	$SubViewport/ColorRect/Label.text = text
