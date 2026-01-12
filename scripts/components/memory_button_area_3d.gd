extends Area3D

var pressed = false
var facing_out = true

func _ready():
	input_event.connect(_on_input_event)
	#mouse_entered.connect(_on_hover)
	#mouse_exited.connect(_on_unhover)
	#$"..".mesh.material.albedo_color = Color(0.3,0.3,0.3)

func _process(_delta: float) -> void:
	if pressed and !Input.is_action_pressed("ui_mouse_left_button") and !facing_out:
		_on_button_released()
		pressed = false
		

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and Input.is_action_just_pressed("ui_mouse_left_button") and !($"../..".disabled) and facing_out:
			_on_button_pressed()
			pressed = true
		
			
			
			
#func _on_hover():
	#if (input_event.get_object() == $"."):
		#$"..".mesh.material.albedo_color = Color(0.35,0.35,0.35)
#
#
#func _on_unhover():
	#if (input_event.get_object() == $"."):
		#$"..".mesh.material.albedo_color = Color(0.3,0.3,0.3)


func _on_button_pressed():
	$"..".transform = $"..".transform.translated(Vector3(0,0,-0.01))
	facing_out = false
	$"../../.."._on_but_pressed($"../..".index)
		
	
	
func _on_button_released():
	$"..".transform = $"..".transform.translated(Vector3(0,0,0.01))
	facing_out = true
	$"../../.."._on_but_released($"../..".index)
	
	#$"..".transform = $"..".transform.scaled(Vector3(1,1,-1))
