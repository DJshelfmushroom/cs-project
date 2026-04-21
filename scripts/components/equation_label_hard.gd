extends Label3D

var gen = RandomNumberGenerator.new()
var x = gen.randi_range(1,9)
var y = gen.randi_range(1,9)
var z = gen.randi_range(1,9)
	
func _ready() -> void:
	var sum_of_squares = pow(x, 2) + pow(y, 2) + pow(z, 2)
	var relation := ""

	if x > y and y > z:
		relation = "x > y > z"
	elif x > z and z > y:
		relation = "x > z > y"
	elif y > x and x > z:
		relation = "y > x > z"
	elif y > z and z > x:
		relation = "y > z > x"
	elif z > x and x > y:
		relation = "z > x > y"
	elif z > y and y > x:
		relation = "z > y > x"

	elif x == y and y > z:
		relation = "x = y > z"
	elif x == y and y < z:
		relation = "x = y < z"
	elif x == z and z > y:
		relation = "x = z > y"
	elif x == z and z < y:
		relation = "x = z < y"
	elif y == z and z > x:
		relation = "y = z > x"
	elif y == z and z < x:
		relation = "y = z < x"

	else:
		relation = "x = y = z"

	text = "x\u00B2 + y\u00B2 + z\u00B2 = " + str(int(sum_of_squares)) + "\n" + relation

func get_x() -> int:
	return x
	
func get_y() -> int:
	return y

func get_z() -> int:
	return z
