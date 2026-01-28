extends Node3D

var newVmesh = Mesh.new()
var newHmesh = Mesh.new()
var newSmesh = Mesh.new()

func _ready() -> void:
	newVmesh = $V1.mesh.duplicate()
	newHmesh = $H1.mesh.duplicate()
	newSmesh = $Screen.mesh.duplicate()

	$V1.mesh = newVmesh
	$V2.mesh = newVmesh
	$H1.mesh = newHmesh
	$H2.mesh = newHmesh
	$Screen.mesh = newSmesh


func set_size(x : float, y : float):
	$V1.position.x -= (x - $H1.mesh.size.x) / 2
	$V2.position.x += (x - $H1.mesh.size.x) / 2
	$H1.position.y += (y - $V1.mesh.size.y) / 2
	$H2.position.y -= (y - $V1.mesh.size.y) / 2

	newHmesh.size.x = x
	newVmesh.size.y = y
	newSmesh.size.x = x
	newSmesh.size.y = y
