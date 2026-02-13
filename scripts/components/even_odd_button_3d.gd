extends MeshInstance3D

var disabled = false
var num = 0
var color : Color

var default_material: StandardMaterial3D
var dred_material: StandardMaterial3D
var dgreen_material: StandardMaterial3D
var red_material: StandardMaterial3D
var blue_material: StandardMaterial3D
var green_material: StandardMaterial3D
var yellow_material: StandardMaterial3D

func _ready() -> void:
	default_material = StandardMaterial3D.new()
	dred_material = StandardMaterial3D.new()
	dgreen_material = StandardMaterial3D.new()
	red_material = StandardMaterial3D.new()
	blue_material = StandardMaterial3D.new()
	green_material = StandardMaterial3D.new()
	yellow_material = StandardMaterial3D.new()

	default_material.albedo_color = Color(0.83, 0.83, 0.83)

	dred_material.albedo_color = Color(1.0, 1.0, 1.0)
	dred_material.emission_enabled = true
	dred_material.emission = Color.RED
	dred_material.emission_energy = 2.0
	
	dgreen_material.albedo_color = Color(1.0, 1.0, 1.0)
	dgreen_material.emission_enabled = true
	dgreen_material.emission = Color.GREEN
	dgreen_material.emission_energy = 2.0

	red_material.albedo_color = Color(1.0, 0.0, 0.0)
	red_material.emission_enabled = true
	red_material.emission = Color.RED
	red_material.emission_energy = 2.0

	blue_material.albedo_color = Color(0.0, 0.0, 1.0)
	blue_material.emission_enabled = true
	blue_material.emission = Color.BLUE
	blue_material.emission_energy = 2.0

	green_material.albedo_color = Color(0.0, 1.0, 0.0)
	green_material.emission_enabled = true
	green_material.emission = Color.GREEN
	green_material.emission_energy = 2.0

	yellow_material.albedo_color = Color(1.0, 1.0, 0.0)
	yellow_material.emission_enabled = true
	yellow_material.emission = Color.YELLOW
	yellow_material.emission_energy = 2.0


func set_color(new_color : Color) -> void:
	color = new_color

	if new_color == Color.RED:
		$ColorOutline.material_override = red_material
	elif new_color == Color.BLUE:
		$ColorOutline.material_override = blue_material
	elif new_color == Color.GREEN:
		$ColorOutline.material_override = green_material
	elif new_color == Color.YELLOW:
		$ColorOutline.material_override = yellow_material
	elif new_color == Color.DARK_RED:
		$ColorOutline.material_override = dred_material
	elif new_color == Color.DARK_GREEN:
		$ColorOutline.material_override = dgreen_material
