extends Node3D

var button_scene = preload("res://scenes/components/button_3d.tscn")

func _ready() -> void:
	$Button3D.visible = false
	var button_num = 1
	for y in range(0, -58, -29):
		for x in range(-58, 87, 29):
			var buttoninst = button_scene.instantiate()
			add_child(buttoninst)
			buttoninst.position = Vector3(x / 100.0, y / 100.0, 0)
			if !button_num == 10:
				buttoninst.set_text(str(button_num))
			else:
				buttoninst.set_text(">")
			buttoninst.num = button_num
			buttoninst.visible = true
			button_num += 1
			
func _on_but_pressed(num : int):
	$".."._on_button_pressed(num)
	
func _on_but_released(num : int):
	$".."._on_button_released(num)
			
