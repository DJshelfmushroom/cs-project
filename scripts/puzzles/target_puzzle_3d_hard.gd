extends Node3D

var id = 11

var completed = false
var points = 0

func _ready() -> void:
	$Screen3D.set_size(2,1.6)
	$Screen3D.position = Vector3(-0.5,-0.5, 0.001)

func _process(_delta: float) -> void:
	if points >= 17:
		$TargetButton3D.disabled = true
		$TargetButton3D.set_color(Color.GREEN)
		$TargetButton3D2.disabled = true
		$TargetButton3D2.set_color(Color.GREEN)
		completed = true
		
func  _on_timer_timeout():
	if points > 0 and !points >= 17:
		points = 0
		$Timer.stop()
		$TargetButton3D.position = Vector3(0, 0, 0.002)
		$TargetButton3D2.position = Vector3(0, 0, 0.002)
		$"../../..".strikes += 1
		var color = $TargetButton3D.get_color()
		$TargetButton3D.set_color(Color.RED)
		$TargetButton3D.disabled = true
		$TargetButton3D2.set_color(Color.RED)
		$TargetButton3D2.disabled = true
		await get_tree().create_timer(1.0).timeout
		$TargetButton3D.set_color(Color(color))
		$TargetButton3D.disabled = false
		$TargetButton3D2.set_color(Color(color))
		$TargetButton3D2.disabled = false

func _on_but_pressed(_num : int):
	if points == 0:
		$Timer.start(5.0)
		var x = randf_range(-0.75,0.75)
		var y = randf_range(-0.57,0.57)
		$TargetButton3D.position = Vector3(x, y, 0.002)
		$TargetButton3D2.position = Vector3(x, y, 0.002)
	points += 1
	if points < 17:
		var x = randf_range(-0.75,0.75)
		var y = randf_range(-0.57,0.57)
		if _num == 0:
			$TargetButton3D.position = Vector3(x, y, 0.002)
		if _num == 1:
			$TargetButton3D2.position = Vector3(x, y, 0.002)

func _on_but_released(_num : int):
	pass
