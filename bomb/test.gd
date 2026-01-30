extends Node3D



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == Key.KEY_SPACE:
			print("space (pressed)")
			for c:GPUParticles3D in get_children():
				c.emitting = true
			$"../bomb_instance".hide()
