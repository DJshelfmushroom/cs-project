extends Node3D

var button_scene = preload("res://scenes/components/button_3d.tscn")

func _ready() -> void:
	var num = 1
	for y in range(0, -66, -22):
		for x in range(0, 66, 22):
			var buttoninst = button_scene.instantiate()
			add_child(buttoninst)
			print(str(x) + str(y))
			buttoninst.position = Vector3(x / 100.0, y / 100.0, 0)
			buttoninst.set_text(str(num))
			buttoninst.visible = true
			num += 1
			
