extends Label

var gen = RandomNumberGenerator.new()
var rand1 = gen.randi_range(1,9)
var rand2 = gen.randi_range(1,9)
	
func _ready() -> void:
	text = "x\u00b2 + " + str(rand1 + rand2) + "x + " + str(rand1 * rand2) + " = 0" 

func get_rand1() -> int:
	return rand1
	
func get_rand2() -> int:
	return rand2
