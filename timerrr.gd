extends Control

func _ready() -> void:
	position = Vector2(0,0)
	
func _process(delta) -> void:
	scale = Vector2(0.01,0.01)

func stop_timer() -> void:
	$Timer.stop()
	$Timer.stopped = true
