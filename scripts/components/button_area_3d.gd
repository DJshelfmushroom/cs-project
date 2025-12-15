extends Area3D

func _ready():
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
	#$"..".get_node("SubViewport/ColorRect").color = Color(0.4,0.4,0.4)


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_on_button_pressed()
			elif !event.pressed:
				_on_button_released()
			
			
func _on_hover():
	#$"..".get_node("SubViewport/ColorRect").color = Color(0.5,0.5,0.5)
	pass


func _on_unhover():
	#$"..".get_node("SubViewport/ColorRect").color = Color(0.4,0.4,0.4)	
	pass

func _on_button_pressed():
	$"..".transform = $"..".transform.scaled(Vector3(1,1,-1))#.rotated_local(Vector3.LEFT, PI)

func _on_button_released():
	$"..".transform = $"..".transform.scaled(Vector3(1,1,-1))#.rotated_local(Vector3.LEFT, PI)
