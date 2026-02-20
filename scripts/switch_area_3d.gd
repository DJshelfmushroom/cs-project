extends Area3D

var up = false

func _ready():
	input_event.connect(_on_input_event)
	#mouse_entered.connect(_on_hover)
	#mouse_exited.connect(_on_unhover)
	#$"..".mesh.material.albedo_color = Color(0.3,0.3,0.3)

		

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and Input.is_action_just_pressed("ui_mouse_left_button") and !($"..".disabled):
			_on_button_pressed()
			
		
func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

			
#func _on_hover():
	#if input_event.get_object() == $"." and !$"../..".ignore_hover:
		#$"../..".on()
#
#
#func _on_unhover():
	#if (input_event.get_object() == $"."):
		#$"../..".off()


func _on_button_pressed():
	if up:
		up = false
		$"..".up = false
		$Switch.rotation = Vector3(5*PI/6, 0, 0)
	else:
		up = true
		$"..".up = true
		$Switch.rotation = Vector3(PI/6, 0, 0)
	$"../.."._on_but_pressed($"..".num)
		
	
	
	
	#$"..".transform = $"..".transform.scaled(Vector3(1,1,-1))
