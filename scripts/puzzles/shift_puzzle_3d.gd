extends Node3D

var id = 13

var completed = false
var positions = []
var buttons = []
var button_scene = preload("res://scenes/components/shift_button_3d.tscn")
var colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]

func _ready() -> void:
	for y in range(-1,2):
		for x in range(-1,2):
			positions.append(Vector3(x / 4.0, y / 4.0, 0.002))
	for b in range(8):
		var buttoninst = button_scene.instantiate()
		var rand = randi_range(0,positions.size() - 1)
		buttoninst.position = positions[rand]
		positions.remove_at(rand)
		buttoninst.set_color(colors[b / 2])
		buttoninst.num = b
		buttons.append(buttoninst)
		add_child(buttoninst)
		
