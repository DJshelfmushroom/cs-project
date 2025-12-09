extends Camera3D
@onready var focused_node: Node3D = $".."

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var from = project_ray_origin(event.position)
		var to = from + project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.new()
		query.from = from
		query.to = to
		query.collision_mask = 0xFFFFFFFF
		var result = space_state.intersect_ray(query)
		if result and result.collider:
			focused_node = result.collider
			print("Focused:", focused_node.name)
		print("click")
