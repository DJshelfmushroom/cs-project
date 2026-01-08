extends MeshInstance3D

var disabled = false
var num = 0
var color = Color.WHITE
var ignore_hover = true
	
func _ready() -> void:
	off()
	
func set_color(new_color : Color):
	if !$button/Area3D/ColorOutline.mesh.material.emission_enabled:
		$button/Area3D/ColorOutline.mesh.material.emission_enabled = true
	color = new_color
	$button/Area3D/ColorOutline.mesh.material.emission = color
	
func on() -> void:
	set_color(color)
	
func off() -> void:
	$button/Area3D/ColorOutline.mesh.material.emission_enabled = false
