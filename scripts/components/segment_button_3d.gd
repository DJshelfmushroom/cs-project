extends MeshInstance3D

var num
var disabled = false

func set_lighting(color : Color):
	var newmaterial = StandardMaterial3D.new()
	newmaterial.emission_enabled = true
	newmaterial.emission = color
	newmaterial.albedo_color = color
	$ColorOutline.set_surface_override_material(0,newmaterial)
	
func win():
	$ColorOutline.mesh.material.emission = Color.GREEN
	disabled = true
	
func light_off():
	var newmaterial = StandardMaterial3D.new()
	$ColorOutline.set_surface_override_material(0,newmaterial)
