@tool
extends Node3D

@export var line_radius = 0.1
@export var line_resolution = 256

func _ready() -> void:
	if has_meta("resolution"):
		line_resolution = get_meta("resolution")
	var target_path: NodePath = NodePath("..")
	if has_meta("path"):
		var meta_np: NodePath = get_meta("path")
		if has_node(meta_np):
			target_path = get_node(meta_np).get_path()
	elif get_parent() is Path3D:
		target_path = get_parent().get_path()
	if target_path != NodePath(""):
		$CSGPolygon3D.path_node = target_path
	var circle := PackedVector2Array()
	for degree in range(line_resolution):
		var x = line_radius * sin(PI * 2 * degree / line_resolution)
		var y = line_radius * cos(PI * 2 * degree / line_resolution)
		var coords = Vector2(x,y)
		circle.append(coords)
	$CSGPolygon3D.polygon = circle
	$CSGPolygon3D.path_interval = get_meta("path_follow") if has_meta("path_follow") else 1
