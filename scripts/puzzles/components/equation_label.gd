extends Label

var gen = RandomNumberGenerator.new()
var rand1 = gen.randi_range(1,9)
var rand2 = gen.randi_range(1,9)
	
func _ready() -> void:
	text = "x + y" + " = " + str(rand1 + rand2) + "\n" + "x * y" + " = " + str(rand1 * rand2) 

func get_rand1() -> int:
	return rand1
	
func get_rand2() -> int:
	return rand2
