extends Timer

var stopped

func _ready() -> void:
	wait_time = 180
	one_shot = true
	stopped = false
	start()
	
