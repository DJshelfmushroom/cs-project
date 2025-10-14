extends Node3D

var plug_scene = preload("res://plug.tscn")
var locs:Array[Transform3D] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in $"../PlugLocs".get_children():
		var plug_mesh = plug_scene.instantiate()
		add_child(plug_mesh) # must be in tree before using global_*
		# Copy world position and rotation from the location node but keep the plug's own scale
		plug_mesh.global_position = i.global_position
		plug_mesh.global_rotation = i.global_rotation

		var ray = plug_mesh.get_node("RayCast3D") as RayCast3D
		ray.target_position = self.position
		add_child(ray)
		ray.force_raycast_update()
		var normal = ray.get_collision_normal()
		plug_mesh.global_rotation = normal

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
