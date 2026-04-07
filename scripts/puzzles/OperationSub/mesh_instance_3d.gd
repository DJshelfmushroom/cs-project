extends MeshInstance3D

func _ready() -> void:
	var target_size = get_parent_node_3d().scale
	self.scale = target_size
	MeshTexture.new()
