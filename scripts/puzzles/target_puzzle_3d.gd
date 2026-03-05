extends Node3D

var id = 11

var completed = false
var points = 0

func _ready() -> void:
	$Screen3D.set_size(2,1.6)
	$Screen3D.position = Vector3(-0.5,-0.5,0.001)

func _process(_delta: float) -> void:
	if points >= 10:
		$TargetButton3D.disabled = true
		$TargetButton3D.position = Vector3(0, 0, 0.002)
		$TargetButton3D.set_color(Color.GREEN)
		completed = true
		
func  _on_timer_timeout():
	if points > 0 and !points >= 10:
		points = 0
		$Timer.stop()
		$TargetButton3D.position = Vector3(0, 0, 0.002)
		$"../../..".strikes += 1
		var color = $TargetButton3D.get_color()
		$TargetButton3D.set_color(Color.RED)
		$TargetButton3D.disabled = true
		await get_tree().create_timer(1.0).timeout
		$TargetButton3D.set_color(Color(color))
		$TargetButton3D.disabled = false

func _on_but_pressed(num : int):
	if points == 0:
		$Timer.start(5.0)
	points += 1
	var x = randf_range(-0.8,0.8)
	var y = randf_range(-0.6,0.6)
	$TargetButton3D.position = Vector3(x, y, 0.002)

func _on_but_released(num : int):
	pass
