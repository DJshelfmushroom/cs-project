extends Label3D

var gen = RandomNumberGenerator.new()
var x = gen.randi_range(1,9)
var y = gen.randi_range(1,9)
	
func _ready() -> void:
	if (x > y):
		text = "x + y" + " = " + str(x + y) + "\n" + "x * y" + " = " + str(x * y) + "\n" + "x > y"
	elif (x < y):
		text = "x + y" + " = " + str(x + y) + "\n" + "x * y" + " = " + str(x * y) + "\n" + "x < y"
	else:
		text = "x + y" + " = " + str(x + y) + "\n" + "x * y" + " = " + str(x * y) + "\n" + "x = y"

func get_x() -> int:
	return x
	
func get_y() -> int:
	return y
