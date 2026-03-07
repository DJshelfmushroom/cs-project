extends MeshInstance3D

var disabled = false
var num = 0
var index = 0

func set_color(color : Color):
	$button.mesh.material.albedo_color = color
	
func get_color() -> Color:
	return $button.mesh.material.albedo_color
