extends Node3D

var disabled = false
var num = 0
var index = 0
var pos = 0

func set_color(color : Color):
	var newmat = StandardMaterial3D.new()
	newmat.albedo_color = color
	$button.set_surface_override_material(0, newmat)
	
func get_color() -> Color:
	var mat = $button.get_surface_override_material(0)
	if mat:
		return mat.albedo_color
	return Color(1,1,1)
