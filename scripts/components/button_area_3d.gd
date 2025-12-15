extends Area3D

func _ready():
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	$"..".mesh.material.albedo_color = Color(0.3,0.3,0.3)


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_on_button_pressed()
			
			
func _on_hover():
	if (input_event.get_object() == $"."):
		$"..".mesh.material.albedo_color = Color(0.35,0.35,0.35)


func _on_unhover():
	if (input_event.get_object() == $"."):
		$"..".mesh.material.albedo_color = Color(0.3,0.3,0.3)


func _on_button_pressed():
	pass
