extends Node3D

var plug_scene = preload("res://plug.tscn")
var locs:Array[Transform3D] = []
var rays:Array[Vector3] = []
var meshes:Array[Node3D] = []
# Called when the node enters the scene tree for the first time.
func process():
	for i in $"../PlugLocs".get_children():
		var plug_mesh = plug_scene.instantiate()
		add_child(plug_mesh)
		plug_mesh.global_position = i.global_position

		var ray = plug_mesh.get_node("RayCast3D") as RayCast3D
		ray.enabled = true
		# set target_position in the ray's local space (convert world -> ray local)
		ray.target_position = ray.to_local(self.global_position)
		ray.force_raycast_update()
		print(ray.is_colliding())
		meshes.append(plug_mesh)
		# if ray.is_colliding():
		if ray.is_colliding():
			var normal = ray.get_collision_normal().normalized()
			var collision_point = ray.get_collision_point()
			# place plug at collision point
			plug_mesh.look_at(collision_point + normal, plug_mesh.transform.basis.z)
			plug_mesh.global_position = collision_point
			rays.append(collision_point)
			rays.append(normal)
	print(rays)
