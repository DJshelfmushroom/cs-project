@tool
extends Node3D

@export var line_radius = 0.1
@export var line_resoultion = 256

func _ready() -> void:
	var target_path: NodePath = NodePath("")
	if has_meta("path"):
		var meta_np: NodePath = get_meta("path")
		if has_node(meta_np):
			target_path = get_node(meta_np).get_path()
	elif get_parent() is Path3D:
		target_path = get_parent().get_path()
	if target_path != NodePath(""):
		$CSGPolygon3D.path_node = target_path
	# Build the circular profile once
	var circle := PackedVector2Array()
	for i in range(line_resoultion):
		var angle := TAU * float(i) / float(line_resoultion)
		circle.append(Vector2(cos(angle), sin(angle)) * line_radius)
	$CSGPolygon3D.polygon = circle
