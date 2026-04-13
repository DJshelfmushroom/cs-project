extends MeshInstance3D

var disabled = false
var num = 0
var ignore_hover = true
var color : Color
var text = ""
var size = 350

var default_material: StandardMaterial3D
var red_material: StandardMaterial3D
var blue_material: StandardMaterial3D
var green_material: StandardMaterial3D
var yellow_material: StandardMaterial3D
var orange_material: StandardMaterial3D
var purple_material: StandardMaterial3D

func _ready() -> void:
	default_material = StandardMaterial3D.new()
	red_material = StandardMaterial3D.new()
	blue_material = StandardMaterial3D.new()
	green_material = StandardMaterial3D.new()
	yellow_material = StandardMaterial3D.new()
	orange_material = StandardMaterial3D.new()
	purple_material = StandardMaterial3D.new()

	default_material.albedo_color = Color(0.83, 0.83, 0.83)

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

	orange_material.albedo_color = Color(1.0, 0.5, 0)
	orange_material.emission_enabled = true
	orange_material.emission = Color.ORANGE
	orange_material.emission_energy = 2.0
	
	purple_material.albedo_color = Color(0.5, 0, 1)
	purple_material.emission_enabled = true
	purple_material.emission = Color.PURPLE
	purple_material.emission_energy = 2.0
	

	off()

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
	elif new_color == Color.ORANGE:
		$ColorOutline.material_override = orange_material
	elif new_color == Color.PURPLE:
		$ColorOutline.material_override = purple_material

func on() -> void:
	set_color(color)

func off() -> void:
	$ColorOutline.material_override = default_material
	
func set_text(new_text : String):
	text = new_text
	$button/Label3D.text = new_text
	
func text_size(new_size):
	size = new_size
	$button/Label3D.font_size = new_size
