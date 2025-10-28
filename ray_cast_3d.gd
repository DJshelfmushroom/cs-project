extends RayCast3D

var colPoint : Vector3
var colNormal : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position = to_local($"../StaticBody3D".global_position)
	colPoint = get_collision_point()
	colNormal = get_collision_normal()

func _process(_delta: float) -> void:
	DebugDraw3D.draw_ray(self.get_collision_point(), self.get_collision_normal(), 5, Color.RED)
	DebugDraw3D.draw_points([colPoint, colNormal], DebugDraw3D.POINT_TYPE_SPHERE, 0.2, Color.RED, 1)
