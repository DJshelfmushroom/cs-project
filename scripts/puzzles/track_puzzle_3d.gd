extends Node3D

var id = 12

var start = false
var completed = false
var time = 4.5
var randy = randf_range(-0.01,0.01)
var randx = randf_range(-0.01,0.01)


func _ready() -> void:
	$Screen3D.set_size(2,1.6)
	$Screen3D.position = Vector3(-0.5,-0.5,0.001)
	
func _process(_delta: float) -> void:
	if start and !$"../../..".failed:
		
		$TrackButton3D.position.x += randx
		$TrackButton3D.position.y += randy
		
		if $Timer.time_left <= time:
			randy = randf_range(-0.0025,0.0025)
			randx = randf_range(-0.003,0.003)
			while (randx > -0.001 and randx < 0.001) or (randy > -0.001 and randy < 0.001):
				randy = randf_range(-0.0025,0.0025)
				randx = randf_range(-0.003,0.003)
			time -= 0.5
	if $TrackButton3D.position.x < -0.75:
		$TrackButton3D.position.x = -0.75
	if $TrackButton3D.position.x > 0.75:
		$TrackButton3D.position.x = 0.75
	if $TrackButton3D.position.y < -0.57:
		$TrackButton3D.position.y = -0.57
	if $TrackButton3D.position.y > 0.57:
		$TrackButton3D.position.y = 0.57
		
			
		
	

func _on_timer_timeout():
	if start and !$"../../..".failed:
		start = false
		$Timer.stop()
		$TrackButton3D.set_color(Color.GREEN)
		completed = true

func _on_but_pressed(_num : int):
	if !$"../../..".failed:
		start = true
		$TrackButton3D.disabled = true
		$Timer.start(3.0)
		randy = randf_range(-0.0025,0.0025)
		randx = randf_range(-0.003,0.003)

func _on_but_released(_num : int):
	pass
	
func _on_hover():
	pass

func _on_unhover():
	if start:
		$"../../..".strikes += 1
		start = false
		$Timer.stop()
		var color = $TrackButton3D.get_color()
		$TrackButton3D.set_color(Color.RED)
		await get_tree().create_timer(1.0).timeout
		$TrackButton3D.set_color(color)
		$TrackButton3D.position = Vector3(0,0,0.002)
		$TrackButton3D.disabled = false
		time = 4.5
